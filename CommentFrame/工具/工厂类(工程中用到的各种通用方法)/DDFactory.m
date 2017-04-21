      
//
//  DDFactory.m
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "DDFactory.h"
#import <sys/utsname.h>
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



/*
 *功能说明：
 *    判断字符串为空
 *参数说明：
 *string : 需要判断的字符串
 */
+ (BOOL)isEmptyWithString:(NSString *)string{
    NSString * temStr;
    if (![string isKindOfClass:[NSString class]]) {
        temStr =  [DDFactory toString:string];
    }else{
        temStr = string;
    }
    return ((temStr == nil)
            ||([temStr isEqual:[NSNull null]])
            ||([temStr isEqualToString:@"<null>"])
            ||([temStr isEqualToString:@"(null)"])
            ||([temStr isEqualToString:@" "])
            ||([temStr isEqualToString:@""])
            ||([temStr isEqualToString:@""])
            ||([temStr isEqualToString:@"(\n)"])
            ||([temStr isEqualToString:@"yanyu"])
            );
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

//标准化时间
+(NSString *)makeTimeFormat:(NSString *)dateStr{
    NSDate * date = [self strTimeToTime:dateStr];
    NSMutableString  *strTemp = [[NSMutableString alloc]init];
    NSDateComponents *components =  [NSDate componentsByDate:date];
    NSDateComponents *ThisTimeCP =  [NSDate  componentsByDate:[NSDate date]];
    
    
    if (components.year == ThisTimeCP.year && components.month==ThisTimeCP.month &&
        components.day==ThisTimeCP.day && components.hour==ThisTimeCP.hour &&
        components.minute==ThisTimeCP.minute) {
        [strTemp appendString:@"刚刚"];
    }
    
    else if (components.year == ThisTimeCP.year && components.month == ThisTimeCP.month && components.day == ThisTimeCP.day) {
        // 当天的
        [strTemp appendFormat:@"%ld:%@",components.hour,[self addZero:components.minute]];
    }

    else if (components.year == ThisTimeCP.year && components.month == ThisTimeCP.month){
        //当月的
        [strTemp appendFormat:@"%@月%@日 %ld:%@", [self addZero:components.month], [self addZero:components.day],components.hour,[self addZero:components.minute]];
    }
    else if (components.year == ThisTimeCP.year && components.month != ThisTimeCP.month){
        //本年 前几个月的
        [strTemp appendFormat:@"%ld-%@-%@ %ld:%@",components.year,[self addZero:components.month],[self addZero:components.day],components.hour,[self addZero:components.minute]];
    }
    else if(components.year != ThisTimeCP.year){
        //以前年度
        [strTemp appendFormat:@"%ld-%@-%@",components.year,[self addZero:components.month],[self addZero:components.day]];
    }
  
    return  [strTemp copy];
}
//计算多久之前
+(NSString *)makeTimeBefore:(NSString *)dateStr{
    NSDate * date = [self strTimeToTime:dateStr];
    NSMutableString  *strTemp = [[NSMutableString alloc]init];
    NSDateComponents *components =  [NSDate componentsByDate:date];
    NSDateComponents *ThisTimeCP =  [NSDate  componentsByDate:[NSDate date]];
    
    
    if (components.year == ThisTimeCP.year && components.month==ThisTimeCP.month &&
        components.day==ThisTimeCP.day && components.hour==ThisTimeCP.hour &&
        components.minute==ThisTimeCP.minute) {
        [strTemp appendString:@"刚刚"];
    }
    
    else if (components.year == ThisTimeCP.year && components.month == ThisTimeCP.month && components.day == ThisTimeCP.day) {
        // 当天的
        [strTemp appendFormat:@"%ld:%ld",labs(components.hour - ThisTimeCP.hour),labs(components.minute - ThisTimeCP.minute)];//abs
    }
    
    else if (components.year == ThisTimeCP.year && components.month == ThisTimeCP.month){
        //当月的
        [strTemp appendFormat:@"%ld",labs(components.day - ThisTimeCP.day)];
    }
    else if (components.year == ThisTimeCP.year && components.month != ThisTimeCP.month){
        //本年 前几个月的
        [strTemp appendFormat:@"%ld:%ld:",labs(components.month- ThisTimeCP.month),labs(components.day - ThisTimeCP.day)];
    }
    else if(components.year != ThisTimeCP.year){
        //以前年度
        [strTemp appendFormat:@"%ld年前",labs(components.year - ThisTimeCP.year)];
    }
    return  [strTemp copy];
}


+(NSString *)addZero:(NSInteger)time{
    if (time<10) {
        return [NSString stringWithFormat:@"0%ld",time];
    }
    return [NSString stringWithFormat:@"%ld",time];
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
    
    //
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
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(void)setBtn:(UIButton *)btn{
    
    [self setBtn:btn Radius:10 NColor:@"#5db9d8" HColor:@"#3e7f96"];
}
+(void)setBtnBackColor:(UIButton *)btn{
    [self setBtn:btn Radius:0 NColor:@"#5db9d8" HColor:@"#3e7f96"];
}
+(void)setBtnGray:(UIButton *)btn{
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.userInteractionEnabled = NO;
}

+(void)setBtnRadius:(UIButton *)btn{
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
}
+(void)setBtn:(UIButton *)btn Radius:(NSInteger)radius NColor:(NSString *)NColor HColor:(NSString *)HColor{
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundImage:[self imageWithColor:[self colorWithHexString:NColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageWithColor:[self colorWithHexString:HColor]] forState:UIControlStateHighlighted];
}
//判断是否是纯字母
+ (BOOL)isPureCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    if(string.length > 0) {
        return NO;
    }
    return YES;
}

//判断是否是纯数字
+ (BOOL)isPureNum:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0) {
        return NO;
    }
    return YES;
}
#pragma mark 判断身份证号是否合法
+(BOOL)judgeIdentityStringValid:(NSString *)identityString {
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
#pragma mark 判断银行卡号是否合法
+(BOOL)isBankCard:(NSString *)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scanner = [NSScanner scannerWithString:string];
    int val;
    return[scanner scanInt:&val] && [scanner isAtEnd];
}
+ (BOOL)isNumOrCharater:(NSString *)string{
    
    return [DDFactory isPureNum:string] || [DDFactory isPureCharacters:string];
}
//判断是否包含连续的数组或字母，yes为包含
+ (BOOL)rangeString:(NSString *)string {
    BOOL result = NO;
    for (int i = 0; i < string.length; i++) {
        if (string.length - i < 4 ) {
            break;
        }
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 4)];
        if ([self isPureCharacters:newStr] || [self isPureNum:newStr]) {
            NSLog(@"%@",newStr);
            result = YES; break;
        }
    }
    return result;
}
//
+ (BOOL) isPrice:(NSString *) price {
   NSString *format =@"(^[1-9]([0-9]+)?(.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9].[0-9]([0-9])?$)";
   NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
     if ([regextest evaluateWithObject:price] == YES)
         return YES;
    else
         return NO;
}

//触摸点是否再某个控件的显示区域内
+(BOOL)isView:(UIView *)view containPoint:(CGPoint)point{
    if (CGRectGetMinX(view.frame) <= point.x && point.x <= CGRectGetMaxX(view.frame)  && CGRectGetMinY(view.frame) <= point.y
        && point.y <= CGRectGetMaxY(view.frame)) {
        return YES;
    }
    return NO;
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


@end

