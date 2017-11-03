Pod::Spec.new do |s|
  s.name         = "Appboy-tvOS-SDK"
  s.version      = "3.2.0"
  s.summary      = "This is the Appboy tvOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.appboy.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.appboy.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :tvos
  s.tvos.deployment_target = 9.0
  s.requires_arc = true
  s.documentation_url = 'http://documentation.appboy.com/'
  s.tvos.frameworks = 'SystemConfiguration'
  s.tvos.weak_framework = 'AdSupport', 'StoreKit'
  s.preserve_paths = 'Appboy-tvOS-SDK/AppboyTVOSKit.framework'
  s.vendored_frameworks = 'Appboy-tvOS-SDK/AppboyTVOSKit.framework'
end
