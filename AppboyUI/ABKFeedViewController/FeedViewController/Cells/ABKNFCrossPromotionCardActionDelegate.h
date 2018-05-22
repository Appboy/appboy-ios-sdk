#import <UIKit/UIKit.h>

@protocol ABKNFCrossPromotionCardActionDelegate <NSObject>

- (void)openItunesStoreProductWithId:(NSNumber *)productId url:(NSURL *)url;

@end
