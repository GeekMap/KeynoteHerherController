//
//  KHCSISpeakerDeck.m
//  slider
//
//  Created by jarronshih on 2014/6/13.
//
//

#import "KHCSISpeakerDeck.h"

@implementation KHCSISpeakerDeck
{
    NSString* base_url;
}

- (id) initWithURL: (NSString*) url
{
    //https://speakerdeck.com/player/03ad1120aa2501313da22a463594f846
    
    self = [super init];
    if (self) {
        base_url = url;
    }
    return self;
}

- (NSDictionary*) getSIData
{
    // https://speakerd.s3.amazonaws.com/presentations/03ad1120aa2501313da22a463594f846/slide_0.jpg
    // NSLog(@"URL: ", base_url);
    NSURL* url = [NSURL URLWithString: base_url];
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

    NSRegularExpression *reg;
    NSRange matchRange;
    // get title
    reg =[NSRegularExpression regularExpressionWithPattern:@"<title>(.+) // Speaker Deck</title>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* title = [html substringWithRange:matchRange];

    // get hash
    reg =[NSRegularExpression regularExpressionWithPattern:@"https://speakerdeck.com/player/([a-zA-Z0-9]+)$" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:base_url options:0 range:NSMakeRange(0, [base_url length])] rangeAtIndex:1];
    NSString* hash = [base_url substringWithRange:matchRange];
    
    // get max_page
    reg =[NSRegularExpression regularExpressionWithPattern:@" of ([0-9]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* max = [NSString stringWithFormat:@"%d" ,[[html substringWithRange:matchRange] intValue]-1];

//    NSLog(@"Hash: %@", hash);
//    NSLog(@"Max: %@", max);
//    NSLog(@"Title: %@", title);
    
    // return
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] initWithCapacity:5];
    [ret setValue:title forKey:@"title"];
    [ret setValue:[NSString stringWithFormat:@"https://speakerd.s3.amazonaws.com/presentations/%@/slide_", hash] forKey:@"url_prefix"];
    [ret setValue:@".jpg" forKey:@"url_postfix"];
    [ret setValue:@"0" forKey:@"min_page"];
    [ret setValue:max forKey:@"max_page"];
    
    return ret;
}

@end
