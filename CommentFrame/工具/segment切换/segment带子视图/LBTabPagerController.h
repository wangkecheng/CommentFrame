//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//


#import "LBPagerController.h"

#define kCollectionViewBarHieght 45
#define kUnderLineViewHeight 1
@class LBTabPagerController;

//获取到pager的个数，用于设置每一个pager的宽度
@protocol GetPagerCountDelegate <NSObject>

@optional
-(NSInteger)getPagerCount;
@end

@protocol TYTabPagerControllerDelegate <TYPagerControllerDelegate>

@optional
// configre collectionview cell
- (void)pagerController:(LBTabPagerController *)pagerController configreCell:(UICollectionViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath;

// did select indexPath
- (void)pagerController:(LBTabPagerController *)pagerController didSelectAtIndexPath:(NSIndexPath *)indexPath;

// transition frome cell to cell with animated
- (void)pagerController:(LBTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell animated:(BOOL)animated;

// transition frome cell to cell with progress
- (void)pagerController:(LBTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell *)fromCell toCell:(UICollectionViewCell *)toCell progress:(CGFloat)progress;

@end

typedef NS_ENUM(NSUInteger, TYPagerBarStyle) {
    TYPagerBarStyleNoneView,
    TYPagerBarStyleProgressView,
    TYPagerBarStyleProgressBounceView,
    TYPagerBarStyleCoverView
};

@interface LBTabPagerController : LBPagerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-property-synthesis"
@property (nonatomic, weak) id<TYTabPagerControllerDelegate> delegate;
#pragma clang diagnostic pop

// view ,don't change frame
@property (nonatomic, weak, readonly) UIView *pagerBarView; // pagerBarView height is contentTopEdging
@property (nonatomic, weak, readonly) UICollectionView *collectionViewBar;
@property (nonatomic, weak, readonly) UIView *progressView;

@property (nonatomic, assign) TYPagerBarStyle barStyle; // you can set or ovrride barStyle

@property (nonatomic, assign) CGFloat collectionLayoutEdging; // collectionLayout left right edging

// progress view
@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, assign) CGFloat progressEdging; // if < 0 width + edge ,if >0 width - edge
@property (nonatomic, assign) CGFloat progressWidth; //if>0 progress width is equal,else progress width is cell width

// cell
@property (nonatomic, assign) CGFloat cellWidth; // if>0 cells width is equal,else if=0 cell will caculate all titles width
@property (nonatomic, assign) CGFloat cellSpacing; // cell space
@property (nonatomic, assign) CGFloat cellEdging;  // cell left right edge

//   animate duration
@property (nonatomic, assign) CGFloat animateDuration;

// text font
@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *selectedTextFont;


@property (nonatomic,weak)id <GetPagerCountDelegate>pagerCountDelegate;

// if you custom cell ,you must register cell
- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib;

@end

