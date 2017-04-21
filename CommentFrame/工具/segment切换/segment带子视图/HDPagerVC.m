//
//  SOPagerViewController.m
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//

#import "HDPagerVC.h"
#import "LBTabPagerController.h"

@interface HDPagerVC ()<GetPagerCountDelegate>
@property(nonatomic,strong)NSArray *arrPagerVC;
@property(nonatomic,strong)HDPagerVC *pagerVC;
@end

@implementation HDPagerVC

-(id)initWithPlistName:(NSString *)plistName{
    if (self  = [super init]) {
        
      self.arrPagerVC = [DDFactory createClassByPlistName:plistName];
    }
    return self;
}
-(NSArray *)arrPagerVC{
    if (!_arrPagerVC) {
        _arrPagerVC = [[NSMutableArray alloc]init];
    }
    return _arrPagerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adjustStatusBarHeight = YES;
    self.cellSpacing = 0;
    [self setBarStyle:TYPagerBarStyleProgressView];   
    self.pagerCountDelegate = self;
    
}
-(void)setPagerCountDelegate:(id<GetPagerCountDelegate>)pagerCountDelegate{
    [super setPagerCountDelegate:pagerCountDelegate];
}

- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    [super setBarStyle:barStyle];
    
    switch (barStyle) {
        case TYPagerBarStyleProgressView:
            self.progressWidth = 48;//设置下划线宽度
            self.progressHeight = kUnderLineViewHeight;
            self.progressEdging = 0;
            break;
            
        case TYPagerBarStyleProgressBounceView:
            self.progressHeight = kUnderLineViewHeight;
            self.progressWidth = [UIScreen mainScreen].bounds.size.width/self.arrPagerVC.count;
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
- (NSInteger)numberOfControllersInPagerController{
    
    return self.arrPagerVC.count;
}
- (NSString *)pagerController:(LBPagerController *)pagerController titleForIndex:(NSInteger)index{
    return  self.arrPagerVC[index][@"title"];
}

- (UIViewController *)pagerController:(LBPagerController *)pagerController controllerForIndex:(NSInteger)index{
    return self.arrPagerVC[index][@"className"];
}
- (void)pagerController:(LBTabPagerController *)pagerController configreCell:(LBTabTitleViewCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath{
    
    [super pagerController:pagerController configreCell:cell forItemTitle:title atIndexPath:indexPath];
    // configure cell
}

- (void)pagerController:(LBTabPagerController *)pagerController didSelectAtIndexPath:(NSIndexPath *)indexPath{
    if (_pageDelegate&& [_pageDelegate respondsToSelector:@selector(pagerSelect:)]) {
        [_pageDelegate pagerSelect:indexPath.row];
    }
   
    NSLog(@"didSelectAtIndexPath %@",indexPath);
}

//返回共有多少个pager选项
-(NSInteger)getPagerCount{
    
    return self.arrPagerVC.count;
}
@end
