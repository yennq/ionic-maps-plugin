#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IonicMaps: NSObject

@property (nonatomic, strong) CLLocationManager* locationManager;

- (NSString *)getLocation;

@end