//
//  LBAlertActionView.m
//  luban-ios
//
//  Created by warron on 16/9/21.
//  Copyright © 2016年 wghx. All rights reserved.
//

#import "DDAlertActionView.h"
#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 245.0f
#define kAlertHeight 110.0f

#define kTitleYOffset 5.0f
#define kTitleHeight 15.0f

#define kSingleButtonWidth kAlertWidth
#define kCoupleButtonWidth (kAlertWidth)/2.0f
#define kButtonHeight 30.0f
#define kButtonBottomOffset 10.0f


@interface DDAlertActionView (){
    BOOL _leftLeave;
    CGFloat needMinusNoContent;//没有内容的时候减去内容高度
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *backImageView;

@end
@implementation DDAlertActionView

+ (CGFloat)alertWidth{
    
    DDAlertActionView * actionView = [[DDAlertActionView alloc]init];
    return [actionView widthOrX:kAlertWidth];
}

+ (CGFloat)alertHeight{
    DDAlertActionView * actionView = [[DDAlertActionView alloc]init];
    return [actionView heightOrY:kAlertHeight];
}


/**
 *   此类使用说明
 *  1.调用- (id)initWithTitle: contentText: leftOrOneButtonTitle:  rightButtonTitle:创建对象 如 alert
 *  参数1：弹出标题  参数2：内容  参数3：左边按钮标题（传入nil时,不显示，此时用右边按钮创建底部按钮，点击按钮弹框小时，需要处理事件回调，使用alert.rightBlock = ^(){};）参数4：右边按钮标题（传入nil时,不显示，此时用左边按钮创建底部按钮，点击按钮弹框小时，需要处理事件回调，使用alert.leftBlock = ^(){};）
 *
 2.弹框消失 出现时间，摇晃都以默认，可自己分别设置时间
 *
 *   3.调用[alert show()]显示弹框
 *
 *   4.例子    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"ABC" contentText:@"好的"  leftOrOneButtonTitle:@"Ok" rightButtonTitle:@"Fine"];
 [alert show];
 alert.leftBlock = ^() {};
 alert.rightBlock = ^() {};
 alert.dismissBlock = ^(){};
 */

//这个方法返回没有按钮的弹框 显示标题和内容
+(instancetype)alertWithTitle:(NSString *)title Content:(NSString *)content{
    
    DDAlertActionView * alertShow = [[DDAlertActionView alloc]initWithTitle:title Content:content];
    
    [alertShow showNoBtn];
    
    return  alertShow;
}
-(instancetype)initWithTitle:(NSString *)title Content:(NSString *)content{
    if (self = [super init]) {
        
        _showFormat = AlertShowNOBtn;
        [self setTitle:title contentText:content];
    }
    return  self;
}

+(instancetype)alertWithContent:(NSString *)content{
    DDAlertActionView * alertShow = [[DDAlertActionView alloc]initWithContent:content];
    [alertShow showJustContent];
    return alertShow;
}
-(instancetype)initWithContent:(NSString *)content{
    if (self = [super init]) {
        _showFormat = AlertShowJustContent;
       [self setContentText:content];
    }
    return  self;
}


//成功打钩动画 待完成
+(instancetype)alertWithCircle{
    
    DDAlertActionView * alertShow = [[DDAlertActionView alloc]init];
    
    [alertShow showNoBtn];
    
    return  alertShow;
}

//设置公有的属性
-(void)setTitle:(NSString *)title
    contentText:(NSString *)content{

    //设置弹框标题
    _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [self heightOrY:kTitleYOffset],[self widthOrX:kAlertWidth] , [self heightOrY:kTitleHeight])];
    _alertTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
    _alertTitleLabel.text = title;
    
    [self addSubview:_alertTitleLabel];
    
    [self setContentText:content];
    
}

