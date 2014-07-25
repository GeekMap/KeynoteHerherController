//
//  KHCSSPSlideshare.m
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//
#import "KHCSSPSlideshare.h"
#import "KHCSISlideshare.h"
#import "SlideshareAPI.h"


 
@implementation KHCSSPSlideshare

+ (NSArray*) getUserSlideList: (NSString *)user
{
    // http://www.slideshare.net/developers/documentation
    NSString* xml = [SlideshareAPI get_slideshows_by_user:user];
    
    NSRegularExpression *url_reg = [NSRegularExpression regularExpressionWithPattern:@"<URL>(.+?)</URL>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* matches = [url_reg matchesInString:xml options:0 range:NSMakeRange(0, [xml length])];
    
    NSMutableArray* si_array = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult* match in matches) {
        NSRange url_range = [match rangeAtIndex:1];
        NSString* substring = [xml substringWithRange:url_range];
        // NSLog(@"Extracted URL: %@",substring);
        
        KHCSISlideshare* si_item = [[KHCSISlideshare alloc] initWithURL:substring];
        [si_array addObject:si_item];
    }
    return si_array;
}

@end
