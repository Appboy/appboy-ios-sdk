#import "GeofencesViewController.h"

@implementation GeofencesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.mapView.delegate = self;
  CLLocation *initialLocation;
  CLLocationManager *geofenceLocationManager = [[CLLocationManager alloc] init];
  for (CLCircularRegion *region in geofenceLocationManager.monitoredRegions) {
    if ([region.identifier hasPrefix:@"ab_"]) {\
      if (initialLocation == nil) {
        initialLocation = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
      }
      [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:region.center radius:region.radius]];
    }
  }
  
  if (initialLocation != nil) {
   [self centerMapOnLocation:initialLocation];
  }
}

- (void)centerMapOnLocation:(CLLocation *)location {
  MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(.1, .1);
  MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(location.coordinate, coordinateSpan);
  [self.mapView setRegion:coordinateRegion animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  if ([overlay isKindOfClass:MKCircle.class]) {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleRenderer.lineWidth = 1.0;
    circleRenderer.strokeColor = [UIColor purpleColor];
    circleRenderer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:(0.4)];
    return circleRenderer;
  }
  
  return nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
