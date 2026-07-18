// Style/template: every visual decision for the CV lives here.
// Design language: terminal/source-file conceit (design-ideation-2c.png).
// Sections render as `pub fn name() {` … `}`; decorations are marked as PDF
// artifacts so the tagged structure tree carries clean semantic headings
// (H1 name, H2 sections) while the visible layer keeps the code styling.
// Fonts: JetBrains Mono (display/meta/labels) + Inter (body text).
// Palette sampled from the design sketch.

// Palette: selected at compile time. Default is the print scheme (GitHub
// Light Default); `--input scheme=dark` builds the screen-only render
// (One Dark Pro Darker).
// Each colours-*.typ exports a `roles` dict with identical keys; which
// syntax slot fills which role differs per scheme (see those files).
// Discipline: body text stays neutral; each hue gets exactly one job.
#import "colours-light.typ" as light
#import "colours-dark.typ" as dark
#let schemes = (light: light.roles, dark: dark.roles)
#let chosen = sys.inputs.at("scheme", default: "light")
#assert(chosen in schemes, message: "unknown scheme '" + chosen + "'; expected: " + schemes.keys().join(", "))
#let scheme = schemes.at(chosen)
#let fonts = (
    mono: ("JetBrains Mono", "JetBrainsMono NF", "Liberation Mono"),
    sans: ("Inter", "Open Sans", "Noto Sans", "Liberation Sans"),
    icons: ("JetBrainsMono NFP", "JetBrainsMono NF"),
)

// Layout constants: the single source of truth for page geometry shared
// between the template and the entry point (which needs the margin to
// position out-of-flow chrome like the corner note).
#let defaults = (margin: 1.0cm, padding: 0.75em)

// Type ramp: every text size in the document, named. Consolidate HERE
// when tightening the system, never at call sites. `body` doubles as
// the em-anchor: all em-based spacing resolves against it, so changing
// it reflows the whole document, not just glyph sizes.
#let sizes = (
    display: 25pt, // H1 — the name
    heading: 10.5pt, // section/appendix headings, tagline
    title: 10pt, // company & project names
    subtitle: 9.5pt, // role beside the company name, header summary
    body: 9pt, // document default
    fine: 7.5pt, // `///` markers, position tag lines, corner note
    footer: 6pt, // page footer
)

#let mono(size: sizes.fine, fill: scheme.muted, it) = text(font: fonts.mono, size: size, fill: fill, it)
#let icon(cp, tilt: 0deg) = text(font: fonts.icons, box(rotate(tilt, str.from-unicode(cp))))

// Section-body text: the one definition of default type inside section
// blocks. Applied at the LEAF level (wrapping text, not layout blocks) —
// a scope-level `set text` would also re-resolve every em-based spacing
// value against the smaller size and shift the whole layout.
#let body-text(it) = text(size: sizes.body, fill: scheme.txt, it)
// Muted italic intro lines: position leads and project blurbs.
#let lead-text(it) = text(size: sizes.body, fill: scheme.muted, style: "italic", it)

// Code-styled heading line: `<prefix> <underlined name><suffix>`, with the
// prefix/suffix marked as PDF artifacts so the structure tree carries only
// the semantic heading text. Shared by the H2 (`pub fn`) and H3 (`impl`)
// show rules — one place for the decoration, no clone drift.
#let code-heading(prefix, suffix, weight: 800, body) = {
    set text(font: fonts.mono, size: sizes.heading)
    pdf.artifact(text(fill: scheme.keyword, style: "italic", prefix + " "))
    underline(offset: 2.5pt, stroke: 0.75pt + scheme.entity, text(fill: scheme.entity, weight: weight, body))
    pdf.artifact(text(fill: scheme.ink, suffix))
}

