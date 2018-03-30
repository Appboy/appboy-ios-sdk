#import <Foundation/Foundation.h>

/*
 * Braze Public API: ABKAppboyEndpointDelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKAppboyEndpointDelegate <NSObject>
/*!
 * Given a valid Braze API endpoint URI string, this method returns a valid endpoint URI string.
 *
 * @param appboyApiEndpoint A URI string for an Braze API endpoint
 * @return A valid Braze API endpoint URI
 */
- (NSString *)getApiEndpoint:(NSString *)appboyApiEndpoint;

@end
NS_ASSUME_NONNULL_END
