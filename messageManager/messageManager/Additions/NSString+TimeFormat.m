//
//  NSString+TimeFormat.m
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "NSString+TimeFormat.h"

@implementation NSString (TimeFormat)

-(NSString *)ConvertStrToTime:(NSString *)timeStr andFormat:(NSString *)format{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:format];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
}
@end
