//
//  KHCSlideControllerViewController.m
//  slider
//
//  Created by Chuck Lin on 6/27/14.
//
//

#import "KHCSlideControllerViewController.h"
#import "KHCSlideManager.h"
#import "KHCSlideItem.h"
#import "RBVolumeButtons.h"
#import "KHCUnlockView.h"

#define statusbarHeight 20

@interface KHCSlideControllerViewController ()
{
    KHCSlideManager *_slideMgr;
    NSObject<KHCSlideItem> *_slide;
    UIButton *btnUp, *btnDown, *btnTooldom;
    RBVolumeButtons *buttonStealer;
}
@end

@implementation KHCSlideControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithSlideManager: (KHCSlideManager*) slideMgr
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [view setBackgroundColor:[UIColor whiteColor]];
        self.view = view;
        
        _slideMgr = slideMgr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    
    //Get the Screen Size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUp.frame = CGRectMake(100, statusbarHeight, screenWidth-100, 130);
    btnUp.layer.borderWidth = 0.5f;
    btnUp.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnUp setImage:[UIImage imageNamed:@"arrow-up.png"] forState:UIControlStateNormal];
    [btnUp addTarget:self action:@selector(didClickPageUp:) forControlEvents:UIControlEventTouchUpInside];
    [btnUp setEnabled:NO];
    
    btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDown.frame = CGRectMake(0, 130+statusbarHeight, screenWidth, screenHeight-130);
    btnDown.layer.borderWidth = 0.5f;
    btnDown.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnDown setImage:[UIImage imageNamed:@"arrow-down.png"] forState:UIControlStateNormal];
    [btnDown addTarget:self action:@selector(didClickPageDown:) forControlEvents:UIControlEventTouchUpInside];
    
    btnTooldom = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTooldom.frame = CGRectMake(0, statusbarHeight, 100, 130);
    btnTooldom.layer.borderWidth = 0.5f;
    btnTooldom.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnTooldom setImage:[UIImage imageNamed:@"settings-wrench.png"] forState:UIControlStateNormal];
    [btnTooldom addTarget:self action:@selector(didClickTooldom:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnUp addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnUp addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [btnUp addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpOutside];
    [btnDown addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnDown addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpOutside];
    [btnTooldom addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnTooldom addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [btnTooldom addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:btnUp];
    [self.view addSubview:btnDown];
    [self.view addSubview:btnTooldom];
    
    // Setup Volume Button steal
    buttonStealer = [[RBVolumeButtons alloc] init];
    id controller = self;
    buttonStealer.upBlock = ^{
        [controller didClickPageUp:nil];
    };
    buttonStealer.downBlock = ^{
        [controller didClickPageDown:nil];
    };

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisableIdle" object:nil];

    [self startPlay];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    buttonStealer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnableIdle" object:nil];
}

- (void)startPlay
{
    NSLog(@"start play slide with title: %@", _slide.title);
    [_slideMgr receiverInitWithSI: _slide];
}

- (void)toggleUpDownButton
{
    [btnUp setEnabled:YES];
    [btnDown setEnabled:YES];
    if ([_slideMgr isFirst] == YES) {
        [btnUp setEnabled:NO];
    } else if ([_slideMgr isLast] == YES) {
        [btnDown setEnabled:NO];
    }
}

- (void)didClickPageUp: (id)sender
{
    [_slideMgr receiverPrePage];
    [self toggleUpDownButton];
}

- (void)didClickPageDown: (id)sender
{
    [_slideMgr receiverNextPage];
    [self toggleUpDownButton];
}

- (void)didClickTooldom: (id)sender
{
    UIActionSheet *tooldoms = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"End slide" otherButtonTitles: @"Volume Button Mode", nil];
    
    tooldoms.actionSheetStyle = UIActionSheetStyleAutomatic;
    [tooldoms showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setSlide: (id<KHCSlideItem>)slide
{
    _slide = slide;
}

#pragma ButtonReaction
- (void)changeButtonBackGroundColor: (UIButton *) sender
{
    [sender setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.2]];
}

- (void)resetButtonBackGroundColor: (UIButton*)sender {
    [sender setBackgroundColor:[UIColor whiteColor]];
}

#pragma ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // End Slide
        [_slideMgr receiverUninit];
        [_slideMgr deviceDisconnect];
        
        [self.navigationController setNavigationBarHidden: NO animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        // Start Volume Button Mode

        // Start Steal
        [buttonStealer startStealingVolumeButtonEvents];
        KHCUnlockView *unlock_view = [[KHCUnlockView alloc] init];
        [unlock_view showWithComplition:^{
            // Stop steal
            [buttonStealer stopStealingVolumeButtonEvents];
        }];
    }
}

@end
