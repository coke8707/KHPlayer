//
//  KHMoreVideo.m
//  KHPlayer
//
//  Created by DevLee on 26/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHMoreVideo.h"
#import "KHPlayerUtil.h"
#import "KHPlayerNotifications.h"
#import "EasyLayout/EasyLayout.h"
#import "UIView+BSXMaterialAnimation.h"
#import "KHPlayListView.h"
#import "KHRecommandListView.h"

@implementation KHMoreVideo

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
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"KHMoreVideo" owner:self options:nil]firstObject];
    [contentView setFrame:self.frame];
    [self addSubview:contentView];
}


-(void)commonInit
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1.0f];
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(miniPlayerClose)];
    [tapGes setNumberOfTapsRequired:1];
    
    [self addGestureRecognizer:tapGes];
    
    self.miniPlayer = [[AVPlayerViewController alloc]init];
    
    [self.miniPlayer setShowsPlaybackControls:NO];
    [self addSubview:self.miniPlayer.view];
    [self.miniPlayer.view.layer setCornerRadius:10.0f];
    [self.miniPlayer.view.layer setMasksToBounds:YES];
    [self.miniPlayer.view setAlpha:0];
}



-(void)showPlayList:(AVPlayer *)currentPlayer withItems:(NSArray *)items
{

    [self commonInit];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat halfWidth = screenWidth/2;
    
    UIEdgeInsets playrMargin = UIEdgeInsetsMake(0, 30, 0, 30);
    
    
    CGSize minisize = [KHPlayerUtil ratioSize:CGSizeMake(1920, 1080) withNeedWidth:halfWidth - (playrMargin.left + playrMargin.right)];
    
    
    
    [self.miniPlayer.view remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@((screenHeight - minisize.height)/2));
        make.ELLeft.equalTo(@(playrMargin.left));
        make.ELWidth.equalTo(@(minisize.width));
        make.ELHeight.equalTo(@(minisize.height));
    } forOrientation:ELInterfaceOritationLandscape];
    [self.miniPlayer setPlayer:currentPlayer];
    [self.miniPlayer.player play];
    
    
    
    KHPlayListView *playlistView = [[KHPlayListView alloc]init];
    [self addSubview:playlistView];
    [playlistView setupForBSXAnimation];
    [playlistView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
        make.ELWidth.equalTo(@(halfWidth));
    } forOrientation:ELInterfaceOritationLandscape];
    
 
    self.miniPlayer.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.miniPlayer.view.transform = CGAffineTransformIdentity;
        [self.miniPlayer.view setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [playlistView runBSXAnimateWithCGPoint:CGPointMake(halfWidth, screenHeight/2)
                                backgroundColor:[UIColor colorWithRed:38.0f/255 green:166.0f/255 blue:91.0f/255 alpha:0.8f]
                                       isExpand:true
                                       duration:0.8
                                 timingFunction:nil
                                     completion:nil];
    }];
    
}
-(void)showRecommandList:(AVPlayer *)currentPlayer withItems:(NSArray *)items
{
    [self commonInit];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat halfWidth = screenWidth/2;
    
    
    
    KHRecommandListView *recommandView = [[KHRecommandListView alloc]init];
    [self addSubview:recommandView];
    [recommandView setupForBSXAnimation];
    [recommandView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELBottom.equalTo(@0);
        make.ELWidth.equalTo(@(halfWidth));
    } forOrientation:ELInterfaceOritationLandscape];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [recommandView runBSXAnimateWithCGPoint:CGPointMake(0, screenHeight/2)
                                backgroundColor:[UIColor colorWithRed:38.0f/255 green:166.0f/255 blue:91.0f/255 alpha:0.8f]
                                       isExpand:true
                                       duration:0.8
                                 timingFunction:nil
                                     completion:nil];
    });
    
    
    
    UIEdgeInsets playrMargin = UIEdgeInsetsMake(0, 30, 0, 30);
    
    
    CGSize minisize = [KHPlayerUtil ratioSize:CGSizeMake(1920, 1080) withNeedWidth:halfWidth - (playrMargin.left + playrMargin.right)];
    
    
    
    [self.miniPlayer.view remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@((screenHeight - minisize.height)/2));
        make.ELLeft.equalTo(recommandView.ELRight).offset(playrMargin.left);
        make.ELWidth.equalTo(@(minisize.width));
        make.ELHeight.equalTo(@(minisize.height));
    } forOrientation:ELInterfaceOritationLandscape];
    [self.miniPlayer setPlayer:currentPlayer];
    [self.miniPlayer.player play];
    
    self.miniPlayer.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.miniPlayer.view.transform = CGAffineTransformIdentity;
        [self.miniPlayer.view setAlpha:1.0f];
    } completion:nil];
    
 
    
}

-(void)miniPlayerClose
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.miniPlayer.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [self.miniPlayer.view setAlpha:1.0f];
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [[NSNotificationCenter defaultCenter]postNotificationName:KHPlayerMoreVideoViewCloseNotification object:nil];
    }];
    
    
}


@end
