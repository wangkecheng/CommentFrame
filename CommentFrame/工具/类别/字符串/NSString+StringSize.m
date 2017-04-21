//
//  NSString+StringSize.m
//  fadein
//
//  Created by WangYaochang on 16/3/17.
//  Copyright © 2016年 Maverick. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}


- (CGSize)textSizeWithSystemFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size {
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}


- (CGSize)textSizeWithFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size lineSpace:(CGFloat)space {
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    //设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space]; //设置行距
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    
    
    CGRect rect = [self boundingRectWithSize:size
                                     options:option
                                  attributes:attributes
                                     context:nil];
    
    return rect.size;
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineSpace:(CGFloat)space {
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    //设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space]; //设置行距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    
    
    CGRect rect = [self boundingRectWithSize:size
                                     options:option
                                  attributes:attributes
                                     context:nil];
    
    return rect.size;
}

+ (NSDictionary *)attributesWith:(UIFont *)font lineSpace:(CGFloat)space {
    //设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space]; //设置行距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    return attributes;
}

+ (NSDictionary *)attributesWithFontSize:(CGFloat)fontSize lineSpace:(CGFloat)space {
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space]; //设置行距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    return attributes;
}

@end
