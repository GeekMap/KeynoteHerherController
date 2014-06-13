//
//  SSPTests.m
//  slider
//
//  Created by jarronshih on 2014/6/2.
//
//

#import <XCTest/XCTest.h>
#import "KHCSISlideshare.h"
#import "KHCSSPSlideshare.h"
#import "KHCSISpeakerDeck.h"

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
    NSDictionary *metadata = [slide_item getSIData];
    
    for (id key in metadata) {
        NSLog(@"key: %@, value: %@ \n", key, [metadata objectForKey:key]);
    }
}


- (void) testSSPSlideshare
{
    NSArray* list = [KHCSSPSlideshare getUserSlideList: @"rashmi"];
    for (KHCSISlideshare* slide_item in list) {
        NSDictionary *metadata = [slide_item getSIData];
        NSLog(@"Slide %@\n", [metadata objectForKey:@"title"]);
    }
}

-(void) testSISpeakerDeck
{
    KHCSISpeakerDeck* slide_item = [[KHCSISpeakerDeck alloc] initWithURL:@"https://speakerdeck.com/player/03ad1120aa2501313da22a463594f846"];
    NSDictionary *metadata = [slide_item getSIData];
    
    for (id key in metadata) {
        NSLog(@"key: %@, value: %@ \n", key, [metadata objectForKey:key]);
    }
}

@end
