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
#import "KHCSSPSpeakerDeck.h"

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
    NSLog(@"Title: %@", [slide_item title]);
    NSLog(@"Author: %@", [slide_item author]);
    NSLog(@"Cover: %@", [slide_item cover_url]);
    NSLog(@"UrlPrefix: %@", [slide_item url_prefix]);
    NSLog(@"UrlPostfix: %@", [slide_item url_postfix]);
    NSLog(@"MinPage: %d", [slide_item min_page]);
    NSLog(@"MaxPage: %d", [slide_item max_page]);
}


- (void) testSSPSlideshare
{
    NSArray* list = [KHCSSPSlideshare getUserSlideList: @"rashmi"];
    for (KHCSISlideshare* slide_item in list) {
        NSLog(@"Title: %@", [slide_item title]);
    }
}

-(void) testSISpeakerDeck
{
    KHCSISpeakerDeck* slide_item = [[KHCSISpeakerDeck alloc] initWithURL:@"https://speakerdeck.com/player/03ad1120aa2501313da22a463594f846"];
    NSLog(@"Title: %@", [slide_item title]);
    NSLog(@"Author: %@", [slide_item author]);
    NSLog(@"Cover: %@", [slide_item cover_url]);
    NSLog(@"UrlPrefix: %@", [slide_item url_prefix]);
    NSLog(@"UrlPostfix: %@", [slide_item url_postfix]);
    NSLog(@"MinPage: %d", [slide_item min_page]);
    NSLog(@"MaxPage: %d", [slide_item max_page]);
}

- (void) testSSPSpeakerDeck
{
    NSArray* list = [KHCSSPSpeakerDeck getUserSlideList: @"shpigford"];
    for (KHCSISpeakerDeck* slide_item in list) {
        NSLog(@"Title: %@", [slide_item title]);
    }
}

@end
