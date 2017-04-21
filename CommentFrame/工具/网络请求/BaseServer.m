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
    NSDictionary *dict  = [objc yy_modelToJSONObject];// [DDFactory reverseObjcToDict:objc];
    [self postDict:dict path:path isShowHud:isShowHud isShowSuccessHud:isShowSuccessHud success:success failed:failed];
}

//当遇到字段是系统保留字段(请求数据的对象属性 不能是系统保留字段) 就用这个方法
+ (void)postDict:(NSDictionary *)dict path:(NSString *)path isShowHud:(BOOL)isShowHud isShowSuccessHud:(BOOL)isShowSuccessHud success:(successBlock)success failed:(failedBlock)failed{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];

    MBProgressHUD *hub = [[MBProgressHUD alloc] init];
    if (isShowHud) {
        //hub = [MBProgressHUD showMessage:@"加载中..."];
    }
    __weak typeof (self) weakSelf = self;
    [manager POST:fullPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hub removeFromSuperview];
        if (isShowSuccessHud) {
            dispatch_async(dispatch_get_main_queue(), ^{
               // [MBProgressHUD showSuccess:responseObject[@"msg"]];
            });
            
        }
        //结果处理
        [weakSelf handleResponse:responseObject success:^(id result) {
            SAFE_BLOCK_CALL(success, result);
        } failed:^(NSError *error) {
            if (error.code == 5) {
                [BaseServer relogin];
                return;
            }
              SAFE_BLOCK_CALL(failed, error);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hub removeFromSuperview];
        });
        if (error.domain == NSCocoaErrorDomain) {
            dispatch_async(dispatch_get_main_queue(), ^{
               // [HUD showErrorMessage:[error.userInfo objectForKey:@"NSDebugDescription"] delay:1.2];
                NSLog(@"%@",[error.userInfo objectForKey:@"NSDebugDescription"]);
            });
        } else {
            SAFE_BLOCK_CALL(failed, error);
        }
        
    }];
}

+ (void)uploadImages:(UIImage *)image names:(NSString *)imgName path:(NSString *)path param:(NSDictionary *)paramDict progress:(progressBlock)progress success:(successBlock)success failed:(failedBlock)failed {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:60]; // 10秒超时
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    __weak typeof (self) weakSelf = self;
    [manager POST:fullPath parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        NSString *mimeType = @"image/jpeg";
      
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [formData appendPartWithFileData:imageData name:@"files" fileName:imgName mimeType:mimeType];
    
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
            SAFE_BLOCK_CALL(progress, uploadProgress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //结果处理
        [weakSelf handleResponse:responseObject success:^(id result) {
            SAFE_BLOCK_CALL(success, result);
        } failed:^(NSError *error) {
            if (error.code == 5) {
                [BaseServer relogin];
                return;
            }
            SAFE_BLOCK_CALL(failed, error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SAFE_BLOCK_CALL(failed, error);
    }];
    
}

+ (void)uploadAudio:(NSData *)audioData names:(NSString *)audioName path:(NSString *)path fileName:(NSString *)fileName   param:(NSDictionary *)param progress:(progressBlock)progress success:(successBlock)success failed:(failedBlock)failed{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager.responseSerializer setAcceptableContentTypes:set];
    [manager.requestSerializer setTimeoutInterval:240]; // 10秒超时
    
    NSString *fullPath = [POST_HOST stringByAppendingString:path];
    
    
    [manager POST:fullPath parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
      [formData appendPartWithFileData:audioData name:audioName fileName:fileName mimeType:@""];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        SAFE_BLOCK_CALL(progress, uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //结果处理
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == 5) {
            [BaseServer relogin];
            return;
        }
        SAFE_BLOCK_CALL(failed, error);
    }];
}

+ (void)handleResponse:(id)responseObject success:(successBlock)success failed:(failedBlock)failed {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        //正常
        NSUInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 0) {
            //成功，进入下一步
            SAFE_BLOCK_CALL(success, responseObject);
        } else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [responseObject objectForKey:@"msg"]};
            NSError *error = [NSError errorWithDomain:NSNetServicesErrorDomain code:code userInfo:userInfo];
            SAFE_BLOCK_CALL(failed, error);
        }
    } else {
        //数据异常
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"数据异常"};
        NSError *error = [NSError errorWithDomain:NSNetServicesErrorDomain code:400 userInfo:userInfo];
        SAFE_BLOCK_CALL(failed, error);
    }
}

+(void)relogin{
//    DDAlertActionView *alertView = [DDAlertActionView alertWithTitle:AlertTitleNotLogin Content:AlertContentNotLogin LeftTitle:AlertLeftTitleNotLogin RightTitle:AlertLeftTitleToLogin];
//    alertView.rightBlock = ^(){
//        [User doLogOut];
//    };

}
@end
