//
//  CKTableAlertView.m
//  CKAlertView
//
//  Created by Chuck Lin on 6/22/14.
//  Copyright (c) 2014 Chuck. All rights reserved.
//

#import "CKTableAlertView.h"

#define AlertPosX 50
#define AlertPosY 108
#define AlertWidth 260
#define AlertHeight 232
#define AlertTitleHeight 50
#define AlertLinePosY 200
#define AlertButtonPosY 200.3
#define AlertButtonWidth 260
#define AlertButtonHeight 32
#define AlertTablePaddingX 10
#define AlertTableWidth 240
#define AlertTableHeight 132

@interface CKAlertView()
@property(nonatomic, strong) UIWindow *window;
@end

@implementation CKAlertView

@synthesize window=_window;

- (void) show
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    
    self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    
    [_window addSubview:self];
    [_window makeKeyAndVisible];
}

- (void) hide
{
    _window.hidden = YES;
    _window = nil;
}

@end

@interface CKTableAlertView()
@property (nonatomic, strong) NSArray* data;
@end

@implementation CKTableAlertView
@synthesize data=_data;

- (id) initWithArray:(NSArray *)data title:(NSString *)title hasCancelButton:(Boolean)hasCancelButton
{
    self = [super initWithFrame:CGRectMake(AlertPosX, AlertPosY, AlertWidth, AlertHeight)];

    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95f];
        self.layer.cornerRadius = 5.0f;
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AlertWidth, AlertTitleHeight)];
        [labTitle setText:title];
        [labTitle setTextAlignment:NSTextAlignmentCenter];
        [labTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self addSubview:labTitle];
        
        _data = [[NSArray alloc] initWithArray:data];
        _table = [[UITableView alloc] initWithFrame:CGRectMake(AlertTablePaddingX, 50, AlertTableWidth, AlertTableHeight)];
        _table.layer.borderWidth = 0.3f;
        _table.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_table setSeparatorInset:UIEdgeInsetsZero];
        [_table setDataSource:self];
        [_table setDelegate:self];
        [self addSubview:_table];
        
        if (hasCancelButton == YES) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, AlertLinePosY, AlertWidth, 0.3f)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            [self addSubview:lineView];

            UIButton *cancelBtn = [self createCancelButton];
            [self addSubview:cancelBtn];
        }
    }
    return self;
}

- (UIButton *) createCancelButton
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];

    //set the button size to fill in the alertview
    cancelBtn.frame = CGRectMake(0, AlertButtonPosY, AlertButtonWidth, AlertButtonHeight);

    //add touch event to hide the alertview
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //use touch event to change the background color
    [cancelBtn addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [cancelBtn addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpOutside];
    
    //mask the bottom corner of this button for 5.0f radius
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:cancelBtn.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    cancelBtn.layer.mask = maskLayer;
    
    return cancelBtn;
}

- (void)changeButtonBackGroundColor: (UIButton *) sender
{
    [sender setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.2]];
}

- (void)resetButtonBackGroundColor: (UIButton*)sender {
    [sender setBackgroundColor:[UIColor whiteColor]];
}

- (void)cancelButtonClicked: (id) sender
{
    if ([self.delegate respondsToSelector:@selector(clickedCancelButtonInTableAlert:)]) {
        [self.delegate clickedCancelButtonInTableAlert:self];
    }
    [self hide];
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableAlert:didSelectRowAtIndexPath:)]) {
        [self.delegate tableAlert:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString *cellText = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = cellText;
    
    return cell;
}
@end
