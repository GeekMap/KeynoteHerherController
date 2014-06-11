//
//  SlideManagerTests.m
//  slider
//
//  Created by jarronshih on 2014/6/6.
//
//

#import <XCTest/XCTest.h>
#import "KHCSlideManager.h"

@interface SlideManagerTests : XCTestCase

@end

@implementation SlideManagerTests
{
    KHCSlideManager* manager;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    manager = [[KHCSlideManager alloc] init];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testSelectChromeCast
{
    NSArray* list = [manager getChromeCastList];
    for (NSString* chromecast in list) {
        NSLog(chromecast);
    }
}

- (void) testInitReceiver
{
    
}

@end
