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

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSlideManager
{
    KHCSlideManager* slide_manager = [[KHCSlideManager alloc] init];
    while (true) {
        NSArray* list = [slide_manager getChromeCastList];
        
        if ([list count] > 0) {
            NSLog(@"Get !!");
            for (NSString* name in list) {
                NSLog(@"get %@", name);
            }
            break;
        }
    }
}

@end
