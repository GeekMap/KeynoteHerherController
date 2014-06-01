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
- (id<KHCSlideItem>) getUserSlideList: (NSString *)user;
@end

