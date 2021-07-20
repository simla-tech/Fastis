Pod::Spec.new do |s|
  s.name             = 'Fastis'
  s.version          = '1.0.13'
  s.summary          = "Simple date picker created using JTAppleCalendar library"
  s.description      = <<-DESC
  Fastis is a fully customizable UI component for picking dates and ranges created using JTAppleCalendar library.
                       DESC

  s.homepage         = 'https://github.com/retailcrm/Fastis'
  s.social_media_url = 'https://retailcrm.pro'
  s.screenshot       = 'https://github.com/retailcrm/Fastis/raw/master/Documentation/top_screen.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ilya Kharlamov' => 'kharlamov@retailcrm.ru' }
  s.source           = { :git => 'https://github.com/retailcrm/Fastis.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'

  s.source_files = [
      "Sources/**/*.swift",
      "Derived/Sources/*.swift"
  ]
  s.resources = "Resources/*.xcassets"

  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'JTAppleCalendar', '~> 8.0.0'
  s.dependency 'PrettyCards', '~> 1.0.0'

end
