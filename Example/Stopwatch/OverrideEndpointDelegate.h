#import <Foundation/Foundation.h>
#import "ABKAppboyEndpointDelegate.h"

@interface OverrideEndpointDelegate : NSObject <ABKAppboyEndpointDelegate>

- (instancetype)initWithEndpoint:(NSString *)endpoint;

@property NSString *appboyEndpoint;

@end
