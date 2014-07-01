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

#define statusbarHeight 20

@interface KHCSlideControllerViewController ()
{
    KHCSlideManager *_slideMgr;
    NSObject<KHCSlideItem> *_slide;
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
    
    UIButton *btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUp.frame = CGRectMake(100, statusbarHeight, screenWidth-100, 130);
    btnUp.layer.borderWidth = 0.5f;
    btnUp.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnUp setImage:[UIImage imageNamed:@"arrow-up.png"] forState:UIControlStateNormal];
    [btnUp addTarget:self action:@selector(didClickPageUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDown.frame = CGRectMake(0, 130+statusbarHeight, screenWidth, screenHeight-130);
    btnDown.layer.borderWidth = 0.5f;
    btnDown.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnDown setImage:[UIImage imageNamed:@"arrow-down.png"] forState:UIControlStateNormal];
    [btnDown addTarget:self action:@selector(didClickPageDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnTooldom = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTooldom.frame = CGRectMake(0, statusbarHeight, 100, 130);
    btnTooldom.layer.borderWidth = 0.5f;
    btnTooldom.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0] CGColor];
    [btnTooldom setImage:[UIImage imageNamed:@"settings-wrench.png"] forState:UIControlStateNormal];
    [btnTooldom addTarget:self action:@selector(didClickTooldom:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnUp];
    [self.view addSubview:btnDown];
    [self.view addSubview:btnTooldom];
    
    [self startPlay];
}

- (void)startPlay
{
    NSLog(@"start play slide with title: %@", _slide.title);
    [_slideMgr receiverInitWithSI: _slide];
}

- (void)didClickPageUp: (id)sender
{
    [_slideMgr receiverPrePage];
}

- (void)didClickPageDown: (id)sender
{
    [_slideMgr receiverNextPage];
}

- (void)didClickTooldom: (id)sender
{
    UIActionSheet *tooldoms = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"End slide" otherButtonTitles: nil];
    
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

#pragma ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_slideMgr receiverUninit];
        [_slideMgr deviceDisconnect];
        
        [self.navigationController setNavigationBarHidden: NO animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
