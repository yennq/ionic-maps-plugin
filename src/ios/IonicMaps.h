#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>

@interface IonicMaps: CDVPlugin {
	CLLocation* locationInfo;
}

@property (nonatomic, strong) CLLocation* locationInfo;

- (NSString *)getLocation;

@end