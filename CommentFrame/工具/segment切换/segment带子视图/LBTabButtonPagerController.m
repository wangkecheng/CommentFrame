//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//


#import "LBTabButtonPagerController.h"

@interface LBTabButtonPagerController ()
@property (nonatomic, assign) CGFloat selectFontScale;
@end


@implementation LBTabButtonPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self configureTabButtonPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configureTabButtonPropertys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    if (!self.dataSource) {
        self.dataSource = self;
    }
    _selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    
    [self configureSubViews];
}

- (void)configureSubViews
{
    // progress
    self.progressView.backgroundColor = _progressColor;
    self.progressView.layer.cornerRadius = _progressRadius;
    self.progressView.layer.masksToBounds = YES;
    
    // tabBar
    self.pagerBarView.backgroundColor = _pagerBarColor;
    self.collectionViewBar.backgroundColor = _collectionViewBarColor;
}

- (void)configureTabButtonPropertys
{
    self.cellSpacing = 2;
    self.cellEdging = 3;
    
    self.barStyle = TYPagerBarStyleProgressView;
    
    _normalTextColor = [UIColor whiteColor];
    _selectedTextColor = UIColorFromHX(0xf78707);
    
    _pagerBarColor = UIColorFromHX(0x222222);
    _collectionViewBarColor = [UIColor clearColor];
    
    _progressColor = UIColorFromHX(0xf78707);
    _progressRadius = self.progressHeight/2;
    
    [self registerCellClass:[LBTabTitleViewCell class] isContainXib:NO];
}

- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    [super setBarStyle:barStyle];
    
    switch (barStyle) {
        case TYPagerBarStyleProgressView:
            self.progressWidth = 0;
            self.progressHeight = kUnderLineViewHeight;
            self.progressEdging = 3;
            break;
        case TYPagerBarStyleProgressBounceView:
            self.progressHeight = kUnderLineViewHeight;
            self.progressWidth = 30;
            break;
        case TYPagerBarStyleCoverView:
            self.progressWidth = 0;
            self.progressHeight = self.contentTopEdging-8;
            self.progressEdging = -self.progressHeight/4;
            break;
        default:
            break;
    }
    
    if (barStyle == TYPagerBarStyleCoverView) {
        self.progressColor = [UIColor lightGrayColor];
    }else {
        self.progressColor = [UIColor redColor];
    }
    self.progressRadius = self.progressHeight/2;
}

#pragma mark - private

- (void)transitionFromCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)toCell{
    
    if (fromCell) {
        fromCell.titleLabel.textColor = self.normalTextColor;
        fromCell.transform = CGAffineTransformMakeScale(self.selectFontScale, self.selectFontScale);
    }
    
    if (toCell) {
        toCell.titleLabel.textColor = self.selectedTextColor;
        toCell.transform = CGAffineTransformIdentity;
    }
}

- (void)transitionFromCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    CGFloat currentTransform = (1.0 - self.selectFontScale)*progress;
    fromCell.transform = CGAffineTransformMakeScale(1.0-currentTransform, 1.0-currentTransform);
    toCell.transform = CGAffineTransformMakeScale(self.selectFontScale+currentTransform, self.selectFontScale+currentTransform);
    
    CGFloat narR,narG,narB,narA;
    [self.normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR,selG,selB,selA;
    [self.selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    fromCell.titleLabel.textColor = [UIColor colorWithRed:selR+detalR*progress green:selG+detalG*progress blue:selB+detalB*progress alpha:selA+detalA*progress];
    toCell.titleLabel.textColor = [UIColor colorWithRed:narR-detalR*progress green:narG-detalG*progress blue:narB-detalB*progress alpha:narA-detalA*progress];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    NSAssert(NO, @"you must impletement method numberOfControllersInPagerController");
    return 0;
}

- (UIViewController *)pagerController:(LBPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSAssert(NO, @"you must impletement method pagerController:controllerForIndex:");
    return nil;
}

#pragma mark - TYTabPagerControllerDelegate

- (void)pagerController:(LBTabPagerController *)pagerController configreCell:(LBTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    LBTabTitleViewCell *titleCell = (LBTabTitleViewCell *)cell;
    titleCell.titleLabel.text = title;
    titleCell.titleLabel.font = self.selectedTextFont;
}

- (void)pagerController:(LBTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)toCell animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self transitionFromCell:(LBTabTitleViewCell *)fromCell toCell:(LBTabTitleViewCell *)toCell];
        }];
    }else{
        [self transitionFromCell:fromCell toCell:toCell];
    }
}

- (void)pagerController:(LBTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<LBTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    [self transitionFromCell:fromCell toCell:toCell progress:progress];
}

@end