#let setup(person, margin: defaults.margin, background: scheme.bg, body) = {
    set document(
        title: person.name + " — CV",
        author: person.name,
        keywords: person.at("keywords", default: ()),
    )
    set page(
        paper: "a4",
        fill: background,
        margin: (x: margin, y: margin),
        footer: context align(right, text(
            font: fonts.mono,
            size: sizes.footer,
            fill: scheme.muted,
            person.at("handle", default: person.name) + " // page " + str(counter(page).get().first()),
        )),
    )
    set text(
        font: fonts.sans,
        size: sizes.body,
        fill: scheme.txt,
        lang: "en",
        region: "GB",
    )
    set par(leading: 0.56em, spacing: 0.78em)
    show link: set text(fill: scheme.link)
    set list(
        marker: text(size: sizes.fine, fill: scheme.bullet, sym.bullet),
        indent: 2pt,
        body-indent: 7pt,
        spacing: 0.58em,
    )
    show heading.where(level: 1): it => text(
        font: fonts.mono,
        size: sizes.display,
        weight: 700,
        fill: scheme.ink,
        // Trim the display-size line box to the glyphs themselves so the
        // name doesn't carry the font's built-in leading above and below.
        top-edge: "cap-height",
        bottom-edge: "baseline",
        it.body,
    )
    // PDF bookmarks (the viewer's sidebar outline) are generated from a
    // heading's BODY, never from what a show rule renders. section() and
    // appendix() exploit that: the body carries the sidebar title, and
    // the on-page title is smuggled through `supplement` (safe while
    // nothing @-references a heading). `auto` means a heading created
    // outside those wrappers — fall back to its body.
    let displayed(it) = if it.supplement == auto { it.body } else {
        it.supplement
    }
    show heading.where(level: 2): it => block(
        above: 1.35em,
        below: 0.8em,
        code-heading("pub fn", "() {", displayed(it)),
    )
    show heading.where(level: 3): it => block(
        above: 0.5em,
        below: 0.8em,
        code-heading("impl Appendix for", " {", weight: 700, displayed(it)),
    )
    body
}

#let prelude(versions, size: sizes.fine) = {
    let item(v) = {
        pdf.artifact(mono(size: size, icon(v.icon, tilt: v.at("tilt", default: 0deg))))
        link(v.link, mono(size: size, fill: scheme.link, " " + v.label))
    }
    versions
        .values()
        .filter(v => v.at("hide-on", default: none) != scheme.name)
        .map(item)
        .join(pdf.artifact(mono(size: size, " // ")))
}

// ── Small helpers ───────────────────────────────────────────────────

// Generic-type styling: colour `<…>` spans in a tagline string.
#let typed-tagline(s) = {
    show regex("<[^>]+>"): m => text(fill: scheme.entity, m.text)
    text(font: fonts.mono, size: sizes.heading, fill: scheme.ink, s)
}

// Project names split on the last `/`: the namespace prefix (owner/org,
// slash included) dims to muted, the repo name itself carries the ink —
// the same scope-dimming convention GitHub uses for owner/repo.
#let project-name(name, size: sizes.title) = text(
    font: fonts.mono,
    size: size,
    weight: 700,
    {
        let parts = name.split("/")
        let prefix = parts.slice(0, -1).join("/")
        if prefix != none and prefix != "" {
            text(fill: scheme.muted, weight: 600, prefix + "/")
        }
        text(fill: scheme.ink, weight: 800, parts.last())
    },
)

// ── Header ──────────────────────────────────────────────────────────

#let header(person) = {
    grid(
        columns: (1fr, auto),
        column-gutter: 1cm,
        {
            // Tight prompt/name/tagline stack: each line is an explicit
            // block (inline content would otherwise join into one line);
            // gaps come from par spacing (set here) plus the H1 line box
            // (trimmed in its show rule).
            set par(spacing: 0.35em)
            block(pdf.artifact(mono(size: sizes.body, "$ whoami")))
            v(0.5em)
            block(heading(level: 1, outlined: false, person.name))
            v(0.5em)
            block(typed-tagline(person.tagline))
        },
        align(right + bottom, {
            set par(leading: 0.75em)
            mono(
                size: sizes.body,
                fill: scheme.txt,
                (person.contact.email, person.contact.phone, person.contact.location).join("\n"),
            )
        }),
    )
    v(defaults.padding / 2)
    line(length: 100%, stroke: 0.5pt + scheme.ink)
    v(defaults.padding / 2)
    set text(size: sizes.subtitle, fill: scheme.ink)
    set par(leading: 0.68em)
    // Emphasis in the summary is bold-only: the highest-read block on the
    // page stays free of colour noise.
    person.summary.lead
    linebreak()
    text(
        size: sizes.body,
        fill: scheme.txt,
        style: "italic",
        person.summary.note,
    )
    v(defaults.padding)
}


// ── Struct-field rows: shared layout for community & portfolio ──────
// A teal mono `label:` followed by inline body text, with an optional
// right-aligned mono tail and an optional link target on the label.

#let field(name, body, tail: none, target: none) = block(above: 0.9em, {
    let lbl = text(
        font: fonts.mono,
        size: sizes.body,
        weight: 600,
        fill: scheme.field,
        name + ": ",
    )
    if target != none { link(target, lbl) } else { lbl }
    body-text(body)
    if tail != none {
        h(1fr)
        tail
    }
})

