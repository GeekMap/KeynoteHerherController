//
//  KHCSlideSelectorViewController.h
//  slider
//
//  Created by Chuck Lin on 6/6/14.
//
//

#import <UIKit/UIKit.h>

@interface KHCSlideSelectorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *sspName;
@property (nonatomic, retain) NSString *userName;

@end
