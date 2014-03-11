#import <Foundation/Foundation.h>

/*
 * There are two possible values which control where the slideup will enter the view.
 *
 *    ABKSlideupFromBottom - This is the default behavior.
 *      The slideup will slide onto the screen from the bottom edge of the view and will hide by sliding back down off
 *      the bottom of the screen.
 *
 *    ABKSlideupFromTop - The slideup will slide onto the screen from the top edge of the view and will hide by sliding
 *      back up off the top of the screen.
 */
typedef NS_ENUM(NSInteger, ABKSlideupAnchor) {
  ABKSlideupFromTop,
  ABKSlideupFromBottom
};

/*
 * The ABKSlideupDismissType defines how the slideup can be dismissed.
 *
 *   ABKSlideupDismissAutomatically - This is the default behavior. It will dismiss after the length of time defined by
 *     the duration property. Slideups of this type can also be dismissed by swiping.
 *
 *   ABKSlideupDismissBySwipe - The slideup will stay on the screen indefinitely unless dismissed by swiping.
 */
typedef NS_ENUM(NSInteger, ABKSlideupDismissType) {
  ABKSlideupDismissAutomatically,
  ABKSlideupDismissBySwipe
};

/*
 * The ABKSlideupClickActionType defines the action that will be performed when the Slideup is clicked.
 *
 *   ABKSlideupDisplayNewsFeed - This is the default behavior. It will open a modal view of Appboy news feed.
 *
 *   ABKSlideupRedirectToURI - The slideup will try to redirect to the uri defined by the uri property. Only when the uri
 *    is an HTTP URL, a modal web view will be displayed. If the uri is a protocol uri, the slideup will redirect to the
 *    protocol uri.
 *
 *   ABKSlideupNoneClickAction - The slideup will do nothing but dismiss itself.
 */
typedef NS_ENUM(NSInteger, ABKSlideupClickActionType) {
  ABKSlideupDisplayNewsFeed,
  ABKSlideupRedirectToURI,
  ABKSlideupNoneClickAction
};

@interface ABKSlideup : NSObject

/*
 * This property defines the message displayed within the slideup.
 */
@property (nonatomic, copy) NSString *message;

/*
 * If hideChevron equals YES, the slideup will not render the chevron on the right side of the slideup.
 * The chevron is a useful visual cue for the user that more content may be reached by tapping the slideup.
 */
@property (nonatomic, assign) BOOL hideChevron;

/*
 * This property carries extra data in the form of an NSDictionary which can be sent down via the Appboy Dashboard.
 * You may want to design and implement a custom handler to access this data depending on your use-case.
 */
@property (nonatomic, retain) NSDictionary *extras;

/*
 * slideupAnchor defines the position of the slideup on screen.
 * The ABKSlideupAnchor enum documentation above offers additional details.
 */
@property (nonatomic, assign) ABKSlideupAnchor slideupAnchor;

/*
 * This property defines the number of seconds before the slideup is automatically dismissed.
 */
@property (nonatomic, assign) NSTimeInterval duration;

/*
 * slideupDismissType defines the dismissal behavior of the slideup.
 * See the above documentation for ABKSlideupDismissType for additional details.
 */
@property (nonatomic, assign) ABKSlideupDismissType slideupDismissType;

/*
 * This property defines the action that will be performed when the Slideup is clicked.
 * See the ABKSlideupClickActionType enum documentation above offers additional details.
 */
@property (nonatomic, assign, readonly) ABKSlideupClickActionType slideupClickActionType;

/*
 * When the slideup's slideupClickActionType is ABKSlideupRedirectToURI, clicking on the slideup will redirect to the uri defined
 * in this property.
 *
 * This property can be a HTTP URI or a protocol URI.
 */
@property (nonatomic, copy, readonly) NSURL *uri;

/*
 * If you're handling slideups completely on your own (returning YES from onSlideupReceived), you should still report
 * impressions and clicks on the slideup back to Appboy with these methods so that your campaign reporting features
 * still work in the dashboard.
 *
 * Note: Each slideup can log at most one impression and at most one click.
 */
- (void) logSlideupImpression;
- (void) logSlideupClicked;

/*
 * This method will set the slideupClickActionType to ABKSlideupRedirectToURI. The parameter uri must not be nil.
 * The method will set the uri property as well.
 */
- (void) setSlideupClickActionToUri:(NSURL *)uri;

/*
 * This method will set the slideupClickActionType to ABKSlideupDisplayNewsFeed.
 * The method will set the uri property to nil.
 */
- (void) setSlideupClickActionToNewsFeed;

/*
 * This method will set the slideupClickActionType to ABKSlideupNoneClickAction.
 * The method will set the uri property to nil.
 */
- (void) setSlideupClickActionToNone;

/*
 * Serializes the slideup to binary data for use by wrappers such as Appboy's Unity SDK for iOS.
 */
- (NSData *) serializeToData;

@end
