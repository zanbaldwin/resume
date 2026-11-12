# CV build recipes. Output names are recruiter-facing and are the published URLs:
#   zanbaldwin-resume-VARIANT-print.pdf — light scheme (GitHub Light Default): printing, ATS portals
#   zanbaldwin-resume-VARIANT.pdf       — dark scheme (One Dark Pro Darker): screen-only
# for each emphasis variant (rust, php).
# All builds use PDF/UA-1 so the tagged structure tree stays verified.

standard := "ua-1"
variants := "rust php"

default: build

build:
    #!/usr/bin/env bash
    set -euo pipefail
    for v in {{ variants }}; do
        typst compile --pdf-standard {{ standard }} --input variant=$v --input scheme=dark  resume.typ "zanbaldwin-resume-$v.pdf"
        typst compile --pdf-standard {{ standard }} --input variant=$v --input scheme=light resume.typ "zanbaldwin-resume-$v-print.pdf"
    done

# Print-friendly build (GitHub Light Default)
light variant="rust":
    typst compile --pdf-standard {{ standard }} --input variant={{ variant }} --input scheme=light resume.typ zanbaldwin-resume-{{ variant }}-print.pdf

# Screen-only build (One Dark Pro Darker)
dark variant="rust":
    typst compile --pdf-standard {{ standard }} --input variant={{ variant }} --input scheme=dark resume.typ zanbaldwin-resume-{{ variant }}.pdf

# Live-recompile preview.pdf on save; scheme is "light" or "dark"
watch scheme="light" variant="rust":
    typst watch --pdf-standard {{ standard }} --input variant={{ variant }} {{ if scheme == "dark" { "--input scheme=dark" } else { "" } }} resume.typ preview.pdf

# Fail on ANY compiler warning (typst reports missing fonts as a warning
# and silently renders tofu), then check text extraction survives.
check:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    for v in {{ variants }}; do
        typst compile --pdf-standard {{ standard }} --input variant=$v resume.typ "$tmp/light-$v.pdf" 2>> "$tmp/warnings"
        typst compile --pdf-standard {{ standard }} --input variant=$v --input scheme=dark resume.typ "$tmp/dark-$v.pdf" 2>> "$tmp/warnings"
    done
    if [ -s "$tmp/warnings" ]; then cat "$tmp/warnings" >&2; echo "FAIL: compiler warnings" >&2; exit 1; fi
    for v in {{ variants }}; do
        pdftotext "$tmp/light-$v.pdf" "$tmp/light-$v.txt"
        grep -q "hello@zanbaldwin.com" "$tmp/light-$v.txt" || { echo "FAIL: contact email missing from extracted text ($v)" >&2; exit 1; }
    done
    echo "OK: all variant/scheme builds compile clean; extracted text carries the contact block"

# Record current renders as the pixel-diff baseline (run after approving a visual change)
bless:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf reference && mkdir -p reference
    for v in {{ variants }}; do
        typst compile --pdf-standard {{ standard }} --input variant=$v resume.typ "reference/light-$v-{p}.png"
        typst compile --pdf-standard {{ standard }} --input variant=$v --input scheme=dark resume.typ "reference/dark-$v-{p}.png"
    done
    echo "blessed $(ls reference | wc -l) pages into reference/"

# Pixel-diff current renders against reference/ (per page: 0 = identical)
diff:
    #!/usr/bin/env bash
    set -euo pipefail
    [ -d reference ] || { echo "no reference/ — run 'just bless' first" >&2; exit 1; }
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    for v in {{ variants }}; do
        typst compile --pdf-standard {{ standard }} --input variant=$v resume.typ "$tmp/light-$v-{p}.png"
        typst compile --pdf-standard {{ standard }} --input variant=$v --input scheme=dark resume.typ "$tmp/dark-$v-{p}.png"
    done
    fail=0
    [ "$(ls reference | wc -l)" = "$(ls "$tmp" | wc -l)" ] || { echo "page count differs from reference"; fail=1; }
    for ref in reference/*.png; do
        page="$(basename "$ref")"
        [ -f "$tmp/$page" ] || continue
        ae="$(compare -metric AE "$ref" "$tmp/$page" null: 2>&1 || true)"
        echo "$page: $ae"
        [ "${ae%% *}" = "0" ] || fail=1
    done
    exit $fail
