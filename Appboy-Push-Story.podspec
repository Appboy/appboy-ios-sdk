Pod::Spec.new do |s|
  s.name         = "Appboy-Push-Story"
  s.version      = "3.27.0"
  s.summary      = "This is the Braze Push Story SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.documentation_url = 'https://www.braze.com/docs'
  s.preserve_paths = 'Appboy-Push-Story/AppboyPushStory.framework'
  s.vendored_frameworks = 'Appboy-Push-Story/AppboyPushStory.framework'

  # Skip this architecture to pass Pod validation since we removed the `arm64` simulator ARCH in order to use lipo later
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
