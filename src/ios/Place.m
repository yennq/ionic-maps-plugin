//
//  Place.m
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import "Place.h"

@implementation Place
@synthesize coordinate;

- (id)initWithLong:(CGFloat)lon Lat:(CGFloat)lat title:(NSString *)title subtitle:(NSString *)subtitle avatarPath:(NSString *)avatarPath {
    self = [super init];
    if (self) {
        coordinate = CLLocationCoordinate2DMake(lat, lon);
        self.avatarPath = avatarPath;
        self.strTitle = title;
        self.strSubTitle = subtitle;
    }
    
    return self;
}

- (NSString *)title {
    return self.strTitle;
}

- (NSString *)subtitle {
    return self.strSubTitle;
}

- (void)dealloc {

}

@end
