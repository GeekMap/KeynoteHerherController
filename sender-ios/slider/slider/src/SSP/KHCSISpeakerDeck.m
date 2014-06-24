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
    NSDictionary* meta_dict;
}

- (id) initWithURL: (NSString*) url
{
    //https://speakerdeck.com/player/03ad1120aa2501313da22a463594f846
    
    self = [super init];
    if (self) {
        base_url = url;
        meta_dict = nil;
    }
    return self;
}

- (NSDictionary*) getMetadata
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
    NSLog(@"HTML: %@",html);

    NSRegularExpression *reg;
    NSRange matchRange;
    // get title
    reg =[NSRegularExpression regularExpressionWithPattern:@"<title>(.+?) // Speaker Deck</title>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* title = [html substringWithRange:matchRange];

    // get author
    reg =[NSRegularExpression regularExpressionWithPattern:@"Talk by <a href=\"https://speakerdeck.com/(.+?)\"" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* author = [html substringWithRange:matchRange];
    
    // get author
    reg =[NSRegularExpression regularExpressionWithPattern:@"\"thumb\":\"(.+?)\"" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* cover_url = [html substringWithRange:matchRange];

    
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
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] initWithCapacity:7];
    [ret setValue:title forKey:@"title"];
    [ret setValue:author forKey:@"author"];
    [ret setValue:cover_url forKey:@"cover_url"];
    [ret setValue:[NSString stringWithFormat:@"https://speakerd.s3.amazonaws.com/presentations/%@/slide_", hash] forKey:@"url_prefix"];
    [ret setValue:@".jpg" forKey:@"url_postfix"];
    [ret setValue:max forKey:@"max_page"];
    
    return ret;
}

- (void) refresh_cache
{
    meta_dict = [self getMetadata];
}

- (NSString*) title
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"title"];
}

- (NSString*) author
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"author"];
}

- (NSString*) cover_url
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"cover_url"];
}

- (NSString*) url_prefix
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"url_prefix"];
}

- (NSString*) url_postfix
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"url_postfix"];
}

- (int) min_page
{
    return 0;
}

- (int) max_page
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [[meta_dict objectForKey:@"max_page"] intValue];
}

@end
