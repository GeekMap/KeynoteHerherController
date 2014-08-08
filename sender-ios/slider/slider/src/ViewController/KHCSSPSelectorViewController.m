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
    NSArray *sspList;

    UIAlertView *alertUserName;
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
    
    sspList = [[NSArray alloc] initWithObjects:@"SlideShare", @"SpeakerDeck", nil];

    // set a default SSP
    selectedSSP = [sspList objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sspSelected:(NSString *)sspName{
    alertUserName = [[UIAlertView alloc] initWithTitle:@"Input username" message:[NSString stringWithFormat:@"Please input the username of %@.", sspName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alertUserName.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *txtInput = [alertUserName textFieldAtIndex:0];
    txtInput.placeholder = @"Username";
    txtInput.autocorrectionType = UITextAutocorrectionTypeNo;
    txtInput.enablesReturnKeyAutomatically= YES;
    txtInput.keyboardType = UIKeyboardTypeWebSearch;
    txtInput.delegate = self;
    [alertUserName show];

    selectedSSP = sspName;
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

#pragma TextField Delegate method
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [alertUserName dismissWithClickedButtonIndex:1 animated:YES];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sspList count];
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

    NSString *imageName = [NSString stringWithFormat:@"%@.png", [[sspList objectAtIndex:indexPath.row] lowercaseString]];

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
    [self sspSelected:[sspList objectAtIndex:indexPath.row]];
}

@end
