Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "2.10.0"
  s.summary      = "This is the Appboy iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.appboy.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.appboy.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = false
  s.documentation_url = 'http://documentation.appboy.com/'
  s.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreImage'
  s.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'StoreKit'
  s.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.resource = 'AppboyKit/Appboy.bundle'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
  s.dependency 'SDWebImage', '~>3.7.0'
  s.default_subspecs = 'AppboyKit'

  s.subspec 'AppboyKit' do |appboyKit|
    appboyKit.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
    appboyKit.resource = 'AppboyKit/Appboy.bundle'
    appboyKit.preserve_paths = 'AppboyKit/**/*.*'
    appboyKit.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
  end

  s.subspec 'AppboyKitWithoutFacebookSupport' do |appboyKitWithoutFacebookSupport|
    appboyKitWithoutFacebookSupport.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
    appboyKitWithoutFacebookSupport.resource = 'AppboyKit/Appboy.bundle'
    appboyKitWithoutFacebookSupport.preserve_paths = 'AppboyKit/**/*.*'
    appboyKitWithoutFacebookSupport.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
  end
end
