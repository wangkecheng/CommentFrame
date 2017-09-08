//
//  Tankuang.h
//  tankuang
//
//  Created by  warron on 2017/1/6.
//  Copyright © 2017年  warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAlertWithTime : UIView

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

+(instancetype)alertWithContent:(NSString *)Content LeftTitle:(NSString *)leftTile RightTitle:(NSString *)rigthTile;

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
