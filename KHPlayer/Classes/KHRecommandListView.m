//
//  KHRecommandListView.m
//  KHPlayer
//
//  Created by DevLee on 26/10/2018.
//  Copyright © 2018 coke. All rights reserved.
//

#import "KHRecommandListView.h"
#import "EasyLayout/EasyLayout.h"
@implementation KHRecommandListView

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
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"KHRecommandListView" owner:self options:nil]firstObject];
    [contentView setFrame:self.frame];
    [self addSubview:contentView];
}

@end
