import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .Fastis,
    targets: [
        .target(
            name: .Fastis,
            dependencies: [
                .target(name: .PrettyCards),
                .external(name: .JTAppleCalendar)
            ]
        )
    ],
    additionalFiles: ["README.MD", "Package.swift", "Fastis.podspec"]
)