-(void)setContentText:(NSString *)content{
    
    //初始化时间
    //下滑时的时间
    _slideTime = 0.35;
    //旋转时间
    _rotationTime = 0.2;
    //是否需要旋转 默认需要旋转
    _isNeedRotaion = YES;
    //弹出样式
    _showType =  AlertShowWithNormal;
    
    //设置按钮边角
    //设置弹出框
    _containerRadius = 0;
    //设置按钮边角
    _btnRadius = 0;
    
    //设置背景颜色
    _containerBackColor = [UIColor whiteColor];
    //设置弹框内容
    _alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_alertTitleLabel.frame), [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight]  - [self heightOrY:kButtonBottomOffset + kButtonHeight] - CGRectGetMaxY(_alertTitleLabel.frame))];
    _alertContentLabel.numberOfLines = 0;
    _alertContentLabel.textAlignment = _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    _alertContentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    _alertContentLabel.font = [UIFont systemFontOfSize:14.0f];
    _alertContentLabel.text = content;
    [self addSubview:_alertContentLabel];
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = _containerRadius;
    self.backgroundColor = _containerBackColor;
    
    
}
//  //如果用户急切diss弹出框
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    UIViewController *topVC = [self appRootViewController];
//    CGPoint point = [touch locationInView:topVC.view];
//
//    if (point.x > 0) {
//        self.backImageView.alpha = 0;
//        
//        self.alpha = 0;
//    }
//}

