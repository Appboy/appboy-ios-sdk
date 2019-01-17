#import <UIKit/UIKit.h>
#import "ABKInAppMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTMLViewController : ABKInAppMessageViewController <UIWebViewDelegate>

/*!
 * The UIWebView used to parse and display the HTML.
 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
NS_ASSUME_NONNULL_END
