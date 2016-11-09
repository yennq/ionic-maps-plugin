#import "IonicMaps.h"

@implementation IonicMaps
@synthesize locationInfo;

- (NSString *)getLocation:(CDVInvokedUrlCommand* )command {
    NSString *responseString = [NSString stringWithFormat:@"Hello %@", [command.arguments objectAtIndex:0]];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end