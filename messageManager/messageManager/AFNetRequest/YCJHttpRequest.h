//
//  YCJHttpRequest.h
//  messageManager
//
//  Created by desunire on 2017/9/1.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "httpRequest.h"

@interface YCJHttpRequest : HttpRequest

//获取首页的数据
-(void)getIndexWebData:(NSDictionary*)parameters complete:(void(^)(NSArray *response,BOOL isSuccess))complete;

//获取每个具体消息的详情
-(void)getMessageDetail:(NSString *)messageId complete:(void(^)(MessageObject *object,BOOL isSuccess))complete;

//登录系统
-(void)loadSystem:(NSDictionary*)parameters complete:(void(^)(BOOL isSuccess))complete;

//更新消息状态
-(void)updateMessageState:(NSDictionary*)parameters complete:(void(^)(NSError* error,BOOL isSuccess))complete;


//设置推送类型
-(void)setPushType:(NSDictionary*)parameters complete:(void(^)(NSError* error,BOOL isSuccess))complete;

//获取流程消息列表
-(void)getProcessList:(NSDictionary*)parameters complete:(void(^)(NSArray *response,BOOL isSuccess))complete;

//获取流程消息详情
//-(void)getProcessDetail:(NSString *)messageId complete:(void(^)(MessageObject *object,BOOL isSuccess))complete;

//流程消息获取详情
/*
 <string name="getProblem">/getProblem</string>
 <string name="getIncident">/getIncident</string>
 <string name="getChange">/getChange</string>
 <string name="getApproval">/getApproval</string>
 <string name="getInteraction">/getInteraction</string>
 <string name="getRequest">/getRequest</string>
 */
-(void)getProblemDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;

-(void)getIncidentDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;

-(void)getChangeDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;

-(void)getApprovalDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;

-(void)getInteractionDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;

-(void)getRequestDetail:(NSDictionary*)parameters complete:(void(^)(NSDictionary *response,BOOL isSuccess))complete;


//更新流程消息为已读
-(void)updateProcessMessageState:(NSDictionary*)parameters complete:(void(^)(NSError* error,BOOL isSuccess))complete;

@end
