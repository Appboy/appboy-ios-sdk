#import "FlushModeTestViewController.h"
#import <AppboyKit.h>

@implementation FlushModeTestViewController

- (void)viewDidLoad{
  [super viewDidLoad];
	
  [self displayAppboyRequestPolicy];
}

// This is the selector of FlushAppboyData Button which flushes queued data to the Appboy servers manually on demand.
- (IBAction) FlushAppboyData:(id)sender {
  NSLog(@"FlushAppboyData:");
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
}

- (IBAction) changeAppboyFlushMode:(id)sender {
  NSLog(@"changeAppboyFlushMode:");
  switch ([Appboy sharedInstance].requestProcessingPolicy) {
    case ABKAutomaticRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKAutomaticRequestProcessingExceptForDataFlush;
      break;
      
    case ABKAutomaticRequestProcessingExceptForDataFlush:
      [Appboy sharedInstance].requestProcessingPolicy = ABKManualRequestProcessing;
      break;
      
    case ABKManualRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKAutomaticRequestProcessing;
      break;
      
    default:
      break;
  }
  [self displayAppboyRequestPolicy];
}

- (void) displayAppboyRequestPolicy {
  ABKRequestProcessingPolicy requestPolicy = [Appboy sharedInstance].requestProcessingPolicy;
  switch (requestPolicy) {
    case ABKAutomaticRequestProcessing:
      self.flushModeLabel.text = @"ABKAutomaticRequestProcessing";
      break;
      
    case ABKAutomaticRequestProcessingExceptForDataFlush:
      self.flushModeLabel.text = @"ABKAutomaticRequestProcessingExceptForDataFlush";
      break;
      
    case ABKManualRequestProcessing:
      self.flushModeLabel.text = @"ABKManualRequestProcessing";
      break;
      
    default:
      break;
  }
  [self.flushModeLabel sizeToFit];
  [self.flushModeLabel setNeedsDisplay];
}

// This method flushes all data within the request queue to the Appboy server, halts all communication with the Appboy
// server, and enables manual network request processing controls.
- (IBAction) flushAndShutDownAppboy:(id)sender {
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
  [[Appboy sharedInstance] shutdownServerCommunication];
}

- (void)viewDidUnload {
  [self setFlushModeLabel:nil];
  [super viewDidUnload];
}
@end
