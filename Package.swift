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
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.3.1/AppboyKitLibrary.xcframework.zip",
      checksum: "3324b0b97b3ab7ca3f751e1673446634063d10f0068230f8526f38504d56eb8c"
    ),
    .target(
      name: "AppboyKit",
      dependencies: ["SDWebImage", "AppboyKitLibrary"],
      path: "AppboyKit",
      resources: [
        .process("Appboy.bundle"),
        .process("headers/AppboyKitLibrary/ZipArchive_LICENSE.txt")
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
      url: "https://github.com/Appboy/appboy-ios-sdk/releases/download/4.3.1/AppboyPushStoryFramework.xcframework.zip",
      checksum: "c7ef104114a6b5ced016d00e461815fbce4eaad6bf08388709dd9b24f7c4b272"
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
