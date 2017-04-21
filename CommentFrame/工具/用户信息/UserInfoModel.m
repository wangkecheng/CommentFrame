//
//  UserInfoModel.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(instancetype)init{
    UserInfoModel *  infoModel = [UserInfoModel share];
    return infoModel;
}
-(instancetype)initPrivate{
    //用父类方法初始化
    if (self = [super init]) {
        
    }
    return self;
}

+(instancetype)share{
    static  UserInfoModel * infoModel = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        //GCD方式创建单列
        if (!infoModel?YES:NO) {
            infoModel = [[UserInfoModel alloc]initPrivate];
             infoModel.isMember = NO;
        }
    });
    return infoModel;
}
-(void)setDataWithDict:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
}

@end
