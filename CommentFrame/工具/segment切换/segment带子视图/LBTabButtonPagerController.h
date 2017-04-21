//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//

#import "LBTabPagerController.h"
#import "LBTabTitleViewCell.h"
#define kUnderLineViewHeight 1
// register cell conforms to TYTabTitleViewCellProtocol

@interface LBTabButtonPagerController : LBTabPagerController<TYTabPagerControllerDelegate,LBPagerControllerDataSource>

// be carefull!!! the barStyle set style will reset progress propertys, set it (behind [super viewdidload]) or (in init) and set cell property that you want

// pagerBar color
@property (nonatomic, strong) UIColor *pagerBarColor;
@property (nonatomic, strong) UIColor *collectionViewBarColor;

// progress view
@property (nonatomic, assign) CGFloat progressRadius;
@property (nonatomic, strong) UIColor *progressColor;

// text color
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end
