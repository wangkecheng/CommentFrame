//
//  PhotosContainerView.h
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotosContainerViewDelegate <NSObject>
-(void)bigImg:(NSInteger)index;
@end
@interface PhotosContainerView : UIView

- (instancetype)initWithMaxItemsCount:(NSInteger)count;

- (instancetype)initWithMaxItemsCount:(NSInteger)count isSingleLine:(BOOL)isSingleLine;

- (instancetype)initWithMaxItemsCount:(NSInteger)count isSingleLine:(BOOL)isSingleLine verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMargin;
@property (nonatomic,assign)id<PhotosContainerViewDelegate> delegate;
@property (nonatomic, assign)BOOL isSingleLine;//只在一排上展示所有的
@property (nonatomic, strong) NSArray *photoNamesArray;
@property (nonatomic, assign) CGFloat autoHeightRatio;
@property (nonatomic, assign) NSInteger maxItemsCount;
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic,assign)BOOL userActionEnable;//图片是否允许点击
@end
