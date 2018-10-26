//
//  KHPlayerViewController.h
//  KHPlayer
//
//  Created by DevLee on 22/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "KHControlOverlayView.h"
#import "KHPlayerNotifications.h"
#import "KHMoreVideo.h"



NS_ASSUME_NONNULL_BEGIN

@interface KHPlayerViewController : AVPlayerViewController
{
    float timeToSeekTo;
}
@property (nonatomic, strong) KHControlOverlayView *controlView;
@property (nonatomic, strong) KHMoreVideo *moreVideoView;
@property (nonatomic, assign)     BOOL isFullScreen;
@property (nonatomic, strong) AVPlayerViewController *miniPlayer;
@property (nonatomic, assign) CMTime currentTime;

@end

NS_ASSUME_NONNULL_END
