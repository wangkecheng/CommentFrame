//
//  YYKJMainTVC.m
//  DieKnight
//
//  Created by WangZhen on 2017/1/17.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import "HDMainTBC.h"
#import "HDMainNavC.h"
@interface HDMainTBC ()

@end

@implementation HDMainTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarBackColor];
    
    [self addTabBarItems];
   
}

// 设置TabBar背景颜色
-(void)setTabBarBackColor{
    UIView *view = [[UIView alloc]init];
    view.frame = self.tabBar.bounds;
    view.backgroundColor = UIColorFromHX(0x222222);
    [self.tabBar insertSubview:view atIndex:0];
    self.tabBar.opaque = YES;
    // 设置tabbar渲染颜色
    [UITabBar appearance].tintColor = UIColorFromHX(0xf78707);
    self.tabBar.translucent = NO;
}
//添加TabBar控制器的所有子控制器
-(void)addTabBarItems{
        for (NSDictionary *dict in [DDFactory createClassByPlistName:@"TabarVCS"]) {
        UIViewController *VC = dict[ClassName];
        HDMainNavC *navc = [[HDMainNavC alloc]initWithRootViewController:VC];
        navc.tabBarItem.image = IMG(dict[Image]);
        navc.tabBarItem.selectedImage =IMG( dict[SelectImage]);
        navc.tabBarItem.title = dict[TitleVC];
        [self addChildViewController:navc];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
