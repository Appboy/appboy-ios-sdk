# Welcome to Appboy's sample project!

Stopwatch is a simple timer application that shows Appboy in action. Below are some screenshots that will reference how to:

* Display an Appboy feedback form and news feed
* Activate an in-app slideup message
* Log custom event data and in-app purchases to Appboy
* Set user attributes for the existing user on the device
* Theme Appboy programmatically
* Miscellaneous features

![](https://appboy.zendesk.com/attachments/token/mlosrjmdc5k5s8g/?name=iPhone+initial+screen.png)

## Getting started
Start by taking a look at `AppDelegate.m` to see how Appboy starts up.  You can copy the sample code right into your project, though be sure to change the API key.

## Feedback form and news feed
Next, take a look at the storyboards for examples of how you might set up the UI in your app. Try using both iPhone and iPad simulators:

* In the iPhone storyboard, you'll see an example of how to open the
Appboy news feed via a push onto the navigation stack using an `ABKFeedViewControllerNavigationContext`
* In the iPad storyboard, there is an example of how to use the `ABKFeedViewControllerGenericContext` in a split-view controller to show the news feed

The content of the news feed is controlled through our [online dashboard](https://dashboard.appboy.com).

There are also examples of how to create news feed and feedback forms programmatically: 

* The `InitialViewController.m` file
shows how to open the feed and feedback in popovers
* `InfoViewController.m` has a feedback view controller which
opens in a modal view

## In-app slideup messages
You'll notice when you first open Stopwatch that a small, unobtrusive message appears on the bottom of the screen. This message is there to alert your users to new content. When you use a Production API Key, this slideup message only appears when you push out new content from the Appboy dashboard, but for this sample app it will appear every time the app is foregrounded.

You can control the timing of the slidesup so that it does not appear or appears only when you want it to. The `SlideupControlsViewController` has code samples for how to handle displaying and queuing of incoming slideup message.

## Custom events and in-app purchases
When you start the timer on Stopwatch, Appboy logs a custom event in `InitialViewController.m`. Purchases are also logged when you click on the "Upgrade" button on the home screen of the app.

## Setting user attributes
If your app collects user information such as name or email address, you can report that to Appboy. Take a look at the `UserAttributesViewController.m` file to see how you can report user attributes back to Appboy.

## Theming Appboy
You can enable and disable Appboy to use [NUI theming](https://github.com/tombenner/nui) in the `AppDelegate.m` file. Try turning it on and off to see the changes in the feedback form and news feed from standard iOS controls to something different.

![](https://raw.github.com/Appboy/appboy-ios-sdk/master/Example/Screenshots/theme-off.png)
![](https://raw.github.com/Appboy/appboy-ios-sdk/master/Example/Screenshots/theme-on.png)

## Miscellaneous features
`TestingViewController.h` enables
and disables Appboy, and displays counts of the cards currently in the news feed.

## Next steps
Finally, look around for other examples of how to use the methods in Appboy.h;  almost all of them are covered in the sample code.

Don't hesitate to contact us if you have questions at [support@appboy.com](mailto:support@appboy.com)!
