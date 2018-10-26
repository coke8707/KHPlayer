//
//  KHMoreVideo.h
//  KHPlayer
//
//  Created by DevLee on 26/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KHMoreVideo : UIView
@property (nonatomic, strong)  AVPlayerViewController *miniPlayer;



-(void)showPlayList:(AVPlayer *)currentPlayer withItems:(NSArray *)items;
-(void)showRecommandList:(AVPlayer *)currentPlayer withItems:(NSArray *)items;


@end

NS_ASSUME_NONNULL_END
