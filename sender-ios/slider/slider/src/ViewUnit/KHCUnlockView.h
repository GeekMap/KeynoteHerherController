//
//  KHCUnlockView.h
//  slider
//
//  Created by jarron on 2014/8/1.
//
//
#import "CKTableAlertView.h"
#import <UIKit/UIKit.h>

@interface KHCUnlockView : UIView
- (void) showWithComplition: (void (^)(void)) complition;
- (void) hide;

@end
