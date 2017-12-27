#import <UIKit/UIKit.h>
#import "ABKInAppMessageUIControlling.h"
#import "ABKInAppMessageUIDelegate.h"
#import "ABKInAppMessageWindowController.h"

@interface ABKInAppMessageUIController : NSObject <ABKInAppMessageUIControlling>

/*!
 * supportedOrientationMasks allows you to change which orientation masks the in-app message supports.
 * In-app messages will normally support the orientations specified in the app settings, but the method
 * supportedInterfaceOrientations may optionally override that. The value of supportedOrientationMasks will be returned
 * in supportedInterfaceOrientations in the in-app message view controller.
 *
 * The default value of supportedOrientationMasks is UIInterfaceOrientationMaskAll.
 */
@property UIInterfaceOrientationMask supportedOrientationMasks;

/*!
 * supportedOrientations allows you to change which orientation the in-app message supports.
 * In-app messages will normally support the orientations specified in the app settings, but method
 * preferredInterfaceOrientationForPresentation may optionally override that. The value of supportedOrientations will be
 * returned in preferredInterfaceOrientationForPresentation in in-app message view controller.
 *
 * The default value of supportedOrientations includes all orientations: UIInterfaceOrientationPortrait,
 * UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationLandscapeLeft and UIInterfaceOrientationPortraitUpsideDown.
 */
@property UIInterfaceOrientation supportedOrientations;

/*!
 * keyboardVisible will have the value YES when the keyboard is shown.
 */
@property BOOL keyboardVisible;

/*!
 * The ABKInAppMessageWindowController that is being shown.
 */
@property (nullable) ABKInAppMessageWindowController *inAppMessageWindowController;

/*!
 * The optional ABKInAppMessageUIDelegate that can be used to specify the UI behaviors of in-app messages.
 */
@property (weak, nullable) id<ABKInAppMessageUIDelegate> uiDelegate;

@end
