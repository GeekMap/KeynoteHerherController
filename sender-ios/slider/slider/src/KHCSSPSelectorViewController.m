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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SSPSelectorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imageName;
    if (indexPath.row == 0) {
        imageName = @"slideshare.png";
    }
    else if (indexPath.row == 1){
        imageName = @"speakerdeck.png";
    }
    else
    {
        imageName = @"";
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell setBackgroundView:  imageView];
    
    UIImageView *selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: imageName]];
    selectedView.contentMode = UIViewContentModeScaleAspectFit;
    selectedView.backgroundColor = [UIColor lightGrayColor];
    [cell setSelectedBackgroundView:selectedView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self slideShareSelected:nil];
    }
    else if (indexPath.row == 1){
        [self speakerDeckSelected:nil];
    }
    else
    {
        
    }
    
}

@end
