#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *twitterDataTextView;
@property (nonatomic, copy) NSString* userDescription;
@property (nonatomic, copy) NSString* twitterName;
@property (nonatomic, copy) NSString* profileImageUrl;
@property (nonatomic, copy) NSString* screenName;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger statusesCount;
@property (nonatomic, assign) NSInteger twitterID;

// This method will prompt the user for permission to use twitter account data from iOS system.
- (IBAction)fetchTwitterAccountData:(id)sender;
- (IBAction)passTwitterDataToAppboy:(id)sender;
@end
