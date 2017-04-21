//
//  UITableView+LOExtension.h
//
//  Created by 唐万龙 on 2016/9/13.
//  Copyright © 2016年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LOExtension)


/**
 隐藏多余的分割线
 */
- (void)hideSurplusLine;

//设置下滑线起始X坐标    ";
-(void)setSepareteX:(CGFloat)X;
@end
