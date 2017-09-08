//
//  SRActionSheetView.h
//  SRActionSheetDemo
//
//  Created by warron on 16/7/5.
//  Copyright © 2016年 warron. All rights reserved.
//



#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SRActionItemAlignment) {
    SRActionItemAlignmentLeft,
    SRActionItemAlignmentCenter
};
@class SRActionSheetPay;

@protocol SRActionSheetPayDelegate <NSObject>

@required

/**
 Delegate method

 @param actionSheet The SRActionSheet instance.
 @param index       Top is 0 and ++ to down, but cancelBtn's index is -1.
 */
- (void)actionSheet:(SRActionSheetPay *)actionSheet didSelectSheet:(NSInteger)index;

@end

/**
 Block callback

 @param actionSheet The same as the delegate.
 @param index       The same as the delegate.
 */
typedef void (^ActionSheetDidSelectSheetPayBlock)(SRActionSheetPay *actionSheet, NSInteger index);

@interface SRActionSheetPay : UIView

/**
 Default is SROtherActionItemAlignmentCenter when no images.
 Default is SROtherActionItemAlignmentLeft when there are images.
 */
@property (nonatomic, assign) SRActionItemAlignment otherActionItemAlignment;

/**
 Create a sheet with block.
 
 @param title            Title on the top, not must.
 @param cancelTitle      Title of action item at the bottom, not must.
 @param destructiveTitle Title of action item at the other action items bottom, not must.
 @param otherTitles      Title of other action items, must.
 @param otherImages      Image of other action items, not must.
 @param selectSheetBlock The call-back's block when select a action item.
 */
+ (instancetype)sr_actionSheetViewWithTitle:(NSString *)title
                                cancelTitle:(NSString *)cancelTitle
                           destructiveTitle:(NSString *)destructiveTitle
                                otherTitles:(NSArray  *)otherTitles
                                otherImages:(NSArray  *)otherImages
                           selectSheetBlock:(ActionSheetDidSelectSheetPayBlock)selectSheetBlock;

/**
 Create a action sheet with delegate.
 */
+ (instancetype)sr_actionSheetViewWithTitle:(NSString *)title
                                cancelTitle:(NSString *)cancelTitle
                           destructiveTitle:(NSString *)destructiveTitle
                                otherTitles:(NSArray  *)otherTitles
                                otherImages:(NSArray  *)otherImages
                                   delegate:(id<SRActionSheetPayDelegate>)delegate;

- (void)show;
- (void)showWithSuperVC:(UIViewController *)superView;

+(instancetype)sr_actionSheetViewWithSubView:(UIView *)view;
-(instancetype)initWithSubView:(UIView *)view;
- (void)dismiss;
@end
