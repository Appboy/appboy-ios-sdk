#import <Foundation/Foundation.h>
#import <AppboyKit.h>

@interface SdkAuthDelegate : NSObject <ABKSdkAuthenticationDelegate>

/*
 * Requests the sdk authentication token.
 *
 * This is an example implementation using a simple endpoint to request an authentication token for
 * a specific user id.
 * Your implementation can differ greatly depending on your authentication flow.
 *
 * The completion block is called with a nil token when the request fails.
 */
- (void)requestSdkAuthTokenForUserId:(nullable NSString *)userId
                          completion:(void (^ _Nonnull)(NSString * _Nullable token))completion;

@end
