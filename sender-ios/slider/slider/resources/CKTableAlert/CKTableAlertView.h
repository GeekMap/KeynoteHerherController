//
//  CKTableAlertView.h
//  CKAlertView
//
//  Created by Chuck Lin on 6/22/14.
//  Copyright (c) 2014 Chuck. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKTableAlertView;

@protocol CKTableAlertViewDelegate
- (void)tableAlert:(CKTableAlertView *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)clickedCancelButtonInTableAlert:(CKTableAlertView *)tableAlert;

@end

@interface CKAlertView : UIView
- (void) show;
- (void) hide;
@end

@interface CKTableAlertView : CKAlertView <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *table;
@property (nonatomic, retain) NSObject<CKTableAlertViewDelegate> *delegate;
- (id) initWithArray: (NSArray*) data title:(NSString*) title hasCancelButton:(Boolean) hasCancelButton;
@end