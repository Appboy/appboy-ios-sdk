#import "TwitterViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppboyKit.h"

static NSString *const TwitterAccountDescriptionKey = @"description";
static NSString *const TwitterAccountFollowersKey = @"followers_count";
static NSString *const TwitterAccountFollowingKey = @"friends_count";
static NSString *const TwitterAccountNumTweetsKey = @"statuses_count";
static NSString *const TwitterAccountUserIdKey = @"id";
static NSString *const TwitterAccountNameKey = @"name";
static NSString *const TwitterAccountImageUrlKey = @"profile_image_url";
static NSString *const TwitterAccountTwitterHandleKey = @"screen_name";
static NSString *const TwitterUserLookupEndpointUrl = @"https://api.twitter.com/1.1/users/lookup.json";

@implementation TwitterViewController

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
- (void)promptUserToConnectTwitterAccountOnDeviceAndFetchAccountData {
  // First, we need to obtain the account instance for the user's Twitter account
  ACAccountStore *store = [[ACAccountStore alloc] init];
  ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  // Request permission from the user to access the available Twitter accounts
  [store requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
    if (error) {
      NSLog(@"Error returned from Twitter access request: %@", error);
    }
    if (!granted) {
      NSLog(@"No Twitter account connected to the device, or user rejected the request.");
    } else {
      ACAccount *account = nil;
      NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
      if ([twitterAccounts count] > 0) {
        // Use the first account for simplicity
        account = twitterAccounts[0];
      }
      
      if (account != nil) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"include_entities", account.username, @"screen_name", nil];
        //  Build the request with our parameter
        NSURL *url = [NSURL URLWithString:TwitterUserLookupEndpointUrl];
        id request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
        
        if (request != nil) {
          // Attach the account object to this request
          [request setAccount:account];
          [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            // If we don't have any data, see what the error was
            if (!responseData) {
              NSLog(@"No data came back from Twitter. Error is: %@", error);
            } else {
              NSError *jsonError;
              id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
              // Log the response or error from Twitter
             
              if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  // The block is called in the background thread, so here we need to make sure to update the UI in the main thread.
                  self.twitterDataTextView.text = [result description];
                });
                if ([result isKindOfClass:[NSArray class]] && ![result isEmpty]) {
                  NSDictionary *twitter = result[0];
                  self.userDescription = twitter[TwitterAccountDescriptionKey];
                  self.twitterName = twitter[TwitterAccountNameKey];
                  self.profileImageUrl = twitter[TwitterAccountImageUrlKey];
                  self.friendsCount = [twitter[TwitterAccountFollowingKey] integerValue];
                  self.followersCount = [twitter[TwitterAccountFollowersKey] integerValue];
                  self.screenName = twitter[TwitterAccountTwitterHandleKey];
                  self.statusesCount = [twitter[TwitterAccountNumTweetsKey] integerValue];
                  self.twitterID = [twitter[TwitterAccountUserIdKey] integerValue];
                }
              } else {
                self.twitterDataTextView.text = [jsonError description];
              }
            }
          }];
        }
      }
    }
  }];
}

- (IBAction)fetchTwitterAccountData:(id)sender {
  [self promptUserToConnectTwitterAccountOnDeviceAndFetchAccountData];
}

// Pass the user's Twitter data to Appboy
- (IBAction)passTwitterDataToAppboy:(id)sender {
  ABKTwitterUser *twitterUser = [[ABKTwitterUser alloc] init];
  twitterUser.userDescription = self.userDescription;
  twitterUser.twitterID = self.twitterID;
  twitterUser.twitterName = self.twitterName;
  twitterUser.profileImageUrl = self.profileImageUrl;
  twitterUser.friendsCount = self.friendsCount;
  twitterUser.followersCount = self.followersCount;
  twitterUser.screenName = self.screenName;
  twitterUser.statusesCount = self.statusesCount;
  [Appboy sharedInstance].user.twitterUser = twitterUser;
}
@end
