#import "AlertControllerUtils.h"

@implementation AlertControllerUtils

+ (void)presentTemporaryAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                            presentingVC:(UIViewController *)presentingVC
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [presentingVC presentViewController:alert animated:YES completion:nil];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [alert dismissViewControllerAnimated:YES completion:nil];
  });
}

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
