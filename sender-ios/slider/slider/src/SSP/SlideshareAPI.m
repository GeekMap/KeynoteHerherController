//
//  SlideshareAPI.m
//  slider
//
//  Created by jarron on 2014/7/25.
//
//

#import "SlideshareAPI.h"
#import <CommonCrypto/CommonDigest.h>

#define TIMESTAMP [NSString stringWithFormat:@"%ld",(time_t)[[NSDate date] timeIntervalSince1970]]
static NSString *const SLIDESHARE_API_KEY = @"6Vusl7yf";
static NSString *const SLIDESHARE_API_SHAREDSECRET = @"mcpB0XTV";


/*
 api_key:   Set this to the API Key that SlideShare has provided for you.
 ts:        Set this to the current time in Unix TimeStamp format, to the nearest second(?).
 hash:      Set this to the SHA1 hash of the concatenation of the shared secret and the timestamp (ts). i.e. SHA1 (sharedsecret + timestamp). The order of the terms in the concatenation is important.
 */
static NSString* SLIDESHARE_GET_SLIDESSHOW_BY_USER_TEMPLATE_URL = @"https://www.slideshare.net/api/2/get_slideshows_by_user?username_for=%@&api_key=%@&ts=%@&hash=%@";
static NSString* SLIDESHARE_GET_SLIDESSHOW_TEMPLATE_URL = @"https://www.slideshare.net/api/2/get_slideshows?slideshow_url=%@&api_key=%@&ts=%@&hash=%@";


@implementation SlideshareAPI
+ (NSString*) get_slideshow: (NSString *) slide_url
{
    NSString* ts = TIMESTAMP;
    NSString* hash = [SlideshareAPI sha1:[NSString stringWithFormat:@"%@%@", SLIDESHARE_API_SHAREDSECRET, ts]];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:SLIDESHARE_GET_SLIDESSHOW_TEMPLATE_URL , slide_url, SLIDESHARE_API_KEY,ts, hash]];
    
    NSURLRequest *url_request = [NSURLRequest requestWithURL: url
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
    
    NSString* xml = [[NSString alloc] initWithData:url_data encoding:NSUTF8StringEncoding];
    return xml;
}

+ (NSString*) get_slideshows_by_user: (NSString *)user
{
    NSString* ts = TIMESTAMP;
    NSString* hash = [SlideshareAPI sha1:[NSString stringWithFormat:@"%@%@", SLIDESHARE_API_SHAREDSECRET, ts]];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:SLIDESHARE_GET_SLIDESSHOW_BY_USER_TEMPLATE_URL, user, SLIDESHARE_API_KEY,ts, hash]];
    
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
    
    NSString* xml = [[NSString alloc] initWithData:url_data encoding:NSUTF8StringEncoding];
    return xml;
}


+ (NSString *)sha1: (NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end


