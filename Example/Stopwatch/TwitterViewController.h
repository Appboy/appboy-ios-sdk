#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController

@property IBOutlet UITextView *twitterDataTextView;
@property (copy) NSString* userDescription;
@property (copy) NSString* twitterName;
@property (copy) NSString* profileImageUrl;
@property (copy) NSString* screenName;
@property NSInteger followersCount;
@property NSInteger friendsCount;
@property NSInteger statusesCount;
@property NSInteger twitterID;

// This method will prompt the user for permission to use twitter account data from iOS system.
- (IBAction)fetchTwitterAccountData:(id)sender;
- (IBAction)passTwitterDataToAppboy:(id)sender;

@end
