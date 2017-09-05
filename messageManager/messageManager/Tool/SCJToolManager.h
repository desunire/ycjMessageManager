//
//  SCJToolManager.h
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCJToolManager : NSObject


+(instancetype)setInstance;

#pragma mark -- 计算宽窄的函数
-(float)autoCalculateWidthOrHeight:(float)height
                             width:(float)width
                          fontsize:(float)fontsize
                           content:(NSString*)content;


//页面提示
-(void)showMessage:(NSString *)title;


@end
