#import "template.typ": (
    appendix, defaults, field, header, mono, position, prelude, project, section, setup, sizes, skills-rows,
)
#import "content.typ": community, experience, person, projects, skills, versions

// Page geometry and the type ramp live in template.typ (`defaults`,
// `sizes`) — one source of truth; override per-call when a variant
// needs different values.
#show: setup.with(person)
// Printers don't guarantee printing anything closer than 4mm to the edge of the page.
#place(top + center, dy: -(defaults.margin - 4mm), prelude(versions))
#header(person)

#section("Projects", {
    for p in projects {
        field(
            lower(p.name),
            p.headline,
            tail: mono((p.lang, ..p.tags).join(" · ")),
            target: p.link.url,
        )
    }
    block(link(
        label("appendix"),
        mono(size: sizes.fine, "/// project details -> appendix"),
    ))
})

#section("Skills", skills-rows(skills))

#section("Community", for item in community {
    field(lower(item.title), item.body)
})

#section("Experience", {
    for e in experience.positions { position(e) }
    v(0.7em)
    if experience.at("excluded", default: none) != none {
        align(center, mono(
            size: sizes.fine,
            "(" + str(experience.excluded.count) + " more positions between " + experience.excluded.dates + ")",
        ))
    }
})
#appendix("Projects", for p in projects { project(p) })
