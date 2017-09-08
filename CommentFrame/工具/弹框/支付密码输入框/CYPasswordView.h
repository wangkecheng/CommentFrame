//
//  CYPasswordView.h
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPasswordInputView.h"
#import "CYConst.h"
#define kRequestTime 3.0f
#define kDelay 1.0f
@interface CYPasswordView : UIView
-(instancetype)initWithTitle:(NSString *)title  superView:(UIView *)view forgetPassBlock:(void (^)())forgetPassBlock finishBlock:(void (^)(NSString *) )finishBlock;

/** 密码框的标题 */
@property (nonatomic, copy) NSString *title;

/** 弹出密码框 */
- (void)showInView:(UIView *)view;

/** 隐藏键盘 */
- (void)hideKeyboard;

/** 隐藏密码框 */
- (void)hide;

/** 开始加载 */
- (void)startLoading;

/** 加载完成 */
- (void)stopLoading;

/** 请求完成 */
- (void)requestComplete:(BOOL)state;
- (void)requestComplete:(BOOL)state message:(NSString *)message;

@end
