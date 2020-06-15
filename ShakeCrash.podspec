#
# Be sure to run `pod lib lint ShakeCrash.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ShakeCrash"
  s.version          = "0.3.1"
  s.summary          = "ShakeCrash idea was taken from Google Maps, just shake your iPhone to submit screenshot with description via e-mail or Redmine!"

  s.description      = <<-DESC
It simple - just shake your phone and new window with screenshot of current view will be presented. You can draw on it and write description, so it's the best way to report bugs, provide some feedback or just ask a question. Then, just click Send button and report will be sended with your message.
                       DESC

  s.homepage         = "https://github.com/Rovalx/ShakeCrash-iOS"
  s.license          = 'MIT'
  s.author           = { "Dominik Majda" => "ddmajda@gmail.com" }
  s.source           = { :git => "https://github.com/Rovalx/ShakeCrash-iOS.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
