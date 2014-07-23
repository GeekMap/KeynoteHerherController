//
//  KHCSlideListViewController.m
//  slider
//
//  Created by Chuck Lin on 6/1/14.
//
//

#import "KHCSlideListViewController.h"
#import "KHCAddSlideNavController.h"
#import "KHCConfirmPageViewController.h"
#import "KHCSlideItem.h"
#import "KHCSISlideshare.h"
#import "KHCSlideTableViewCell.h"
#import "KHCSISpeakerDeck.h"

@interface KHCSlideListViewController ()
{
    NSMutableArray *slides;
    NSArray *searchResults;
    NSString *cellIdentifier;
}

@end

@implementation KHCSlideListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSlideClicked:)];
    
    cellIdentifier = @"slideCell";
    [self.tableView registerClass:[KHCSlideTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSlide:) name:@"addSlide" object:nil];

    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSlideClicked:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KHCAddSlideNavController *addSlideViewController = (KHCAddSlideNavController*) [storyBoard instantiateViewControllerWithIdentifier: @"KHCAddSlideNavController"];

    [self presentViewController:addSlideViewController animated:YES completion:NULL];
}

- (void) loadData
{
    NSLog(@"Load user stored data.");
    NSData *savedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"slideArray"];
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            slides = [[NSMutableArray alloc] initWithArray:oldArray];
        } else {
            slides = [[NSMutableArray alloc] init];
        }
        NSLog(@"Loaded successfully.");
    }
    else
    {
        NSLog(@"No saved data.");
        slides = [NSMutableArray arrayWithObjects: nil];
    }
}

- (void) saveData
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:slides] forKey:@"slideArray"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [slides count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KHCSlideTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[KHCSlideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Display slide info in the tablecell
    NSObject<KHCSlideItem> *slide = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        slide = [searchResults objectAtIndex:indexPath.row];
    } else {
        slide = [slides objectAtIndex:indexPath.row];
    }

    [cell.titleLabel setText:slide.title];
//    [cell.imageView setImage:[UIImage imageWitzzhData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[slide cover_url]]]]];
    [cell.pageNumLabel setText:[NSString stringWithFormat:@"Pages: %d", slide.page_count]];
    return cell;
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [slides removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [slides exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self saveData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedValue = [slides objectAtIndex:indexPath.row];
    NSLog(@"%@", selectedValue);
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KHCConfirmPageViewController *confirmPage = (KHCConfirmPageViewController*) [storyBoard instantiateViewControllerWithIdentifier: @"KHCConfirmPage"];
    
    [confirmPage setSlide:[slides objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:confirmPage animated:YES];
}

#pragma SearchBar Delegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithBlock:^BOOL(id<KHCSlideItem> evaluatedObject, NSDictionary *bindings) {
        NSString *title = [evaluatedObject.title lowercaseString];
        NSString *searchString = [searchText lowercaseString];
        return [title rangeOfString:searchString].location != NSNotFound;
    }];

    searchResults = [slides filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma NoficationCenter Events
- (void) addSlide:(NSNotification*) notification
{
    NSObject<KHCSlideItem> *slide = [notification object];
    [slides addObject:slide];
    [self saveData];
    [self.tableView reloadData];
}
@end
