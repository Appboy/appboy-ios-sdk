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
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.4.3/AppboyKitLibrary.xcframework.zip",
      checksum: "66f13ebff3323d7eeccfba4fb67ab2174402a2b021c6b5a28990737316041510"
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
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.4.3/AppboyPushStoryFramework.xcframework.zip",
      checksum: "950a16e8d8ad665f92986d4d0af405316ea28b2655228ac798d0f156ca892718"
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
