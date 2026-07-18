// One Dark Pro Darker — the screen colour scheme. Strictly no-print:
// this scheme fills the page with the editor background.
//
// Extracted 2026-07-03 from the source repo theme file
// (Binaryify/OneDark-Pro, themes/OneDark-Pro-darker.json, master branch)
// and cross-checked against the compiled extension artefact
// (zhuangtongfa.material-theme v3.19.0 via the open-vsx .vsix) — the two
// agree on every value. The Darker variant changes background tones only;
// syntax scopes are shared with the base One Dark Pro theme.
//
// Exports the same shape as colours-light.typ: a raw scheme dict plus a
// `roles` dict (identical keys across schemes) consumed by the template.

#let onedark = (
    // ── Editor chrome ──
    fg: rgb("#abb2bf"), // editor.foreground
    bg: rgb("#23272e"), // editor.background (Darker variant; base theme is #282c34)
    fg-muted: rgb("#9da5b4"), // statusBar.foreground — nearest muted-fg analogue
    // (the theme's descriptionForeground is just fg)
    link: rgb("#61afef"), // textLink.foreground
    border: rgb("#3e4452"), // panel.border / focusBorder
    indent-guide: rgb("#3b4048"), // editorIndentGuide.background

    // ── Syntax scopes ──
    syntax: (
        comment: rgb("#7f848e"), // comment, punctuation.definition.comment
        keyword: rgb("#c678dd"), // keyword (pub, fn, impl, for) — purple here
        entity: rgb("#61afef"), // entity.name.function (declared names) — blue here
        constant: rgb("#d19a66"), // constant.numeric
        string: rgb("#98c379"), // string
        variable: rgb("#e06c75"), // variable — also JSON property keys
        tag: rgb("#e06c75"), // entity.name.tag
        type: rgb("#e5c07b"), // entity.name.type, support.class
    ),

    // ── Neutral ladder (dark → light; every value verbatim from the theme) ──
    gray: (
        rgb("#181a1f"), // 0 — editorGroup.border
        rgb("#1d1f23"), // 1 — input.background
        rgb("#1e2227"), // 2 — sideBar / statusBar background
        rgb("#23272e"), // 3 — editor.background
        rgb("#2c313a"), // 4 — selection background
        rgb("#3b4048"), // 5 — indent guide
        rgb("#3e4452"), // 6 — panel.border
        rgb("#495162"), // 7 — editorLineNumber.foreground
        rgb("#515a6b"), // 8 — bracket-match background
        rgb("#636b78"), // 9 — ignored-resource foreground
        rgb("#7f848e"), // 10 — comment
        rgb("#9da5b4"), // 11 — statusBar.foreground
        rgb("#abb2bf"), // 12 — editor.foreground
    ),
)

// ── Semantic roles (consumed by the template) ───────────────────────
// Same keys as colours-light.typ, different slots: One Dark assigns hues
// differently (keywords purple, functions blue, JSON keys coral), so a
// same-slot swap would not look like One Dark.
#let roles = (
    name: "dark",
    ink: onedark.fg, // name, headings, entry titles, braces
    txt: onedark.fg, // body text
    muted: onedark.syntax.comment, // meta, dates, blurbs, decorations
    hairline: onedark.indent-guide, // section left-strokes
    link: onedark.link, // hyperlinks
    keyword: onedark.syntax.keyword, // `pub fn` / `impl … for`
    entity: onedark.syntax.constant, // section titles, generics
    field: onedark.syntax.variable, // coral — One Dark's JSON-key colour
    bullet: onedark.fg-muted, // between comment and fg, mirroring light
    bg: onedark.bg, // screen-only: paint the page
)
