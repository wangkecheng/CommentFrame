//
//  CacheTool.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/7.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "CacheTool.h"
#import "YYModel.h"

static NSString *loginInfoKey = @"userInfo";
static NSString *loginInfoArchiver = @"UserInfo.archive";
static NSString *loginInfoKeylushu = @"userInfolushu";
static NSString *loginInfoArchiverlushu = @"UserInfo.archivelushu";
@implementation CacheTool

+ (void)cacheUserInfo:(UserInfoModel *)userInfoModel {
    //先转换为JSON
    NSString *userInfoString = [userInfoModel yy_modelToJSONString];
    [self cacheObj:userInfoString WithKey:loginInfoKey AndArchiver:loginInfoArchiver];
}

+ (UserInfoModel *)getCachedUserInfo {
    NSString *userInfoString = [self getCacheWithKey:loginInfoKey AndArchiver:loginInfoArchiver];
    NSDictionary *dict = [self dictionaryWithJsonString:userInfoString];
    UserInfoModel *userInfoModel = [UserInfoModel share];
    [userInfoModel setDataWithDict:dict];
    return  userInfoModel;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 清除登录信息，注销时使用
 */
+ (void)removeUserInfo {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getArchiverPathWith:loginInfoArchiver];
    [manager removeItemAtPath:path error:nil];
}
+ (void)removeUserRoadbook{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getArchiverPathWith:loginInfoArchiverlushu];
    [manager removeItemAtPath:path error:nil];
}

//======================== 归档基础方法 ===========================
+ (void)cacheObj:(id)obj WithKey:(NSString *)key AndArchiver:(NSString *)archiverString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化
        NSMutableData *archiverData = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
        //编码
        [archiver encodeObject:obj forKey:key];
        [archiver finishEncoding];
        //归档
        [archiverData writeToFile:[self getArchiverPathWith:archiverString] atomically:YES];
    });
    
}

+ (id)getCacheWithKey:(NSString *)key AndArchiver:(NSString *)archiverString {
    
    //读取
    NSData *cacheData = [NSData dataWithContentsOfFile:[self getArchiverPathWith:archiverString]];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:cacheData];
    //解码
    id archiverObj = [unArchiver decodeObjectForKey:key];
    [unArchiver finishDecoding];
    
    return archiverObj;
}

//======================== 归档路径 ==============================
+ (NSString *)getArchiverPathWith:(NSString *)extention {
    NSString *docPath = [self getCachePath];
    NSString *archiverPath = [docPath stringByAppendingPathComponent:extention];
    return archiverPath;
}




+ (BOOL)isFirstTimeLaunch {
    NSString *key = @"firstLaunch";
    NSString *tag = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!tag) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:key];
        return YES;
    } else {
        return NO;
    }
}

+ (void)doLogOut {
    //清除用户信息
    [CacheTool removeUserInfo];
    UserInfoModel * userInfoModel = [CacheTool getCachedUserInfo];
    userInfoModel.isMember = NO;
    userInfoModel.token = nil;
    userInfoModel.uid = nil;
    userInfoModel.kid = nil;
    [CacheTool cacheUserInfo:userInfoModel];
    //    //取消极光推送别名 推送
    //    [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    //        NSLog(@"wecode %d-------------%@,-------------%@",iResCode,iTags,iAlias);
    //    }];
    //清除缓存
    [self clearCacheCompele:^(BOOL isFinish) {
        //清除完成，回到登录界面
        UIWindow *window = CurrentAppDelegate.window;
        if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)window.rootViewController;
//            if (![nav.visibleViewController isKindOfClass:[HDLoginVC class]]) {
//                //不在登录界面
//                [self presentToLogin];
//            }
            
        } else {
            [self presentToLogin];
        }
    }];
}
+ (void)presentToLogin {
    UIWindow *window = CurrentAppDelegate.window;
    //    HDLoginVC *VC  = [[HDLoginVC alloc]init];
    //    HDMainNavC *navc = [[HDMainNavC alloc]initWithRootViewController:VC];
    //    [window.rootViewController presentViewController:navc animated:YES completion:^{
    //        [CurrentAppDelegate.window setRootViewController:navc];
    //    }];
}

/**
 清理缓存
 
 @param finish 完成回调
 */
+ (void)clearCacheCompele:(finishBlock)finish {
    NSString *cachePath = [self getCachePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dispatch_queue_t ioQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(ioQueue, ^{
        if ([fileManager fileExistsAtPath:cachePath]) {
            NSArray *fileNames = [fileManager subpathsAtPath:cachePath];
            for (NSString *fileName in fileNames) {
                NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
        
        [[SDImageCache sharedImageCache] cleanDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SAFE_BLOCK_CALL(finish, YES);
        });
        
    });
    
}

/**
 *  获取缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString *)getCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

//设置根视图
+ (void)setRootController:(UIViewController *)controller {
    UIWindow *window = CurrentAppDelegate.window;
    [window setRootViewController:controller];
}


@end
