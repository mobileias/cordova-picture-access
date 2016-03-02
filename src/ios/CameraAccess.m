//
//  CameraAccess.m
//

#import "CameraAccess.h"

@implementation CameraAccess

@synthesize callbackId;

- (void) checkAccess:(CDVInvokedUrlCommand *)command {

    // Check for permission
    ALAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    CDVPluginResult* result = nil;

    if (authStatus == AVAuthorizationStatusAuthorized) {
        NSLog(@"Access to camera granted");
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Access granted"];
        [self invokeCallback:command withResult:result];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        NSLog(@"Access to camera not yet determined. Will ask user.");
        __block CDVPluginResult* result = nil;

        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
            } else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }
    else {
        NSLog(@"Access to camera denied");
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Access denied"];
        [self invokeCallback:command withResult:result];
    }
}

- (void) invokeCallback:(CDVInvokedUrlCommand *)command withResult:(CDVPluginResult *)result {
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
