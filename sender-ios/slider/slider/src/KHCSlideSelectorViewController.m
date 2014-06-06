//
//  KHCSlideSelectorViewController.m
//  slider
//
//  Created by Chuck Lin on 6/6/14.
//
//

#import "KHCSlideSelectorViewController.h"

@interface KHCSlideSelectorViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation KHCSlideSelectorViewController

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
    NSLog(@"TEST");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = CGRectMake (20.0, 10.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.view addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
