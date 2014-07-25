//
//  KHCConfirmPageViewController.m
//  slider
//
//  Created by Chuck Lin on 6/20/14.
//
//

#import "KHCConfirmPageViewController.h"
#import "KHCSlideItem.h"
#import "KHCSlideManager.h"
#import "KHCSlideControllerViewController.h"
#import "CKTableAlertView.h"

#define PlayBtnHeight 40
#define PlayBtnPaddingY 10
#define PlayBtnPaddingX 30

@interface KHCConfirmPageViewController ()
{
    KHCSlideManager *slideManager;
    NSObject<KHCSlideItem> *_slide;
    Boolean handling_connection;
    CKTableAlertView *alert;
    UIButton *btnChooseChromecast;
    
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    NSMutableArray *previewImageViews;
}
@end

@implementation KHCConfirmPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the Screen Size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [mainView setBounces:YES];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [mainView setContentSize:CGSizeMake(screenWidth, screenHeight-64)];
    self.view = mainView;

    //Disable naviagtion slide gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //Set cast icon
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cast_icon"] landscapeImagePhone:[UIImage imageNamed:@"cast_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(chooseChromecast:)];
    
    [self addPreviewPageViewWithWidth:screenWidth];
    [self addSlideInfomationViews];
    
    slideManager = [[KHCSlideManager alloc] init];
    
    handling_connection = false;
}

- (void) addPreviewPageViewWithWidth: (CGFloat) screenWidth {
    pageControl = [[UIPageControl alloc] init];
    //UIPageControl
    [pageControl setNumberOfPages:[_slide.preview_pages count]];
    [pageControl setCurrentPage:0];
    [pageControl setFrame:CGRectMake(0, 0, 90, 10)];
    [pageControl setCenter:CGPointMake(screenWidth/2, 230)];
    [pageControl setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.2]];
    [pageControl setUserInteractionEnabled:NO];
    pageControl.layer.cornerRadius = 5;
    pageControl.layer.masksToBounds = YES;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 240)];
    //UIScrollView
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setScrollsToTop:NO];
    [scrollView setDelegate:self];
    
    // Add shadow on the scrollview
    scrollView.layer.masksToBounds = NO; // this default
    scrollView.layer.shadowColor = [[UIColor blackColor] CGColor];
    scrollView.layer.shadowOpacity = 0.4;
    scrollView.layer.shadowRadius = 5;
    scrollView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    CGFloat width, height;
    width = scrollView.frame.size.width;
    height = scrollView.frame.size.height;
    [scrollView setContentSize:CGSizeMake(width * [_slide.preview_pages count], height)];
    
    //Setup the content of ScrollView
    for (int i=0; i < [_slide.preview_pages count]; i++) {
        CGRect frame = CGRectMake(width*i, 0, width, height);
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = frame;
        [activityIndicator startAnimating];
        
        [previewImageViews addObject:activityIndicator];
        [scrollView addSubview:activityIndicator];
        
        NSNumber *index = [[NSNumber alloc] initWithInt:i];
        [NSThread detachNewThreadSelector:@selector(loadPreviewImages:) toTarget:self withObject:index];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
}

- (void) addSlideInfomationViews
{
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:_slide.author_avatar_url]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageView];
    
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];

    CGFloat width, height;
    width = scrollView.frame.size.width;
    height = scrollView.frame.size.height;
    CGRect frame = CGRectMake(0, 0, width, height);
    
    [scrollView scrollRectToVisible:frame animated:NO];
}

- (void) loadPreviewImages: (NSNumber*) index
{
    CGFloat width, height;
    width = scrollView.frame.size.width;
    height = scrollView.frame.size.height;

    int i = [index intValue];
    
    CGRect frame = CGRectMake(width*i + 1, 0, width - 2, height);

    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[_slide.preview_pages objectAtIndex:i]]];
    NSLog(@"%d page url: %@", i, [[_slide.preview_pages objectAtIndex:i] absoluteString]);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = frame;

    [scrollView addSubview:imageView];
    
    UIActivityIndicatorView *activityIndicator = [previewImageViews objectAtIndex:i];
    [previewImageViews removeObject:activityIndicator];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [previewImageViews insertObject:imageView atIndex:i];
}

- (void)chooseChromecast: (id)sender
{
    alert = [[CKTableAlertView alloc] initWithArray: [slideManager getChromeCastList] title:@"Select your Chromecast" hasCancelButton:YES];
    
	[alert setDelegate:self];

	[alert show];
}

- (void)setSlide: (id<KHCSlideItem>)slide
{
    _slide = slide;
}

- (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width {
    float ratio = image.size.width / width;
    float height = image.size.height / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

#pragma mark - ScrollPageViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    [pageControl setCurrentPage:currentPage];
}

#pragma mark - CKTableAlertDelegate

- (void)tableAlert:(CKTableAlertView *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (handling_connection == false) {
        handling_connection = true;
        UITableViewCell *cell = (UITableViewCell*)[[tableAlert table] cellForRowAtIndexPath:indexPath];
        
        // add activity indicator on the UI
        UIActivityIndicatorView *activityView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
        
        [[tableAlert table] deselectRowAtIndexPath:indexPath animated:NO];
        
        // connect to chromecast
        [slideManager connectChromeCastWithName:cell.textLabel.text withID:self withCallback:@selector(callbackForConnection:)];
        
        NSLog(@"Row #%@ selected", [NSNumber numberWithInteger:indexPath.row]);
    } else {
        NSLog(@"Currently handling another cell");
        [[tableAlert table] deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void) callbackForConnection: (NSNumber*) connected
{
    if ([connected intValue] == YES) {
        NSLog(@"Callback Connected");
        
        [alert hide];
        
        handling_connection = false;
        
        KHCSlideControllerViewController *slideController = [[KHCSlideControllerViewController alloc] initWithSlideManager:slideManager];
        
        [slideController view];
        [slideController setSlide: _slide];
        
        [self.navigationController pushViewController:slideController animated:YES];
    }
}

- (void) clickedCancelButtonInTableAlert:(CKTableAlertView *)tableAlert
{
    handling_connection = false;
}

@end
