
#import <UIKit/UIKit.h>

@interface SegmentView : UIView

//选中分段的下标
@property(nonatomic, assign) NSUInteger selectedSegmentIndex;

//选中颜色
@property(nonatomic, strong) UIColor * selectedColor;

//选中颜色下划线颜色
@property(nonatomic, strong) UIColor * selIndicaotrColor;

//正常状态下得颜色
@property(nonatomic, strong) UIColor * normalColor;

//是否显示下面的线条
@property(nonatomic, assign) BOOL isShowLine;

@property(nonatomic, assign) BOOL isShowSlider;



//通过items去创建segmentControl对象
-(void)setSegmentItems:(NSArray *)items;
//通过items去创建segmentControl对象
//添加事件
- (void)addTarget:(id)target action:(SEL)action;

-(void)resetBtnTitle:(NSArray *)arrTitle;//重新设置按钮标题
@end