// ── Portfolio: the page-1 project strip ─────────────────────────────
// One field row per project; names link to the appendix write-ups.

#let project(p, padding: defaults.padding, blurb-indent: 0.55cm) = block(above: 2em, breakable: false, {
    block(sticky: true, below: padding, {
        project-name(p.name)
        h(1fr)
        mono((p.lang, ..p.tags).join(" · ") + " · ")
        link(p.link.url, mono(fill: scheme.link, p.link.label))
    })
    set par(leading: 0.5em)
    v(padding / 3)
    // The blurb is the human-facing context: rendered as a Rust doc comment,
    // mirroring the muted-italic lead lines of experience entries. Every
    // layouted line gets a `///` marker via par.line numbering.
    // The two knobs are INDEPENDENT (verified empirically): the markers
    // anchor to the page text column and are positioned by the clearance
    // alone; the block inset moves only the paragraph text. So
    // `blurb-indent` sets the text position (and thereby the gap after
    // the `///`), while the fixed clearance below pins the markers.
    block(below: 0.62em, inset: (left: blurb-indent), {
        set par.line(
            numbering: n => mono(size: sizes.fine, "///"),
            // Hand-tuned pin: negative clearance pushes the markers right of
            // the page text column so the `///` sits flush with the tech
            // text edge below. Do not derive from `blurb-indent`.
            number-clearance: -(padding + 0.9cm),
        )
        lead-text(p.blurb)
    })
    v(padding / 3)
    body-text(p.tech)
})

// ── Skills: struct-field rows ───────────────────────────────────────

#let skills-rows(skills) = {
    // Row items are plain strings, except spoken languages: (lang, level)
    // dicts formatted here. Skill tokens stay atomic via box(): lines wrap
    // only between items, never inside one.
    let fmt(it) = if type(it) == dictionary { it.skill + " (" + lower(it.level) + ")" } else { it }
    let row(s) = (
        text(font: fonts.mono, size: sizes.body, weight: 600, fill: scheme.field, lower(s.label) + ":"),
        body-text(s.items.map(it => box(fmt(it))).join(" · ")),
    )
    grid(
        columns: (auto, 1fr),
        column-gutter: 1em,
        row-gutter: 1em,
        ..skills.map(row).flatten(),
    )
}

// ── Experience entries ──────────────────────────────────────────────

#let position(e) = block(above: 1.5em, {
    block(sticky: true, below: 0.75em, {
        text(font: fonts.mono, size: sizes.title, weight: 700, fill: scheme.ink, e.company)
        text(size: sizes.subtitle, fill: scheme.ink, " · " + e.role)
        h(1fr)
        mono(e.dates + " · " + e.location)
        linebreak()
        v(0.1em)
        mono(size: sizes.fine, e.tags.join(" · "))
    })
    if e.lead != none { block(below: 0.78em, lead-text(e.lead)) }
    body-text(list(..e.bullets))
})

// ── Scope wrappers: `heading {` … `}` ───────────────────────────────
// One skeleton shared by sections and the appendix: heading, hairline-
// stroked body block, closing brace. The brace renders in exactly one
// place — no clone drift.

#let scoped(title-heading, body, padding: defaults.padding) = {
    title-heading
    v(padding)
    block(width: 100%, inset: (left: padding * 3), stroke: (left: 0.75pt + scheme.hairline), body)
    v(padding)
    pdf.artifact(text(font: fonts.mono, weight: 600, size: sizes.heading, fill: scheme.ink)[\}])
}

// `pub fn title() {` … `}`
// `bookmark:` overrides the PDF-sidebar title only (heading body = sidebar,
// supplement = on-page render; see the show rules in setup()). The sidebar
// keeps the title's own casing; only the on-page render is lowercased.
#let section(title, body, bookmark: none, padding: defaults.padding) = {
    let sidebar = if bookmark == none { title } else { bookmark }
    scoped(heading(level: 2, supplement: lower(title), sidebar), body, padding: padding)
    v(0.75em)
}

// `impl Appendix for Title {` … `}` — starts on a fresh page: the CV
// proper stays self-contained, the appendix carries optional depth for
// the hiring-manager read. The sidebar title is prefixed "Appendix: " so
// it can't be mistaken for a sibling of the page-1 sections.
#let appendix(title, body, padding: defaults.padding) = {
    pagebreak(weak: true)
    scoped([#heading(level: 3, supplement: title, "Appendix: " + title) <appendix>], body, padding: padding)
}
