//
//  KHPlayerUtil.h
//  KHPlayer
//
//  Created by DevLee on 23/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KHPlayerUtil : NSObject


+(NSString*)getStringFromCMTime:(CMTime)time;
+(NSInteger)convertInteger:(CMTime)time;
+(void)interfaceOrientation:(UIInterfaceOrientation)orientation;
+(void)haptic;
+(CGSize)ratioSize:(CGSize)originalSize withNeedWidth:(CGFloat)needWidth;
+(UIEdgeInsets)safeAreaInset;
@end

NS_ASSUME_NONNULL_END
