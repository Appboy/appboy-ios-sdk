#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKAppboyEndpointDelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKAppboyEndpointDelegate <NSObject>
/*!
 * Given a valid Appboy API endpoint URI string, this method returns a valid endpoint URI string.
 *
 * @param appboyEndpoint A URI string for an Appboy API endpoint
 * @return A valid Appboy API endpoint URI
 */
- (NSString *)getApiEndpoint:(NSString *)appboyApiEndpoint;

@end
NS_ASSUME_NONNULL_END
