//
//  KHCSlideManager.m
//  slider
//
//  Created by jarronshih on 2014/5/31.
//
//

#import "KHCSlideManager.h"
#import "KHCCommandChannel.h"

static NSString *const APP_ID = @"6EC34210";
static NSString *const APP_NAMESPACE = @"urn:x-cast:com.cve-2014-0160.keynote-herher-controller";

@interface KHCSlideManager (){
    int slide_current_page;
    int slide_min_page;
    int slide_max_page;
    id callback_obj;
    SEL callback;
}

@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property KHCCommandChannel *cmdChannel;

@end



@implementation KHCSlideManager

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedDevice = nil;
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

- (void)connectChromeCastWithName: (NSString*) chromecast_name withID:(id)cb_obj withCallback:(SEL)cb
{
    for (GCKDevice* device in self.deviceScanner.devices) {
        if ([chromecast_name isEqualToString:device.friendlyName]) {
            self.selectedDevice = device;
        }
    }
    
    if (self.selectedDevice == nil)
        return;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager = [[GCKDeviceManager alloc] initWithDevice: self.selectedDevice clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];

    self.deviceManager.delegate = self;
    [self.deviceManager connect];
    callback_obj = cb_obj;
    callback = cb;
    
    
}

- (void) receiverInitWithSI: (id<KHCSlideItem>)slide_item
{
    [self receiverInitWithTitle:[slide_item title]
                      urlPrefix:[slide_item url_prefix]
                     urlPostfix:[slide_item url_postfix]
                        minPage:[NSString stringWithFormat:@"%d", [slide_item min_page]]
                        maxPage:[NSString stringWithFormat:@"%d", [slide_item max_page]]];
    
}

- (void) receiverInitWithTitle:(NSString*) title urlPrefix:(NSString*) url_prefix urlPostfix:(NSString*) url_postfix minPage:(NSString*) min_page maxPage:(NSString*)max_page
{
    NSString* cmd = [NSString stringWithFormat:@"{\"cmd\":\"init\", \"meta\":{\"title\":\"%@\", \"url_prefix\":\"%@\", \"url_postfix\":\"%@\", \"max_page\":\"%@\", \"min_page\":\"%@\"}}",
                     title,
                     url_prefix,
                     url_postfix,
                     max_page,
                     min_page
                     ];
    slide_current_page = [min_page intValue];
    slide_min_page = [min_page intValue];
    slide_max_page = [max_page intValue];
    [self.cmdChannel sendTextMessage:cmd];
}

- (void) receiverUninit
{
    NSString* cmd =@"{\"cmd\":\"uninit\", \"meta\":{}}";
    slide_current_page = 0;
    slide_max_page = 0;
    slide_min_page = 0;
    [self.cmdChannel sendTextMessage:cmd];
}

- (void) receiverNextPage
{
    slide_current_page = slide_current_page + 1;
    if (slide_current_page > slide_max_page) {
        slide_current_page = slide_max_page;
    }
    NSString* cmd = [NSString stringWithFormat:@"{\"cmd\":\"go\", \"meta\":{ \"page\":\"%d\"}}", slide_current_page];
    [self.cmdChannel sendTextMessage:cmd];
    
}

- (void) receiverPrePage
{
    slide_current_page = slide_current_page - 1;
    if (slide_current_page < slide_min_page) {
        slide_current_page = slide_min_page;
    }
    NSString* cmd = [NSString stringWithFormat:@"{\"cmd\":\"go\", \"meta\":{ \"page\":\"%d\"}}", slide_current_page];
    [self.cmdChannel sendTextMessage:cmd];
    
}

- (void) sendJsonToChromeCast: (NSString*) json
{
    
    if (self.selectedDevice == nil)
        return;
    NSLog(@"Send cmd: %@", json);
    [self.cmdChannel sendTextMessage:json];
    
    
}

- (void) deviceDisconnected {
    self.cmdChannel = nil;
    self.deviceManager = nil;
    self.selectedDevice = nil;
    NSLog(@"Device disconnected");
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"device found!!! %@", device.friendlyName);
    
    //[self connectChromeCastWithName:device.friendlyName];
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
    NSLog(@"application has launched %d", launchedApp);
    
    self.cmdChannel = [[KHCCommandChannel alloc] initWithNamespace:APP_NAMESPACE];
    [self.deviceManager addChannel: self.cmdChannel];

    if (callback_obj) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [callback_obj performSelector: callback withObject:[NSNumber numberWithBool:YES]];
    #pragma clang diagnostic pop
    }
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    [self showError:error];
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    [self showError:error];
    if (callback_obj) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [callback_obj performSelector: callback withObject:[NSNumber numberWithBool:NO]];
        #pragma clang diagnostic pop
    }
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didDisconnectWithError:(GCKError *)error {
    NSLog(@"Received notification that device disconnected");
    
    if (error != nil) {
        [self showError:error];
    }
    [self deviceDisconnected];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    self.applicationMetadata = applicationMetadata;
    
    NSLog(@"Received device status: %@", applicationMetadata);
}

#pragma mark - misc
- (void)showError:(NSError *)error {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
//                                                    message:NSLocalizedString(error.description, nil)
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                                          otherButtonTitles:nil];
//    [alert show];
}

@end
