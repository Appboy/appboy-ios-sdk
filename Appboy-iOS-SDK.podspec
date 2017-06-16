Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "2.30.0"
  s.summary      = "This is the Appboy iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.appboy.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.appboy.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.documentation_url = 'http://documentation.appboy.com/'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.default_subspec = 'UI'

  s.subspec 'Core' do |sc|
    sc.ios.library = 'z'
    sc.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreText', 'WebKit'
    sc.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/ABKIdentifierForAdvertisingProvider.m', 'AppboyKit/ABKModalWebViewController.m', 'AppboyKit/ABKNoConnectionLocalization.m'
    sc.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
    sc.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'StoreKit','UserNotifications'
  end

  s.subspec 'UI' do |sui|
    sui.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
    sui.resource = 'AppboyKit/Appboy.bundle'
    sui.dependency 'SDWebImage/GIF', '~>4.0'
    sui.dependency 'Appboy-iOS-SDK/Core'
  end
end
