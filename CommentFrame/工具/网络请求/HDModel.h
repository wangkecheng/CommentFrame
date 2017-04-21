//
//  HDApplyModel.h
//  DieKnight
//
//  Created by warron on 2017/2/22.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求一般的数据 都用这个类来初始化请求数据
@interface HDModel : NSObject
+(HDModel *)model;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *openid;
@property (nonatomic,strong)NSString *face_img;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *keywords;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *class_id;
@property (nonatomic,strong)NSString *parent_id;
@property (nonatomic,strong)NSString *comment_type;
@property (nonatomic,strong)NSString *topic_id;
@property (nonatomic,strong)NSString *content;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;

//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;
//@property (nonatomic,strong)NSString *;


@end
