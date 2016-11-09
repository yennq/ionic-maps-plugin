#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IonicMaps: NSObject {
	CLLocation* locationInfo;
}

@property (nonatomic, strong) CLLocation* locationInfo;

- (NSString *)getLocation;

@end