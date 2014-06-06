//
//  KHCSlideManager.m
//  slider
//
//  Created by jarronshih on 2014/5/31.
//
//

#import "KHCSlideManager.h"
#import "KHCCommandChannel.h"

static NSString *const APP_ID = @"43049BBC";
static NSString *const APP_NAMESPACE = @"urn:x-cast:com.cve-2014-0160.keynote-herher-controller";

@interface KHCSlideManager (){}

@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property KHCCommandChannel *cmdChannel;

@end



@implementation KHCSlideManager

- (id)init
{
    self = [super init];
    if (self) {
        _selectedDevice = nil;
        self.deviceScanner = nil;
        self.deviceManager = nil;
        
        self.deviceScanner = [[GCKDeviceScanner alloc] init];
        [self.deviceScanner addListener:self];
        [self.deviceScanner startScan];
        NSLog(@"init");
    }
    return self;
}

- (NSArray*) getChromeCastList
{
    NSMutableArray* list = [[NSMutableArray alloc] init ];
    for( GCKDevice* device in self.deviceScanner.devices ){
        [list addObject: device.friendlyName];
    }
    return list;
}

- (void)connectChromeCastWithName: (NSString*) chromecast_name
{
    for (GCKDevice* device in self.deviceScanner.devices) {
        if ([chromecast_name isEqualToString:device.friendlyName]) {
            _selectedDevice = device;
        }
    }
    
    if (_selectedDevice == nil)
        return;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager = [[GCKDeviceManager alloc] initWithDevice: _selectedDevice clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];

    self.deviceManager.delegate = self;
    [self.deviceManager connect];
    
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"device found!!!");
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    NSLog(@"device disappeared!!!");
}


#pragma mark - GCKDeviceManagerDelegate
- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    NSLog(@"connected!!");
    
    [self.deviceManager launchApplication: APP_ID];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApp {
    
    _cmdChannel = [[KHCCommandChannel alloc] initWithNamespace:APP_NAMESPACE];
    [self.deviceManager addChannel:_cmdChannel];
}


- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    self.applicationMetadata = applicationMetadata;
    
    NSLog(@"Received device status: %@", applicationMetadata);
}


@end
