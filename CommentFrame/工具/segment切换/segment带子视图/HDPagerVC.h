//
//  SOPagerViewController.h
//  SchOrigin
//
//  Created by WARRON on 8/8/16.
//  Copyright © 2016 smufs. All rights reserved.
//

#import "LBTabButtonPagerController.h"
@protocol PageSelectDelegate <NSObject>

-(void)pagerSelect:(NSInteger)index;//点击切换 回调切换 的index

@end

@interface HDPagerVC : LBTabButtonPagerController

-(id)initWithPlistName:(NSString *)plistName;

@property(nonatomic,weak)id<PageSelectDelegate> pageDelegate;

@end
