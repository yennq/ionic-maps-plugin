#import "IonicMaps.h"

@implementation IonicMaps
@synthesize locationInfo;

- (NSString *)getLocation:(CDVInvokedUrlCommand* )command {
    NSString *responseString = [NSString stringWithFormat:@"Hello %@", [command.arguments objectAtIndex:0]];
    return responseString;
}

@end