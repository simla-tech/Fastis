import ProjectDescription
import ProjectDescriptionHelpers

let project = Library(
    name: .Fastis,
    options: .includeResources,
    dependencies: TargetDependencies(
        thirdParty: [.JTAppleCalendar, .SnapKit, .PrettyCards]
    ),
    additionalFiles: ["README.MD", "Package.swift", "Fastis.podspec"]
).project
