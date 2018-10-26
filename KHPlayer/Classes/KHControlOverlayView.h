//
//  KHControlOverlayView.h
//  KHPlayer
//
//  Created by DevLee on 22/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHPlayerNotifications.h"
#import "KHPlayerUtil.h"
#import <MediaPlayer/MediaPlayer.h>


NS_ASSUME_NONNULL_BEGIN

@interface KHControlOverlayView : UIView
{
    MPVolumeView *hiddenVolumeView;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCenterPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnBottomPlay;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UIButton *btnResolution;
@property (weak, nonatomic) IBOutlet UIButton *BtnFullScreen;
@property (weak, nonatomic) IBOutlet UIButton *btnPlaylist;
@property (weak, nonatomic) IBOutlet UILabel *lbNowTime;
@property (weak, nonatomic) IBOutlet UILabel *lbEndTime;
@property (weak, nonatomic) IBOutlet UIView *airPlayView;
@property (weak, nonatomic) IBOutlet UIView *googleCastView;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, assign) BOOL isSeekDrag;

-(void)playerSeek:(NSNumber *)currentSeek withCurrentPlayTime:(CMTime)currentPlayTime withEndTime:(CMTime)endTime;

-(void)volumeControl:(BOOL)isUp;
-(void)brightlessControl:(BOOL)isUP;



@end

NS_ASSUME_NONNULL_END
