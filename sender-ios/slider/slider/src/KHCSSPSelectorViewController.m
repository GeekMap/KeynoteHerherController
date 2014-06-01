//
//  KHCSSPSelectorViewController.m
//  slider
//
//  Created by Chuck Lin on 6/1/14.
//
//

#import "KHCSSPSelectorViewController.h"

@interface KHCSSPSelectorViewController ()

@end

@implementation KHCSSPSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Add Slide"];
    btnSlideShare.layer.cornerRadius = 10;
    btnSlideShare.layer.borderWidth = 1;
    btnSlideShare.layer.borderColor = [UIColor colorWithRed:0.23 green:0.72 blue:0.83 alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
