//
//  NSString+Num2String.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/10/30.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Num2String)

+ (NSString *)stringFromDouble:(double)num;

+ (NSString *)stringFromNum:(NSNumber *)num;

+ (NSString *)stringFromInt:(NSInteger )num;

/**
 获取缓存Cell使用的key

 @param indexPath indexPath
 @return key
 */
+ (NSString *)stringKeyFromIndexPath:(NSIndexPath *)indexPath;

@end
