      
//
//  DDFactory.m
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "DDFactory.h"
#import <sys/utsname.h>
#include<sys/types.h>

#include<sys/sysctl.h>
@implementation DDFactory

+(instancetype)factory{
    
    static  DDFactory *factory  = nil;
    static dispatch_once_t once;
    if (!factory) {
        dispatch_once(&once, ^{
            factory = [[DDFactory alloc]initPrivate];
         
        });
    }
    return factory;
}


-(instancetype)init{
    //不允许用init方法
    @throw [NSException exceptionWithName:@"Singleton" reason:@"FirstVC is a Singleton, please Use shareView to create" userInfo:nil];
}

-(instancetype)initPrivate{
    //键盘随输入位置上下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification  object:nil];
    return  self = [super init];
}
-(void)keyboardWillShow:(NSNotification *)notify{
    [self removeChannel:UIKeyboardDidShowNotification];
    //获取键盘的高度
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.trendsHeigth = keyboardRect.size.height; //这里是键盘高度
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notify{
    [self removeChannel:UIKeyboardDidHideNotification];
    self.trendsHeigth = 0; //这里是键盘高度
}

+ (NSString *)getString:(NSString *)string withDefault:(NSString *)defaultString{
    
    NSString * temStr;
    if (![string isKindOfClass:[NSString class]]) {
        temStr =  [DDFactory toString:string];
    }else{
        temStr = string;
    }
    if([DDFactory isEmptyWithString:temStr]
       ){
        //为空，返回默认数据
        return defaultString;
    }else{
        //不为空，直接返回数据
        return temStr;
    }
}
+ (NSString *)toString:(id)anyObject{
    return [NSString stringWithFormat:@"%@",anyObject];
}

+(NSArray *)createClassByPlistName:(NSString *)plistName{
    
    NSString *itemVCPath = [[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"];
    
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:itemVCPath];
    
    
    NSMutableArray * arrItemVC = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary  *dict, NSUInteger idx, BOOL *  stop) {
        //每一个视图有类名，标题， 将其放在字典中
        NSMutableDictionary * dictItem = [NSMutableDictionary dictionary];
        
        NSString *className = dict[ClassName];
        Class classControl = NSClassFromString(className);
        UIViewController *basePagerVC = [[classControl alloc]init];
        basePagerVC.title = dict[TitleVC];
        
        //将视图放在字典中
        [dictItem setObject:basePagerVC forKey:ClassName];
        
        //将标题放在字典中
        [dictItem setObject:dict[TitleVC] forKey:TitleVC];
        
        //将图片放在字典中
        if ([[dict allKeys]containsObject:Image]) {
            
            [dictItem setObject:dict[Image] forKey:Image];
            
        }
        //将图片放在字典中
        if ([[dict allKeys]containsObject:SelectImage]) {
            
            [dictItem setObject:dict[SelectImage] forKey:SelectImage];
            
        }
        //将附加信息放在字典中
        if ([[dict allKeys]containsObject:AttachInfo]) {
            
            [dictItem setObject:dict[AttachInfo] forKey:AttachInfo];
            
        }
        [arrItemVC addObject:dictItem];
    }];
    return  [arrItemVC copy];
}

#pragma mark - 发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel {
    
    if(_observerData == nil) {
        _observerData = [[NSMutableDictionary alloc]init];
    }
    
    if(data != nil) {
        [_observerData setObject: data forKey:channel];
    }
    else {
        [_observerData removeObjectForKey:channel];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:channel object:data];
}

#pragma mark - 安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:channel object:nil];
    if(_observerData != nil) {
        id data = [_observerData objectForKey:channel];
        if(data != nil) {
            NSNotification *notification = [[NSNotification alloc] initWithName:channel object:data userInfo:nil];
            [observer performSelector:aSelector withObject: notification];
        }
    }
}

+ (id)getViewControllerWithId:(NSString *)Id storyboardName:(NSString *)name {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:Id];
    return VC;
}
+(id)getXibObjc:(NSString *)xibName{
    
    return [[NSBundle mainBundle]loadNibNamed:xibName owner:nil options:nil][0];
}
#pragma mark - 移除收音机
- (void) removeObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - 移除接收频道
- (void)removeChannel:(NSString *)channel{
    if (_observerData!= nil)
        [_observerData removeObjectForKey:channel];
}

// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(NSURL *)getImgUrl:(NSString *)imgStr{
    if ([imgStr isKindOfClass:[NSURL class]]) {
        NSURL *imgUrl = (NSURL *)imgStr;
        imgStr = imgUrl.absoluteString;
        if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
            return [NSURL URLWithString:[POST_HOST_image stringByAppendingString:imgStr]];
        }
        
        return [NSURL URLWithString:imgStr];
    }
    
    if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
        return [NSURL URLWithString:[POST_HOST_image stringByAppendingString:imgStr]];
    }
    
    return [NSURL URLWithString:imgStr] ;
}



//高度不变获取宽度
+(CGFloat)autoWidthWithLabel:(UILabel *)label{
    if (label == nil ) {
        return  0;
    }
    CGRect rect=  [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
    return rect.size.width;
}

+(CGFloat)autoHeightWithLabel:(UILabel *)label{
    if (label ==nil ) {
        return  0;
    }
    CGRect rect=  [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width,MAXFLOAT) options: NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:label.font} context:nil];
    return rect.size.height;
}

//高度不变获取宽度
+(CGFloat)autoWByText:(NSString *)text Font:(CGFloat)font H:(CGFloat)H{
    if (text.length == 0  ) {
        return  0;
    }
    CGRect rect=  [text boundingRectWithSize:CGSizeMake(MAXFLOAT, H) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}

+(CGFloat)autoHByText:(NSString *)text Font:(CGFloat)font W:(CGFloat)W{
    if (text.length == 0  )  {
        return  0;
    }
    CGRect rect=  [text boundingRectWithSize:CGSizeMake(W,MAXFLOAT) options: NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

//时间字符串转换为时间
+(NSDate *)strTimeToTime:(NSString *)strTime{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //将时间戳转换为时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:zone];
    return [formatter dateFromString:strTime]; //------------将字符串按formatter转成nsdate
}


+(void)circleImageView:(UIImageView *)imageView{
    
    CGSize size = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    
    //创建视图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制按钮头像范围
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat iconX = imageView.frame.origin.x;
    CGFloat iconY = imageView.frame.origin.y;
    CGFloat iconW = imageView.frame.size.width;
    CGFloat iconH = imageView.frame.size.height;
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [imageView.image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    imageView.image =  UIGraphicsGetImageFromCurrentImageContext();

}

//挑整图片大小
+(UIImage *)resetImgFrame:(CGRect)frame Img:(UIImage *)img{
    CGSize size = CGSizeMake(frame.size.width,frame.size.height);
    
    //创建视图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制按钮头像范围
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat iconX = frame.origin.x;
    CGFloat iconY = frame.origin.y;
    CGFloat iconW = frame.size.width;
    CGFloat iconH = frame.size.height;
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [img drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    img =  UIGraphicsGetImageFromCurrentImageContext();
    return img;
}



//检查密码强度
+(void)examineSecurity:(NSRange)range String:(NSString *)string{
    if (range.location > 6) {
        //密码较弱
    }
    else if (range.location>9){
        //中等强度
    }
    else if(range.location>12){
        //密码较强
    }
    else{
        //密码长度太长 请牢记密码
    }
}

//将对象的属性和值对应起来， 作为字典的格式
+(NSDictionary*)reverseObjcToDict:(id)obj{
    
    NSMutableDictionary
    *dic = [NSMutableDictionary dictionary];
    
    unsigned
    int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++){
        
        objc_property_t prop = props[i];
        
        NSString  *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [obj valueForKey:propName];
        
        if(value == nil) {
            value = [NSNull null];
        }
        
        else {
            value = [DDFactory getObjectInternal:value];
        }
        
        if (value!= [NSNull null]) {
            //如果value 不为空 才存到字典中
            [dic setObject:value forKey:propName];
        }
    }
    if (dic!=nil) {
        return dic;
    }
    return nil;
}

+(id)getObjectInternal:(id)obj{
    
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]){
        
        return obj;
    }
    
    if([obj  isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        
        NSMutableArray  *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int  i = 0;i < objarr.count; i++) {
            
            [arr setObject:[DDFactory getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if([obj  isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary  *objdic = obj;
        
        NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys){
            [dic  setObject:[DDFactory getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return  dic;
    }
    
    return [DDFactory reverseObjcToDict:obj];
}

+(UIViewController *)appRootViewController{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = appRootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}

+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+(NSString *)timeFormatted:(NSInteger)totalSeconds{
    
    NSInteger seconds = totalSeconds % 60;
    
    NSInteger minutes = (totalSeconds / 60) % 60;
    
    NSInteger hours = totalSeconds / 3600;
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds];
    return time;
}

+(void)checkNetWorkingState{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue       = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"有网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"无网络");
                break;
        }
    }];
    // 开始监听
    [manager.reachabilityManager startMonitoring];
}

+ (NSString*)getCurrentDeviceModel{
    
    int mib[2];
    
    size_t len;
    
    char*machine;
    
    mib[0] =CTL_HW;
    
    mib[1] =HW_MACHINE;
    
    sysctl(mib,2,NULL, &len,NULL,0);
    
    machine =malloc(len);
    
    sysctl(mib,2, machine, &len,NULL,0);
    
    NSString*platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    free(machine);
    
    if([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G (A1203)";
    
    if([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G (A1241/A1324)";
    
    if([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS (A1303/A1325)";
    
    if([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4 (A1332)";
    
    if([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4 (A1332)";
    
    if([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4 (A1349)";
    
    if([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S (A1387/A1431)";
    
    if([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5 (A1428)";
    
    if([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5 (A1429/A1442)";
    
    if([platform isEqualToString:@"iPhone5,3"])return@"iPhone 5c (A1456/A1532)";
    
    if([platform isEqualToString:@"iPhone5,4"])return@"iPhone 5c (A1507/A1516/A1526/A1529)";
    
    if([platform isEqualToString:@"iPhone6,1"])return@"iPhone 5s (A1453/A1533)";
    
    if([platform isEqualToString:@"iPhone6,2"])return@"iPhone 5s (A1457/A1518/A1528/A1530)";
    
    if([platform isEqualToString:@"iPhone7,1"])return@"iPhone 6 Plus (A1522/A1524)";
    
    if([platform isEqualToString:@"iPhone7,2"])return@"iPhone 6 (A1549/A1586)";
    
    if([platform isEqualToString:@"iPod1,1"])return@"iPod Touch 1G (A1213)";
    
    if([platform isEqualToString:@"iPod2,1"])return@"iPod Touch 2G (A1288)";
    
    if([platform isEqualToString:@"iPod3,1"])return@"iPod Touch 3G (A1318)";
    
    if([platform isEqualToString:@"iPod4,1"])return@"iPod Touch 4G (A1367)";
    
    if([platform isEqualToString:@"iPod5,1"])return@"iPod Touch 5G (A1421/A1509)";
    
    if([platform isEqualToString:@"iPad1,1"])return@"iPad 1G (A1219/A1337)";
    
    if([platform isEqualToString:@"iPad2,1"])return@"iPad 2 (A1395)";
    
    if([platform isEqualToString:@"iPad2,2"])return@"iPad 2 (A1396)";
    
    if([platform isEqualToString:@"iPad2,3"])return@"iPad 2 (A1397)";
    
    if([platform isEqualToString:@"iPad2,4"])return@"iPad 2 (A1395+New Chip)";
    
    if([platform isEqualToString:@"iPad2,5"])return@"iPad Mini 1G (A1432)";
    
    if([platform isEqualToString:@"iPad2,6"])return@"iPad Mini 1G (A1454)";
    
    if([platform isEqualToString:@"iPad2,7"])return@"iPad Mini 1G (A1455)";
    
    if([platform isEqualToString:@"iPad3,1"])return@"iPad 3 (A1416)";
    
    if([platform isEqualToString:@"iPad3,2"])return@"iPad 3 (A1403)";
    
    if([platform isEqualToString:@"iPad3,3"])return@"iPad 3 (A1430)";
    
    if([platform isEqualToString:@"iPad3,4"])return@"iPad 4 (A1458)";
    
    if([platform isEqualToString:@"iPad3,5"])return@"iPad 4 (A1459)";
    
    if([platform isEqualToString:@"iPad3,6"])return@"iPad 4 (A1460)";
    
    if([platform isEqualToString:@"iPad4,1"])return@"iPad Air (A1474)";
    
    if([platform isEqualToString:@"iPad4,2"])return@"iPad Air (A1475)";
    
    if([platform isEqualToString:@"iPad4,3"])return@"iPad Air (A1476)";
    
    if([platform isEqualToString:@"iPad4,4"])return@"iPad Mini 2G (A1489)";
    
    if([platform isEqualToString:@"iPad4,5"])return@"iPad Mini 2G (A1490)";
    
    if([platform isEqualToString:@"iPad4,6"])return@"iPad Mini 2G (A1491)";
    
    if([platform isEqualToString:@"i386"])return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])return@"iPhone Simulator";
    
    return platform;
    
}


@end

