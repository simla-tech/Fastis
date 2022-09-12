Pod::Spec.new do |s|
  s.name             = 'Fastis'
  s.version          = '2.2.0'
  s.summary          = "Simple date picker created using JTAppleCalendar library"
  s.description      = <<-DESC
  Fastis is a fully customizable UI component for picking dates and ranges created using JTAppleCalendar library.
                       DESC

  s.homepage         = 'https://github.com/simla-tech/Fastis'
  s.social_media_url = 'https://www.simla.com'
  s.screenshot       = 'https://user-images.githubusercontent.com/4445510/187880045-cb66b662-095b-4173-b795-b1e732cc2166.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ilya Kharlamov' => 'kharlamov@retailcrm.ru' }
  s.source           = { :git => 'https://github.com/simla-tech/Fastis.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'

  s.source_files = [
      "Sources/**/*.swift",
  ]

  s.dependency 'JTAppleCalendar', '~> 8.0.0'
  s.dependency 'PrettyCards', '~> 1.0.0'

end
