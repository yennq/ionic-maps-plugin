#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import "MPGTextField.h"
#import "Place.h"
#import "AWIconAnnotationView.h"

@interface IonicMaps: CDVPlugin <CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation, UITextFieldDelegate, MPGTextFieldDelegate, UIWebViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property (strong, nonatomic) MPGTextField *searchInput;

- (void)getLocation:(CDVInvokedUrlCommand *)command;
- (IBAction)textFieldFinished:(UITextField *)textField command:(CDVInvokedUrlCommand *)command;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError*)error;

@end
