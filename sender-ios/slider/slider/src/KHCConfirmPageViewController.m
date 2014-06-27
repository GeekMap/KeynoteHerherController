//
//  KHCConfirmPageViewController.m
//  slider
//
//  Created by Chuck Lin on 6/20/14.
//
//

#import "KHCConfirmPageViewController.h"
#import "KHCSlideItem.h"
#import "KHCSlideManager.h"
#import "KHCSlideControllerViewController.h"
#import "CKTableAlertView.h"

#define PlayBtnHeight 40
#define PlayBtnPaddingY 10
#define PlayBtnPaddingX 30

@interface KHCConfirmPageViewController ()
{
    KHCSlideManager *slideManager;
    NSObject<KHCSlideItem> *_slide;
    Boolean handling_connection;
    CKTableAlertView *alert;
    UIButton *btnChooseChromecast;
}
@end

@implementation KHCConfirmPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the Screen Size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    btnChooseChromecast = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChooseChromecast.frame = CGRectMake(PlayBtnPaddingX,
                               screenHeight - PlayBtnHeight - PlayBtnPaddingY,
                               screenWidth - PlayBtnPaddingX*2,
                               PlayBtnHeight);
    [btnChooseChromecast.layer setCornerRadius:5.0f];
    
    [btnChooseChromecast setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0]];
    [btnChooseChromecast setTitle:@"Select ChromeCast & Play" forState:UIControlStateNormal];
    [btnChooseChromecast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChooseChromecast addTarget:self action:@selector(chooseChromecast:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChooseChromecast];
    
    slideManager = [[KHCSlideManager alloc] init];
    
    handling_connection = false;
}

- (void)chooseChromecast: (id)sender
{
    alert = [[CKTableAlertView alloc] initWithArray: [slideManager getChromeCastList] title:@"Select your Chromecast" hasCancelButton:YES];
    
	[alert setDelegate:self];

	[alert show];
}

- (void)setSlide: (id<KHCSlideItem>)slide
{
    _slide = slide;
}

#pragma mark - CKTableAlertDelegate

- (void)tableAlert:(CKTableAlertView *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (handling_connection == false) {
        handling_connection = true;
        UITableViewCell *cell = (UITableViewCell*)[[tableAlert table] cellForRowAtIndexPath:indexPath];
        
        // add activity indicator on the UI
        UIActivityIndicatorView *activityView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
        
        [[tableAlert table] deselectRowAtIndexPath:indexPath animated:NO];
        
        // connect to chromecast
        [slideManager connectChromeCastWithName:cell.textLabel.text withID:self withCallback:@selector(callbackForConnection:)];
        
        NSLog(@"Row #%@ selected", [NSNumber numberWithInteger:indexPath.row]);
    } else {
        NSLog(@"Currently handling another cell");
        [[tableAlert table] deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void) callbackForConnection: (NSNumber*) connected
{
    if ([connected intValue] == YES) {
        NSLog(@"Callback Connected");
        
        [alert hide];
        
        handling_connection = false;
        
        KHCSlideControllerViewController *slideController = [[KHCSlideControllerViewController alloc] initWithSlideManager:slideManager];
        
        [slideController view];
        [slideController setSlide: _slide];
        
        [self.navigationController pushViewController:slideController animated:YES];
    }
}

- (void) clickedCancelButtonInTableAlert:(CKTableAlertView *)tableAlert
{
    handling_connection = false;
}

@end
