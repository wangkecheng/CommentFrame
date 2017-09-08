//
//  UserInfoModel.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+(instancetype)share{
    UserInfoModel * infoModel = [[UserInfoModel alloc]init];
    infoModel.isMember = NO;
    return infoModel;
}
-(void)setDataWithDict:(NSDictionary *)dict{
    if (dict == nil || [dict isKindOfClass:[NSNull class]]) {
        return;
    }
    [self setValuesForKeysWithDictionary:dict];
}

@end
