//
//  AlertControllerUtils.m
//  Stopwatch
//
//  Created by Daniel Hok on 2/14/19.
//  Copyright © 2019 Appboy. All rights reserved.
//

#import "AlertControllerUtils.h"

@implementation AlertControllerUtils

+ (void)presentAlertWithOKButtonForTitle:(NSString *)title
                                 message:(NSString *)message
                            presentingVC:(UIViewController *)presentingVC
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
  [alert addAction:okButton];
  [presentingVC presentViewController:alert animated:YES completion:nil];
}

@end