//这个方法返回有按钮的弹框
+(instancetype)alertWithTitle:(NSString *)title
                      Content:(NSString *)Content
                    LeftTitle:(NSString *)leftTile
                   RightTitle:(NSString *)rigthTile{
    
    DDAlertActionView * alertShow = [[DDAlertActionView alloc]initWithTitle:title contentText:Content leftOrOneButtonTitle:leftTile rightButtonTitle:rigthTile];
    
    [alertShow showWithBtn];
    
    return  alertShow;
}

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
leftOrOneButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle{
    
    if (self = [super init]) {
        
        [self setTitle:title contentText:content];
        if (content.length == 0) {
            needMinusNoContent = kAlertHeight - kTitleHeight -  [self heightOrY:kButtonBottomOffset + kButtonHeight + 20] ;
        }
        
        
        _showFormat = AlertShowWithBtn;
        //设置底部两个按钮
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        //如果左边title为空，就只设置一个按钮
        if (!leftTitle) {
            //点击按钮的回调用 rightBlock
            rightBtnFrame = CGRectMake(([self widthOrX:kAlertWidth] - [self widthOrX:kSingleButtonWidth]) * 0.5, [self heightOrY:kAlertHeight - kButtonBottomOffset-kButtonHeight -needMinusNoContent] ,  [self widthOrX:kSingleButtonWidth],  [self heightOrY:kButtonBottomOffset +kButtonHeight]);
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn.frame = rightBtnFrame;
            
        }
        //如果右边边title为空，就只设置一个按钮
        else if (!rigthTitle) {
            
            //点击按钮的回调用 leftBlock
            leftBtnFrame = CGRectMake(([self widthOrX:kAlertWidth] -  [self widthOrX:kSingleButtonWidth]) * 0.5, [self heightOrY:kAlertHeight - kButtonBottomOffset -kButtonHeight  -needMinusNoContent],  [self widthOrX:kSingleButtonWidth], [self heightOrY:kButtonBottomOffset + kButtonHeight]);
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.frame = leftBtnFrame;
        }
        
        else {
            leftBtnFrame = CGRectMake(0, [self heightOrY:kAlertHeight- kButtonBottomOffset -kButtonHeight -needMinusNoContent] , [self widthOrX:kCoupleButtonWidth],  [self heightOrY:kButtonBottomOffset +kButtonHeight]);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame), [self heightOrY:kAlertHeight -kButtonHeight - kButtonBottomOffset -needMinusNoContent]  , [self widthOrX:kCoupleButtonWidth],  [self heightOrY:kButtonBottomOffset + kButtonHeight]);
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.frame = leftBtnFrame;
            _rightBtn.frame = rightBtnFrame;
        }
        
        //批量设置左右按钮属性
        
        
        //只能这样子设置image 否则会出错
        //[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal]
        //[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]]
        [_rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]] forState:UIControlStateNormal];
        
        
        _leftBtn.layer.masksToBounds = _rightBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = _rightBtn.layer.cornerRadius = _btnRadius;
        
        
        [_leftBtn  setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        
        [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        //添加左右按钮点击事件
        [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //给按钮控件添加边线
        [self addLine];
        
        [self addSubview:_leftBtn];
        [self addSubview:_rightBtn];
        
    }
    return self;
}
-(void)addLine{
    //给左边按钮添加
    CALayer *leftBtnLayer = [[CALayer alloc]init];
    CGRect frame = CGRectMake(0, 0, _leftBtn.frame.size.width, 1);
    leftBtnLayer.backgroundColor = [[UIColor grayColor] CGColor];
    leftBtnLayer.frame = frame;
    [_leftBtn.layer addSublayer:leftBtnLayer];
    
    //给右边按钮添加
    CALayer *rightBtnLayer = [[CALayer alloc]init];
    frame = CGRectMake(0, 0, _rightBtn.frame.size.width, 1);
    rightBtnLayer.backgroundColor = [[UIColor grayColor] CGColor];
    rightBtnLayer.frame = frame;
    [_rightBtn.layer addSublayer:rightBtnLayer];
    
    if (  _leftBtn.titleLabel.text != nil &&_rightBtn.titleLabel.text != nil) {
        //设置左侧按钮右边边框
        frame = CGRectMake(_leftBtn.frame.size.width - 0.5, 0, 0.5,  _leftBtn.frame.size.height);
        CALayer *leftBtnRLayer = [[CALayer alloc]init];
        leftBtnRLayer.backgroundColor = [[UIColor grayColor] CGColor];
        leftBtnRLayer.frame  = frame;
        [_leftBtn.layer addSublayer:leftBtnRLayer];
        
        //设置右侧按钮左边边框
        frame = CGRectMake( 0, 0, 0.5,  _rightBtn.frame.size.height);
        CALayer *rigthBtnLLayer = [[CALayer alloc]init];
        rigthBtnLLayer.backgroundColor = [[UIColor grayColor] CGColor];
        rigthBtnLLayer.frame  = frame;
        [_rightBtn.layer addSublayer:rigthBtnLLayer];
        
    }
}


- (void)leftBtnClicked:(id)sender{
    
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender{
    
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)dismissAlert{
    
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
}


-(void)showWithBtn{
    
    //设置弹出初始位置 这是滑动动画需要设置的
    UIViewController *topVC = [DDFactory appRootViewController];
    
    
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self widthOrX:kAlertWidth]) * 0.5, 0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight - needMinusNoContent]);
    if (_showType == AlertShowWithNormal) {
      self.center = CGPointMake(topVC.view.frame.size.width/2, topVC.view.frame.size.height/2 );//这里有个_trendsHeigth 若键盘弹起 则改变位置  导入其他工程 可以直接删除减号后面的内容
    }
    [topVC.view addSubview:self];
}

-(void)showNoBtn{
    needMinusNoContent = kAlertHeight - kTitleHeight -  [self heightOrY:kButtonBottomOffset + kButtonHeight + 20] ;
    UIViewController *topVC = [DDFactory appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self widthOrX:kAlertWidth]) * 0.5, 0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight - needMinusNoContent]);
    if (_showType == AlertShowWithNormal) {
        self.center = CGPointMake(topVC.view.frame.size.width/2, topVC.view.frame.size.height/2 );//这里有个_trendsHeigth 若键盘弹起 则改变位置  导入其他工程 可以直接删除减号后面的内容
    }

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 *NSEC_PER_SEC));
    void(^task)()=^{
        [self removeFromSuperview];
    };
    dispatch_after(time, dispatch_get_main_queue(), task);
    [topVC.view addSubview:self];
}

