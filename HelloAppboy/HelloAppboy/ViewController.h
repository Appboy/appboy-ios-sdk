#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UISlider *ratingSlider;

- (IBAction)logLikeAppboyEvent:(id)sender;
- (IBAction)ratingChange:(UISlider *)sender;
@end
