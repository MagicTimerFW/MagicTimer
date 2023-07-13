Pod::Spec.new do |s|
  s.name             = 'MagicTimer'
  s.version          = '2.0.1'
  s.summary          = 'MagicTimer framework, your ultimate solution for handling timers in your iOS applications. This framework provides a powerful and flexible timer implementation with various features to meet your timer needs.'

  s.homepage         = 'https://github.com/MagicTimerFW/MagicTimer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sadeghgoo' => 'sadeghitunes2@gmail.com' }
  s.source           = { :git => 'https://github.com/MagicTimerFW/MagicTimer', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
  s.dependency 'MagicTimerCore'
end
