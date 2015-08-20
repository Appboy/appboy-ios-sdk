#import <Foundation/Foundation.h>


/*
 * Appboy Public API: ABKAttributionData
 */
@interface ABKAttributionData : NSObject

/*!
 * @param network The attribution network
 * @param campaign The attribution campaign
 * @param adGroup The attribution adGroup
 * @param creative The attribution creative
 *
 * @discussion: Creates an ABKAttributionData object to send to Appboy's servers.
 */
- (id) initWithNetwork:(NSString *)network
              campaign:(NSString *)campaign
               adGroup:(NSString *)adGroup
              creative:(NSString *) creative;

@property (nonatomic, readonly) NSString *network;
@property (nonatomic, readonly) NSString *campaign;
@property (nonatomic, readonly) NSString *adGroup;
@property (nonatomic, readonly) NSString *creative;
@end