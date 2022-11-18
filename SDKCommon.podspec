Pod::Spec.new do |s|
  s.name             = 'SDKCommon'
  s.version          = '0.0.2'
  s.summary          = 'A short description of SDKCommon.'
  s.homepage         = 'https://github.com/Felipaugsts/Common'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felipe Augusto Silva' => '' }
  s.source           = { :git => 'git@github.com:Felipaugsts/Common.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'SDKCommon/Classes/**/*'
  s.dependency 'SwinjectAutoregistration'
  s.dependency 'Swinject'
end
