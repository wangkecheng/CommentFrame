//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LBTabTitleCellProtocol.h"

@interface LBTabTitleViewCell : UICollectionViewCell<LBTabTitleCellProtocol>
@property (nonatomic, weak,readonly) UILabel *titleLabel;
@end
