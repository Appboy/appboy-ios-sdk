#import <Foundation/Foundation.h>

@class ABKCard;

/*
 * Appboy Public API: ABKFeedViewControllerDelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKFeedViewControllerDelegate <NSObject>
@optional
/*!
 @param newsFeed The calling news feed context
 @param clickedCard The card that's clicked by user.
 @return A boolean value indicates if Appboy should still try to display the url of the clicked card. If it's YES, Appboy
 will still display the content of the url as default. Otherwise, Appboy won't do anything but stay on the news feed.
 
 Called when a card on the news feed is clicked.
 */
- (BOOL)onCardClicked:(ABKCard *)clickedCard feedViewController:(UIViewController *)newsFeed;

@end
NS_ASSUME_NONNULL_END
