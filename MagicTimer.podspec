#
# Be sure to run `pod lib lint MagicTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MagicTimer'
  s.version          = '0.1.6'
  s.summary          = 'Magic Timer is a label timer that deals with schedule timer'

  s.homepage         = 'https://github.com/sadeghgoo/MagicTimer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sadeghgoo' => 'sadeghitunes2@gmail.com' }
  s.source           = { :git => 'https://github.com/sadeghgoo/MagicTimer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.source_files = 'MagicTimer/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation'
end
