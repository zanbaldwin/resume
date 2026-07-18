// Semantic content only: facts as strings/arrays; content blocks where prose
// carries inline markup (links). Casing, joining, and placement are applied
// by template.typ. Apostrophes are typed as literal U+2019 in strings because
// smart-quote substitution only happens in markup mode.

#let versions = (
    print: (
        link: "https://zanbaldwin.com/print.pdf",
        icon: 0xF042A, // nf-md-printer
        label: "print-friendly version",
        hide-on: "light",
    ),
    screen: (
        link: "https://zanbaldwin.com/resume.pdf",
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
    tagline: "Senior Software Engineer: Rust · PHP · Systems",
    keywords: ("Rust", "systems programming", "backend", "API design", "PHP", "Symfony"),
    contact: (
        phone: "+31 6 38865043",
        email: "hello@zanbaldwin.com",
        location: "Netherlands (UTC+1)",
    ),
    summary: (
        lead: [16 years of production experience, from software supply chain infrastructure at Packagist to healthcare compliance, fintech regulation, and high-traffic event platforms. Experience in scalable API design, security-sensitive systems (#box[PCI-DSS], GDPR, ISO 27001), and open-source community leadership. Strongest in systems where correctness matters more than shipping speed.],
        // Adapt tagline to specific job description: "International work history with remote/distributed/cross-timezone experience."
        note: "After over a decade climbing from junior to conference keynotes, I enjoyed the ascent to the top of the PHP world more than being there; I'm making that climb again in Rust, and I do my best work on teams I can grow and thrive with.",
    ),
)

#let projects = (
    (
        name: "zanbaldwin/atshield",
        lang: "Rust",
        tags: ("library + CLI",),
        headline: "cryptographically-verified tamper-detection for ATProto identities",
        link: (label: "github.com/zanbaldwin/atshield", url: "https://github.com/zanbaldwin/atshield"),
        blurb: "A sole-authored tamper-detection tool for AT Protocol (Bluesky) decentralised identities.",
        tech: [Re-verifies every did:plc operation from scratch: recomputes every CID from canonical DAG-CBOR, re-checks every ECDSA signature (secp256k1/P-256, strict low-S), re-derives DIDs from genesis bytes, and attributes each change to its signing key. Validated against official protocol test vectors and captured histories, including forks, tombstones, and legacy operations. Published on #link("https://crates.io/crates/atshield-core")[crates.io].],
    ),
    (
        name: "darsyn/ip",
        lang: "PHP",
        tags: ("2M+ installs", "~35k/month"),
        headline: "128-bit byte-level IP address library",
        link: (label: "github.com/darsyn/ip", url: "https://github.com/darsyn/ip"),
        blurb: "Author and maintainer since 2015, six major versions, Doctrine integration.",
        tech: "Implements 128-bit IPv6/CIDR arithmetic as dependency-free byte-string operations, pluggable IPv4-in-IPv6 embedding strategies (mapped, 6to4, Teredo, NAT64), and address classification aligned with the IANA special-purpose registries. One codebase, tested across ten PHP runtimes (7.1–8.5) and verified by ~6k tests, under strict SemVer and static analysis.",
    ),
    (
        name: "zanbaldwin/rawr",
        lang: "Rust",
        tags: ("11-crate workspace",),
        headline: "content-addressed offline archival tool",
        link: (label: "github.com/zanbaldwin/rawr", url: "https://github.com/zanbaldwin/rawr"),
        blurb: "An offline archival tool that organises a library of downloaded web fiction: cataloguing each copy, tracking successive versions, and rendering works to PDF for e-readers (Kindle, reMarkable).",
        // Removed: Web-published works are subject to silent revision or deletion by their authors; saved copies are often the only durable record.",
        tech: "Content-addressed storage (BLAKE3), ephemeral SQLite catalogue rebuildable from archive files, pluggable local/S3 backends, Tokio-based async streaming that never loads a file whole, and compile-time state-machine enforcement via the typestate pattern.",
    ),
)

#let community = (
    (
        title: "Speaking",
        body: [Closing keynote of #link("https://live.symfony.com/2019-amsterdam-con/schedule/one-year-of-symfony")[SymfonyCon Amsterdam 2019] ("One Year of Symfony", co-presented with Symfony lead developer Nicolas Grekas); technical speaker at Symfony conferences. Speaker, panellist, and CfP selection committee member at Dutch PHP Conference.],
    ),
    (
        title: "Open Source",
        body: [Code and documentation contributor across the PHP ecosystem, plus "soft" contributions: Codes of Conduct, team coordination, and moderation.],
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
            "Rust",
            "Tokio & structured concurrency",
            "Cargo workspaces",
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
            "Doctrine",
            "Composer",
            "GraphQL",
            "REST",
            "OpenAPI",
            "OAuth",
            "DDD",
            "TDD/BDD",
            "PHPUnit",
            "Behat",
            "PHPStan/Psalm",
            "SOLID",
        ),
    ),
    (
        label: "Data",
        items: ("PostgreSQL", "MySQL", "SQLite", "Redis", "Elasticsearch"),
    ),
    (
        label: "Infra",
        items: ("Linux", "systemd", "Docker/Podman", "CI/CD", "AWS", "TLS"),
    ),
    (
        label: "Practices",
        items: (
            "software architecture",
            "API design",
            "code review",
            "documentation",
            "mentoring",
            "Agile",
            "debugging & profiling",
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

#let experience = (
    excluded: (count: 2, dates: "2010–2012"),
    positions: (
        (
            company: "WeDevelop",
            role: "Senior Symfony Engineer",
            dates: "December 2023–Present",
            location: "Apeldoorn, Netherlands",
            tags: ("PHP/Symfony", "API Design", "Documentation, Architecture and Guidelines"),
            lead: none,
            bullets: (
                "Led all backend development handling enrolments, payments (Mollie, Stripe), and administration for a course registration platform: processing ~500 applicants and €250K in revenue in the first 6 months.",
                "Built a data aggregation API caching ~250K monthly inventory and pricing changes from Microsoft Dynamics 365 Business Central, reducing upstream API load and providing endpoints for downstream consumers.",
                "Wrote the OpenAPI specification and acceptance criteria for the course-registration API from client discovery sessions.",
                "Introduced containerised development environments and established the team's API-design and code-review conventions.",
            ),
        ),
        (
            company: "Packagist",
            role: "Senior Software Engineer",
            dates: "March 2022–December 2023",
            location: "Berlin (Remote)",
            tags: ("PHP/Symfony", "Platform Engineering", "Code Hosting & Distribution"),
            lead: none,
            bullets: (
                "Maintained and extended Private Packagist, the commercial arm of the PHP ecosystem’s central package registry.",
                "Contributed to PHP software supply chain security by building Composer audit API endpoints and integrating security advisory tracking into the package distribution pipeline.",
                "Designed and built security-sensitive features including multi-factor authentication, organisational token management, and audit logging.",
                "Built a Team Management API from specification to implementation: OpenAPI design, permissions model, unit and integration test coverage.",
                "Identified and resolved race conditions in package synchronisation and entity persistence, improving reliability of concurrent operations.",
                "Created the project’s containerised development environment from scratch, standardising onboarding and replacing fragile manual setup.",
            ),
        ),
        (
            company: "SmarterQueue",
            role: "Symfony Developer",
            dates: "2020–2022",
            location: "Vancouver → Netherlands (Remote)",
            tags: ("PHP/Symfony", "GraphQL", "Social Media APIs", "Docker"),
            lead: "Hired to lead the rewrite of the legacy product into a Symfony/GraphQL application.",
            bullets: (
                "Designed the application architecture: domain modelling, service boundaries, and data layer design for a GraphQL-backed platform.",
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
                "Increased resilience of the company assets spread across multiple continents, upgraded internal source control, and added automated upgrades and backups.",
                "Decreased company expenses and increased developer productivity by obsoleting old manual processes, replacing with automated CI/CD and containerised deployment.",
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
                "Reduced organisation’s risk while storing/handling health and medical data of vulnerable individuals by ensuring strict compliance with ISO 27001 & GDPR within the developer teams.",
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
                "Ensured that builds could be deployed with confidence by adding behavioural test case coverage on top of the existing unit tests within the CI pipeline.",
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
                "Kept the software current with continually changing legal and regulatory requirements within the industry.",
                "Handled credit-card acceptance and credit-report data for personal loan products under PCI-DSS constraints.",
                "Handled deployments of software for both cloud-based servers and in-store shop kiosks, with bottom-line accountability for the company’s infrastructure.",
                "Led and mentored teams of developers both in-house and remote (Bulgaria), including travelling to provide training.",
            ),
        ),
    ),
)
