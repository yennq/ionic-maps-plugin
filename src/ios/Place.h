//
//  Place.h
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface Place : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strSubTitle;

- (id)initWithLong:(CGFloat)lon Lat:(CGFloat)lat title:(NSString *)title subtitle:(NSString *)subtitle avatarPath:(NSString *)avatarPath;

@end
