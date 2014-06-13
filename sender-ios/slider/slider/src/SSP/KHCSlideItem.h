//
//  KHCSlideItem.h
//  slider
//
//  Created by jarronshih on 2014/5/30.
//
//

#import <Foundation/Foundation.h>

@protocol KHCSlideItem <NSObject>
- (id) initWithURL: (NSString*) url;
- (NSDictionary*) getSIData;
@end
