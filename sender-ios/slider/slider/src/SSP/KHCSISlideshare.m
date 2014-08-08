//
//  KHCSISlideshare.m
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import "KHCSISlideshare.h"


@implementation KHCSISlideshare
{
    NSString* base_url;
    NSDictionary* meta_dict;
}

- (id) initWithURL:(NSString *)url
{
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
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta content=\"(.+?)\" class=\"fb_og_meta\" property=\"og:title\" name=\"og_title\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* title = [html substringWithRange:matchRange];
    
    // get author
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta content=\"http://www.slideshare.net/(.+?)\" class=\"fb_og_meta\" property=\"slideshare:author\" name=\"slideshow_author\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* author = [html substringWithRange:matchRange];
    
    // get description
    reg =[NSRegularExpression regularExpressionWithPattern:@"<p class=\"descriptionExpanded notranslate\"(.+?)itemprop=\"description\">(.+?)</p>" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:2];
    NSString* description = [html substringWithRange:matchRange];
    description = [description stringByReplacingOccurrencesOfString:@"<br />"
                                                         withString:@""];

    // get upload_time
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta content=\"(.+?)\" class=\"fb_og_meta\" property=\"slideshare:updated_at\" name=\"slideshow_updated_at\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* upload_time = [html substringWithRange:matchRange];
    
    // get viewers_count
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta content=\"(.+?)\" class=\"fb_og_meta\" property=\"slideshare:view_count\" name=\"slideshow_view_count\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* viewers_count = [html substringWithRange:matchRange];
    
    // get categories
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta content=\"(.+?)\" class=\"fb_og_meta\" property=\"slideshare:category\" name=\"slideshow_category\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* categories = [html substringWithRange:matchRange];
   
    // get cover_url
    reg =[NSRegularExpression regularExpressionWithPattern:@"<meta class=\"twitter_image\" value=\"(.+?)\" name=\"twitter:image\" />" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* cover_url = [html substringWithRange:matchRange];
    
    // get max
    reg =[NSRegularExpression regularExpressionWithPattern:@"\"totalSlides\":([0-9]+)," options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* max = [html substringWithRange:matchRange];
    
    // get author_avatar_url
    reg =[NSRegularExpression regularExpressionWithPattern:@"\"userimage_placeholder\":\"([^\"]+?)\"," options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* author_avatar_url = [html substringWithRange:matchRange];
    
    // get url_prefix
    reg =[NSRegularExpression regularExpressionWithPattern:@"data-full=\"(.+?)1-1024.jpg" options:NSRegularExpressionCaseInsensitive error:nil];
    matchRange = [[reg firstMatchInString:html options:0 range:NSMakeRange(0, [html length])] rangeAtIndex:1];
    NSString* url_prefix = [html substringWithRange:matchRange];
    
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] initWithCapacity:10];
    [ret setValue:title forKey:@"title"];
    [ret setValue:author forKey:@"author"];
    [ret setValue:cover_url forKey:@"cover_url"];
    [ret setValue:url_prefix forKey:@"url_prefix"];
    [ret setValue:@"-1024.jpg" forKey:@"url_postfix"];
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
    return 1;
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
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
