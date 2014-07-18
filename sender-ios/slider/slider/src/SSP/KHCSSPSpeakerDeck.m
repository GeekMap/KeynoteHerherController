//
//  KHCSSPSpeakerDeck.m
//  slider
//
//  Created by jarronshih on 2014/6/13.
//
//

#import "KHCSSPSpeakerDeck.h"
#import "KHCSISpeakerDeck.h"

@implementation KHCSSPSpeakerDeck

+ (NSArray*) getUserSlideList: (NSString *)user
{
    // https://speakerdeck.com/shpigford
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"https://speakerdeck.com/%@", user]];
    NSURLRequest *url_request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval:30];
    // Fetch the JSON response
    NSData *url_data;
    NSURLResponse *response;
    NSError *error;
    // TODO: error handle for
    
    
    // Make synchronous request
    url_data = [NSURLConnection sendSynchronousRequest:url_request
                                     returningResponse:&response
                                                 error:&error];
    
    NSString* html = [[NSString alloc] initWithData:url_data encoding:NSUTF8StringEncoding];
    // NSLog(@"HTML: %@",html);
    
    //<a class="slide_preview scrub" href="/shpigford/from-idea-to-5000-dollars-a-month-in-5-months">
    NSRegularExpression *url_reg = [NSRegularExpression regularExpressionWithPattern:@"class=\"slide_preview scrub\" href=\"([a-zA-Z0-9-/]+)\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* matches = [url_reg matchesInString:html options:0 range:NSMakeRange(0, [html length])];
    
    NSMutableArray* si_array = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult* match in matches) {
        NSRange url_range = [match rangeAtIndex:1];
        NSString* substring = [html substringWithRange:url_range];
        NSLog(@"Extracted suburl: %@",substring);
        
        KHCSISpeakerDeck* si_item = [[KHCSISpeakerDeck alloc] initWithURL:[NSString stringWithFormat:@"https://speakerdeck.com%@" ,substring]];
        [si_array addObject:si_item];
    }
    return si_array;
}
@end
