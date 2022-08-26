import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .Fastis,
    targets: [
        Target(
            name: .Fastis,
            dependencies: [
                .target(name: .PrettyCards),
                .external(name: .JTAppleCalendar),
                .external(name: .SnapKit)
            ]
        )
    ],
    additionalFiles: ["README.MD", "Package.swift", "Fastis.podspec"]
)
