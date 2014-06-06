//
//  SSPTests.m
//  slider
//
//  Created by jarronshih on 2014/6/2.
//
//

#import <XCTest/XCTest.h>
#import "KHCSISlideshare.h"

@interface SSPTests : XCTestCase

@end

@implementation SSPTests

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

- (void) testSISlideshare
{
    KHCSISlideshare* slide_item = [[KHCSISlideshare alloc] initWithURL:@"http://www.slideshare.net/haraldf/business-quotes-for-2011"];
    NSDictionary *metadata = [slide_item getMetadata];
    
    for (id key in metadata) {
        NSLog(@"key: %@, value: %@ \n", key, [metadata objectForKey:key]);
    }
}

@end
