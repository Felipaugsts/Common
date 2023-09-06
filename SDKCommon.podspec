Pod::Spec.new do |s|
  s.name             = 'SDKCommon'
  s.version          = '0.0.5'
  s.summary          = 'A short description of SDKCommon.'
  s.homepage         = 'https://github.com/Felipaugsts/Common'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felipe Augusto Silva' => '' }
  s.source           = { :git => 'git@github.com:Felipaugsts/Common.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'SDKCommon/Classes/**/*'
  s.dependency 'SwinjectAutoregistration'
  s.dependency 'Swinject'
  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Firestore'
  s.dependency 'Firebase/Core'
  s.dependency 'FirebaseFirestoreSwift', '> 7.0-beta'
  s.dependency 'KeychainSwift', '20.0.0'
  
end
