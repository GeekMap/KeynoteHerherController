//
//  SlideshareAPI.h
//  slider
//
//  Created by jarron on 2014/7/25.
//
//

#import <Foundation/Foundation.h>

@interface SlideshareAPI : NSObject
+ (NSString*) get_slideshow: (NSString *)slide_url;
+ (NSString*) get_slideshows_by_user: (NSString *)user;
@end
