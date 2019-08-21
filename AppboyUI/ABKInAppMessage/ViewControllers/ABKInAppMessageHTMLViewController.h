#import <UIKit/UIKit.h>
#import "ABKInAppMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTMLViewController : ABKInAppMessageViewController <UIWebViewDelegate>

/*!
 * The UIWebView used to parse and display the HTML.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@property (weak, nonatomic) IBOutlet UIWebView *webView;

#pragma clang diagnostic pop

@end
NS_ASSUME_NONNULL_END
