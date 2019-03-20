//
//  CNExtensionMessageObject.h
//  CNChat
//
//  Created by 吴超 wuchao on 2018/5/16.
//  Copyright © 2018年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNExtensionMessageObject : NSObject

/*
 *拓展定制消息内容(备用)
 */
@property(nonatomic,strong)NSDictionary * extensionInfo;

+(instancetype)initWithExtensionInfo:(NSDictionary *)extensionInfo;

@end
