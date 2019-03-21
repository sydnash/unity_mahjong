//
//  CNShareBaseObj.h
//  CNChat
//
//  Created by 吴超 wuchao on 2018/3/28.
//  Copyright © 2018年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNShareBaseObj : NSObject

//消息标题
@property(nonatomic,copy)NSString * title;

//消息描述
@property(nonatomic,copy)NSString * descr;

//thumImage 缩略图（UIImage或者NSData类型，或者image_url）
@property(nonatomic,strong) id thumImage;

/*
 *分享的web h5页面urlstring
 */
@property(nonatomic,copy)NSString * urlIntent;

/*
 *拓展信息字段备用
 */
@property(nonatomic,strong)NSDictionary * cnextra;

@end
