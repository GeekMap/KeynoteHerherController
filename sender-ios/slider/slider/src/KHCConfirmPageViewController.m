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
#import "CKTableAlertView.h"

#define PlayBtnHeight 40
#define PlayBtnPaddingY 10
#define PlayBtnPaddingX 30

@interface KHCConfirmPageViewController ()
{
    KHCSlideManager *slideManager;
    Boolean handling_connection;
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

    UIButton *btnChooseChromecast = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnChooseChromecast.frame = CGRectMake(PlayBtnPaddingX,
                               screenHeight - PlayBtnHeight - PlayBtnPaddingY - 50,
                               screenWidth - PlayBtnPaddingX*2,
                               PlayBtnHeight);
    [btnChooseChromecast.layer setCornerRadius:5.0f];
    
    [btnChooseChromecast setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0]];
    [btnChooseChromecast setTitle:@"..." forState:UIControlStateNormal];
    [btnChooseChromecast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChooseChromecast addTarget:self action:@selector(chooseChromecast:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChooseChromecast];
    
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPlay.frame = CGRectMake(PlayBtnPaddingX,
                                screenHeight - PlayBtnHeight - PlayBtnPaddingY,
                                screenWidth - PlayBtnPaddingX*2,
                                PlayBtnHeight);
    [btnPlay.layer setCornerRadius:5.0f];
    [btnPlay setBackgroundColor:[UIColor redColor]];
    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    [btnPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btnPlay];
    
    slideManager = [[KHCSlideManager alloc] init];
    
    handling_connection = false;
}

- (void)chooseChromecast: (id)sender
{
    CKTableAlertView *alert;

    alert = [[CKTableAlertView alloc] initWithArray: [slideManager getChromeCastList] title:@"Select your Chromecast" hasCancelButton:YES];
    
	[alert setDelegate:self];

	[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSlide: (id<KHCSlideItem>)slide
{

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
        
        NSLog(@"Row #%@ selected", [NSNumber numberWithInteger:indexPath.row]);
    } else {
        NSLog(@"Currently handling another cell");
        [[tableAlert table] deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void) clickedCancelButtonInTableAlert:(CKTableAlertView *)tableAlert
{
    handling_connection = false;
}

@end
