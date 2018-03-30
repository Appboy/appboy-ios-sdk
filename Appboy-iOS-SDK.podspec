Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "3.3.3"
  s.summary      = "This is the Braze iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.documentation_url = 'http://documentation.braze.com/'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.default_subspec = 'UI'

  s.subspec 'Core' do |sc|
    sc.ios.library = 'z'
    sc.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreText', 'WebKit'
    sc.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/ABKIdentifierForAdvertisingProvider.m', 'AppboyKit/ABKModalWebViewController.m', 'AppboyKit/ABKNoConnectionLocalization.m'
    sc.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
    sc.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'StoreKit', 'UserNotifications'
  end

  s.subspec 'UI' do |sui|
    sui.resource = 'AppboyKit/Appboy.bundle'
    sui.dependency 'Appboy-iOS-SDK/Feedback'
    sui.dependency 'Appboy-iOS-SDK/InAppMessage'
    sui.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'Feedback' do |sfb|
    sfb.source_files = 'AppboyUI/ABKFeedbackViewController/FeedbackViewController/*.*', 'AppboyUI/ABKFeedbackViewController/AppboyFeedback.h', 'AppboyUI/ABKUIUtils/**/*.*'
    sfb.resource = 'AppboyUI/ABKFeedbackViewController/Feedback_Resources/**/*.*'
    sfb.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'InAppMessage' do |siam|
    siam.source_files = 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyUI/InAppMessage/*.*', 'AppboyUI/InAppMessage/ViewControllers/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    siam.resource = 'AppboyUI/InAppMessage/Resources/*.*'
    siam.dependency 'SDWebImage/GIF', '~>4.0'
    siam.dependency 'Appboy-iOS-SDK/Core'
  end
end
