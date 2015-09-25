#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)logLikeAppboyEvent:(id)sender {
  [[Appboy sharedInstance] logCustomEvent:@"like Appboy"];
}

- (IBAction)ratingChange:(UISlider *)sender {
  self.ratingLabel.text = [NSString stringWithFormat:@"%f", sender.value];
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"Appboy love rate" andDoubleValue:(double)self.ratingSlider.value];
}

@end
