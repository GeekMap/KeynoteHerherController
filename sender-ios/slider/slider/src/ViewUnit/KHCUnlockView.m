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
#define ViewMask 0.85

#define LabelOffsetX 10
#define LabelWidth 20
#define VolumeUpLabelPosX (LabelOffsetX)
#define VolumeUpLabelPosY 75
#define VolumeDownLabelPosX (LabelOffsetX)
#define VolumeDownLabelPosY 142
#define SliderTipLabelPosX 100
#define SliderTipLabelPosY 500

#define SliderLength 350
#define SliderWidth 96
#define SliderPosX (320-SliderWidth)/2
#define SliderPosY 150



@interface KHCUnlockView()
@property(nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) void (^complition)(void);
@end


@implementation KHCUnlockView
{
    UILabel *sliderTipLabel;
    UILabel *volumeUpLabel;
    UILabel *volumeDownLabel;
    BOOL did_unlock;
}
@synthesize window;
- (id) init
{
    did_unlock = NO;
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:ViewMask];
        // add Text
        volumeUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(VolumeUpLabelPosX, VolumeUpLabelPosY, ViewWidth, LabelWidth)];
        [volumeUpLabel setText:@"<<  Previous"];
        [volumeUpLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
        [volumeUpLabel setTextAlignment:NSTextAlignmentLeft];
        [volumeUpLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self addSubview:volumeUpLabel];
        
        volumeDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(VolumeDownLabelPosX, VolumeDownLabelPosY, ViewWidth, LabelWidth)];
        [volumeDownLabel setText:@"<<  Next"];
        [volumeDownLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
        [volumeDownLabel setTextAlignment:NSTextAlignmentLeft];
        [volumeDownLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self addSubview:volumeDownLabel];
        
        sliderTipLabel = [[UILabel alloc] init];
        sliderTipLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        [sliderTipLabel setAutoresizesSubviews:NO];
        [sliderTipLabel setFrame: CGRectMake(SliderPosX, SliderPosY, SliderWidth, SliderLength)];
        [sliderTipLabel.layer setBackgroundColor:[UIColor lightGrayColor].CGColor];
        sliderTipLabel.layer.cornerRadius = SliderWidth/2;
        [sliderTipLabel setText:@"slide to unlock\t\t"];
        [sliderTipLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f ]];
        [sliderTipLabel setTextAlignment:NSTextAlignmentRight];
        [sliderTipLabel setFont:[UIFont boldSystemFontOfSize: 28.0]];
        [self addSubview:sliderTipLabel];
        
        
        // add Slide
        UISlider *slider = [[UISlider alloc] init];
        slider.transform = CGAffineTransformMakeRotation(M_PI_2);
        [slider setFrame:CGRectMake(SliderPosX,SliderPosY,SliderWidth,SliderLength)];
        [slider addTarget:self action:@selector(sliderMoveAction:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderReset:) forControlEvents:UIControlEventTouchUpInside];
        [slider addTarget:self action:@selector(sliderReset:) forControlEvents:UIControlEventTouchUpOutside];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0f;
        slider.maximumValue = SliderLength-SliderWidth;
        slider.value = 0.0f;
        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"Nothing.png"]
                                   stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"Nothing.png"]
                                    stretchableImageWithLeftCapWidth:30.0 topCapHeight:0.0];
        UIImage *thumbImage = [UIImage imageNamed:@"slider-arrow.png"];
        [slider setThumbImage:thumbImage  forState:UIControlStateNormal];
        [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
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
    did_unlock = YES;
    
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
    if (slider.value >= slider.maximumValue)
    {
        [self hide];
    }
    else if(did_unlock == NO)
    {
        volumeDownLabel.hidden = YES;
        volumeUpLabel.hidden = YES;
        [sliderTipLabel setFrame: CGRectMake(SliderPosX, SliderPosY+slider.value, SliderWidth, SliderLength-slider.value)];
        float alpha = ViewMask - ViewMask*0.8*(slider.value/slider.maximumValue);
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:alpha];
        if (SliderLength-slider.value > 300)
        {
            sliderTipLabel.text = @"slide to unlock\t\t";
        }
        else
        {
            sliderTipLabel.text = @"";
        }
    }
}

- (void) sliderReset:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    if (slider.value != slider.maximumValue)
    {
        sliderTipLabel.text = @"";
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [slider setValue:0.0f animated:YES];
                             [sliderTipLabel setFrame: CGRectMake(SliderPosX, SliderPosY+slider.value, SliderWidth, SliderLength)];
                             self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:ViewMask];
                         } completion:^(BOOL finish){
                            sliderTipLabel.text = @"slide to unlock\t\t";
                            volumeDownLabel.hidden = NO;
                            volumeUpLabel.hidden = NO;
                         }];
    }
}
@end
