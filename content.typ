// Semantic content only: facts as strings/arrays; content blocks where prose
// carries inline markup (links). Casing, joining, and placement are applied
// by template.typ. Apostrophes are typed as literal U+2019 in strings because
// smart-quote substitution only happens in markup mode.

#let variants = (
    rust: (
        tagline: "Senior Software Engineer: Rust · PHP · Systems",
        keywords: ("Rust", "systems programming", "backend", "API design", "PHP", "Symfony"),
        note: "Over five years of Rust alongside a senior PHP career: published crates, applied cryptography, and async systems work. I want Rust to be my day job.",
        project-order: ("zanbaldwin/atshield", "darsyn/ip", "zanbaldwin/rawr"),
        skill-order: ("Rust", "PHP", "Data", "Infra", "Practices", "Languages"),
    ),
    php: (
        tagline: "Senior Software Engineer: PHP · Symfony · APIs",
        keywords: ("PHP", "Symfony", "backend", "API design", "Rust", "systems programming"),
        note: "I have worked in office, hybrid, and fully remote teams across time zones. I lead by coaching, code review, and clear conventions, and I stay hands-on in the code.",
        project-order: ("darsyn/ip", "zanbaldwin/atshield", "zanbaldwin/rawr"),
        skill-order: ("PHP", "Data", "Infra", "Practices", "Rust", "Languages"),
    ),
)
#let variant = sys.inputs.at("variant", default: "rust")
#assert(variant in variants, message: "unknown variant '" + variant + "'; expected: " + variants.keys().join(", "))
#let chosen = variants.at(variant)

#let pdf-url(kind) = (
    "https://zanbaldwin.com/zanbaldwin-resume-" + variant + (if kind == "print" { "-print" } else { "" }) + ".pdf"
)

#let versions = (
    print: (
        link: pdf-url("print"),
        icon: 0xF042A, // nf-md-printer
        label: "print-friendly version",
        hide-on: "light",
    ),
    screen: (
        link: pdf-url("screen"),
        // nf-md-moon_waxing_crescent: the filled crescent, tilted into a
        // dark-mode moon silhouette (bulge lower-right).
        icon: 0xF0F67,
        tilt: 30deg,
        label: "dark-mode version",
        hide-on: "dark",
    ),
    source: (
        link: "https://github.com/zanbaldwin/resume",
        icon: 0xF408, // nf-oct-mark-github
        label: "source",
    ),
)

#let person = (
    name: "Zan Baldwin",
    handle: "@zanbaldwin.com",
    tagline: chosen.tagline,
    keywords: chosen.keywords,
    contact: (
        phone: "+31 6 38865043",
        email: "hello@zanbaldwin.com",
        location: "Apeldoorn, Netherlands",
        status: "UK citizen · NL permanent resident",
    ),
    summary: (
        lead: [
            Senior backend engineer with 16 years of PHP and more than 10 years of Symfony.
            I design and build APIs, and I own features from specification to production. Background in package infrastructure (Packagist), payments and fintech (#box[PCI-DSS]), and health data (GDPR, ISO 27001).
            Symfony certified, SymfonyCon keynote speaker, and maintainer of an open-source library with 2M+ installs.
            Strongest in systems where correctness is non-negotiable.
        ],
        note: chosen.note,
    ),
)

#let projects = (
    // (
    //     name: "zanbaldwin/fakesky",
    //     lang: "Rust",
    //     tags: ("Axum", "Pingora"),
    //     headline: "hands-on did:plc tamper-detection training",
    //     link: (label: "fakesky.zanbaldwin.com", url: "https://fakesky.zanbaldwin.com"),
    //     blurb: "Web platform that interactively teaches ATProto identity-attack recovery: real commands on throwaway identities.",
    //     tech: [Axum service that signs users in over live ATProto OAuth, mints disposable sandbox #box[did:plc] identities against a private reference-PLC, then forges genuine tampers (key seizure, PDS repointing, signing-key swaps, tombstones) and grades recovery inside the real 72-hour nullification window using the same atshield-core verifier as the CLI. Compile-time-verified SQLite queries, a background identity reaper, and a single self-contained binary embedding a Vite/Tailwind/HTMX frontend; offline end-to-end tests via an in-process fake-PLC harness.],
    // ),
    (
        name: "zanbaldwin/atshield",
        lang: "Rust",
        tags: ("library + CLI",),
        headline: "cryptographically-verified tamper-detection for ATProto identities",
        link: (label: "github.com/zanbaldwin/atshield", url: "https://github.com/zanbaldwin/atshield"),
        blurb: none,
        tech: [A tamper-detection tool for AT Protocol (Bluesky) decentralised identities. Independently re-verifies an identity's full history: every hash, signature, and key change. Validated against the official protocol test vectors. Published on #link("https://crates.io/crates/atshield-core")[crates.io].],
    ),
    (
        name: "darsyn/ip",
        lang: "PHP",
        tags: ("2M+ installs", "~35k/month"),
        headline: "128-bit byte-level IP address library",
        link: (label: "github.com/darsyn/ip", url: "https://github.com/darsyn/ip"),
        blurb: none,
        tech: "Author and maintainer since 2015. IPv4, IPv6, and CIDR arithmetic with no dependencies, aligned with the IANA special-purpose registries. Verified by ~6k tests across eleven PHP versions (7.1–8.6), under strict SemVer and static analysis.",
    ),
    (
        name: "zanbaldwin/rawr",
        lang: "Rust",
        tags: ("11-crate workspace",),
        headline: "content-addressed offline archival tool",
        link: (label: "github.com/zanbaldwin/rawr", url: "https://github.com/zanbaldwin/rawr"),
        blurb: none,
        tech: [
            An offline archival tool that catalogues downloaded web fiction, tracks versions, and renders works to PDF for e-readers.
            Content-addressed storage with local and S3 backends, async streaming (Tokio), and a catalogue that can be rebuilt from the archive files.
        ],
    ),
)

