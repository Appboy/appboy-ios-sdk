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
      url: "https://api.github.com/repos/Appboy/appboy-ios-sdk/releases/assets/95502684.zip",
      checksum: "dd5e2b70e4832ee84be03e094409b122745e10846649416c3ac6754829fdac0f"
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
      url: "https://api.github.com/repos/Appboy/appboy-ios-sdk/releases/assets/95502682.zip",
      checksum: "b88f4e1306d3111b47ae9fb88d267557e41463470330cfe98ae4619096776ee5"
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
