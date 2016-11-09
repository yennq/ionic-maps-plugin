#import "IonicMaps.h"

@implementation IonicMaps
@synthesize locationInfo;

- (NSString *)getLocation:(CDVInvokedUrlCommand* )command {
    return [NSString stringWithFormat:@"Nguyen Quang Yen %@", [command.arguments objectAtIndex:0]];
}

@end