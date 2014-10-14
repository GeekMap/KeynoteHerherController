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

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:base_url forKey:@"base_url"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self initWithURL:[decoder decodeObjectForKey:@"base_url"]];
    return self;
}

- (NSDictionary*) getMetadata
{
    // https://speakerdeck.com/jlugia/build-your-cross-platform-service-in-a-week-with-app-engine
    NSURL* url = [NSURL URLWithString: base_url];
    NSURLRequest *url_request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
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
    //NSLog(@"HTML: %@",html);
    
    NSRegularExpression *reg;
    NSRange matchRange;
    // get title
    reg =[NSRegularExpression regularExpressionWithPattern:@"<title>(.+?) // Speaker Deck</title>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* title = [html substringWithRange:matchRange];

    // get author
    reg =[NSRegularExpression regularExpressionWithPattern:@"<h2><a href=\"/(.+?)\">.+?</a></h2>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* author = [html substringWithRange:matchRange];
    
    // get hash
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta property=\"og:image\" content=\"https://speakerd.s3.amazonaws.com/presentations/(.+?)/slide_0.jpg\"" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* hash = [html substringWithRange:matchRange];
    
    // https://speakerdeck.com/player/<HASH>
    NSURL* url2 = [NSURL URLWithString: [NSString stringWithFormat:@"https://speakerdeck.com/player/%@", hash]];
    NSURLRequest *url_request2 = [NSURLRequest requestWithURL:url2
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:30];
    // Fetch the JSON response
    NSData *url_data2;
    NSURLResponse *response2;
    NSError *error2;
    // TODO: error handle for
    
    
    // Make synchronous request
    url_data2 = [NSURLConnection sendSynchronousRequest:url_request2
                                      returningResponse:&response2
                                                  error:&error2];
    
    NSString* html2 = [[NSString alloc] initWithData:url_data2 encoding:NSUTF8StringEncoding];
    
    // get max_page
    reg =[NSRegularExpression regularExpressionWithPattern:@" of ([0-9]+)" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html2 options:0 range:NSMakeRange(0, [html2 length])] rangeAtIndex:1];
    NSString* max = [NSString stringWithFormat:@"%d" ,[[html2 substringWithRange:matchRange] intValue]-1];

    // get viewers_count
    reg =[NSRegularExpression regularExpressionWithPattern:@"<li class=\"views\">Stats <span>([0-9,]+) Views</span></li>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* viewers_count = [html substringWithRange:matchRange];
    viewers_count = [viewers_count stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    // get upload_time
    reg =[NSRegularExpression regularExpressionWithPattern:@"Published <mark>(.+?)</mark>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* upload_time = [html substringWithRange:matchRange];
    
    // get description
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta name=\"twitter:description\" content=\"([^>]+?)\">" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* description = [html substringWithRange:matchRange];
    
    // get category
    reg =[NSRegularExpression regularExpressionWithPattern:@"in <mark><a href=\".+?\">(.+?)</a></mark>" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* categories = [html substringWithRange:matchRange];
    
    // get author_avatar_url
    reg =[NSRegularExpression regularExpressionWithPattern:@"src=\"(//secure.gravatar.com/avatar[^\"]+?)\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* author_avatar_url = [html substringWithRange:matchRange];
    
    // return
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] initWithCapacity:10];
    [ret setValue:title forKey:@"title"];
    [ret setValue:author forKey:@"author"];
    [ret setValue:[NSString stringWithFormat:@"https://speakerd.s3.amazonaws.com/presentations/%@/slide_0.jpg", hash] forKey:@"cover_url"];
    [ret setValue:[NSString stringWithFormat:@"https://speakerd.s3.amazonaws.com/presentations/%@/slide_", hash] forKey:@"url_prefix"];
    [ret setValue:@".jpg" forKey:@"url_postfix"];
    [ret setValue:max forKey:@"max_page"];
    [ret setValue:viewers_count forKey:@"viewers_count"];
    [ret setValue:upload_time forKey:@"upload_time"];
    [ret setValue:description forKey:@"description"];
    [ret setValue:categories forKey:@"categories"];
    [ret setValue:author_avatar_url forKey:@"author_avatar_url"];
    
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

- (int) page_count
{
    return self.max_page - self.min_page + 1;
}

- (int) viewers_count
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [[meta_dict objectForKey:@"viewers_count"] intValue];
}

- (NSArray*) categories
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [[meta_dict objectForKey:@"categories"] componentsSeparatedByString:@","];
}

- (NSDate*) upload_time
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"LLLL dd, yyyy"];
    
    NSDate *date = [formatter dateFromString:[meta_dict objectForKey:@"upload_time"]];
    return date;
}

- (NSString*) description
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"description"];
}

- (NSArray*) preview_pages
{
    NSMutableArray* ary = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        if (self.min_page + i > self.max_page) {
            break;
        }
        int page = self.min_page + i;
        [ary addObject: [NSURL URLWithString:[NSString stringWithFormat: @"%@%d%@", self.url_prefix, page, self.url_postfix]]];
    }
    return ary;
}

- (NSURL*) author_avatar_url
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"http:%@",[meta_dict objectForKey:@"author_avatar_url"]]];
}

@end
