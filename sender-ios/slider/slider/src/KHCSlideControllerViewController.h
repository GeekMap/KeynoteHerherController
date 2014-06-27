//
//  KHCSlideControllerViewController.h
//  slider
//
//  Created by Chuck Lin on 6/27/14.
//
//

#import <UIKit/UIKit.h>
#import "KHCSlideManager.h"

@interface KHCSlideControllerViewController : UIViewController

- (id) initWithSlideManager: (KHCSlideManager*) slideMgr;
- (void)setSlide: (id<KHCSlideItem>)slide;

@end