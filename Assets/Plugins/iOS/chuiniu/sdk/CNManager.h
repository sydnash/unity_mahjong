//
//  CNManager.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/11.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNchatAuthSDK.h"
#import "CNShareManager.h"

#define ShareTypeKey @"type"

@protocol CNManagerDelegate <NSObject>

-(void)oauthBackWith:(OauthObj *)oauthObj errCode:(CNAuthErrCode)errCode;
-(void)inviteBackWith:(id)backInfo;
-(void)shareCompletion:(id)result error:(CNShareErrCode)error;

@end

@interface CNManager : NSObject

@property(nonatomic,copy)NSString * appid;
@property(nonatomic,copy)NSString * appsecret;

//单例
+(instancetype)shared;

/*! @brief 判断吹牛软件是否安装
 *
 * @return 支持返回YES，不支持返回NO。
 */
+(BOOL) isCNAppInstalled;

//跳转到appstore下载吹牛
+(void)showInstallCNChat;

/*! @brief sdk初始化
 * appid 注册申请的appid
 * appsecret 注册申请的appsecret
 */
+(void)registerAppWithAppid:(NSString *)appid appsecret:(NSString *)appsecret delegate:(id<CNManagerDelegate>)delegate;

/*! @brief 处理吹牛通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。(如果只适配S9+的话可以用S9提供的新方法)
 * @param url 吹牛启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL)handleOpenURL:(NSURL *) url;


@end
