//
//  KHCSlideServiceProvider.h
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import <Foundation/Foundation.h>
#import "KHCSlideItem.h"

@protocol KHCSlideServiceProvider <NSObject>
+ (NSArray*) getUserSlideList: (NSString *)user;
@end