// Most relevant ecosystem leads; facts above are defined exactly once.
#assert(
    variants.values().all(v => v.project-order.len() == projects.len()),
    message: "each variant must order every project",
)
#let projects = chosen.project-order.map(name => {
    let found = projects.find(p => p.name == name)
    assert(found != none, message: "unknown project in project-order: " + name)
    found
})

#let community = (
    (
        title: "Speaking",
        body: [Closing keynote of #link("https://live.symfony.com/2019-amsterdam-con/schedule/one-year-of-symfony")[SymfonyCon Amsterdam 2019] ("One Year of Symfony", co-presented with Symfony lead developer Nicolas Grekas); technical speaker at Symfony conferences. Speaker, panellist, and CfP selection committee member at Dutch PHP Conference.],
    ),
    (
        title: "Open Source",
        body: [Author and maintainer of #link("https://github.com/darsyn/ip")[darsyn/ip] since 2015 (2M+ installs). Code and documentation contributor across the PHP ecosystem, plus "soft" contributions: Codes of Conduct, team coordination, and moderation.],
    ),
    (
        title: "Mentoring & Inclusion",
        body: [Member of Symfony's #link("https://symfony.com/doc/current/contributing/code_of_conduct/care_team.html")[CARE team] (code-of-conduct incident response) and #link("https://symfony.com/doc/current/contributing/diversity/governance.html#guidance")[Diversity Initiative guidance team]. Mentoring junior developers, meetup organiser, and UK charity committee-board member.],
    ),
)

#let skills = (
    (
        label: "Rust",
        items: (
            "Tokio & structured concurrency",
            "applied cryptography",
            "sealed typestate design",
            "streaming I/O",
        ),
    ),
    (
        label: "PHP",
        items: (
            "PHP 8",
            "Symfony 7 & 8",
            "Symfony certified",
            "Doctrine",
            "API Platform",
            "Composer",
            "GraphQL",
            "REST",
            "OpenAPI",
            "OAuth",
            "asynchronous messaging",
            "DDD",
            "TDD/BDD",
            "PHPUnit",
            "Behat",
            "PHPStan/Psalm",
        ),
    ),
    (
        label: "Data",
        items: ("PostgreSQL", "MySQL/MariaDB", "SQLite", "Redis", "Elasticsearch", "RabbitMQ"),
    ),
    (
        label: "Infra",
        items: ("Linux", "Docker/Podman", "GitLab CI/CD", "AWS", "Kubernetes"),
    ),
    (
        label: "Practices",
        items: (
            "software architecture",
            "API design",
            "code review",
            "documentation",
            "mentoring",
            "debugging & profiling",
            "agentic development",
        ),
    ),
    (
        label: "Languages",
        items: (
            (
                skill: "English",
                level: "Native",
            ),
            (
                skill: "Dutch",
                level: "Beginner",
            ),
        ),
    ),
)

#assert(
    variants.values().all(v => v.skill-order.len() == skills.len()),
    message: "each variant must order every skills group",
)
#let skills = chosen.skill-order.map(label => {
    let found = skills.find(g => g.label == label)
    assert(found != none, message: "unknown skills group in skill-order: " + label)
    found
})

