#import "MiscViewController.h"
#import <AppboyKit.h>
#import "ABKAttributionData.h"
#import "ABKLocationManager.h"
#import "AppDelegate.h"
#import "AlertControllerUtils.h"
#import "CustomThemesDataSource.h"

@interface MiscViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (nonatomic, strong) CustomThemesDataSource *customThemesDataSource;

- (void)updateScrollViewContentSize;
- (void)setViewBottomSpace:(CGFloat)bottomSpace;

@end

@implementation MiscViewController

- (void)viewDidLoad{
  [super viewDidLoad];
  self.customThemesDataSource = [[CustomThemesDataSource alloc] init];
  self.customThemePicker.dataSource = self.customThemesDataSource;
  self.customThemePicker.delegate = self.customThemesDataSource;
  [self.customThemePicker selectRow:[self.customThemesDataSource currentTheme] inComponent:0 animated:NO];
  
  self.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.appboy-version.message", nil), APPBOY_SDK_VERSION];
  [self displayAppboyRequestPolicy];
  self.attributionCounter++;
  
  self.apiKeyTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:OverrideApiKeyStorageKey];
  self.endointTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:OverrideEndpointStorageKey];
  self.inAppMessageDelegateSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:SetInAppMessageControllerDelegateKey];
  self.urlDelegateSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:SetURLDelegateKey];
  self.sessionTimeoutTextField.keyboardType = UIKeyboardTypeNumberPad;
  self.sessionTimeoutTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:NewSessionTimeoutKey];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateScrollViewContentSize];
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Scroll view settings

- (void)updateScrollViewContentSize {
  self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.contentViewHeightConstraint.constant);
}

- (void)setViewBottomSpace:(CGFloat)bottomSpace {
  self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, bottomSpace, 0.0);
}

/* Data Flush Settings */

// This is the selector of flushAppboyData Button which flushes queued data to the Braze servers manually on demand.
- (IBAction)flushAppboyData:(id)sender {
  NSLog(@"Flushing data to Braze.");
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
  [self showAlertWithMessage:@"Data was successfully flushed"];
}

- (IBAction)changeAppboyFlushMode:(id)sender {
  switch ([Appboy sharedInstance].requestProcessingPolicy) {
    case ABKAutomaticRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKManualRequestProcessing;
      NSLog(@"Changing request processing policy to ABKManualRequestProcessing.");
      break;
    case ABKManualRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKAutomaticRequestProcessing;
      NSLog(@"Changing request processing policy to ABKAutomaticRequestProcessing.");
      break;
    default:
      break;
  }
  [self displayAppboyRequestPolicy];
}

- (void)displayAppboyRequestPolicy {
  ABKRequestProcessingPolicy requestPolicy = [Appboy sharedInstance].requestProcessingPolicy;
  switch (requestPolicy) {
    case ABKAutomaticRequestProcessing:
      self.flushModeLabel.text = @"ABKAutomaticRequestProcessing";
      break;
      
    case ABKManualRequestProcessing:
      self.flushModeLabel.text = @"ABKManualRequestProcessing";
      break;
      
    default:
      break;
  }
  [self.flushModeLabel setNeedsDisplay];
}

/* Logging Attribution Data */
- (IBAction)logAttributionData:(id)sender {
  ABKAttributionData *attributionData = [[ABKAttributionData alloc]
                                         initWithNetwork:[self attributionStringGenerator:@"network"]
                                         campaign:[self attributionStringGenerator:@"campaign"]
                                         adGroup:[self attributionStringGenerator:@"adgroup"]
                                         creative:[self attributionStringGenerator:@"creative"]];
  [[Appboy sharedInstance].user setAttributionData:attributionData];
  [self showAlertWithMessage:@"Attribution Data was successfully logged."];
  self.attributionCounter++;
}

- (NSString *)attributionStringGenerator:(NSString *)inputString {
  return [inputString stringByAppendingString:[NSString stringWithFormat:@"%li", (long)self.attributionCounter]];
}

/* Showing Caches Dir Files */
- (IBAction)launchCachedFilesAlertView:(id)sender {
  NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
  NSArray *allFiles = [self getDirectoryContentsWithPath:cachePath];
  NSString *fileString = [allFiles componentsJoinedByString:@"\n"];
  [AlertControllerUtils presentTemporaryAlertWithTitle:@"Cache Files"
                                                 message:fileString
                                            presentingVC:self];
}

- (IBAction)rebootAndApplyEnvironment:(id)sender {
  if ([[self.endointTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0) {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:OverrideEndpointStorageKey];
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:self.endointTextField.text forKey:OverrideEndpointStorageKey];
  }
  if ([[self.apiKeyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0) {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:OverrideApiKeyStorageKey];
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:self.apiKeyTextField.text forKey:OverrideApiKeyStorageKey];
  }
  [self showForceCloseAlertWithTitle:@"Environment Set"];
}

