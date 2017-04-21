
//
//  HDMsgBtn.m
//  DieKnight
//
//  Created by  晏语科技 on 2017/2/8.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import "HDMsgBtn.h"
@interface HDMsgBtn()

@end
@implementation HDMsgBtn

+(HDMsgBtn *)shareBtnByFrame:(CGRect)frame{
    HDMsgBtn *btn= [[HDMsgBtn alloc]initWithFrame:frame];;
    [btn addTarget:btn action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_tongzhi"] forState:0];
    [btn addLblByFrame:CGRectMake(frame.size.width/2.0, -5, frame.size.width/2.0, frame.size.width/2.0)];
    return btn;
}

-(void)setMagNum:(NSString *)num{
    if ([num integerValue] == 0) {
        self.numLbl.text = @"";
        self.numLbl.mj_w = self.numLbl.mj_h = 0;
        return;
    }
    self.numLbl.text = num;//传入是字符串
}
-(void)showMsg{
    UIViewController *VC = [self getCurrentViewController];
    if (VC){
        //弹出消息界面
//        HDBroadCastVC *broadVC = [DDFactory getViewControllerWithId:@"HDBroadCastVC" storyboardName:@"HDBroadCastVC"];
//        if (VC.navigationController) {
//             [VC.navigationController pushViewController:broadVC animated:YES];
//            return;
//        }
//          HDMainNavC *navC =  (HDMainNavC *)VC;
//          [navC pushViewController:broadVC animated:YES];
    }
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
-(void)addLblByFrame:(CGRect)frame{
    _numLbl= [[UILabel alloc]initWithFrame:frame];
    _numLbl.layer.cornerRadius = frame.size.height/2;
    _numLbl.layer.masksToBounds = YES;
    [_numLbl setBackgroundColor: [UIColor redColor]];
    _numLbl.font = [UIFont systemFontOfSize:10];
    _numLbl.textColor = [UIColor whiteColor];
    _numLbl.textAlignment = 1;
    [self addSubview:_numLbl];
}
@end
