Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "3.24.1"
  s.summary      = "This is the Braze iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :http => "https://github.com/Appboy/appboy-ios-sdk/releases/download/#{s.version.to_s}/Appboy_iOS_SDK.zip" }
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.documentation_url = 'https://www.braze.com/docs'
  s.exclude_files = 'Appboy_iOS_SDK/AppboyKit/**/*.txt'
  s.preserve_paths = 'Appboy_iOS_SDK/AppboyKit/**/*.*'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.default_subspec = 'UI'

  s.subspec 'Core' do |sc|
    sc.ios.library = 'z'
    sc.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreText', 'WebKit'
    sc.source_files = 'Appboy_iOS_SDK/AppboyKit/headers/AppboyKitLibrary/*.h', 'Appboy_iOS_SDK/AppboyKit/ABKIdentifierForAdvertisingProvider.m', 'Appboy_iOS_SDK/AppboyKit/ABKModalWebViewController.m', 'Appboy_iOS_SDK/AppboyKit/ABKNoConnectionLocalization.m', 'Appboy_iOS_SDK/AppboyKit/ABKLocationManagerProvider.m'
    sc.resource = 'Appboy_iOS_SDK/AppboyKit/Appboy.bundle'
    sc.vendored_libraries = 'Appboy_iOS_SDK/AppboyKit/libAppboyKitLibrary.a'
    sc.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'UserNotifications'
  end

  s.subspec 'UI' do |sui|
    sui.dependency 'Appboy-iOS-SDK/NewsFeed'
    sui.dependency 'Appboy-iOS-SDK/InAppMessage'
    sui.dependency 'Appboy-iOS-SDK/ContentCards'
    sui.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'NewsFeed' do |snf|
    snf.source_files = 'Appboy_iOS_SDK/AppboyUI/ABKNewsFeed/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKNewsFeed/ViewControllers/**/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKUIUtils/**/*.*', 'Appboy_iOS_SDK/AppboyKit/ABKSDWebImageProxy.m'
    snf.resource = 'Appboy_iOS_SDK/AppboyUI/ABKNewsFeed/Resources/**/*.*'
    snf.dependency 'Appboy-iOS-SDK/Core'
    snf.dependency 'SDWebImage', '~>5.0'
  end

  s.subspec 'InAppMessage' do |siam|
    siam.source_files = 'Appboy_iOS_SDK/AppboyUI/ABKUIUtils/**/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKInAppMessage/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKInAppMessage/ViewControllers/*.*', 'Appboy_iOS_SDK/AppboyKit/ABKSDWebImageProxy.m'
    siam.resource = 'Appboy_iOS_SDK/AppboyUI/ABKInAppMessage/Resources/*.*'
    siam.dependency 'Appboy-iOS-SDK/Core'
    siam.dependency 'SDWebImage', '~>5.0'
  end

  s.subspec 'ContentCards' do |scc|
    scc.source_files = 'Appboy_iOS_SDK/AppboyUI/ABKContentCards/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKContentCards/ViewControllers/**/*.*', 'Appboy_iOS_SDK/AppboyUI/ABKUIUtils/**/*.*', 'Appboy_iOS_SDK/AppboyKit/ABKSDWebImageProxy.m'
    scc.resource = 'Appboy_iOS_SDK/AppboyUI/ABKContentCards/Resources/**/*.*'
    scc.dependency 'Appboy-iOS-SDK/Core'
    scc.dependency 'SDWebImage', '~>5.0'
  end
end
