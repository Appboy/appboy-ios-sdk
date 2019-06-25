#import "OverrideEndpointDelegate.h"

@implementation OverrideEndpointDelegate

- (instancetype)initWithEndpoint:(NSString *)endpoint {
  self = [super init];
  if (self) {
    self.appboyEndpoint = endpoint;
  }
  return self;
}

- (NSString *)getApiEndpoint:(NSString *)appboyApiEndpoint {
    NSMutableString *modifiedEndpoint = [appboyApiEndpoint mutableCopy];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"https.*\\.com" options:0 error:nil];
    
    if (self.appboyEndpoint && modifiedEndpoint) {
        [regex replaceMatchesInString:modifiedEndpoint options:0 range:NSMakeRange(0, [modifiedEndpoint length]) withTemplate:self.appboyEndpoint];
        if (![modifiedEndpoint containsString:@"https://"] && ![modifiedEndpoint containsString:@"http://"]) {
            modifiedEndpoint = [NSMutableString stringWithFormat:@"https://%@", modifiedEndpoint];
        }
    }
    
    return [modifiedEndpoint copy];
}

@end
