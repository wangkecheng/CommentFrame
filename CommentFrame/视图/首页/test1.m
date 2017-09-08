//
//  test1.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "test1.h"
#import "test2.h"
@interface test1 ()

@end

@implementation test1

- (void)viewDidLoad {
    [super viewDidLoad];
 
}
- (IBAction)action:(id)sender {
//    test2 *vc = [[test2 alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [BaseServer postDict:nil path:@"" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
