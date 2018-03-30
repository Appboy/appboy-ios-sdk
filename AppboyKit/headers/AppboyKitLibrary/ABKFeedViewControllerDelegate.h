#import <Foundation/Foundation.h>

@class ABKCard;

/*
 * Braze Public API: ABKFeedViewControllerDelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKFeedViewControllerDelegate <NSObject>
@optional
/*!
 * @param newsFeed The calling News Feed context.
 * @param clickedCard The card that was clicked by the user.
 * @return A boolean value that controls whether Appboy will handle opening the URL of the clicked card.
 *         Returning YES will prevent Appboy from opening the URL.
 *         Returning NO will cause Appboy to handle opening the URL.
 *
 * This delegate method is called whenever a News Feed card is clicked.
 */
- (BOOL)onCardClicked:(ABKCard *)clickedCard feedViewController:(UIViewController *)newsFeed;

@end
NS_ASSUME_NONNULL_END
