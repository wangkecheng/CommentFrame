//
//  DDFactory.h
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFactory : NSObject

@property (nonatomic,strong)NSString *pardiseType;//用于直播 文章 轨迹 的点赞类型  1:直播，2：轨迹，3.轨迹

@property (nonatomic,assign)BOOL isNotShowHud;

@property (nonatomic,strong)NSMutableDictionary *observerData; //广播的数据

+(instancetype)factory;

//更随键盘弹出动态改变弹框的高度
@property (nonatomic,assign)CGFloat trendsHeigth;


//发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel;

//安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel;

//移除收音机
- (void) removeObserver:(id)observer;

- (void) removeChannel:(NSString *)channel;

#pragma mark - 制作圆形图片
+(void)circleImageView:(UIImageView *)imageView;

#pragma mark - 设置label
#pragma mark - 高度不变获取宽度
+(CGFloat)autoWidthWithLabel:(UILabel *)label;

+(CGFloat)autoHeightWithLabel:(UILabel *)label;

+(CGFloat)autoWByText:(NSString *)text Font:(CGFloat)font H:(CGFloat)H;

+(CGFloat)autoHByText:(NSString *)text Font:(CGFloat)font W:(CGFloat)W;

//检查密码强度
+(void)examineSecurity:(NSRange)range String:(NSString *)string;

// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color;
//挑战图片大小
+(UIImage *)resetImgFrame:(CGRect)frame Img:(UIImage *)img;

+(NSArray *)createClassByPlistName:(NSString *)plistName;

//将对象的属性和值对应起来， 作为字典的格式
+(NSDictionary*)reverseObjcToDict:(id)obj;

/**
 通过Storyboard名及其ID获取控制器
 @param Id 控制器id
 @param name Storyboard名
 @return 控制器
 */
+ (id)getViewControllerWithId:(NSString *)Id storyboardName:(NSString *)name;
//通过xib文件 初始化对象
+(id)getXibObjc:(NSString *)xibName;

/**
 *  用于规避网络请求的字符串，并在为空的时候用一个可以设置的默认值来代替，避免程序因此崩溃
 *  并且，在做这步操作的同时，去除字符串中可能出现的不必要的空格，火车或者换行符的问题
 */
+ (NSString *)getString:(NSString *)string withDefault:(NSString *)defaultString;

+ (BOOL)isEmptyWithString:(NSString *)string;

//快速获得图片url
+(NSURL *)getImgUrl:(NSString *)imgStr;

//获取根视图
+(UIViewController *)appRootViewController;

//通过图片地址获取图片大小
+(CGSize)getImageSizeWithURL:(id)imageURL;

//通过秒获取 时分秒
+(NSString *)timeFormatted:(NSInteger)totalSeconds;

+(void)checkNetWorkingState;

//判断设备型号
+ (NSString*)getCurrentDeviceModel;
@end

