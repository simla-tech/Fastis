import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .Fastis,
    targets: [
        Target(
            name: .Fastis,
            resources: .defaultResourcesPath,
            dependencies: [
                .external(name: .JTAppleCalendar),
                .external(name: .SnapKit),
                .external(name: .PrettyCards)
            ]
        )
    ],
    additionalFiles: ["README.MD", "Package.swift", "Fastis.podspec"]
)
