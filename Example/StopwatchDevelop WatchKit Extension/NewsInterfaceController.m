#import "NewsInterfaceController.h"

static NSString *const StopwatchSuiteName = @"group.com.appboy.stopwatch";

@interface NewsInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *newsBodyLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *newsTitleLabel;

@end

@implementation NewsInterfaceController

- (void)willActivate {
  [super willActivate];
  NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:StopwatchSuiteName];
  id card = [defaults objectForKey:@"AppboyFirstNews"];
  if (card) {
    self.newsTitleLabel.text = card[@"news-title"];
    self.newsBodyLabel.text = card[@"news-body"];
  }
}

@end
