Pod::Spec.new do |s|
  s.name         = "Appboy-Push-Story"
  s.version      = "4.0.0"
  s.summary      = "This is the Braze Push Story SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :http => "https://github.com/Appboy/appboy-ios-sdk/releases/download/#{s.version.to_s}/AppboyPushStory.zip" }
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.documentation_url = 'https://www.braze.com/docs'
  s.vendored_frameworks = 'AppboyPushStory/AppboyPushStory.xcframework'
  s.resource_bundle = { 'AppboyPushStory' => 'AppboyPushStory/Resources/*' }
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
end
