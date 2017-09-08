//
//  JYJCommenItem.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJCommenItem.h"

@implementation JYJCommenItem

+ (instancetype)itemWithIcon:(NSString *)leftIcon title:(NSString *)title subtitle:(NSString *)subtitle rightIcon:(NSString *)rightIcon destVcClass:(Class)destVcClass {
    JYJCommenItem *item = [[self alloc] init];
    item.leftIcon = leftIcon;
    item.title = title;
    item.subtitle = subtitle;
    item.rightIcon =  rightIcon;
    item.destVcClass = destVcClass;
    return item;
}
@end
