//
//  CYPasswordInputView.h
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYPasswordInputViewDelegate <NSObject>

-(void)btnClose_Click;

-(void)btnForgetPWD_Click;

@end

@interface CYPasswordInputView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) id <CYPasswordInputViewDelegate> delegate;
@end
