//
//  OauthObj.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/7.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OauthObj : NSObject

/*
 * access_token用户授权令牌,7200秒刷新一次
 */
@property(nonatomic,copy)NSString * access_token;

/*
 * access_token用来刷新的access_token,30天刷新一次
 */
@property(nonatomic,copy)NSString * refresh_token;

/*
 * 当前用户对应当前app的唯一用户标识
 */
@property(nonatomic,copy)NSString * openid;

/*
 * extra备用字段
 */
@property(nonatomic,copy)NSString * extra;

@end
