//
//  KHCSlideSelectorViewController.m
//  slider
//
//  Created by Chuck Lin on 6/6/14.
//
//

#import "KHCSlideSelectorViewController.h"
#import "KHCSSPSlideshare.h"
#import "KHCSlideItem.h"

@interface KHCSlideSelectorViewController ()

@end

@implementation KHCSlideSelectorViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [view setBackgroundColor:[UIColor whiteColor]];
        self.view = view;
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

    //size helper
    CGSize size = self.view.frame.size;
    
    UIActivityIndicatorView *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSLog(@"SSP name: %@", _sspName);
    NSLog(@"User name: %@", _userName);
    
    if ([_sspName isEqualToString: @"SlideShare"]) {
        NSLog(@"Hi");
        NSArray *slides = [KHCSSPSlideshare getUserSlideList:self.userName];
        NSLog(@"Hi again");
        for (NSObject<KHCSlideItem> *slide in slides) {
            NSLog(@"Slide title: %@", slide.title);
        }
        NSLog(@"End printing");
    }
}

@end
