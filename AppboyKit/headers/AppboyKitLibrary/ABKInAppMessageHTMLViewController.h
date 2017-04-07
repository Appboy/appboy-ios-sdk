#import <UIKit/UIKit.h>
#import "ABKInAppMessageHTML.h"
#import "ABKInAppMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTMLViewController : ABKInAppMessageViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
NS_ASSUME_NONNULL_END
