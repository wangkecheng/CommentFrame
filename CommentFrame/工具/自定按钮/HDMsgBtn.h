//
//  HDMsgBtn.h
//  DieKnight
//
//  Created by  晏语科技 on 2017/2/8.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMsgBtn : UIButton
-(void)setMagNum:(NSString *)num;
@property (strong, nonatomic) UILabel *numLbl;
+(HDMsgBtn *)shareBtnByFrame:(CGRect)frame;
@end
