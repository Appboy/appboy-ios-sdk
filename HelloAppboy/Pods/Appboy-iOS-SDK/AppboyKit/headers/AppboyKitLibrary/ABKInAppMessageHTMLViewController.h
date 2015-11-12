#import <UIKit/UIKit.h>
#import "ABKInAppMessageHTML.h"
#import "ABKInAppMessageViewController.h"

@interface ABKInAppMessageHTMLViewController : ABKInAppMessageViewController <UIWebViewDelegate>

@property IBOutlet UIWebView *webView;

@end
