#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MiscViewController : UIViewController <UIScrollViewDelegate, CLLocationManagerDelegate>

@property IBOutlet UILabel *versionLabel;
@property IBOutlet UILabel *flushModeLabel;
@property NSInteger attributionCounter;
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UITextField *apiKeyTextField;
@property IBOutlet UITextField *endointTextField;
@property IBOutlet UITextField *sessionTimeoutTextField;
@property (weak, nonatomic) IBOutlet UISwitch *inAppMessageDelegateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *urlDelegateSwitch;

// Stopwatch setting that determines to enable/disable Dark Mode colors
@property (strong, nonatomic) IBOutlet UISwitch *allowDarkThemeToggle;
// Stopwatch custom theme example
@property IBOutlet UILabel *customThemeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *customThemePicker;

// Stopwatch setting that determines to display silent push alerts
@property (weak, nonatomic) IBOutlet UISwitch *showSilentPushAlertsToggle;

- (IBAction)flushAppboyData:(id)sender;
- (IBAction)changeAppboyFlushMode:(id)sender;
- (IBAction)logAttributionData:(id)sender;
- (IBAction)launchCachedFilesAlertView:(id)sender;
- (IBAction)logSingleLocation:(id)sender;
- (IBAction)setInAppDelegateSwitchChanged:(id)sender;
- (IBAction)urlDelegateSwitchChanged:(id)sender;
- (IBAction)setSessionTimeout:(id)sender;
- (IBAction)manuallyRequestGeofences:(id)sender;

@end
