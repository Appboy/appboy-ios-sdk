#import "AboutViewController.h"
#import "AppboyKit.h"
#import "AppDelegate.h"

@implementation AboutViewController

- (void)viewDidLoad {
  [self updateLabels];
}

- (void)updateLabels {
  self.apiKeyLabel.numberOfLines = 0;
  self.apiKeyLabel.text = [NSString stringWithFormat:@"API Key: %@", [[NSUserDefaults standardUserDefaults] stringForKey:ApiKeyInUse]];
  [self.apiKeyLabel sizeToFit];

  self.apiEndpointLabel.numberOfLines = 0;
  self.apiEndpointLabel.text = [NSString stringWithFormat:@"Endpoint: %@", [[NSUserDefaults standardUserDefaults] stringForKey:EndpointInUse]];
  [self.apiEndpointLabel sizeToFit];
}

@end
