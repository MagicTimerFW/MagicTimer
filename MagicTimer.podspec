#
# Be sure to run `pod lib lint MagicTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MagicTimer'
  s.version          = '1.0.4'
  s.summary          = 'MagicTimer is a UIView based timer that displays a countdown or count-up timer.'

  s.homepage         = 'https://github.com/MagicTimerFW/MagicTimer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sadeghgoo' => 'sadeghitunes2@gmail.com' }
  s.source           = { :git => 'https://github.com/MagicTimerFW/MagicTimer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit', 'Foundation'
end
