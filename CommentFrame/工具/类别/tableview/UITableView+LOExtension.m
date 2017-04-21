//
//  UITableView+LOExtension.m
//
//  Created by 唐万龙 on 2016/9/13.
//  Copyright © 2016年  All rights reserved.
//

#import "UITableView+LOExtension.h"

@implementation UITableView (LOExtension)


- (void)hideSurplusLine {
    //去除多余分割线
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:footerView];
}
-(void)setSepareteX:(CGFloat)X{
    
   [self setSeparatorInset:UIEdgeInsetsMake(0, X, 0, 0)];
}
@end
