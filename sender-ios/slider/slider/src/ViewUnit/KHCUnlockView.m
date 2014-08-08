//
//  KHCUnlockView.m
//  slider
//
//  Created by jarron on 2014/8/1.
//
//

#import "KHCUnlockView.h"

#define ViewWidth 320
#define ViewHeight 568

#define LabelOffsetX 10
#define LabelWidth 20
#define VolumeUpLabelPosX (LabelOffsetX)
#define VolumeUpLabelPosY 75
#define VolumeDownLabelPosX (LabelOffsetX)
#define VolumeDownLabelPosY 142
#define SliderTipLabelPosX 100
#define SliderTipLabelPosY 450

#define SliderPosX 250
#define SliderPosY 180
#define SliderLength 350
#define SlideWidth 50

@interface KHCUnlockView()
@property(nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) void (^complition)(void);
@end


@implementation KHCUnlockView

@synthesize window;
- (id) init
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        // add Text
        UILabel *volumeUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(VolumeUpLabelPosX, VolumeUpLabelPosY, ViewWidth, LabelWidth)];
        [volumeUpLabel setText:@"<-- Press to go UP"];
        [volumeUpLabel setTextColor:[UIColor yellowColor]];
        [volumeUpLabel setTextAlignment:NSTextAlignmentLeft];
        [volumeUpLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self addSubview:volumeUpLabel];
        
        UILabel *volumeDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(VolumeDownLabelPosX, VolumeDownLabelPosY, ViewWidth, LabelWidth)];
        [volumeDownLabel setText:@"<-- Press to go NEXT"];
        [volumeDownLabel setTextColor:[UIColor yellowColor]];
        [volumeDownLabel setTextAlignment:NSTextAlignmentLeft];
        [volumeDownLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self addSubview:volumeDownLabel];
        
        UILabel *sliderTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SliderTipLabelPosX, SliderTipLabelPosY, ViewWidth, LabelWidth)];
        [sliderTipLabel setText:@"Slide to UNLOCK -->"];
        [sliderTipLabel setTextColor:[UIColor yellowColor]];
        [sliderTipLabel setTextAlignment:NSTextAlignmentLeft];
        [sliderTipLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self addSubview:sliderTipLabel];
        
        
        // add Slide
        UISlider *slider = [[UISlider alloc] init];
        slider.transform = CGAffineTransformMakeRotation(M_PI_2);
        [slider setFrame:CGRectMake(SliderPosX,SliderPosY,SlideWidth,SliderLength)];
        [slider addTarget:self action:@selector(sliderMoveAction:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderReset:) forControlEvents:UIControlEventTouchUpInside];
        [slider addTarget:self action:@selector(sliderReset:) forControlEvents:UIControlEventTouchUpOutside];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0f;
        slider.maximumValue = 1.0f;
        slider.value = 0.0f;
        [slider setContinuous: YES];
        [slider setEnabled:YES];
        [slider setUserInteractionEnabled:YES];
        [self addSubview:slider];
    }
    return self;
}

- (void) showWithComplition:(void (^)(void))complition
{
    [self show];
    self.complition = complition;
}

- (void) show
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.f];
    self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    
    [self.window addSubview:self];
    [self.window makeKeyAndVisible];
}

- (void) hide
{
    [UIView animateWithDuration:0.5f
                          delay:0.f
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{self.window.alpha = 0.f;}
                     completion:^(BOOL finished){
                         if (finished) {
                             // self.window.hidden = YES;
                             self.complition();
                             self.window = nil;
                         }
                     }];
}

- (void) sliderMoveAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    if (slider.value == slider.maximumValue)
        [self hide];
}

- (void) sliderReset:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    if (slider.value != slider.maximumValue)
    {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [slider setValue:0.0f animated:YES];
                         }];
    }
}
@end
