import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: .Fastis,
    targets: [
        Target(
            name: .Fastis,
            resources: .defaultResourcesPath,
            dependencies: [
                .carthage(.JTAppleCalendar),
                .carthage(.SnapKit),
                .carthage(.PrettyCards)
            ]
        )
    ],
    additionalFiles: ["README.MD", "Package.swift", "Fastis.podspec"]
)
