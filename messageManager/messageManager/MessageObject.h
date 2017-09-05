//
//  MessageObject.h
//  messageManager
//
//  Created by desunire on 2017/8/28.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *sequenceNumber;//排序

@property(nonatomic,copy)NSString *state;//状态

@property(nonatomic,copy)NSString *severity;//严重程度

@property(nonatomic,copy)NSString *priority;//优先级

@property(nonatomic,copy)NSString *timeCreated;//创建时间

@property(nonatomic,copy)NSString *timeChanged;//改变时间

@property(nonatomic,copy)NSString *timeReceived;//收到时间

@property(nonatomic,copy)NSString *assignedUserId;//分配用户id

@property(nonatomic,copy)NSString *assignedUserLoginName;//分配用户登录名

@property(nonatomic,copy)NSString *assignedUserName;//分配用户名称

@property(nonatomic,copy)NSString *readFlag;//0 未读 1 已读

@property(nonatomic,copy)NSString *readDate;




@end
