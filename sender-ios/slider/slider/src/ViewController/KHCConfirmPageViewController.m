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

#define TitleX 85
#define TitleY 250
#define TitleWidth 230
#define TitleHeight 55

@interface KHCConfirmPageViewController ()
{
    KHCSlideManager *slideManager;
    NSObject<KHCSlideItem> *_slide;
    Boolean handling_connection;
    CKTableAlertView *alert;
    UIButton *btnChooseChromecast;

    NSTimer *timerDismissPagecontrol, *timerShowSlideNotification;
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    NSMutableArray *previewImageViews;
    UIView *notifyArrow;
    UILabel *labSlide;
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
    [pageControl setFrame:CGRectMake(0, 0, 90, 15)];
    [pageControl setCenter:CGPointMake(screenWidth/2, 225)];
    [pageControl setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.4]];
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

    [self.view addSubview:scrollView];
    [pageControl setAlpha:0.f];
    [self.view addSubview:pageControl];

    timerDismissPagecontrol = [NSTimer scheduledTimerWithTimeInterval: 2.3f
                                                               target: self
                                                             selector: @selector(createNotifyArrow)
                                                             userInfo: nil
                                                              repeats: NO];
}

- (void) addSlideInfomationViews
{
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:_slide.author_avatar_url]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(1, TitleY, 78, 78);
    // Add shadow on the Author Avatar
    imageView.layer.masksToBounds = NO; // this default
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    imageView.layer.shadowOpacity = 0.4;
    imageView.layer.shadowRadius = 3;
    imageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    [self.view addSubview:imageView];

    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(88, TitleY, TitleWidth, TitleHeight)];
    labTitle.numberOfLines = 2;
    [labTitle setFont:[UIFont systemFontOfSize:18]];
    [labTitle setText:[_slide.title stringByHTMLDecoded]];
    [self.view addSubview:labTitle];

    UILabel *labAuthor = [[UILabel alloc] initWithFrame:CGRectMake(88, TitleY + 52, 150, 20)];
    labAuthor.numberOfLines = 1;
    [labAuthor setFont:[UIFont systemFontOfSize:14]];
    [labAuthor setText:[NSString stringWithFormat:@"By %@", _slide.author]];
    [self.view addSubview:labAuthor];

    UIImageView *viewicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view"]];
    viewicon.frame = CGRectMake(245, TitleY + 52, 24, 24);
    [self.view addSubview:viewicon];

    UILabel *labViews = [[UILabel alloc] initWithFrame:CGRectMake(272, TitleY + 54, 45, 20)];
    labViews.numberOfLines = 1;
    [labViews setFont:[UIFont systemFontOfSize:14]];
    [labViews setText:[NSString stringWithFormat:@"%d", _slide.viewers_count]];
    [self.view addSubview:labViews];

    UILabel *labLine1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 336, 318, 1)];
    [labLine1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:labLine1];

    UILabel *staticLabDescription = [[UILabel alloc] initWithFrame:CGRectMake(1, 344, 318, 20)];
    [staticLabDescription setText:@"Description"];
    [staticLabDescription setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:staticLabDescription];

    UILabel *labDescription = [[UILabel alloc] initWithFrame:CGRectMake(1, 369, 318, 75)];
    labDescription.numberOfLines = 0; //no limit
    [labDescription setFont:[UIFont systemFontOfSize:14]];
    [labDescription setText:[_slide.description stringByHTMLDecoded]];
    [labDescription sizeToFit];
    CGFloat desHeight = labDescription.frame.size.height;
    [self.view addSubview:labDescription];
    
    UIScrollView *mainView = (UIScrollView *)self.view;
    CGFloat oX = [mainView contentSize].width;
    CGFloat newY = 369 + desHeight;
    [mainView setContentSize:CGSizeMake(oX, newY)];
    self.view = mainView;
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

    if (i == 0) {
        if ([scrollView.subviews containsObject:notifyArrow]) {
            [scrollView bringSubviewToFront:notifyArrow];
            [scrollView bringSubviewToFront:labSlide];
        }
    }
}

- (void) createNotifyArrow
{
    NSLog(@"Create Arrow");
    CGPoint origin = CGPointMake(0, 30);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    [path addLineToPoint:CGPointMake(origin.x+20, origin.y-25)];
    [path addLineToPoint:CGPointMake(origin.x+20, origin.y-15)];
    [path addLineToPoint:CGPointMake(origin.x+70, origin.y-15)];
    [path addLineToPoint:CGPointMake(origin.x+70, origin.y+15)];
    [path addLineToPoint:CGPointMake(origin.x+20, origin.y+15)];
    [path addLineToPoint:CGPointMake(origin.x+20, origin.y+25)];
    [path closePath];

    CAShapeLayer *sl = [CAShapeLayer layer];
    sl.fillColor = [UIColor grayColor].CGColor;
    sl.path = path.CGPath;
    sl.transform = CATransform3DMakeScale(2.5, 1.5, 1);

    sl.masksToBounds = NO; // this default
    sl.shadowColor = [[UIColor blackColor] CGColor];
    sl.shadowOpacity = 0.4;
    sl.shadowRadius = 1.4;
    sl.shadowOffset = CGSizeMake(0.0f, 0.0f);

    // set the frame height to 0 so the arrow won't disable the scroll function
    notifyArrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 0)];
    [notifyArrow.layer addSublayer:sl];

    notifyArrow.center = CGPointMake(279, 75);

    labSlide = [[UILabel alloc] initWithFrame:CGRectMake(25, 33, 65, 25)];
    [labSlide setText:@"Preview"];
    [labSlide setTextColor:[UIColor whiteColor]];
//    [notifyArrow addSubview:labSlide];
    labSlide.center = CGPointMake(288, 120);

    [scrollView addSubview:notifyArrow];
    [scrollView addSubview:labSlide];

    [UIView animateWithDuration:1.5f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                          notifyArrow.center = CGPointMake(239, 75);
                          [scrollView layoutIfNeeded];
                     }
                     completion:nil];
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

- (void)dismissPageControl: (NSTimer*) timer
{
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [pageControl setAlpha:0.0f];
    } completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [pageControl setAlpha:1.0f];
    } completion:nil];
    if ([timerDismissPagecontrol isValid]) {
        [timerDismissPagecontrol invalidate];
    }
    timerDismissPagecontrol = [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                             target: self
                                           selector: @selector(dismissPageControl:)
                                           userInfo: nil
                                            repeats: NO];

    // disable notify arrow timer
    if ([timerShowSlideNotification isValid]) {
        [timerShowSlideNotification invalidate];
    }
    if ([scrollView.subviews containsObject:notifyArrow]) {
        [notifyArrow removeFromSuperview];
        [labSlide removeFromSuperview];
    }

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
