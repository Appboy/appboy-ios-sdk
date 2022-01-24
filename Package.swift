// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Appboy_iOS_SDK",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v9)
  ],
  products: [
    .library(name: "AppboyKit", type: .static, targets: ["AppboyKit"]),
    .library(name: "AppboyUI", targets: ["AppboyUI"]),
    .library(name: "AppboyPushStory", targets: ["AppboyPushStory"])
  ],
  dependencies: [
    .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.8.2")
  ],
  targets: [
    .binaryTarget(
      name: "AppboyKitLibrary",
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.4.2/AppboyKitLibrary.xcframework.zip",
      checksum: "8af8194536bcbd83247f7239815ee01676d3a1587ef63849e047b671cad60f43"
    ),
    .target(
      name: "AppboyKit",
      dependencies: ["SDWebImage", "AppboyKitLibrary"],
      path: "AppboyKit",
      resources: [
        .process("Appboy.bundle")
      ],
      linkerSettings: [
        .linkedFramework("SystemConfiguration"),
        .linkedFramework("QuartzCore"),
        .linkedFramework("CoreImage"),
        .linkedFramework("CoreText"),
        .linkedFramework("WebKit"),
        .linkedFramework("UserNotifications"),
        .linkedFramework("CoreTelephony", .when(platforms: [.iOS])),
        .linkedLibrary("z"),
      ]
    ),
    .target(
      name: "AppboyUI",
      dependencies: ["AppboyKit"],
      path: "AppboyUI",
      resources: [
        .process("ABKNewsFeed/Resources"),
        .process("ABKInAppMessage/Resources"),
        .process("ABKContentCards/Resources")
      ],
      publicHeadersPath: "include/AppboyUI"
    ),
    .binaryTarget(
      name: "AppboyPushStoryFramework",
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.4.2/AppboyPushStoryFramework.xcframework.zip",
      checksum: "7b376545e163bca7482a1a52ef742315350f095da107de79048d654ca5d49714"
    ),
    .target(
      name: "AppboyPushStory",
      dependencies: ["AppboyPushStoryFramework"],
      path: "AppboyPushStory",
      resources: [
        .process("Resources/ABKPageView.nib")
      ]
    )
  ]
)
