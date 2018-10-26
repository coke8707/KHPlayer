//
//  KHControlOverlayView.m
//  KHPlayer
//
//  Created by DevLee on 22/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHControlOverlayView.h"



@implementation KHControlOverlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadXib];
    }
    return self;
}

-(void)loadXib
{
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"KHControlOverlayView" owner:self options:nil]firstObject];
    [contentView setFrame:self.frame];
    [self addSubview:contentView];
    
    hiddenVolumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(-10000, -1000, 0, 0)];
    [hiddenVolumeView setShowsRouteButton:NO];
    
    for (UIView *view in hiddenVolumeView.subviews) {
        [view setAlpha:0];
    }
    
    [self addSubview:hiddenVolumeView];
    
    
    self.volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.volumeView setTintColor:[UIColor whiteColor]];
    [self.volumeView setShowsRouteButton:YES];
    [self.volumeView setShowsVolumeSlider:NO];
    [self.volumeView sizeToFit];
    [self.airPlayView addSubview:self.volumeView];
    self.volume = [[AVAudioSession sharedInstance] outputVolume];
 
}

-(void)playerSeek:(NSNumber *)currentSeek withCurrentPlayTime:(CMTime)currentPlayTime withEndTime:(CMTime)endTime
{
 
 
    [self.lbNowTime setText:[KHPlayerUtil getStringFromCMTime:currentPlayTime]];
    [self.lbEndTime setText:[KHPlayerUtil getStringFromCMTime:endTime]];
    
    if (!self.isSeekDrag) {
        [self.playSlider setValue:currentSeek.floatValue];
    }
    
 
}
-(void)volumeControl:(BOOL)isUp
{
    if (isUp) {
        self.volume = self.volume + 0.01f;
        if (self.volume >= 1.0f) {
            self.volume = 1.0f;
        }
        UISlider *volumeViewSlider = nil;
        
        for (UIView *view in hiddenVolumeView.subviews) {
            if ([view isKindOfClass:[UISlider class]]) {
                volumeViewSlider = (UISlider *)view;
                break;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            volumeViewSlider.value = self.volume;
        });
    }
    else {
        self.volume = self.volume - 0.01f;
        if (self.volume <= 0.0f) {
            self.volume = 0.0f;
        }
        UISlider *volumeViewSlider = nil;
        
        for (UIView *view in hiddenVolumeView.subviews) {
            if ([view isKindOfClass:[UISlider class]]) {
                volumeViewSlider = (UISlider *)view;
                break;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            volumeViewSlider.value = self.volume;
        });
    }
    
}
-(void)brightlessControl:(BOOL)isUP
{
    if (isUP) {
        CGFloat currentBright = [UIScreen mainScreen].brightness;
        
        currentBright = currentBright + 0.01f;
        if (currentBright >= 1.0f) {
            currentBright = 1.0f;
        }

        
        [[UIScreen mainScreen] setBrightness:currentBright];
    }
    else {
        CGFloat currentBright = [UIScreen mainScreen].brightness;
        
        currentBright = currentBright - 0.01f;
        
        if (currentBright <= 0.0f) {
            currentBright = 0.0f;
        }
        

        
        [[UIScreen mainScreen] setBrightness:currentBright];
    }
}

#pragma mark - IBAction

- (IBAction)centerPlayPress:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerPlayNotification object:nil];
}
- (IBAction)bottomPlayPress:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerPlayNotification object:nil];
}

- (IBAction)playTimeSeekChange:(UISlider *)sender {
    self.isSeekDrag = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerSeekMoveNotification object:@(sender.value)];
}
- (IBAction)playTimeSeekChangEnd:(UISlider *)sender {
    self.isSeekDrag = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerSeekMoveENDNotification object:@(sender.value)];
}

- (IBAction)resolutionPress:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerResolutionNotification object:nil];
}

- (IBAction)fullScreenPress:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerFullScreenNotification object:nil];
}

- (IBAction)showPlayList:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerShowMoreVideoViewNotification object:nil];
}
- (IBAction)showRecommadList:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerRecommandVideoListNotification object:nil];
    
}





@end
