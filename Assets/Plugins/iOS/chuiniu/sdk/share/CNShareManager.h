//
//  CNShareManager.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/8.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CNShareMessageObject.h"

#import "CNShareWebpageObject.h"
#import "CNImageObject.h"
#import "CNShareInviteObject.h"
#import "CNExtensionMessageObject.h"

#define Time_Mark_Key @"timemark"

typedef NS_ENUM(NSUInteger, CNShareErrCode) {
    CNShareErrCode_Ok = 0,  //Auth成功
    CNShareErrCode_Err_Cancel = 1,     //用户取消分享
    CNShareErrCode_NormalErr = 2,  //普通错误
};
typedef void (^CNshareRequestCompletionHandler)(id result,CNShareErrCode errorCode);

@interface CNShareManager : NSObject

@property(nonatomic,strong)NSNumber * timeMark;
@property(nonatomic,copy)CNshareRequestCompletionHandler shareBackOption;


+(instancetype)defaultManager;
-(void)shareWithMessageObject:(CNShareMessageObject *)messageObject  currentViewController:(id)currentViewController
completion:(CNshareRequestCompletionHandler)completion;


@end
