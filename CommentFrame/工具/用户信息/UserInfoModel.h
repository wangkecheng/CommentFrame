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
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *tou_url;
@property (nonatomic, copy) NSString *live_titla; // 用户昵称
@property (nonatomic, copy) NSString *guan_total;
@property (nonatomic, copy) NSString *silk_totla;
@property (nonatomic, copy) NSString *carport_total;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *long_time;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *live_pic;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *nickame;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *adress;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *zanTing;
@property (nonatomic, copy) NSString *suoDing;
@property (strong, nonatomic)NSString *message;
@property (strong, nonatomic)NSString *QRImageUrl;
@property (strong, nonatomic)NSString *constellation;
@property (strong, nonatomic)NSString *constellation_msg;
@property (strong, nonatomic)NSString *number;
@property (strong, nonatomic)NSString *msgLingDangNum;



@end
