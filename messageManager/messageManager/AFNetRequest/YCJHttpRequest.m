//
//  YCJHttpRequest.m
//  messageManager
//
//  Created by desunire on 2017/9/1.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "YCJHttpRequest.h"

@implementation YCJHttpRequest

-(void)getIndexWebData:(NSDictionary *)parameters complete:(void (^)(NSArray *, BOOL))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@/eventList",serverUrl];
    NSArray *back = [NSArray array];
    
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    //NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        //NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSArray *data=[NSArray arrayWithArray:[[dic valueForKey:@"body"] valueForKey:@"list"]];
            complete(data,true);
        }else{
            complete(back,false);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        complete(back,false);
        
    }];
    
}

/**
 <string name="getProcessList">/processList</string>
 <string name="updateProcessReadFlag">/updateProcessReadFlag</string>
 <string name="getProblem">/getProblem</string>
 <string name="getIncident">/getIncident</string>
 <string name="getChange">/getChange</string>
 <string name="getApproval">/getApproval</string>
 <string name="getInteraction">/getInteraction</string>
 <string name="getRequest">/getRequest</string>
 */
//获取流程消息列表
-(void)getProcessList:(NSDictionary*)parameters complete:(void(^)(NSArray *response,BOOL isSuccess))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/processList",serverUrl];
    NSArray *back = [NSArray array];
    
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSArray *data=[NSArray arrayWithArray:[[dic valueForKey:@"body"] valueForKey:@"list"]];
            complete(data,true);
        }else{
            complete(back,false);
        }
        
    } failure:^(NSError *error) {
        complete(back,false);
        
    }];
}




//获取某一个消息详情
-(void)getMessageDetail:(NSString *)messageId complete:(void (^)(MessageObject *,BOOL))complete{

    NSString *urlString = [NSString stringWithFormat:@"%@/getEvent",serverUrl];
    NSDictionary *para = [NSDictionary dictionaryWithObject:messageId forKey:@"id"];
    
//    NSArray *back = [NSArray array];
//    
//    //保证已经登陆过系统
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//    
//    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    
//    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            MessageObject *message=[MessageObject mj_objectWithKeyValues:[[dic valueForKey:@"body"] valueForKey:@"event"]];
            complete(message,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
    
}


-(void)loadSystem:(NSDictionary *)parameters complete:(void (^)(BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/login",serverUrl];
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:parameters success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        if ([[dic valueForKey:@"success"] boolValue]) {
            complete(true);
        }else{
            complete(false);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        complete(false);
    }];
}

-(void)updateMessageState:(NSDictionary *)parameters complete:(void (^)(NSError *, BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/updateReadFlag",serverUrl];
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:parameters success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        if ([[dic valueForKey:@"success"] boolValue]) {
            complete(nil,true);
        }else{
            complete(nil,false);
        }
    } failure:^(NSError *error) {
         complete(error,false);
    }];
    
}

//更新流程消息为已读
-(void)updateProcessMessageState:(NSDictionary*)parameters complete:(void(^)(NSError* error,BOOL isSuccess))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@/updateProcessReadFlag",serverUrl];
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:parameters success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        if ([[dic valueForKey:@"success"] boolValue]) {
            complete(nil,true);
        }else{
            complete(nil,false);
        }
    } failure:^(NSError *error) {
        complete(error,false);
    }];
}

//设置推送类型
-(void)setPushType:(NSDictionary *)parameters complete:(void (^)(NSError *, BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/setPushType",serverUrl];
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:parameters success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        if ([[dic valueForKey:@"success"] boolValue]) {
            complete(nil,true);
        }
        else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
       complete(error,false);
    }];
}

//获取问题事件详情流程
-(void)getProblemDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/getProblem",serverUrl];
    
    
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"problem"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
    
}

//获取突发事件详情流程
-(void)getIncidentDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@/getIncident",serverUrl];
      //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"incident"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
}

-(void)getChangeDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/getChange",serverUrl];
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"change"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
}


-(void)getRequestDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/getRequest",serverUrl];
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"request"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
}

-(void)getInteractionDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@/getInteraction",serverUrl];
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"interaction"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
}

-(void)getApprovalDetail:(NSDictionary *)parameters complete:(void (^)(NSDictionary *, BOOL))complete{
    NSString *urlString = [NSString stringWithFormat:@"%@/getApproval",serverUrl];
    //保证已经登陆过系统
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [para setObject:[userDefault valueForKey:@"name"] forKey:@"loginName"];
    
    NSLog(@"请求参数%@",para);
    
    [[HttpRequest sharedInstance] postWithURLString:urlString parameters:para success:^(id responseObject) {
        NSDictionary *dic=responseObject;
        NSLog(@"%@",dic);
        if ([[dic valueForKey:@"success"] boolValue]) {
            NSDictionary *data=[NSDictionary dictionaryWithDictionary:[[dic valueForKey:@"body"] valueForKey:@"approval"]];
            complete(data,true);
        }else{
            complete(nil,false);
        }
        
    } failure:^(NSError *error) {
        complete(nil,false);
        
    }];
}

@end
