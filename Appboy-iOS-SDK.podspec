Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "2.24.2"
  s.summary      = "This is the Appboy iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.appboy.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.appboy.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.documentation_url = 'http://documentation.appboy.com/'
  s.library = 'z'
  s.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreImage', 'CoreText'
  s.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'StoreKit','UserNotifications'
  s.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.resource = 'AppboyKit/Appboy.bundle'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
  s.dependency 'SDWebImage', '~>3.7'
end
