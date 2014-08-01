//
//  KHCSlideItem.h
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import <Foundation/Foundation.h>

@protocol KHCSlideItem <NSObject>
@property(readonly) NSString* title;
@property(readonly) NSString* author;
@property(readonly) NSString* cover_url;
@property(readonly) NSString* url_prefix;
@property(readonly) NSString* url_postfix;
@property(readonly) int min_page;
@property(readonly) int max_page;

@property(readonly) int page_count;
@property(readonly) int viewers_count;
@property(readonly) NSArray* categories;
@property(readonly) NSDate* upload_time;
@property(readonly) NSString* description;
@property(readonly) NSArray* preview_pages;
@property(readonly) NSURL* author_avatar_url;


- (id) initWithURL: (NSString*) url;
- (void) refresh_cache;
@end

@interface NSString(HTML)
- (NSString *) stringByHTMLDecoded;
@end

@implementation NSString(HTML)
- (NSString *) stringByHTMLDecoded {
    // Use for decode htmlentities
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *decoded_str = [[[NSAttributedString alloc] initWithData:stringData options:options documentAttributes:NULL error:NULL] string];
    return decoded_str;
}

@end