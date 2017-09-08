//
//  BaseServer.m
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/7.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.



#import "BaseServer.h"
@interface BaseServer()
@end

@implementation BaseServer

//一般的请求数据只能传对象
+ (void)postObjc:(id)objc path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud success:(successBlock)success failed:(failedBlock)failed{
    
    NSDictionary *dict  = [objc yy_modelToJSONObject];
    [self postDict:dict path:path isShowHud:isShowHud isShowSuccessHud:isShowSuccessHud isShowFieldHud:YES  success:success failed:failed];
}

//当遇到字段是系统保留字段(请求数据的对象属性 不能是系统保留字段) 就用这个方法
+ (void)postDict:(NSDictionary *)dict path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud isShowFieldHud:(BOOL)isShowFieldHud success:(successBlock)success failed:(failedBlock)failed{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    
    [manager.requestSerializer setTimeoutInterval:10.0]; // 10秒超时
   
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    
    //    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    if (isShowHud){
        //      hub = [MBProgressHUD showMessage:@""];
        [CurrentAppDelegate.window makeToast:@"努力加载中..." duration:0.8 ];
    }
    [manager POST:fullPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isShowSuccessHud) {
            [CurrentAppDelegate.window  makeToast:responseObject[@"msg"] duration:2 position:@"CSToastPositionCenter"];
        }
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *dict = [DDFactory reverseDict:responseObject];
            SAFE_BLOCK_CALL(success, dict);
            return ;
        }
        else if([responseObject[@"code"] integerValue] == 300){//失败
            if (isShowFieldHud) {//默认的isShowNotFieldHud是NO, 传YES表示不显示
                NSString *msg = responseObject[@"msg"];
                if (msg.length >0 )
                    [CurrentAppDelegate.window  makeToast:msg];
            }
            
            NSError *error = [NSError errorWithDomain:@"出错了"
                                                 code:01
                                             userInfo:responseObject];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *msg = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];
        if (msg.length >0 ){
            [CurrentAppDelegate.window makeToast:msg];
        }
        SAFE_BLOCK_CALL(failed, error);
    }];
}


+ (void)uploadImages:(UIImage *)image path:(NSString *)path param:(id )obj  isShowHud:(BOOL)isShowHud success:(successBlock)success failed:(failedBlock)failed {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"multipart/form-data",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:10.0]; // 10秒超时
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    NSDictionary *paramDict  = [DDFactory reverseObjcToDict:obj];
    
    if (isShowHud) {
        [CurrentAppDelegate.window makeToast:@"上传图片中..."  duration:0.8 ];
    }
    [manager POST:fullPath parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        NSData *imageData =  [DDFactory resetSizeOfImageData:image maxSize:500000];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"yhsy.jpeg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //结果处理
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *msg = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];
        [CurrentAppDelegate.window.rootViewController.view makeToast:msg];
        
        SAFE_BLOCK_CALL(failed, error);
    }];
}

+ (void)uploadAudio:(NSData *)audioData names:(NSString *)audioName path:(NSString *)path fileName:(NSString *)fileName   param:(NSDictionary *)param progress:(progressBlock)progress success:(successBlock)success failed:(failedBlock)failed{
    if (![self isMember]) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:240]; // 10秒超时
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    
    weakObj;
    [CurrentAppDelegate.window makeToast:@"数据上传中..."  duration:0.8 ];
    [manager POST:fullPath parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        [formData appendPartWithFileData:audioData name:audioName fileName:fileName mimeType:@""];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //结果处理
        SAFE_BLOCK_CALL(success, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SAFE_BLOCK_CALL(failed, error);
    }];
}

+(BOOL)isMember{
    UserInfoModel *userInfoModel = [CacheTool getCachedUserInfo];
    if (!userInfoModel.isMember) {
        [CurrentAppDelegate.window makeToast:@"您尚未登陆,暂无法查看信息,请登录..."];
    }
    return userInfoModel.isMember;
}

+(void)relogin{
    
}
@end
