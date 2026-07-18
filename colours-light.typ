// GitHub Light Default — the print colour scheme.
//
// Extracted 2026-07-03 from the compiled VS Code theme artefact
// (GitHub.github-vscode-theme v6.3.5, themes/light-default.json via the
// open-vsx .vsix), cross-checked against primer/github-vscode-theme
// src/theme.js with tokens resolved through @primer/primitives v7.10.0.
// All hex values are literal from the built theme — no symbolic drift.
// (The primitives *main* branch has since reshuffled its neutral scale;
// do not re-derive these values from there.)
//
// Companion file: colours-dark.typ (One Dark Pro Darker, screen-only)
// exports the same shape — a raw scheme dict plus a `roles` dict with
// identical keys — so the template swaps schemes without edits.

#let github-light = (
    // ── Editor chrome ──
    fg: rgb("#1f2328"), // editor.foreground (theme override of primitives fg.default)
    bg: rgb("#ffffff"), // editor.background
    fg-muted: rgb("#656d76"), // descriptionForeground
    link: rgb("#0969da"), // textLink.foreground
    border: rgb("#d0d7de"), // editorGroup.border / panel.border
    indent-guide: rgb("#1f23281f"), // editorIndentGuide.background: 12%-alpha ink

    // ── Syntax scopes ──
    syntax: (
        comment: rgb("#6e7781"), // comment, punctuation.definition.comment
        keyword: rgb("#cf222e"), // keyword, storage, storage.type (pub, fn, impl, for)
        entity: rgb("#8250df"), // entity.name.function + broad entity (declared names, types)
        constant: rgb("#0550ae"), // constant, entity.name.constant (also JSON/YAML keys)
        string: rgb("#0a3069"), // string, quoted literals
        variable: rgb("#953800"), // variable, parameters
        tag: rgb("#116329"), // entity.name.tag (markup tags)
    ),

    // ── Neutral scale (@primer/primitives v7.10.0, light mode) ──
    // Scheme-native grays for print tuning; pick from here rather than
    // inventing off-scale values.
    gray: (
        rgb("#f6f8fa"), // 0
        rgb("#eaeef2"), // 1
        rgb("#d0d7de"), // 2 — border.default
        rgb("#afb8c1"), // 3
        rgb("#8c959f"), // 4
        rgb("#6e7781"), // 5 — syntax comment
        rgb("#57606a"), // 6
        rgb("#424a53"), // 7
        rgb("#32383f"), // 8
        rgb("#24292f"), // 9
    ),
)

// ── Semantic roles (consumed by the template) ───────────────────────
// Every scheme file exports a `roles` dict with exactly these keys; the
// template binds them at compile time via `--input scheme=…`.
#let roles = (
    name: "light",
    ink: github-light.fg, // name, headings, entry titles, braces
    txt: github-light.fg, // body text (single foreground, as the scheme renders code)
    muted: github-light.syntax.comment, // meta, dates, blurbs, decorations
    hairline: github-light.indent-guide, // section left-strokes (12%-alpha ink)
    link: github-light.link, // hyperlinks
    keyword: github-light.syntax.keyword, // `pub fn` / `impl … for`
    entity: github-light.syntax.entity, // section titles, generics
    field: github-light.syntax.constant, // struct-field labels (JSON-key convention)
    bullet: github-light.fg-muted, // between comment and fg
    bg: none, // print scheme: real paper, no fill
)
