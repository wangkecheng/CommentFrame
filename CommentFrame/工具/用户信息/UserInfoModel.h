//
//  UserInfoModel.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

+(instancetype)share;

-(void)setDataWithDict:(NSDictionary *)dict;

@property (nonatomic,assign)BOOL isMember;

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString *companyaddress;
@property (nonatomic, copy) NSString *creattime;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *homeaddress;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *inviteid;
@property (nonatomic, copy) NSString *isfirst;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *paypwd;
@property (nonatomic, copy) NSString *state;//状态，0-正常，1-锁定，2-冻结，3-禁止登录
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *token;
@property (nonatomic,strong)NSString *homecoords;
@property (nonatomic,strong)NSString *companycoords;
@property (nonatomic,strong)NSString *passengerid;
@property (nonatomic,strong)NSString *isUnit;//是否是单位 自己建的
@property (nonatomic,strong)NSString *deviceid;
@property (nonatomic,strong)NSString *firstcalltime;
@property (nonatomic,strong)NSString *takecashpwd;
@end
