#import <UIKit/UIKit.h>

@interface FacebookViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *facebookDataTextView;
@property (retain, nonatomic) NSDictionary *facebookUserProfile;
@property (retain, nonatomic) NSArray *facebookLikes;
@property (assign, nonatomic) NSInteger numberOfFacebookFriends;

// This method will prompt the user for permission to use facebook account data from iOS system.
- (IBAction)fetchFacebookAccountData:(id)sender;
- (IBAction)passFacebookDataToAppboy:(id)sender;
@end
