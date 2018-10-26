//
//  KHPlayerViewController.m
//  KHPlayer
//
//  Created by DevLee on 22/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHPlayerViewController.h"
#import "EasyLayout/EasyLayout.h"

 

@implementation KHPlayerViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initOverLayView];
        [self initGesture];
        [self initNotification];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initOverLayView];
        [self initGesture];
        [self initNotification];
    }
    return self;
}

-(void)initOverLayView
{
    
    [self.player setAllowsExternalPlayback:YES];
    [self.player setUsesExternalPlaybackWhileExternalScreenIsActive:YES];
    
    self.controlView = [[KHControlOverlayView alloc]init];
    
    [self.contentOverlayView addSubview:self.controlView];
    
    [self.controlView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
    }forOrientation:ELInterfaceOritationPortrait];
    
    [self.controlView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
    }forOrientation:ELInterfaceOritationLandscape];
    
}

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerResolutionNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerSeekMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerShowMoreVideoViewNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerSeekMoveENDNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerMoreVideoViewCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerVolumeChange object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:KHPlayerRecommandVideoListNotification object:nil];
    
    
}


-(void)initGesture
{
    [self setShowsPlaybackControls:NO];

    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc]init];
    [doubleTapGes setNumberOfTapsRequired:2];
    [doubleTapGes addTarget:self action:@selector(doubleTapGesture)];
    
    [self.view addGestureRecognizer:doubleTapGes];
    
    
    UITapGestureRecognizer *singleTapGes = [[UITapGestureRecognizer alloc]init];
    [singleTapGes setNumberOfTapsRequired:1];

    [singleTapGes addTarget:self action:@selector(singleTapGesture)];
    [singleTapGes requireGestureRecognizerToFail:doubleTapGes];
    [self.view addGestureRecognizer:singleTapGes];
    
    
    
    
    
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]init];
    
    [panGes addTarget:self action:@selector(panGesure:)];
    [self.view addGestureRecognizer:panGes];
    
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    [self.view addGestureRecognizer:pinchGes];
    
}


-(void)gestureEnable:(BOOL)enable withAllDisable:(BOOL)allDisable
{
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
 
        if (allDisable) {
            [gesture setEnabled:NO];
        }
        else {
            
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                [gesture setEnabled:YES];
            }
            else {
                [gesture setEnabled:enable];
            }
        }
 
    }
}

-(void)playerDurationObserver:(CMTime)interval
{
    
    __weak __typeof(self) weakself = self;
    id playbackObserver;
    playbackObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (weakself.player.currentItem.asset.duration, weakself.player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        double normalizedTime = (double) weakself.player.currentTime.value / (double) endTime.value;
        [weakself.controlView playerSeek:[NSNumber numberWithDouble:normalizedTime]
                     withCurrentPlayTime:weakself.player.currentTime
                             withEndTime:endTime];
    }];
}



-(void)singleTapGesture
{

    if (self.controlView) {
        
        [self.controlView setHidden:!self.controlView.hidden];
        [self gestureEnable:self.controlView.hidden withAllDisable:NO];
    }
}

-(void)doubleTapGesture
{
    [self.player pause];
}


-(void)pinchGesture:(UIPinchGestureRecognizer *)sender
{
 
    if (sender.velocity < 0) {
        [self setVideoGravity:AVLayerVideoGravityResizeAspect];
    }
    else {
        [self setVideoGravity:AVLayerVideoGravityResize];
    }
    
    
}


