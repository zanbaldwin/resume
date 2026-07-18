# CV build recipes. Output names follow the deployment contract:
#   print.pdf  — light scheme (GitHub Light Default): printing, ATS portals
#   resume.pdf — dark scheme (One Dark Pro Darker): screen-only
# All builds use PDF/UA-1 so the tagged structure tree stays verified.

standard := "ua-1"

# Build both schemes
default: build

build: light dark

# Print-friendly build (GitHub Light Default)
light:
    typst compile --pdf-standard {{ standard }} resume.typ print.pdf

# Screen-only build (One Dark Pro Darker)
dark:
    typst compile --pdf-standard {{ standard }} --input scheme=dark resume.typ resume.pdf

# Live-recompile preview.pdf on save; scheme is "light" or "dark"
watch scheme="light":
    typst watch --pdf-standard {{ standard }} {{ if scheme == "dark" { "--input scheme=dark" } else { "" } }} resume.typ preview.pdf

# Fail on ANY compiler warning (typst reports missing fonts as a warning
# and silently renders tofu), then check text extraction survives.
check:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    typst compile --pdf-standard {{ standard }} resume.typ "$tmp/light.pdf" 2> "$tmp/warnings"
    typst compile --pdf-standard {{ standard }} --input scheme=dark resume.typ "$tmp/dark.pdf" 2>> "$tmp/warnings"
    if [ -s "$tmp/warnings" ]; then cat "$tmp/warnings" >&2; echo "FAIL: compiler warnings" >&2; exit 1; fi
    pdftotext "$tmp/light.pdf" "$tmp/light.txt"
    grep -q "hello@zanbaldwin.com" "$tmp/light.txt" || { echo "FAIL: contact email missing from extracted text" >&2; exit 1; }
    echo "OK: both schemes compile clean; extracted text carries the contact block"

# Record current renders as the pixel-diff baseline (run after approving a visual change)
bless:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf reference && mkdir -p reference
    typst compile --pdf-standard {{ standard }} resume.typ "reference/light-{p}.png"
    typst compile --pdf-standard {{ standard }} --input scheme=dark resume.typ "reference/dark-{p}.png"
    echo "blessed $(ls reference | wc -l) pages into reference/"

# Pixel-diff current renders against reference/ (per page: 0 = identical)
diff:
    #!/usr/bin/env bash
    set -euo pipefail
    [ -d reference ] || { echo "no reference/ — run 'just bless' first" >&2; exit 1; }
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
    typst compile --pdf-standard {{ standard }} resume.typ "$tmp/light-{p}.png"
    typst compile --pdf-standard {{ standard }} --input scheme=dark resume.typ "$tmp/dark-{p}.png"
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