-(void)showJustContent{
    
    UIViewController *topVC = [DDFactory appRootViewController];
    
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self widthOrX:kAlertWidth]) * 0.5, 0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight - 100]);
    if (_showType == AlertShowWithNormal) {
        
        self.alpha = 0.5;
        self.center = CGPointMake(topVC.view.frame.size.width/2, topVC.view.frame.size.height/2);//这里有个_trendsHeigth 若键盘弹起 则改变位置  导入其他工程 可以直接删除减号后面的内容
    }
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC));
    void(^task)()=^{
        [self removeFromSuperview];
    };
    dispatch_after(time, dispatch_get_main_queue(), task);
    [topVC.view addSubview:self];
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (newSuperview == nil) {
        
        return;
    }
    
    UIViewController *topVC = [DDFactory appRootViewController];
    
    if (!_backImageView) {
        
        _backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        
        _backImageView.backgroundColor = [UIColor blackColor];
        
        _backImageView.alpha = 0.2f;
        
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake(0, 0, 0, 0);
   
     if(_showFormat == AlertShowWithBtn)
      afterFrame = CGRectMake(0,0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight -needMinusNoContent] );
    
     else if ( _showFormat == AlertShowNOBtn)
      afterFrame = CGRectMake(0,0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight - 60] );
     else if (_showFormat == AlertShowJustContent)
      afterFrame = CGRectMake(0,0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight - 100] );
   
    __weak typeof (self) weakSelf = self;
    
    if (_showType == AlertShowWithNormal) {
         //如果type是正常显示
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.alpha = 1;
        }];
        
        return;
    }
    
    //开始一个动画
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    [UIView animateWithDuration:_slideTime delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.transform = CGAffineTransformMakeRotation(0);
        weakSelf.frame = afterFrame;
        weakSelf.center = CGPointMake(topVC.view.frame.size.width/2, topVC.view.frame.size.height/2);
    } completion:^(BOOL finished) {
        
        if (finished && _isNeedRotaion) {
            
            //结束后 判断一下是否 再来一个左右摇摆的动画 开始
            [UIView animateWithDuration:_rotationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent|  UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 //摇摆弧度
                                 weakSelf.transform   =CGAffineTransformMakeRotation(0.1);
                             } completion:^(BOOL finished) {
                                 //复位
                                 weakSelf.transform   =CGAffineTransformMakeRotation(0);
                             }];
            
        }
        //结束
        
    }];
    
    [super willMoveToSuperview:newSuperview];
}


- (void)removeFromSuperview{
    
    __weak typeof (self) weakSelf = self;

    
    //如果type是正常显示
    if (_showType == AlertShowWithNormal) {
       
        [UIView animateWithDuration:0.3 animations:^{
                
                weakSelf.backImageView.alpha = 0;
                
                weakSelf.alpha = 0;
          
        } completion:^(BOOL finished) {
            [weakSelf.backImageView removeFromSuperview];
            weakSelf.backImageView = nil;
        }];
        
        return;
    }
    
    UIViewController *topVC = [DDFactory appRootViewController];
    
    CGRect afterFrame  = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self widthOrX:kAlertWidth]) * 0.5, CGRectGetHeight(topVC.view.bounds), [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight]);//从顶部弹出，从底部离开的frame就是这个
    
    [UIView animateWithDuration:_slideTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backImageView.alpha = 0;
        weakSelf.frame = afterFrame;
        if (_leftLeave) {
            weakSelf.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            weakSelf.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        [weakSelf.backImageView removeFromSuperview];
         weakSelf.backImageView = nil;
    }];
}
//获取适配后的宽度 X坐标
-(CGFloat) widthOrX: (CGFloat)widthOrX  {
    return  [self currentScreenBoundsDependOnOrientation].size.width * widthOrX / 320.0f;
}
//获取适配后的高度 Y坐标
-(CGFloat)heightOrY: (CGFloat)heightOrY{
    
    return  [self currentScreenBoundsDependOnOrientation].size.height  * heightOrY / 568.0f;
}
#warning 进行屏幕适配的时候， 只能够传入像素值，不能够传入获取的屏幕宽度
//获取当前屏幕宽度 不管是横屏竖屏
-(CGRect)currentScreenBoundsDependOnOrientation
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }
    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(height, width);
        
    }
    return screenBounds ;
}


@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
