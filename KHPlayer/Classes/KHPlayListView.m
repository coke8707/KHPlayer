//
//  KHPlayListView.m
//  KHPlayer
//
//  Created by DevLee on 23/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHPlayListView.h"
#import "KHPlayerUtil.h"
#import "KHPlayerNotifications.h"
#import "EasyLayout/EasyLayout.h"
#import "UIView+BSXMaterialAnimation.h"


@implementation KHPlayListView

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
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"KHPlayListView" owner:self options:nil]firstObject];
    [self addSubview:contentView];
    [contentView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
    } forOrientation:ELInterfaceOritationLandscape];
    [contentView remakeConstraints:^(ELConstraintsMaker *make) {
        make.ELTop.equalTo(@0);
        make.ELLeft.equalTo(@0);
        make.ELRight.equalTo(@0);
        make.ELBottom.equalTo(@0);
    } forOrientation:ELInterfaceOritationPortrait];
    
}

 

@end
