Pod::Spec.new do |s|
  s.name         = "Appboy-Push-Story"
  s.version      = "3.13.0"
  s.summary      = "This is the Braze Push Story SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.documentation_url = 'http://documentation.braze.com/'
  s.preserve_paths = 'Appboy-Push-Story/AppboyPushStory.framework'
  s.vendored_frameworks = 'Appboy-Push-Story/AppboyPushStory.framework'
end
