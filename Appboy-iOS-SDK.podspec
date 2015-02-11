Pod::Spec.new do |s|
  s.name         = "Appboy-iOS-SDK"
  s.version      = "2.9.4"
  s.summary      = "This is the Appboy iOS SDK for Mobile Marketing Automation"
  s.description  = <<-DESC
                    This pod has two subspecs, please ensure you only choose one of them when you are adding Appboy-iOS-SDK pod to your podfile by:

                    pod 'Appboy-iOS-SDK/AppboyKit'
                    * This requires Facebook-iOS-SDK in the workspace. Installing this pod will automatically install Facebook-iOS-SDK is it's not incluced in the workspace.


                    pod 'Appboy-iOS-SDK/AppboyKitWithoutFacebookSupport'


                    Warning: Integrating both pods will cause the SDK to be integrated twice which will cause errors!
                   DESC
  s.homepage     = "http://www.appboy.com"
  s.license      = { :type => 'Commercial', :text => 'Please refer to https://github.com/Appboy/appboy-ios-sdk/blob/master/LICENSE'}
  s.author       = { "Appboy" => "http://www.appboy.com" }
  s.source       = { :git => 'https://github.com/Appboy/appboy-ios-sdk.git', :tag => s.version.to_s}
  s.platform = :ios
  s.ios.deployment_target = '5.1.1'
  s.requires_arc = false
  s.documentation_url = 'http://documentation.appboy.com/'
  s.frameworks = 'SystemConfiguration', 'QuartzCore', 'CoreImage'
  s.weak_framework = 'CoreTelephony', 'Social', 'Twitter', 'Accounts', 'AdSupport', 'StoreKit'

  s.subspec 'AppboyKit' do |aks|
    aks.source_files = 'AppboyKit/headers/AppboyKitLibrary/*.h', 'AppboyKit/*.m'
    aks.exclude_files = 'AppboyKit/**/*.txt'
    aks.resource = 'AppboyKit/Appboy.bundle'
    aks.preserve_paths = 'AppboyKit/**/*.*'
    aks.vendored_libraries = 'AppboyKit/libAppboyKitLibrary.a'
    aks.dependency 'Facebook-iOS-SDK', '~> 3.16.2'
    aks.dependency 'SDWebImage', '>= 3.7.0'
  end

  s.subspec 'AppboyKitWithoutFacebookSupport' do |akwfss|
    akwfss.source_files = 'AppboyKitWithoutFacebookSupport/headers/AppboyKitLibrary/*.h', 'AppboyKitWithoutFacebookSupport/*.m'
    akwfss.exclude_files = 'AppboyKitWithoutFacebookSupport/**/*.txt'
    akwfss.resource = 'AppboyKitWithoutFacebookSupport/Appboy.bundle'
    akwfss.preserve_paths = 'AppboyKitWithoutFacebookSupport/**/*.*'
    akwfss.vendored_libraries = 'AppboyKitWithoutFacebookSupport/libAppboyKitLibrary.a'
    akwfss.dependency 'SDWebImage', '>= 3.7.0'
  end

end
