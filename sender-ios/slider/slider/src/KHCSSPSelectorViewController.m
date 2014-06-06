//
//  KHCSSPSelectorViewController.m
//  slider
//
//  Created by Chuck Lin on 6/1/14.
//
//

#import "KHCSSPSelectorViewController.h"
#import "KHCSlideSelectorViewController.h"

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
    [self setTitle:@"Select Slide Service"];
    btnSlideShare.layer.cornerRadius = 10;
    btnSlideShare.layer.borderWidth = 1;
    btnSlideShare.layer.borderColor = [UIColor colorWithRed:0.23 green:0.72 blue:0.83 alpha:1].CGColor;
    
    [btnSlideShare addTarget:self action:@selector(slideShareSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slideShareSelected:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input username" message:@"Please input the username of slideshare." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //search with SSP plugin
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        KHCSlideSelectorViewController *slideSelectorView = (KHCSlideSelectorViewController*) [storyBoard instantiateViewControllerWithIdentifier: @"slideSelectorView"];

        NSString *title = [alertView textFieldAtIndex:0].text;

        [slideSelectorView view];
        [slideSelectorView setTitle:title];
        NSLog(@"TEST1");
        [self.navigationController pushViewController:slideSelectorView animated:YES];
    }
}

@end
