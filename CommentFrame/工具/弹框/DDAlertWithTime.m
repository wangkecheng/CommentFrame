

//
//  Tankuang.m
//  tankuang
//
//  Created by  warron on 2017/1/6.
//  Copyright © 2017年  warron. All rights reserved.
//

#import "DDAlertWithTime.h"
#define kAlertWidth 245.0f
#define kAlertHeight 120.0f

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f


#define kSingleButtonWidth kAlertWidth
#define kCoupleButtonWidth (kAlertWidth)/2.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 10.0f
@interface DDAlertWithTime()

@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,assign)BOOL isShutDownCountTime;
@end
@implementation DDAlertWithTime
+(instancetype)alertWithContent:(NSString *)Content LeftTitle:(NSString *)leftTile RightTitle:(NSString *)rigthTile{
    DDAlertWithTime * alertShow = [[DDAlertWithTime alloc]initWithContentText:Content leftOrOneButtonTitle:leftTile rightButtonTitle:rigthTile];
    [alertShow showWithBtn];
    [alertShow openCountdown];
    return  alertShow;
}
- (id)initWithContentText:(NSString *)content
leftOrOneButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle{
      if (self = [super init]) {
    _containerRadius = 0;
    //设置按钮边角
    _btnRadius = 0;
    
    //设置背景颜色
    _containerBackColor = [UIColor whiteColor];
    //设置弹框内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [self heightOrY:kTitleYOffset],[self widthOrX:kAlertWidth] , [self heightOrY:kAlertHeight- kButtonBottomOffset -kButtonHeight] -  [self heightOrY:kTitleYOffset])];
    _contentLabel.numberOfLines = 0;
    [_contentLabel setFont:[UIFont  systemFontOfSize:12]];
[_contentLabel setTextColor:[UIColor lightGrayColor]];
    [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    _contentLabel.text = content;
    [self addSubview:_contentLabel];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = _containerRadius;
    self.backgroundColor = _containerBackColor;

    //设置底部两个按钮
    CGRect leftBtnFrame = CGRectMake(0, [self heightOrY:kAlertHeight- kButtonBottomOffset -kButtonHeight] , [self widthOrX:kCoupleButtonWidth],  [self heightOrY:kButtonBottomOffset +kButtonHeight]);
    CGRect rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame), [self heightOrY:kAlertHeight -kButtonHeight - kButtonBottomOffset ]  , [self widthOrX:kCoupleButtonWidth],  [self heightOrY:kButtonBottomOffset + kButtonHeight]);
    _leftBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = leftBtnFrame;
    _rightBtn.frame = rightBtnFrame;
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
    leftBtnLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    leftBtnLayer.frame = frame;
    [_leftBtn.layer addSublayer:leftBtnLayer];
    
    //给右边按钮添加
    CALayer *rightBtnLayer = [[CALayer alloc]init];
    frame = CGRectMake(0, 0, _rightBtn.frame.size.width, 1);
    rightBtnLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    rightBtnLayer.frame = frame;
    [_rightBtn.layer addSublayer:rightBtnLayer];
    
    if (_leftBtn.titleLabel.text != nil &&_rightBtn.titleLabel.text != nil) {
        //设置左侧按钮右边边框
        frame = CGRectMake(_leftBtn.frame.size.width - 0.5, 0, 0.5,  _leftBtn.frame.size.height);
        CALayer *leftBtnRLayer = [[CALayer alloc]init];
        leftBtnRLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        leftBtnRLayer.frame  = frame;
        [_leftBtn.layer addSublayer:leftBtnRLayer];
        
        //设置右侧按钮左边边框
        frame = CGRectMake( 0, 0, 0.5,  _rightBtn.frame.size.height);
        CALayer *rigthBtnLLayer = [[CALayer alloc]init];
        rigthBtnLLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        rigthBtnLLayer.frame  = frame;
        [_rightBtn.layer addSublayer:rigthBtnLLayer];
        
    }
}

-(void)showWithBtn{
    //设置弹出初始位置 这是滑动动画需要设置的
    UIViewController *topVC = [DDFactory appRootViewController];
    
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self widthOrX:kAlertWidth]) * 0.5, 0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight]);
    
    self.center = CGPointMake(topVC.view.frame.size.width/2, topVC.view.frame.size.height/2);
    
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
        
        _backImageView.alpha = 0.6f;
        
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = afterFrame = CGRectMake(0,0, [self widthOrX:kAlertWidth], [self heightOrY:kAlertHeight] );
    
     __weak typeof (self) weakSelf = self;
    
 
        //如果type是正常显示
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.alpha = 1;
        }];
    
     [super willMoveToSuperview:newSuperview];
    
     return;
}


- (void)removeFromSuperview{
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.backImageView.alpha = 0;
            
            weakSelf.alpha = 0;
            
        } completion:^(BOOL finished) {
            [weakSelf.backImageView removeFromSuperview];
             weakSelf.backImageView = nil;
        }];
        
        return;
 }
- (void)leftBtnClicked:(id)sender{
    
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender{
    
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
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 10; //倒计时时间
    _isShutDownCountTime = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if (_isShutDownCountTime) {
            time = 0;
        }
        
        if(time <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self dismissAlert];
                _leftBlock();
            });
         }else{
            
            int seconds = time % 120;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
               [self.rightBtn setTitle:[NSString stringWithFormat:@"%.2d后自动返回", seconds] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
