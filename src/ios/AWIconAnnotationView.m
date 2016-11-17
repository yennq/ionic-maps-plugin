//
//  AWIconAnnotationView.m
//  Easy Custom Map Icons
//
//  Created by Alek Åström on 2011-08-12.
//  Copyright 2011 Apps & Wonders. No rights reserved.
//

#import "AWIconAnnotationView.h"

@implementation AWIconAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Compensate frame a bit so everything's aligned
        [self setCenterOffset:CGPointMake(-9, -3)];
        [self setCalloutOffset:CGPointMake(-2, 3)];
        
        // Add the pin icon
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 3, 32, 32)];
        [self addSubview:iconView];
    }
    
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    Place *place = (Place *)annotation;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", place.avatarPath]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    icon = [[UIImage alloc] initWithData:data];
    
    iconView.layer.cornerRadius = iconView.frame.size.width / 2;
    iconView.layer.borderWidth = 3.0f;
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconView.clipsToBounds = YES;
    iconView.backgroundColor = [UIColor whiteColor];
    
    [iconView setImage:icon];
}

/** Override to make sure shadow image is always set
 */
- (void)setImage:(UIImage *)image {
    [super setImage:[UIImage imageNamed:@"pin_shadow.png"]];
}

- (void)dealloc {
}

@end
