//
//  AlertControllerUtils.h
//  Stopwatch
//
//  Created by Daniel Hok on 2/14/19.
//  Copyright © 2019 Appboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertControllerUtils : NSObject

+ (void)presentAlertWithOKButtonForTitle:(NSString *)title
                                 message:(NSString *)message
                            presentingVC:(UIViewController *)presentingVC;

@end
