#import "InterfaceController.h"
#import "AppboyWatchKit.h"

@interface InterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *timer;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *startStopButton;
@property (nonatomic) BOOL timerIsRunning;
@end

@implementation InterfaceController

- (IBAction)resetButtonTapped {
  if (self.timerIsRunning) {
    self.timerIsRunning = NO;
    [self.timer stop];
  }
  [self.timer setDate:[NSDate date]];
}

- (IBAction)startButtonTapped {
  if (self.timerIsRunning) {
    [self.timer stop];
    [self.startStopButton setTitle:@"Start"];
    [AppboyWatchKit logCustomEvent:@"Watch_Timer_Stop"];
  } else {
    // Here we need to set the timer again to make sure it starts from 0.
    [self.timer setDate:[NSDate date]];
    [self.timer start];
    [self.startStopButton setTitle:@"Stop"];
    [AppboyWatchKit logCustomEvent:@"Watch_Timer_Begin"];
  }
  self.timerIsRunning = !self.timerIsRunning;
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification {
  // Log a remote notification push open on the watch to Appboy.
  [AppboyWatchKit logActionWithIdentifier:identifier forRemoteNotification:remoteNotification];
}

@end