#let experience = (
    excluded: (count: 2, dates: "2010–2012"),
    positions: (
        (
            company: "WeDevelop",
            role: "Senior Symfony Engineer",
            dates: "December 2023–Present",
            location: "Apeldoorn, Netherlands",
            tags: ("PHP/Symfony", "API Design", "Documentation, Architecture and Guidelines"),
            lead: "Software agency. Backend lead on client projects, from specification to production.",
            bullets: (
                "Owned the backend of a course registration platform end to end, from client discovery sessions and the OpenAPI specification to production: enrolments, payments (Mollie, Stripe), and administration, processing ~500 applicants and €250K in revenue in the first 6 months.",
                "Built a data aggregation API caching ~30K monthly inventory and pricing changes across ~10K products from Microsoft Dynamics 365 Business Central, reducing upstream API load and providing endpoints for downstream consumers.",
                "Established the API-design and code-review conventions used company-wide.",
                "Part of the team that patched ~100 client servers across AWS and Hetzner within 24 hours of a wave of critical PHP vulnerabilities (including PHP2Shell), using AI agents as an independent auditor and penetration tester to verify each server after patching.",
            ),
        ),
        (
            company: "Packagist",
            role: "Senior Software Engineer",
            dates: "March 2022–December 2023",
            location: "Berlin (Remote)",
            tags: ("PHP/Symfony", "Platform Engineering", "Code Hosting & Distribution"),
            lead: "Maintained and extended the PHP ecosystem’s central package registry.",
            bullets: (
                "During my time, the registry took in ~1M new packages/versions and served ~50 billion installs.",
                "Built Composer audit API endpoints and integrated security advisory tracking into the package distribution pipeline, strengthening PHP software supply chain security.",
                "Designed and built security-sensitive features including multi-factor authentication, organisational token management, and audit logging.",
                "Built a Team Management API from specification to implementation: OpenAPI design, permissions model, unit and integration test coverage.",
                "Identified and resolved race conditions in package synchronisation and entity persistence, on a platform that relies on pre-computation, caching, and queues.",
                "Created the project’s containerised development environment from scratch, standardising onboarding and replacing fragile manual setup.",
            ),
        ),
        (
            company: "SmarterQueue",
            role: "Lead Symfony Developer",
            dates: "2020–2022",
            location: "Vancouver → Netherlands (Remote)",
            tags: ("PHP/Symfony", "GraphQL", "Social Media APIs", "Docker"),
            lead: "Hired to lead a team of 3–5 on the rewrite of the legacy product into a Symfony/GraphQL application.",
            bullets: (
                "Designed the application architecture: domain modelling, service boundaries, and data layer design for a GraphQL backed platform.",
                "Improved both speed and memory performance of the legacy product up to 50 times via xhprof profiling.",
                "Enforced and maintained 100% test coverage (CI-gated) across the GraphQL API.",
            ),
        ),
        (
            company: "Intergalactic Agency",
            role: "Lead PHP Developer",
            dates: "2019–2020",
            location: "Vancouver, Canada",
            tags: ("PHP/Symfony", "OpenAPI", "DevOps & Docker", "Deployment Strategies"),
            lead: "Lead PHP developer for in-house and client projects, both new and legacy, including: BC Liquor, Mental Health Commission Canada, Palo Alto, Eventbase, Sundance Film Festival.",
            bullets: (
                "Upgraded internal source control and added automated upgrades and backups for company infrastructure spread across multiple continents.",
                "Replaced manual release processes with automated CI/CD and containerised deployment, reducing company expenses and developer time.",
                "Ran the platform for Palo Alto’s annual conference on a single server, down from the three originally scoped, with zero downtime across the event.",
            ),
        ),
        (
            company: "CarePlanner Ltd",
            role: "Senior Software Developer",
            dates: "2018–2019",
            location: "Bristol, England",
            tags: ("PHP/Symfony", "RESTful APIs", "SaaS", "Data Protection", "GDPR"),
            lead: "Built a RESTful API platform from scratch for a SaaS provider in the home-care sector.",
            bullets: (
                "Kept the developer teams compliant with ISO 27001 and GDPR while storing and handling health and medical data of vulnerable individuals.",
                "Built the integration APIs that brought two external companies and a local government authority onto CarePlanner’s platform.",
                "Coached a Drupal 7 development team of 3 on Symfony framework from scratch.",
            ),
        ),
        (
            company: "BaseKit Platform",
            role: "Software Engineer",
            dates: "2015–2018",
            location: "Bristol, England",
            tags: ("PHP/Symfony", "B2B", "DevOps & Docker", "Sysadmin", "Behat"),
            lead: "Worked on the backend of a global B2B site-building SaaS platform and its supporting projects.",
            bullets: (
                "Migrated a multi-million-line codebase from PHP 5.x to 7, rewriting several legacy parts that blocked the upgrade.",
                "Added behavioural (Behat) test coverage on top of the existing unit tests in the CI pipeline, so that builds could be deployed with confidence.",
            ),
        ),
        (
            company: "Nosco Systems",
            role: "Lead Technical Developer",
            dates: "2012–2015",
            location: "Pontypridd, Wales",
            tags: ("PHP", "Fintech", "PCI-DSS", "Legal & Regulation", "Sysadmin", "Mentorship"),
            lead: "Developer for a cloud-based digital debt and loan management application, and supporting software/hardware.",
            bullets: (
                "Worked under PCI-DSS constraints on credit-card acceptance and credit-report data for personal loan products.",
                "Deployed the software to both cloud-based servers and in-store shop kiosks, with bottom-line accountability for the company’s infrastructure.",
                "Led and mentored teams, both in-house (2 developers) and remote (Bulgaria; 3 developers), including travelling to provide training.",
            ),
        ),
    ),
)