- (IBAction)rebootAndApplyK8Environment:(id)sender {
  [[NSUserDefaults standardUserDefaults] setObject:@"elsa.braze.com" forKey:OverrideEndpointStorageKey];
  [self showForceCloseAlertWithTitle:@"K8s Environment Set"];
}

- (NSArray *)getDirectoryContentsWithPath:(NSString *)path {
  NSMutableArray *returnArray = [NSMutableArray array];
  NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:path];
  BOOL isDirectory;
  int count = 1;
  for (NSString *item in subpaths){
    NSString *fullPath = [[path stringByAppendingString:@"/"] stringByAppendingString:item];
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
    if (fileExistsAtPath) {
      if (!isDirectory && ![item hasSuffix:@".DS_Store"]) {
        [returnArray addObject:[NSString stringWithFormat:@"%d) %@", count, item]];
        count++;
        NSLog(@"Cache file: %@", item);
      }
    }
  }
  return returnArray;
}

- (IBAction)setInAppDelegateSwitchChanged:(id)sender {
  [[NSUserDefaults standardUserDefaults] setBool:self.inAppMessageDelegateSwitch.on forKey:SetInAppMessageControllerDelegateKey];
  NSString *switchStatus = (self.inAppMessageDelegateSwitch.on) ? @"Set" : @"Unset";
  NSString *alertTitle = [NSString stringWithFormat:@"In-App Message Controller Delegate %@", switchStatus];
  [self showForceCloseAlertWithTitle:alertTitle];
}

- (IBAction)urlDelegateSwitchChanged:(id)sender {
  [[NSUserDefaults standardUserDefaults] setBool:self.urlDelegateSwitch.on forKey:SetURLDelegateKey];
  NSString *switchStatus = (self.urlDelegateSwitch.on) ? @"Set" : @"Unset";
  NSString *alertTitle = [NSString stringWithFormat:@"URL Delegate %@", switchStatus];
  [self showForceCloseAlertWithTitle:alertTitle];
}

- (IBAction)allowDarkThemeToggleSwitched:(id)sender {
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  appDelegate.stopwatchEnableDarkTheme = self.allowDarkThemeToggle.on;
}

- (IBAction)toggleSilentPushAlerts:(id)sender {
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  appDelegate.showSilentPushAlerts = self.showSilentPushAlertsToggle.on;
}

- (IBAction)setSessionTimeout:(id)sender {
  NSLog(@"session timeout called");
  [[NSUserDefaults standardUserDefaults] setObject:self.sessionTimeoutTextField.text forKey:NewSessionTimeoutKey];
  NSString *alertTitle = [NSString stringWithFormat:@"New Session Timeout: %@", self.sessionTimeoutTextField.text];
  [self showForceCloseAlertWithTitle:alertTitle];
}

/* Location Tracking */

- (IBAction)logSingleLocation:(id)sender {
  [[Appboy sharedInstance].locationManager logSingleLocation];
  [self showAlertWithMessage:@"Location was successfully logged."];
}

- (IBAction)manuallyRequestGeofences:(id)sender {
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

  if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
      authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [self showAlertWithMessage:@"Manually requesting Geofences."];
    [locationManager requestLocation];
  } else {
    [self showAlertWithMessage:@"Can't request geofences because of insufficient location permissions."];
  }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations lastObject];
  double longitude = location.coordinate.longitude;
  double latitude = location.coordinate.latitude;
  [[Appboy sharedInstance] requestGeofencesWithLongitude:longitude
                                                latitude:latitude];
  NSString *alertMessage = [NSString stringWithFormat:@"Requesting geofences with longitude %f and latitude %f", longitude, latitude];
  [self showAlertWithMessage:alertMessage];
  NSLog(@"%@", alertMessage);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Can't request geofences because of error:%@", error);
}

- (void)showForceCloseAlertWithTitle:(NSString *)title {
  [AlertControllerUtils presentTemporaryAlertWithTitle:title
                                                 message:@"Force Close App and Re-Open to Apply"
                                            presentingVC:self];
}

- (void)showAlertWithMessage:(NSString *)message {
  [AlertControllerUtils presentTemporaryAlertWithTitle:nil
                                                 message:message
                                            presentingVC:self];
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  CGFloat keyboardHeight = MIN(keyboardSize.width, keyboardSize.height);
  [self setViewBottomSpace:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self setViewBottomSpace:0.0];
}

#pragma mark - Transition

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  // updating content size when interface orientation changes
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {} completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self updateScrollViewContentSize];
  }];
}

@end
