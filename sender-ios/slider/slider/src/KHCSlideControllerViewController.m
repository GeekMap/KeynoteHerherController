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
    
    NSLog(@"Test");
    
    UIButton *btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUp.frame = CGRectMake(30, 70, 200, 40);
    [btnUp.layer setCornerRadius:5.0f];
    [btnUp setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0]];
    [btnUp setTitle:@"page up" forState:UIControlStateNormal];
    [btnUp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnUp addTarget:self action:@selector(didClickPageUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDown.frame = CGRectMake(30, 120, 200, 40);
    [btnDown setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0]];
    [btnDown setTitle:@"page up" forState:UIControlStateNormal];
    [btnDown setTitle:@"page down" forState:UIControlStateNormal];
    [btnDown setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDown addTarget:self action:@selector(didClickPageDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnd.frame = CGRectMake(30, 170, 200, 40);
    [btnEnd.layer setCornerRadius:5.0f];
    [btnEnd setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:1.0]];
    [btnEnd setTitle:@"End slide" forState:UIControlStateNormal];
    [btnEnd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEnd addTarget:self action:@selector(didClickEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnUp];
    [self.view addSubview:btnDown];
    [self.view addSubview:btnEnd];
    
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

- (void)didClickEnd: (id)sender
{
    [_slideMgr receiverUninit];
    [_slideMgr deviceDisconnect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setSlide: (id<KHCSlideItem>)slide
{
    _slide = slide;
}

@end
