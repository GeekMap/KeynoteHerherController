//
//  KHCConfirmPageViewController.h
//  slider
//
//  Created by Chuck Lin on 6/20/14.
//
//

#import <UIKit/UIKit.h>
#import "CKTableAlertView.h"
#import "KHCSlideItem.h"

@interface KHCConfirmPageViewController : UIViewController <CKTableAlertViewDelegate, UIScrollViewDelegate>
- (void)setSlide: (id<KHCSlideItem>)slide;
@end
