//
//  CNImageObject.h
//  CNChat
//
//  Created by 吴超 wuchao on 2017/12/11.
//  Copyright © 2017年 吴超 wuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNShareBaseObj.h"

@interface CNImageObject : CNShareBaseObj

/**
 * @param image（UIImage或者NSData类型，或者image_url）
 */
+(instancetype)initWithImage:(id)image;

@end
