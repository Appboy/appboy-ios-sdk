#import <AppboyKit.h>
@interface CustomSlideupViewController : ABKSlideupViewController

@property (retain, nonatomic) IBOutlet UILabel *slideupMessageLabel;

// dismiss the slideup
- (IBAction)closeButtonTapped:(id)sender;

@end
