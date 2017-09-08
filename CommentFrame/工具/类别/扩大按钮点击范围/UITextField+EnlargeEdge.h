//
//  UIView+EnlargeEdge.h
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/12/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField(EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
