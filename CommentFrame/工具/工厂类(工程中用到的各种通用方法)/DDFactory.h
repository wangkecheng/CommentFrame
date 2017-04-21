//
//  DDFactory.h
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,WhichVCPresentLoginVC) {
    TypeBenefitVC = 100,
    TypeMyBenefitVC,
    TypeMySelf,
    TypePaperPlane,
    TypeNaQuProductDetail,//直接进入或者拿去
    TypeExchangeProdcutDetail,
    TypeCateProductDetail,//直接进入到分类中
    TypeActivity,
    TypeNearBy,
    TypePublish,
    TypeTopic
};
 
@interface DDFactory : NSObject

@property (nonatomic,strong)NSString *pardiseType;//用于直播 文章 轨迹 的点赞类型  1:直播，2：轨迹，3.轨迹

@property (nonatomic,assign)BOOL isNotShowHud;

@property (nonatomic,strong)NSMutableDictionary *observerData; //广播的数据

+(instancetype)factory;


//更随键盘弹出动态改变弹框的高度
@property (nonatomic,assign)CGFloat trendsHeigth;
@property (nonatomic,assign)WhichVCPresentLoginVC loginType;
@property (nonatomic,strong)NSString *product_id;

//发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel;

//安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel;

//移除收音机
- (void) removeObserver:(id)observer;

- (void) removeChannel:(NSString *)channel;

#pragma mark - //标准化时间
+(NSString *)makeTimeFormat:(NSString *)dateStr;

//计算多久之前
+(NSString *)makeTimeBefore:(NSString *)dateStr;
#pragma mark - 制作圆形图片
+(void)circleImageView:(UIImageView *)imageView;

//解决时间数为 个位的情况
+(NSString *)addZero:(NSInteger)time;
+ (NSString *)toString:(id)anyObject;
#pragma mark - 16进制颜色转换成RGB
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
#pragma mark -  颜色转换为背景图片
+(UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - 设置label
#pragma mark - 高度不变获取宽度
+(CGFloat)autoWidthWithLabel:(UILabel *)label;

+(CGFloat)autoHeightWithLabel:(UILabel *)label;

+(CGFloat)autoWByText:(NSString *)text Font:(CGFloat)font H:(CGFloat)H;

+(CGFloat)autoHByText:(NSString *)text Font:(CGFloat)font W:(CGFloat)W;

//通过xib文件 初始化对象
+(id)getXibObjc:(NSString *)xibName;

#pragma mark - 直接设置按钮颜色
+(void)setBtn:(UIButton *)btn;
#pragma mark - 直接设置按钮不可用
+(void)setBtnGray:(UIButton *)btn;
#pragma mark - 直接设置按钮边角
+(void)setBtnRadius:(UIButton *)btn;
#pragma mark - 直接设置按钮正常和点击
+(void)setBtnBackColor:(UIButton *)btn;
#pragma mark - 分条设置按钮颜色
+(void)setBtn:(UIButton *)btn Radius:(NSInteger)radius NColor:(NSString *)NColor HColor:(NSString *)HColor;
// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color;
//挑战图片大小
+(UIImage *)resetImgFrame:(CGRect)frame Img:(UIImage *)img;
//判断是否是纯字母
+ (BOOL)isPureCharacters:(NSString *)string;
//判断是否是纯数字
+ (BOOL)isPureNum:(NSString *)string;
//判断是否是纯数字 纯字母
+ (BOOL)isNumOrCharater:(NSString *)string;

+ (BOOL) isPrice:(NSString *) price;
#pragma mark 判断身份证号是否合法
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
#pragma mark 判断银行卡号是否合法
+(BOOL)isBankCard:(NSString *)cardNumber;


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

//SDLayout 获取控件动态高度
+(CGFloat)tableview:(UITableView *)tableView heigth:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath fixedH:(CGFloat)fixedH class:(NSString *)className;

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
@end

