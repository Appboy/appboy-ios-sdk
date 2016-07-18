#import "FacebookViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppboyKit.h"

static NSString *const FacebookIDPlistKey = @"FacebookAppID";
static NSString *const FacebookUserProfileEndpointUrl = @"https://graph.facebook.com/v2.6/me";
static NSString *const FacebookLikesEndpointUrl = @"https://graph.facebook.com/v2.6/me/likes";
static NSString *const FacebookFriendsEndpointUrl = @"https://graph.facebook.com/v2.6/me/friends";

@implementation FacebookViewController

/*
 * This method prompts user to connect the Facebook acount on the device, and fetch account data.
 * It can only fetch the Facebook data when:
 *     The plist has Facebook ID set up.
 *     There is at least one Facebook account signed in on the device.
 *
 * If the user has grants permissions, the method will send three requests to fetch user's profile data,
 * friends, and likes, and store them in the properties.
 * You can use this method as a replacement of
 * [[Appboy sharedInstance] promptUserForAccessToSocialNetwork:ABKSocialNetworkFacebook].
 *
 * After getting all the user's Facebook data, you can pass the information to Appboy using
 * method "- (IBAction)passFacebookDataToAppboy:(id)sender";
 */
- (void)promptUserToConnectFacebookAccountOnDeviceAndFetchAccountData {
  ACAccountStore *store = [[ACAccountStore alloc] init];
  // Please put your Facebook ID in the app's plist file with key "FacebookAppID"
  NSString *facebookID = [[NSBundle mainBundle] infoDictionary][FacebookIDPlistKey];
  // Here you can change Facebook read permission.
  NSArray *facebookPermission = @[@"user_about_me", @"email", @"user_hometown", @"user_likes", @"user_birthday"];
  ACAccountType *facebookAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  NSDictionary *options = @{ACFacebookAppIdKey : facebookID, ACFacebookPermissionsKey : facebookPermission};
  
  void (^requestAccessCompletionBlock)(ACAccount *, NSString *) = ^(ACAccount *account,  NSString *endPointUrl) {
    // Now make an authenticated request to our endpoint
    NSURL *url = [NSURL URLWithString:endPointUrl];
    //  Build the request with our parameter
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:url parameters:nil];
    [request setAccount:account];
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
       if (!responseData) {
         NSLog(@"Error from Facebook response: %@", error);
       } else {
         NSError *jsonError;
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
         if ([endPointUrl isEqualToString:FacebookUserProfileEndpointUrl]) {
           self.facebookUserProfile = result;
         } else if ([endPointUrl isEqualToString:FacebookLikesEndpointUrl]) {
           self.facebookLikes = result[@"data"];
         } else if ([endPointUrl isEqualToString:FacebookFriendsEndpointUrl]) {
           self.numberOfFacebookFriends = ((NSArray *)result[@"data"]).count;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
           // The block is called in the background thread, so here we need to make sure to update the UI in the main thread.
           self.facebookDataTextView.text =[[result description] stringByAppendingString:self.facebookDataTextView.text];
         });
       }
     }];
  };
  
  //  Request permission from the user to access the available Facebook accounts
  [store requestAccessToAccountsWithType:facebookAccountType
                                 options:options
                              completion:^(BOOL granted, NSError *error) {
                                if (error) {
                                  NSLog(@"Error returned from OS Facebook access request: %@", error);
                                  return;
                                }
                                if (!granted) {
                                  NSLog(@"No Facebook account connected to the device, or user rejected request.");
                                } else {
                                  // Grab the available accounts
                                  NSArray *facebookAccounts = [store accountsWithAccountType:facebookAccountType];
                                  
                                  if ([facebookAccounts count] > 0) {
                                    // Use the first account for simplicity
                                    ACAccount *account = facebookAccounts[0];
                                    
                                    [store renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *renewError) {
                                      if (renewError) {
                                        NSLog(@"Error encountered while renewing Facebook account: %@", error);
                                      } else {
                                        NSLog(@"Renewed Facebook access token with status %ld", (long)renewResult);
                                        requestAccessCompletionBlock(account, FacebookUserProfileEndpointUrl);
                                        requestAccessCompletionBlock(account, FacebookLikesEndpointUrl);
                                        requestAccessCompletionBlock(account, FacebookFriendsEndpointUrl);
                                      }
                                    }];
                                  }
                                }
                              }];
}

- (IBAction)fetchFacebookAccountData:(id)sender {
  [self promptUserToConnectFacebookAccountOnDeviceAndFetchAccountData];
}

// Pass the user's Facebook data to Appboy
- (IBAction)passFacebookDataToAppboy:(id)sender {
  ABKFacebookUser *facebookUser = [[ABKFacebookUser alloc] initWithFacebookUserDictionary:self.facebookUserProfile numberOfFriends:self.numberOfFacebookFriends likes:self.facebookLikes];
  [Appboy sharedInstance].user.facebookUser = facebookUser;
}
@end
