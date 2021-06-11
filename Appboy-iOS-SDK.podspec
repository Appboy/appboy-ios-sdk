Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "4.3.0"
  s.summary      = "This is the Braze iOS SDK for Mobile Marketing Automation"
  s.homepage     = "http://www.braze.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.braze.com" }
  s.source       = { :http => "https://github.com/Appboy/appboy-ios-sdk/releases/download/#{s.version.to_s}/Appboy_iOS_SDK.zip" }
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.documentation_url = 'https://www.braze.com/docs'
  s.exclude_files = 'AppboyKit/**/*.txt'
  s.preserve_paths = 'AppboyKit/**/*.*'
  s.default_subspec = 'UI'

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }

  s.subspec 'Core' do |sc|
    sc.ios.library = 'z'
    sc.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreText', 'WebKit'
    sc.source_files = 'AppboyKit/include/*.h', 'AppboyKit/ABKModalWebViewController.m', 'AppboyKit/ABKNoConnectionLocalization.m', 'AppboyKit/ABKLocationManagerProvider.m'
    sc.resource_bundle = { 'Appboy' => 'AppboyKit/Appboy.bundle/*.lproj' }
    sc.vendored_framework = 'AppboyKit/AppboyKitLibrary.xcframework'
    sc.weak_framework = 'CoreTelephony', 'UserNotifications'
  end

  s.subspec 'UI' do |sui|
    sui.dependency 'Appboy-iOS-SDK/NewsFeed'
    sui.dependency 'Appboy-iOS-SDK/InAppMessage'
    sui.dependency 'Appboy-iOS-SDK/ContentCards'
    sui.dependency 'Appboy-iOS-SDK/Core'
  end

  s.subspec 'NewsFeed' do |snf|
    snf.source_files = 'AppboyUI/ABKNewsFeed/*.*', 'AppboyUI/ABKNewsFeed/ViewControllers/**/*.*', 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    snf.resource_bundle = { 'AppboyUI.NewsFeed' => 'AppboyUI/ABKNewsFeed/Resources/**/*.*' }
    snf.dependency 'Appboy-iOS-SDK/Core'
    snf.dependency 'SDWebImage', '>= 5.8.2', '< 6'
  end

  s.subspec 'InAppMessage' do |siam|
    siam.source_files = 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyUI/ABKInAppMessage/*.*', 'AppboyUI/ABKInAppMessage/ViewControllers/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    siam.resource_bundle = { 'AppboyUI.InAppMessage' => 'AppboyUI/ABKInAppMessage/Resources/*.*' }
    siam.dependency 'Appboy-iOS-SDK/Core'
    siam.dependency 'SDWebImage', '>= 5.8.2', '< 6'
  end

  s.subspec 'ContentCards' do |scc|
    scc.source_files = 'AppboyUI/ABKContentCards/*.*', 'AppboyUI/ABKContentCards/ViewControllers/**/*.*', 'AppboyUI/ABKUIUtils/**/*.*', 'AppboyKit/ABKSDWebImageProxy.m'
    scc.resource_bundle = { 'AppboyUI.ContentCards' => 'AppboyUI/ABKContentCards/Resources/**/*.*' }
    scc.dependency 'Appboy-iOS-SDK/Core'
    scc.dependency 'SDWebImage', '>= 5.8.2', '< 6'
  end
end
