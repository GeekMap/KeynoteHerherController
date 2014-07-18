//
//  KHCSISlideshare.m
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import "KHCSISlideshare.h"

static NSString *const  SLIDESHARE_OEMBED_TEMPLATE_URL = @"http://www.slideshare.net/api/oembed/2?url=%@&format=json";

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
    /*
     @Return
         slideshow_id       : Slideshow ID
         version            : The oEmbed version number.
         type               : Type of oEmbed response.
         title              : Title of the embed media.
         author_name        : Author of the embed content.
         author_url         : SlideShare profile page of the author of embed content.
         provider_name      : Provider of the embed content, SlideShare.
         provider_url       : URL of provider.
         html               : The real juice lies here. This is the html embed code, which contains links to embed media.
         width              : Width of the embed media, respects maxheight query parameter
         height             : Height of the embed media, respects maxheight query parameter
         thumbnail          : URL to the thumbnail of embed content.
         thumbnail_width    : Width of thumbnail
         thumbnail_height   : Height of thumbnail
         total_slides       : Number of slides in the slideshow
         version_no         : Version of the slideshow
         slide_image_baseurl : Base URL of the slideshow images
         slide_image_baseurl_suffix : Base URL suffix
     TODO:
         Error handle for,
         404 Not Found : If URL is missing or doesn't point to an embeddable resource.
         501 Not Implemented : If the format provided is not supported. Should be one of xml, json or jsonp
     ref:
     http://www.slideshare.net/developers/oembed
     */
    
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:SLIDESHARE_OEMBED_TEMPLATE_URL, base_url]];
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
    
    // Construct a NSDict around the Data from the response
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:url_data options:NSJSONReadingMutableLeaves error:&error];
    
    return res;
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
    return [meta_dict objectForKey:@"author_name"];
}

- (NSString*) cover_url
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [NSString stringWithFormat:@"http:%@",[meta_dict objectForKey:@"thumbnail"]];
}

- (NSString*) url_prefix
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [NSString stringWithFormat:@"http:%@",[meta_dict objectForKey:@"slide_image_baseurl"]];
}

- (NSString*) url_postfix
{
    if (meta_dict == nil) {
        [self refresh_cache];
    }
    return [meta_dict objectForKey:@"slide_image_baseurl_suffix"];
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
    return [[meta_dict objectForKey:@"total_slides"] intValue];
}

- (int) page_count
{
    return self.max_page - self.min_page + 1;
}




@end
