//
//  CNShareInviteObject.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/12.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNShareBaseObj.h"

//邀请消息
@interface CNShareInviteObject : CNShareBaseObj

@property(nonatomic,copy) NSString * reciveInviteBackInfo;

/**
 * @param title 标题
 * @param descr 描述
 * @param reciveInviteBackInfo  (此消息点击的吹牛回调中会返回此信息)
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 */
+(instancetype)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr reciveInviteBackInfo:(NSString *)reciveInviteBackInfo thumImage:(id)thumImage;

@end
