#import "IonicMaps.h"
#import <Cordova/CDVViewController.h>

@implementation IonicMaps {
    CLLocationManager *locationManager;
    CGFloat longitudeLabel;
    CGFloat latitudeLabel;
    MKMapView *mapView;
    NSArray *marker;
    UIWebView *webView;
}

@synthesize locationManager, geocoder, placemark, searchInput;

- (void)pluginInitialize {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        
        //iOS8+
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager requestWhenInUseAuthorization];
        }
        else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
            [locationManager requestAlwaysAuthorization];
        }
        else {
            NSLog(@"[Warning] No NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription key is defined in the Info.plist file.");
        }
    }
    
    for (UIView *subview in self.viewController.view.subviews) {
        if ([subview isKindOfClass:[UIWebView class]]) {
            webView = (UIWebView *)subview;
//            webView.delegate = self;
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
    // Do whatever you want here
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
    
    for (NSDictionary *dict in marker) {
        //the center of the region we'll move the map to
        [mapView addAnnotation:[[Place alloc]
                                initWithLong:[[dict objectForKey:@"longitude"] floatValue]
                                Lat:[[dict objectForKey:@"latitude"] floatValue]
                                title:[dict objectForKey:@"title"]
                                subtitle:[dict objectForKey:@"address"]
                                avatarPath:[dict objectForKey:@"avatar"]]];
    }
    
    [locationManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        NSLog(@"Clicked Pizza Shop");
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == theMapView.userLocation) {
        return nil; // Let map view handle user location annotation
    }
    
    // Identifyer for reusing annotationviews
    static NSString *annotationIdentifier = @"icon_annotation";
    
    // Check in queue if there is an annotation view we already can use, else create a new one
    AWIconAnnotationView *annotationView = (AWIconAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[AWIconAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

- (void)getLocation:(CDVInvokedUrlCommand *)command {
    marker = command.arguments;
    // Do any additional setup after loading the view, typically from a nib.
    [self.commandDelegate runInBackground:^{
        
    }];
    
    // Set the frame & image later.
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewController.view.frame.size.width - 100, self.viewController.view.frame.size.height - 100, 100, 100)];
    NSURL *url = [NSURL URLWithString:@"https://d30y9cdsu7xlg0.cloudfront.net/png/16812-200.png"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data scale:0.3];
    imgView.image = img;
    
    // create button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(addMarker:) forControlEvents:UIControlEventTouchUpInside];
    [button setExclusiveTouch:YES];
    button.frame = CGRectMake(0, 0, 40, 40.0);
    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    UIImage *btnImage = [UIImage imageNamed:@"menu"];
    [button setImage:btnImage forState:UIControlStateNormal];

    // create search input
    searchInput = [[MPGTextField alloc] initWithFrame:CGRectMake(10, 30, self.viewController.view.frame.size.width - 20, 40)];
    searchInput.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    searchInput.font = [UIFont fontWithName:@"Helvetica" size:14];
    searchInput.backgroundColor = [UIColor whiteColor];
    [searchInput setBorderStyle:UITextBorderStyleRoundedRect];
    searchInput.layer.cornerRadius = 5.0;
    searchInput.layer.borderWidth = 0.0;
    searchInput.layer.borderColor = [UIColor whiteColor].CGColor;
    searchInput.layer.masksToBounds = YES;
    searchInput.delegate = self;
    searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchInput setReturnKeyType:UIReturnKeyDone];
    [searchInput setPlaceholder:@"search"];
    [searchInput addTarget:self
                    action:@selector(textFieldFinished:command:)
          forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    searchInput.leftView = paddingView;
    searchInput.leftViewMode = UITextFieldViewModeAlways;
    
    // create mapview
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
    
    // add
    [paddingView addSubview:button];
    [self.viewController.view addSubview:mapView];
    [self.viewController.view addSubview:searchInput];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.location.coordinate, 1000, 1000);
    [mapView setRegion:region animated:YES];
    
    // auto update location
    [locationManager startUpdatingLocation];

    NSString *responseString = [NSString stringWithFormat:@"Hello %@", [command.arguments objectAtIndex:0]];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (IBAction)textFieldFinished:(UITextField *)textField command:(CDVInvokedUrlCommand *)command {
    // [sender resignFirstResponder];
}

- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField {
    if ([textField isEqual:searchInput]) {
        return marker;
    }
    else {
        return nil;
    }
}

- (BOOL)textFieldShouldSelect:(MPGTextField *)textField {
    return YES;
}

- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result {
    //A selection was made - either by the user or by the textfield. Check if its a selection from the data provided or a NEW entry.
    //the center of the region we'll move the map to
    CLLocationCoordinate2D center;
    center.latitude = [[result objectForKey:@"latitude"] floatValue];
    center.longitude = [[result objectForKey:@"longitude"] floatValue];
    
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
    
    id pin = [[Place alloc]
              initWithLong:[[result objectForKey:@"longitude"] floatValue]
              Lat:[[result objectForKey:@"latitude"] floatValue]
              title:[result objectForKey:@"title"]
              subtitle:[result objectForKey:@"address"]
              avatarPath:[result objectForKey:@"avatar"]];
    
    [mapView addAnnotation:pin];
    [mapView selectAnnotation:pin animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)addMarker:(UIButton *)button {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New marker" message:[NSString stringWithFormat:@"Click OK to add \"%@\" or CANCEL to go back", searchInput.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertView show];
    
    [self getLocationFromAddressString:[NSString stringWithFormat:@"%@", searchInput.text]];
}

- (void)getLocationFromAddressString:(NSString *)addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    NSString *jsCallback = [NSString stringWithFormat:@"cordova.plugins.GoogleMarker.addNewMarker(\"%@\", \"%@\", %f, %f)", esc_addr, @"", latitude, longitude];
    [webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

- (void)dealloc {
    locationManager.delegate = nil;
}

- (void)onReset {
    [locationManager stopUpdatingHeading];
}

@end
