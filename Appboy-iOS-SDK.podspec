Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "3.15.0"
  s.summary      = "This is the Braze iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.documentation_url = 'http://documentation.braze.com/'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.default_subspec = 'UI'

  s.subspec 'Core' do |sc|
    sc.ios.library = 'z'
    sc.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreText', 'WebKit'
    sc.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/ABKIdentifierForAdvertisingProvider.m', 'AppboyKit/ABKModalWebViewController.m', 'AppboyKit/ABKNoConnectionLocalization.m', 'AppboyKit/ABKLocationManagerProvider.m'
    sc.resource = 'AppboyKit/Appboy.bundle'
    sc.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
    sc.weak_framework = 'CoreTelephony', 'Social', 'Accounts', 'AdSupport', 'UserNotifications'
  end

  s.subspec 'UI' do |sui|
    sui.dependency 'Appboy-iOS-SDK/NewsFeed'
    sui.dependency 'Appboy-iOS-SDK/Feedback'
    sui.dependency 'Appboy-iOS-SDK/InAppMessage'
    sui.dependency 'Appboy-iOS-SDK/ContentCards'
    sui.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'Feedback' do |sfb|
    sfb.source_files = 'AppboyUI/ABKFeedback/ViewControllers/*.*', 'AppboyUI/ABKFeedback/AppboyFeedback.h', 'AppboyUI/ABKUIUtils/**/*.*'
    sfb.resource = 'AppboyUI/ABKFeedback/Resources/**/*.*'
    sfb.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'NewsFeed' do |snf|
    snf.source_files = 'AppboyUI/ABKNewsFeed/*.*', 'AppboyUI/ABKNewsFeed/ViewControllers/**/*.*', 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    snf.resource = 'AppboyUI/ABKNewsFeed/Resources/**/*.*'
    snf.dependency 'Appboy-iOS-SDK/Core'
    snf.dependency 'SDWebImage', '~>5.0'
  end

  s.subspec 'InAppMessage' do |siam|
    siam.source_files = 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyUI/ABKInAppMessage/*.*', 'AppboyUI/ABKInAppMessage/ViewControllers/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    siam.resource = 'AppboyUI/ABKInAppMessage/Resources/*.*'
    siam.dependency 'Appboy-iOS-SDK/Core'
    siam.dependency 'SDWebImage', '~>5.0'
  end

  s.subspec 'ContentCards' do |scc|
    scc.source_files = 'AppboyUI/ABKContentCards/*.*', 'AppboyUI/ABKContentCards/ViewControllers/**/*.*', 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    scc.resource = 'AppboyUI/ABKContentCards/Resources/**/*.*'
    scc.dependency 'Appboy-iOS-SDK/Core'
    scc.dependency 'SDWebImage', '~>5.0'
  end
end
