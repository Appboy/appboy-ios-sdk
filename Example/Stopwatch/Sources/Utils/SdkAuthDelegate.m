#import <AppboyKit.h>
#import "LoggerUtils.h"
#import "SdkAuthDelegate.h"

static NSString *const SdkAuthTokenEndpoint = @"https://us-central1-jwt-responder.cloudfunctions.net/getToken";

@implementation SdkAuthDelegate

#pragma mark - ABKSdkAuthenticationDelegate

- (void)handleSdkAuthenticationError:(ABKSdkAuthenticationError *)authError {
  StopwatchDebugMsg(@"SDK Authentication Error: %ld %@", (long)authError.code, authError.reason);

  if (authError.userId
      && Appboy.sharedInstance.user.userID
      && ![authError.userId isEqualToString:Appboy.sharedInstance.user.userID]) {
    StopwatchDebugMsg(@"SDK Authentication Error: error user id does not match current user id, skipping refresh token request", nil);
  }

  // Request + update SDK authentication token
  [self requestSdkAuthTokenForUserId:Appboy.sharedInstance.user.userID
                          completion:^(NSString * token) {
    [Appboy.sharedInstance setSdkAuthenticationSignature:token];
  }];
}

#pragma mark - Helper Methods

- (void)requestSdkAuthTokenForUserId:(nullable NSString *)userId
                          completion:(void (^ _Nonnull)(NSString * _Nullable token))completion {
  if (userId == nil) {
    StopwatchDebugMsg(@"SDK Authentication Error: no user id, cannot refresh authentication token", nil);
    return;
  }

  // Setup request
  NSURL *url = [NSURL URLWithString:SdkAuthTokenEndpoint];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"POST";
  NSDictionary *body = @{@"data": @{@"user_id": userId}};
  request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
  request.allHTTPHeaderFields = @{
    @"Content-Type": @"application/json",
    @"Accept": @"application/json"
  };

  // Launch request
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data,
                                   NSURLResponse * _Nullable response,
                                   NSError * _Nullable error) {
      if (data.length == 0 || response == nil || error) {
        StopwatchDebugMsg("SDK Authentication Error: failed to refresh auth token - error: %@", error)
        // Completion failure
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil);
        });
        return;
      }

      NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSMutableString *token = [payload[@"data"][@"token"] mutableCopy];

      // Completion success
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(token);
      });
    }];

  [task resume];
}

@end
