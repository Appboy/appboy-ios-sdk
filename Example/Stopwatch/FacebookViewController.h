#import <UIKit/UIKit.h>

@interface FacebookViewController : UIViewController

@property IBOutlet UITextView *facebookDataTextView;
@property NSDictionary *facebookUserProfile;
@property NSArray *facebookLikes;
@property NSInteger numberOfFacebookFriends;

// This method will prompt the user for permission to use facebook account data from iOS system.
- (IBAction)fetchFacebookAccountData:(id)sender;
- (IBAction)passFacebookDataToAppboy:(id)sender;

@end
