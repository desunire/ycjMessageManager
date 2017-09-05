//
//  NSString+TimeFormat.h
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormat)

//将后台传递的时间戳毫秒数--时间字符串
-(NSString *)ConvertStrToTime:(NSString *)timeStr andFormat:(NSString *)format;

@end
