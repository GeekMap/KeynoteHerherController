//
//  KHCSSPSlideshare.m
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import "KHCSSPSlideshare.h"
#import <CommonCrypto/CommonDigest.h>

#define TIMESTAMP [NSString stringWithFormat:@"%d",(time_t)[[NSDate date] timeIntervalSince1970]]
static NSString *const SLIDESHARE_API_KEY = @"Nr6UMFRO";
static NSString *const SLIDESHARE_API_SHAREDSECRET = @"YDkAB20Z";


/*
 api_key:   Set this to the API Key that SlideShare has provided for you.
 ts:        Set this to the current time in Unix TimeStamp format, to the nearest second(?).
 hash:      Set this to the SHA1 hash of the concatenation of the shared secret and the timestamp (ts). i.e. SHA1 (sharedsecret + timestamp). The order of the terms in the concatenation is important.
 */
static NSString* SLIDESHARE_GET_SLIDESSHOW_BY_USER_TEMPLATE_URL = @"https://www.slideshare.net/api/2/get_slideshows_by_user?username_for=%@&api_key=%@&ts=%@&hash=%@";


/*
// XML parser
@interface Slideshow : NSObject {
    NSString *userName;
    NSString *firstName;
    NSString *lastName;
}
@property (nonatomic, retain) NSString *Title;
@end

@interface XMLParser : NSObject {
    NSMutableString *currentElementValue;
    Slideshow *slidesshow;
    NSMutableArray *slidesshows;
}

@property (nonatomic, retain) Slideshow *slidesshow;
@property (nonatomic, retain) NSMutableArray *slidesshows;

- (XMLParser *) initXMLParser;

@end

@implementation XMLParser
@synthesize slidesshow, slidesshows;

- (XMLParser *) initXMLParser {
    self = [super init];
    // init array of user objects
    slidesshows = [[NSMutableArray alloc] init];
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"Slideshow"]) {
        slidesshow = [[Slideshow alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}

@end
*/
 
@implementation KHCSSPSlideshare

+ (NSArray*) getUserSlideList: (NSString *)user
{
    // http://www.slideshare.net/developers/documentation
    NSString* ts = TIMESTAMP;
    NSString* hash = [KHCSSPSlideshare sha1:[NSString stringWithFormat:@"%@%@", SLIDESHARE_API_SHAREDSECRET, ts]];
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
    
    NSLog(@"%@",[[NSString alloc] initWithData:url_data encoding:NSUTF8StringEncoding]);
    
    return nil;

}



+ (NSString *)sha1: (NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
@end
