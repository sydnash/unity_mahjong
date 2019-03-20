//
//  CNShareWebpageObject.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/8.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNShareBaseObj.h"

@interface CNShareWebpageObject : CNShareBaseObj

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 */
+(instancetype)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage;

@end
