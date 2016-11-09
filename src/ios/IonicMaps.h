#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

@interface IonicMaps: CDVPlugin

@property (nonatomic, strong) CLLocation* locationInfo;

- (NSString *)getLocation: (CDVInvokedUrlCommand*)command;

@end