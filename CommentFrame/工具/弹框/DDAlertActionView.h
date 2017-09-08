//
//  LBAlertActionView.h
//  luban-ios
//
//  Created by warron on 16/9/21.
//  Copyright © 2016年 wghx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AlertShowType{
   AlertShowWithNormal = 1,
   AlertShowWithSlide
}AlertShowType;

typedef enum  AlertShowFormat{
  AlertShowWithBtn,
  AlertShowNOBtn,
  AlertShowJustContent
}AlertShowFormat;

@interface DDAlertActionView : UIView

+(instancetype)alertWithTitle:(NSString *)title Content:(NSString *)Content LeftTitle:(NSString *)leftTile RightTitle:(NSString *)rigthTile;

+(instancetype)alertWithTitle:(NSString *)title Content:(NSString *)content;

+(instancetype)alertWithContent:(NSString *)content;


//dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
//
//在给定的调度队列中，异步执行相应的代码块。
//dispatch_block_t代码块格式为：void (^dispatch_block_t)(void)
//这里的Block实际上就是dispatch_async 中的block
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

//出现 消失所用时间
@property (nonatomic,assign)CGFloat  slideTime;

//摇晃时间
@property (nonatomic,assign)CGFloat  rotationTime;

//是否需要左右摇晃效果
@property (nonatomic,assign)BOOL isNeedRotaion;

//显示方式 正常还是下滑
@property (nonatomic,assign)AlertShowType showType;

//显示格式 正常还是下滑
@property (nonatomic,assign)AlertShowFormat showFormat;

//弹出容器的边角弧度
@property (nonatomic,assign)CGFloat containerRadius;

//背景色
@property (nonatomic,assign)UIColor *containerBackColor;

//子视图的控件的弧度
@property (nonatomic,assign)CGFloat btnRadius;


@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;
@end
