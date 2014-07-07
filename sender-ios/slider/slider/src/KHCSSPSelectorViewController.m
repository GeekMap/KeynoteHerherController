//
//  KHCSSPSelectorViewController.m
//  slider
//
//  Created by Chuck Lin on 6/1/14.
//
//

#import "KHCSSPSelectorViewController.h"
#import "KHCSlideSelectorViewController.h"
#import "KHCSlideServiceProvider.h"

@interface KHCSSPSelectorViewController ()
{
    NSString *selectedSSP;
}

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
    
    UIButton *btnSlideShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSlideShare setImage:[UIImage imageNamed:@"slideshare.png"] forState:UIControlStateNormal];
    btnSlideShare.frame = CGRectMake(50, 100, 165, 45);
    btnSlideShare.layer.cornerRadius = 10;
    btnSlideShare.layer.borderWidth = 1;
    btnSlideShare.layer.borderColor = [UIColor colorWithRed:0.23 green:0.72 blue:0.83 alpha:1].CGColor;
    
    [btnSlideShare addTarget:self action:@selector(slideShareSelected:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btnSpeakerdeck = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSpeakerdeck setImage:[UIImage imageNamed:@"speakerdeck.png"] forState:UIControlStateNormal];
    btnSpeakerdeck.frame = CGRectMake(50, 150, 165, 45);
    btnSpeakerdeck.layer.cornerRadius = 10;
    btnSpeakerdeck.layer.borderWidth = 1;
    btnSpeakerdeck.layer.borderColor = [UIColor colorWithRed:0.23 green:0.72 blue:0.83 alpha:1].CGColor;
    
    [btnSpeakerdeck addTarget:self action:@selector(speakerDeckSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSlideShare];
    [self.view addSubview:btnSpeakerdeck];
    // set a default SSP
    selectedSSP = @"SlideShare";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)slideShareSelected:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input username" message:@"Please input the username of slideshare." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    selectedSSP = @"SlideShare";
}

- (void)speakerDeckSelected:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input username" message:@"Please input the username of speakerdeck." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    selectedSSP = @"SpeakerDeck";
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {

        NSLog(@"Create SlideSelectorView");
        KHCSlideSelectorViewController *slideSelectorView = [[KHCSlideSelectorViewController alloc] init];
        NSString *userName = [alertView textFieldAtIndex:0].text;

        [slideSelectorView view];
        [slideSelectorView setTitle:userName];
        [slideSelectorView setSspName: selectedSSP];
        [slideSelectorView setUserName:userName];
        [self.navigationController pushViewController:slideSelectorView animated:YES];
    }
}

@end
