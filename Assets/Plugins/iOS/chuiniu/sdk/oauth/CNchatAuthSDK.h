//
//  CNchatAuthSDK.h
//  CNchatAuthSDK
//
//  Created by 吴超 wuchao on 2017/12/8.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OauthObj.h"

typedef NS_ENUM(NSUInteger, CNAuthErrCode) {
    CNchatAuth_Err_Ok = 0,  //Auth成功
    CNchatAuth_Err_Cancel = 1,     //用户取消授权
    CNchatAuth_Err_NormalErr = 2,  //普通错误
};

typedef void(^GetTokenOption)(OauthObj * oauthObj,CNAuthErrCode errCode);

@interface CNchatAuthSDK:NSObject

@property(nonatomic,copy)GetTokenOption getTokenOption;

//单例
+(instancetype)shared;

/*! @brief 获取授权
 * succeed 获取token回调
 */
-(void)getAuthSucceed:(GetTokenOption)succeed;

/*! @brief 获取授权的用户信息
 * oauthObj 授权对象(包含openid与token)
 * completionHandler 响应回调,回调在异步线程
 */
//-(void)getUserInfoWithOauth:(OauthObj *)oauthObj completionHandler:(void (^)(NSData *  data, NSURLResponse *  response, NSError *  error))completionHandler;


@end

