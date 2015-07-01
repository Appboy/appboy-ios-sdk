#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKAppboyEndpointDelegate
 */
@protocol ABKAppboyEndpointDelegate <NSObject>

/*!
 * Given a valid Appboy API endpoint URI string, this method returns a valid endpoint URI string.
 *
 * @param appboyEndpoint A URI string for an Appboy API endpoint
 * @return A valid Appboy API endpoint URI
 */
- (NSString *) getApiEndpoint:(NSString *)appboyApiEndpoint;

/*!
 * Given a valid Appboy Resource endpoint URI string, this method returns a valid resource endpoint URI string.
 * Currently resource endpoints are image URIs, but may be extended to include video and other external content.
 *
 * @param appboyResourceEndpoint A URI string for an Appboy API resource endpoint
 * @return A valid Appboy API resource endpoint URI
 */
- (NSString *) getResourceEndpoint:(NSString *)appboyResourceEndpoint;
@end