- (void)panGesure:(UIPanGestureRecognizer *)sender
{
    
    
    
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };

    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;

    
    BOOL isSoundControl = NO;
    
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGPoint value = [sender locationInView:self.view];
    
    if (screenWidth/2 <= value.x) {
        isSoundControl = YES;
    }
    else {
        isSoundControl = NO;
    }
 
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (direction == UIPanGestureRecognizerDirectionUndefined) {
            
            CGPoint velocity = [sender velocityInView:self.view];
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            
            if (isVerticalGesture) {
                if (velocity.y > 0) {
                    direction = UIPanGestureRecognizerDirectionDown;
                } else {
                    direction = UIPanGestureRecognizerDirectionUp;
                }
            }
            
            else {
                [self.player pause];
                if (velocity.x > 0) {
                    direction = UIPanGestureRecognizerDirectionRight;
                } else {
                    direction = UIPanGestureRecognizerDirectionLeft;
                }
            }
        }

    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        
        
        if (direction == UIPanGestureRecognizerDirectionUp) {
            [self handleUpwardsGesture:sender withSoundControl:isSoundControl];
        }
        else if (direction == UIPanGestureRecognizerDirectionDown) {
            [self handleDownwardsGesture:sender withSoundControl:isSoundControl];
        }
        else if (direction == UIPanGestureRecognizerDirectionLeft) {
            CGPoint translation = [sender translationInView:self.view];
            
            float horizontalTranslation = translation.x;
            
            float durationInSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
            
            //I'd like to be able to swipe across the whole view.
            float translationLimit = self.view.bounds.size.width;
            float minTranslation = 0;
            float maxTranslation = translationLimit;
            
            if (horizontalTranslation > maxTranslation) {
                horizontalTranslation = maxTranslation;
            }
            
            
            timeToSeekTo = [self normalize:horizontalTranslation
                               andMinDelta:minTranslation
                               andMaxDelta:maxTranslation
                            andMinDuration:0
                            andMaxDuration:durationInSeconds];
            
            
            
            [self handleLeftGesture:sender];
        }
        else if (direction == UIPanGestureRecognizerDirectionRight) {
            
            CGPoint translation = [sender translationInView:self.view];
            
            float horizontalTranslation = translation.x;
            
            float durationInSeconds = CMTimeGetSeconds(self.player.currentItem.asset.duration);
            
            //I'd like to be able to swipe across the whole view.
            float translationLimit = self.view.bounds.size.width;
            float minTranslation = 0;
            float maxTranslation = translationLimit;
            
            if (horizontalTranslation > maxTranslation) {
                horizontalTranslation = maxTranslation;
            }
            
            if (horizontalTranslation < minTranslation) {
                horizontalTranslation = minTranslation;
            }
            
            timeToSeekTo = [self normalize:horizontalTranslation
                               andMinDelta:minTranslation
                               andMaxDelta:maxTranslation
                            andMinDuration:0
                            andMaxDuration:durationInSeconds];
            
            
            
            [self handleRightGesture:sender];
        }
        
 
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (direction == UIPanGestureRecognizerDirectionLeft||direction == UIPanGestureRecognizerDirectionRight) {
            
            if(CMTIME_IS_VALID(self.currentTime)){
                float seconds = self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale;
                
                [self.player seekToTime:CMTimeMakeWithSeconds(seconds+timeToSeekTo, self.player.currentTime.timescale)
                        toleranceBefore:kCMTimeZero
                         toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished)
                 {
                     if(finished) {
                         self.currentTime = self.player.currentItem.currentTime;
                         [self.player play];
                     }
                     
                 }];
            }
            else
            {
                [self.player seekToTime:CMTimeMakeWithSeconds(timeToSeekTo,
                                                              self.player.currentTime.timescale) toleranceBefore:kCMTimeZero
                         toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                             if(finished) {
                                 self.currentTime = self.player.currentItem.currentTime;
                                 [self.player play];
                             }
                             
                         }];
            }
            
            
            
        }
        direction = UIPanGestureRecognizerDirectionUndefined;
    }
    
 
    
}
- (float) normalize:(float)delta
        andMinDelta:(float)minDelta
        andMaxDelta:(float)maxDelta
     andMinDuration:(float)minDuration
     andMaxDuration:(float)maxDuration{
    
    float result = ((delta - minDelta) * (maxDuration - minDuration) / (maxDelta - minDelta) + minDuration);
    return result;
}

- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender withSoundControl:(BOOL)isSoundControl
{
    if (isSoundControl) {
        [self.controlView volumeControl:YES];
    }
    else {
        [self.controlView brightlessControl:YES];
    }
}

- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender withSoundControl:(BOOL)isSoundControl
{
    if (isSoundControl) {
        [self.controlView volumeControl:NO];
    }
    else {
        [self.controlView brightlessControl:NO];
    }
}

- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Left");
}

- (void)handleRightGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Right");
}



-(void)didReceiveNotification:(NSNotification *)noti
{
    NSLog(@"%@",noti.name);
    
    if ([noti.name isEqualToString:KHPlayerPlayNotification]) {
        [self playerPlayControl];
        [self.controlView setHidden:YES];
    }
    else if ([noti.name isEqualToString:KHPlayerFullScreenNotification]) {
        [self playerShowFullScreen];
    }
    else if ([noti.name isEqualToString:KHPlayerResolutionNotification]) {
        [self playerShowResolution];
    }
    else if ([noti.name isEqualToString:KHPlayerSeekMoveNotification]) {
        [self playerSeekChaned:[noti.object floatValue]];
    }
    else if ([noti.name isEqualToString:KHPlayerShowMoreVideoViewNotification]) {
        [self playerShowPlaylist];
    }
    else if ([noti.name isEqualToString:KHPlayerSeekMoveENDNotification]) {
         [self playerSeekMoveEnd:[noti.object floatValue]];
    }
    else if ([noti.name isEqualToString:KHPlayerMoreVideoViewCloseNotification]) {
        [self dismissMoreVideoView];
    }
    else if ([noti.name isEqualToString:KHPlayerVolumeChange]) {
        self.controlView.volume = [[[noti userInfo]objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]floatValue];
    }
    else if ([noti.name isEqualToString:KHPlayerRecommandVideoListNotification]) {
        [self playerShowRecommandVideoList];
    }
    
}



-(void)playerPlayControl
{
    
    if (self.player.rate == 0.0f) {

        [self.player play];
    }
    else {
        [self.player pause];
    }
    [self playerDurationObserver:CMTimeMake(1, 60)];
}

-(void)playerShowFullScreen
{
    NSLog(@"가로 모드로");
    
    if (self.isFullScreen) {
        self.isFullScreen = NO;
        [KHPlayerUtil interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        self.isFullScreen = YES;
        [KHPlayerUtil interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    
    
    
}

-(void)playerShowResolution
{
    NSLog(@"해상도 선택화면");
}

-(void)playerSeekChaned:(float)movePoint
{
    NSLog(@"재생 포인트 변경 %f",movePoint);
}
-(void)playerSeekMoveEnd:(float)movePoint
{
    [self.player pause];
    CMTime seekTime = CMTimeMakeWithSeconds(movePoint * (double)self.player.currentItem.asset.duration.value/(double)self.player.currentItem.asset.duration.timescale, self.player.currentTime.timescale);
    [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}


-(void)showMoreVideoView
{
    [self.controlView setHidden:YES];
    [self gestureEnable:NO withAllDisable:YES];
    [self setVideoGravity:AVLayerVideoGravityResize];
    
    if (!self.moreVideoView) {
        self.moreVideoView = [[KHMoreVideo alloc]init];
    }
    [self.moreVideoView setAlpha:0];
    [self.view addSubview:self.moreVideoView];
    [self.moreVideoView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
    } forOrientation:ELInterfaceOritationLandscape];
}

-(void)dismissMoreVideoView
{
    [self.player setMuted:NO];
    [self gestureEnable:YES withAllDisable:NO];
    [self.moreVideoView removeFromSuperview];
    self.moreVideoView = nil;
    
}


-(void)playerShowPlaylist
{
    [self showMoreVideoView];
    [self.moreVideoView showPlayList:self.player withItems:@[]];
    
}

-(void)playerShowRecommandVideoList
{
    [self showMoreVideoView];
    [self.moreVideoView showRecommandList:self.player withItems:@[]];
}





- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.isFullScreen) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotate {
    if (self.isFullScreen) {
        return NO;
    }
    return YES;
}



@end
