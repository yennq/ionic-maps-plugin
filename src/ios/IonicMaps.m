#import "IonicMaps.h"
#import <Cordova/CDVViewController.h>

@implementation IonicMaps {
	CLLocationManager *locationManager;
	CGFloat longitudeLabel;
	CGFloat latitudeLabel;
    MKMapView *mapView;
}

@synthesize locationManager, geocoder, placemark;

- (void)pluginInitialize {
	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    mapView.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
 
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        longitudeLabel = currentLocation.coordinate.longitude;
        latitudeLabel = currentLocation.coordinate.latitude;
    }

    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Get your Location"
                               message:[NSString stringWithFormat:@"Longitude: %f\nLatitude: %f", longitudeLabel, latitudeLabel]
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    //the center of the region we'll move the map to
    CLLocationCoordinate2D center;
    center.latitude = latitudeLabel;
    center.longitude = longitudeLabel;
    
    //set up zoom level
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .1f; //the zoom level in degrees
    zoom.longitudeDelta = .1f;//the zoom level in degrees
    
    //the region the map will be showing
    MKCoordinateRegion myRegion;
    myRegion.center = center;
    myRegion.span = zoom;
    
    //set the map location/region
    [mapView setRegion:myRegion animated:YES];
    
    mapView.mapType = MKMapTypeStandard;//standard map(not satellite)
    
    IonicMaps *pin = [[IonicMaps alloc] init];
    pin.title = @"Central Park";
    pin.subtitle = @"New York City";
    pin.coordinate = center;
    [mapView addAnnotation:pin];
}

- (void)getLocation:(CDVInvokedUrlCommand*)command {
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the frame & image later.
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewController.view.frame.size.width - 100, self.viewController.view.frame.size.height - 100, 100, 100)];
    NSURL *url = [NSURL URLWithString:@"https://d30y9cdsu7xlg0.cloudfront.net/png/16812-200.png"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:data];
    imgView.image = img;
    
    // create button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    [button setExclusiveTouch:YES];
    button.frame = CGRectMake(0, self.viewController.view.frame.size.height - 40, 160.0, 40.0);
    
    // create mapview
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 300, self.viewController.view.frame.size.width, 300)];
    [self.viewController.view addSubview:mapView];
    
    // add
    [self.viewController.view addSubview:button];
    [self.viewController.view addSubview:imgView];

    NSString *responseString = [NSString stringWithFormat:@"Hello %@", [command.arguments objectAtIndex:0]];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)aMethod:(UIButton *)button {
    [button setTitle:@"Clicked" forState:UIControlStateNormal];
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        //iOS8+
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
            [locationManager requestWhenInUseAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
            [locationManager requestAlwaysAuthorization];
        } else {
            NSLog(@"[Warning] No NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription key is defined in the Info.plist file.");
        }
    }
    
    [locationManager startUpdatingLocation];
}

- (void)dealloc {
    locationManager.delegate = nil;
}

- (void)onReset {
    [locationManager stopUpdatingHeading];
}

@end
