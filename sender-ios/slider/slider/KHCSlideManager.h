//
//  KHCSlideManager.h
//  slider
//
//  Created by jarronshih on 2014/5/31.
//
//

#import <Foundation/Foundation.h>
#import <GoogleCast/GoogleCast.h>
#import "KHCSlideItem.h"

@interface KHCSlideManager : NSObject <GCKDeviceScannerListener, GCKDeviceManagerDelegate>

@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;
@property(nonatomic, strong) GCKDeviceManager* deviceManager;

- (NSArray*) getChromeCastList;
- (void)connectChromeCastWithName: (NSString*) chromecast_name;
- (void)deviceDisconnected;

- (void) receiverInitWithTitle:(NSString*) title urlPrefix:(NSString*) url_prefix urlPostfix:(NSString*) url_postfix minPage:(NSString*) min_page maxPage:(NSString*)max_page;
- (void) receiverUninit;
- (void) receiverNextPage;
- (void) receiverPrePage;

@end
