//
//  KHPlayerUtil.m
//  KHPlayer
//
//  Created by DevLee on 23/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHPlayerUtil.h"

@implementation KHPlayerUtil

+(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}
+(NSInteger)convertInteger:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    NSInteger currentDuration = fmodf(currentSeconds, 60.0);
    return currentDuration;
}
+(void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
+(void)haptic
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 10.0) {
        NSInteger value = [[[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"]integerValue];
        
        if (value == 2) {
            UIImpactFeedbackGenerator *impac = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleHeavy];
            [impac impactOccurred];
        }
        
    }
}

+(CGSize)ratioSize:(CGSize)originalSize withNeedWidth:(CGFloat)needWidth
{
    
    CGFloat scaleFactor = needWidth / originalSize.width;
    CGFloat newHeight = originalSize.height * scaleFactor;
    CGFloat newWidth = originalSize.width * scaleFactor;
    
    
    return CGSizeMake(newWidth,newHeight);
}

+(UIEdgeInsets)safeAreaInset
{
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    }
    
    return UIEdgeInsetsZero;
    
}

@end
