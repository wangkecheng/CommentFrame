//
//  PhotosContainerView.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "PhotosContainerView.h"

@interface PhotosContainerView()


@end
@implementation PhotosContainerView
{
    NSMutableArray *_btnArray;
}

- (instancetype)initWithMaxItemsCount:(NSInteger)count
{
    if (self = [super init]) {
        _maxItemsCount = count;
        _verticalMargin = _horizontalMargin = 10;
         _userActionEnable = YES;//默认图片可以点击
    }
    return self;
}
- (instancetype)initWithMaxItemsCount:(NSInteger)count isSingleLine:(BOOL)isSingleLine
{
    if (self = [super init]) {
        _maxItemsCount = count;
        _isSingleLine = isSingleLine;
        _verticalMargin = _horizontalMargin = 10;
        _autoHeightRatio = 1;
         _userActionEnable = YES;//默认图片可以点击
    }
    return self;
}
- (instancetype)initWithMaxItemsCount:(NSInteger)count isSingleLine:(BOOL)isSingleLine verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMargin
{
    if (self = [super init]) {
        _maxItemsCount = count;
        _isSingleLine = isSingleLine;
        _verticalMargin = verticalMargin;
        _horizontalMargin = horizontalMargin;
        _autoHeightRatio = 1;
        _userActionEnable = YES;//默认图片可以点击
    }
    return self;
}
- (void)setPhotoNamesArray:(NSArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_btnArray) {
        _btnArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _btnArray.count);
    
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIButton *btn = [UIButton new];
            [self addSubview:btn];
            if (_userActionEnable) {
                btn.userInteractionEnabled = YES;//
            }
            else{
                btn.userInteractionEnabled = NO;//
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(bigImg:) forControlEvents:UIControlEventTouchUpInside];
            [_btnArray addObject:btn];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if (idx < _photoNamesArray.count) {
            btn.hidden = NO;
            btn.sd_layout.autoHeightRatio(_autoHeightRatio);
            NSString *imgStr = _photoNamesArray[idx];
            if ([imgStr containsString:@"http"]) {
                [btn sd_setImageWithURL:[DDFactory getImgUrl:imgStr] forState:UIControlStateNormal];
            }
            else{
                
                [btn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
            }
            [temp addObject:btn];
        } else {
            [btn sd_clearAutoLayoutSettings];
            btn.hidden = YES;
        }
    }];
    
    if (_isSingleLine) {
       [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:self.maxItemsCount verticalMargin:_verticalMargin horizontalMargin:_horizontalMargin verticalEdgeInset:0 horizontalEdgeInset:0];
        return;//挑战排行榜那里展示
    }
    
    if (_photoNamesArray.count == 1) {
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:1 verticalMargin:_verticalMargin horizontalMargin:_horizontalMargin verticalEdgeInset:0 horizontalEdgeInset:0];
    }
    else if (_photoNamesArray.count == 2){
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:2 verticalMargin:_verticalMargin horizontalMargin:_horizontalMargin verticalEdgeInset:0 horizontalEdgeInset:0];
        }
    else{
        [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:_verticalMargin horizontalMargin:_horizontalMargin verticalEdgeInset:0 horizontalEdgeInset:0];
    }
}
-(void)bigImg:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(bigImg:)]) {
        [_delegate bigImg:btn.tag];
    }
}
@end
