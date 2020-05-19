#import "LocationCustomAttributeViewController.h"
#import <MapKit/MapKit.h>
#import <AppboyKit.h>
#import "UIViewController+Keyboard.h"
#import "LocationAnnotation.h"

typedef NS_ENUM(NSInteger, LocationCustomAttributeAlertType) {
  LocationCustomAttributeAlertTypeAddSuccess,
  LocationCustomAttributeAlertTypeAddError,
  LocationCustomAttributeAlertTypeRemoveSuccess,
  LocationCustomAttributeAlertTypeRemoveError,
  LocationCustomAttributeAlertTypeEmptyKey,
  LocationCustomAttributeAlertTypeEmptyLocation
};

static NSString *const AnnotationReusableIdentifier = @"LocationReusableIdentifier";

@interface LocationCustomAttributeViewController () <UITextFieldDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *keyTextField;
@property (nonatomic, weak) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, weak) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) LocationAnnotation *annotation;

- (void)addAttribute;
- (void)removeAttribute;
- (NSString *)keyFromTextField;
- (CLLocation *)locationFromTextFieldShowAlert:(BOOL)show;
- (void)showAlertOfType:(LocationCustomAttributeAlertType)alertType argument:(NSString *)argument;

- (IBAction)addCustomAttributeTapped:(id)sender;
- (IBAction)removeCustomAttributeTapped:(id)sender;

@end

@implementation LocationCustomAttributeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addDismissGestureForView:self.view];
  [self addMapGesture];
}

- (void)addAttribute {
  NSString *key = [self keyFromTextField];
  if (key == nil) {
    return;
  }
  CLLocation *location = [self locationFromTextFieldShowAlert:YES];
  if (location == nil) {
    return;
  }
  BOOL success = [Appboy.sharedInstance.user addLocationCustomAttributeWithKey:key
                                                                      latitude:location.coordinate.latitude
                                                                     longitude:location.coordinate.longitude];
  LocationCustomAttributeAlertType alertType = success ? LocationCustomAttributeAlertTypeAddSuccess : LocationCustomAttributeAlertTypeAddError;
  [self showAlertOfType:alertType argument:key];
}

- (void)removeAttribute {
  NSString *key = [self keyFromTextField];
  if (key == nil) {
    return;
  }
  BOOL success = [Appboy.sharedInstance.user removeLocationCustomAttributeWithKey:key];
  LocationCustomAttributeAlertType alertType = success ? LocationCustomAttributeAlertTypeRemoveSuccess : LocationCustomAttributeAlertTypeRemoveError;
  [self showAlertOfType:alertType argument:key];
}

- (NSString *)keyFromTextField {
  NSString *key = [self.keyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (key.length == 0) {
    [self showAlertOfType:LocationCustomAttributeAlertTypeEmptyKey argument:nil];
    return nil;
  }
  return key;
}

- (CLLocation *)locationFromTextFieldShowAlert:(BOOL)show {
  NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSString *latitudeString = [self.latitudeTextField.text stringByTrimmingCharactersInSet:whitespaceCharacterSet];
  NSString *longitudeString = [self.longitudeTextField.text stringByTrimmingCharactersInSet:whitespaceCharacterSet];
  if (latitudeString.length == 0 || longitudeString.length == 0) {
    if (show) {
      [self showAlertOfType:LocationCustomAttributeAlertTypeEmptyLocation argument:nil];
    }
    return nil;
  }
  double latitude = [latitudeString doubleValue];
  double longitude = [longitudeString doubleValue];
  return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

- (void)addMapGesture {
  UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(longGesturePressed:)];
  [self.mapView addGestureRecognizer:gestureRecognizer];
}

- (void)updateMapAnnotation {
  CLLocation *location = [self locationFromTextFieldShowAlert:NO];
  if (location) {
    CLLocationCoordinate2D coordinate = location.coordinate;
    if (self.annotation == nil) {
      self.annotation = [[LocationAnnotation alloc] initWithCoordinate:coordinate];
      [self.mapView addAnnotation:self.annotation];
    } else {
      [self.annotation setCoordinate:coordinate];
    }
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(5.0, 5.0)) animated:YES];
  } else {
    [self.mapView removeAnnotation:self.annotation];
    self.annotation = nil;
  }
}

#pragma mark - Alert

- (void)showAlertOfType:(LocationCustomAttributeAlertType)alertType argument:(NSString *)argument {
  NSString *title = NSLocalizedString(@"Location Custom Attribute", @"");
  NSString *message = @"";
  switch (alertType) {
    case LocationCustomAttributeAlertTypeAddError:
      message = [NSString stringWithFormat:@"%@ %@.", NSLocalizedString(@"Error when adding location custom attribute", @""),
                 argument];
      break;
      
    case LocationCustomAttributeAlertTypeAddSuccess:
      message = [NSString stringWithFormat:@"%@ %@ %@.", NSLocalizedString(@"Location custom attribute", @""),
                 argument, @"was added successfully"];
      break;
      
    case LocationCustomAttributeAlertTypeRemoveError:
      message = [NSString stringWithFormat:@"%@ %@.", NSLocalizedString(@"Error when removing location custom attribute", @""),
                 argument];
      break;
      
    case LocationCustomAttributeAlertTypeRemoveSuccess:
      message = [NSString stringWithFormat:@"%@ %@ %@.", @"Location custom attribute", argument, @"was removed successfully"];
      break;
      
    case LocationCustomAttributeAlertTypeEmptyKey:
      message = @"Key must be not empty";
      break;
      
    case LocationCustomAttributeAlertTypeEmptyLocation:
      message = @"Location must be not empty";
      break;
  }
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"")
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Buttons

- (IBAction)addCustomAttributeTapped:(id)sender {
  [self addAttribute];
}

- (IBAction)removeCustomAttributeTapped:(id)sender {
  [self removeAttribute];
}

- (void)longGesturePressed:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint point = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
  self.latitudeTextField.text = [NSString stringWithFormat:@"%lf", coordinate.latitude];
  self.longitudeTextField.text = [NSString stringWithFormat:@"%lf", coordinate.longitude];
  [self updateMapAnnotation];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.longitudeTextField) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [textField resignFirstResponder];
    });
    return YES;
  }
  NSInteger nextTag = textField.tag + 1;
  UIResponder *nextResponder = [self.view viewWithTag:nextTag];
  [nextResponder becomeFirstResponder];
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField == self.latitudeTextField || textField == self.longitudeTextField) {
    [self updateMapAnnotation];
  }
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKAnnotationView *pinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationReusableIdentifier];
  if (!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationReusableIdentifier];
    pinView.canShowCallout = YES;
  }
  return pinView;
}

@end
