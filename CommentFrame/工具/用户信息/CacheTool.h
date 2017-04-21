//
//  CacheTool.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/7.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
typedef void (^finishBlock)(BOOL isFinish);
#define SAFE_BLOCK_CALL(b, p) (b == nil ? : b(p) )
@interface CacheTool : NSObject
#pragma mark - loginInfo
/**
 是否为第一次启动
 
 @return BOOL
 */
+ (BOOL)isFirstTimeLaunch;

/**
 缓存登录信息
 @param userInfoModel 用户信息模型
 */
+ (void)cacheUserInfo:(UserInfoModel *)userInfoModel;

/**
 获取缓存的登录信息

 @return 登录信息
 */
+ (UserInfoModel *)getCachedUserInfo;


/**
 注销操作
 */
+ (void)doLogOut;
@end
