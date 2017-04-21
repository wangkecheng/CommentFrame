//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//


#import "LBTabTitleViewCell.h"

@interface LBTabTitleViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation LBTabTitleViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
}

@end
