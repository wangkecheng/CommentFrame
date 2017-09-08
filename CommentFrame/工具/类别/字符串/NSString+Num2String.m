//
//  NSString+Num2String.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/10/30.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "NSString+Num2String.h"

@implementation NSString (Num2String)

+ (NSString *)stringFromDouble:(double)num {
    return [NSString stringWithFormat:@"%0.2f",num];
}

+ (NSString *)stringFromNum:(NSInteger)num {
    return [NSString stringWithFormat:@"%ld",num];
}

+ (NSString *)stringKeyFromIndexPath:(NSIndexPath *)indexPath {
    NSString *section = [self stringFromNum:indexPath.section];
    NSString *row = [self stringFromNum:indexPath.row];
    return [NSString stringWithFormat:@"%@-%@",section,row];
}

@end
