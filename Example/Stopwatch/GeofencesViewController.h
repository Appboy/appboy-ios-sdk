#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GeofencesViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
