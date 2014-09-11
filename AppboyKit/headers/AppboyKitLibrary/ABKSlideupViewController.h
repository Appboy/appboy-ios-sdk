
/*
 * ABKSlideupViewController is the class for the slideup view controller.
 *  * In order to create a custom view controller you must:
 *  *  * Create a subclass of ABKSlideupViewController
 *  *  * The view of the subclass instance must be an instance of ABKSlideupView or optionally a subclass thereof.
 *
 *  * The custom slideup view controller must handle and account for:
 *  *  * Slideup messages of varying lengths.
 *  *  * Different possible layouts and orientations for possible devices
 *  *  *  * e.g. iPhone [Portrait & Landscape] as well as iPad [Portrait & Landscape].
 *
 *  * Note: Adding buttons which do anything other than dismiss the slideup within a custom slideup view controller will
 *  * disable Appboy's ability to capture analytics regarding clicks on the slideup.
 *
 */

#import <UIKit/UIKit.h>

@class ABKSlideup;

@interface ABKSlideupViewController : UIViewController
@property (nonatomic, retain) ABKSlideup *slideup;

/*
 * The initWithSlideup method may be used to pass the slideup property to any custom view controller that you create.
 */
- (id) initWithSlideup:(ABKSlideup *)slideup;

/*!
 * @param animated If YES, the slideup will slide off the screen. If NO, the slideup will disappear immediately without an animation.
 *
 * @discussion The void method hideSlideup may be called in order to dismiss the slideup. Animation of the dismissal is controlled with the animated parameter.  
 */
- (void) hideSlideup:(BOOL)animated;

@end


