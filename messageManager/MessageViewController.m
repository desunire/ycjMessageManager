
//
//  MessageViewController.m
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *processDetailDic;

@property(nonatomic,strong)MessageObject *messageObject;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //设置消息为已读
    //查看消息详情
    //[self lookMessageDetail];
    //[self setMessageRead];
}


-(void)lookMessageDetail{
    
//    NSDictionary *pare=@{@"id":self.object.ID};
//    [[HttpRequest sharedInstance] postWithURLString:@"http://192.168.1.139:8088/tour/a/sys/user/getEvent" parameters:pare success:^(id responseObject) {
//        NSDictionary *dic=responseObject;
//        NSLog(@"%@",dic);
//    } failure:^(NSError *error) {
//        
//    }];
    
    [[YCJHttpRequest sharedInstance] getMessageDetail:self.object.ID complete:^(MessageObject *object, BOOL isSuccess) {
        
        self.messageObject = object;
        [self.tableView reloadData];
        
    }];
    
}


//设置告警消息为已读
-(void)setMessageRead{
    
    NSDictionary *pare=@{@"id":self.object.ID};
    
    [[YCJHttpRequest sharedInstance] updateMessageState:pare complete:^(NSError *error, BOOL isSuccess) {
       
        if (isSuccess) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(changeMessageState:andId:)]) {
                [self.delegate changeMessageState:@"1" andId:self.object.ID];
            }
        }
    }];
    
}


//设置流程消息为已读
-(void)setprocessRead{
    NSDictionary *pare=@{@"id":[self.processDic valueForKey:@"id"]};
    
    [[YCJHttpRequest sharedInstance] updateProcessMessageState:pare complete:^(NSError *error, BOOL isSuccess) {
        
        if (isSuccess) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(changeProcessMessageState:andId:)]) {
                [self.delegate changeProcessMessageState:@"1" andId:[self.processDic valueForKey:@"id"]];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //导航栏背景色
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault]; 
    
    // 导航栏标题字体颜色
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 导航栏左右按钮字体颜色
    
    self.navigationController.navigationBar.tintColor =
    [UIColor whiteColor];
    
    
}

-(void)setUI{
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    if (self.object) {
        self.navigationItem.title = @"消息详情";
        [self lookMessageDetail];
        if ([self.object.readFlag integerValue] == 0) {
            [self setMessageRead];
        }
    }else if (self.processDic){
        //设置消息为已读
        if ([[self.processDic valueForKey:@"readFlag"] integerValue] ==0) {
            [self setprocessRead];
        }
        NSDictionary *pare = @{@"id":[self.processDic valueForKey:@"id"]};
        //获取详情
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"problem"]) {
            self.navigationItem.title = @"问题事件流程";
            [[YCJHttpRequest sharedInstance] getProblemDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
            
        }else if ([[self.processDic valueForKey:@"type"] isEqualToString:@"incident"]){
            [[YCJHttpRequest sharedInstance] getIncidentDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
                self.navigationItem.title = @"突发事件流程";
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
        }else if ([[self.processDic valueForKey:@"type"] isEqualToString:@"interaction"]){
            [[YCJHttpRequest sharedInstance] getInteractionDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
                self.navigationItem.title = @"交互事件流程";
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
        }else if ([[self.processDic valueForKey:@"type"] isEqualToString:@"change"]){
            [[YCJHttpRequest sharedInstance] getChangeDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
                self.navigationItem.title = @"变更事件流程";
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
        }else if ([[self.processDic valueForKey:@"type"] isEqualToString:@"approval"]){
            [[YCJHttpRequest sharedInstance] getApprovalDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
                self.navigationItem.title = @"审批事件流程";
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
        }else if ([[self.processDic valueForKey:@"type"] isEqualToString:@"request"]){
            [[YCJHttpRequest sharedInstance] getRequestDetail:pare complete:^(NSDictionary *response, BOOL isSuccess) {
               self.navigationItem.title = @"请求事件流程";
                self.processDetailDic = [NSMutableDictionary dictionaryWithDictionary:response];
                [self.tableView reloadData];
            }];
        }
    }
    
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.messageObject) {
        return 8;
    }
    else if(self.processDic){
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"incident"] && self.processDetailDic) {
            return 9;
        }
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"change"] && self.processDetailDic) {
            return 7;
        }
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"problem"] && self.processDetailDic) {
            return 8;
        } if ([[self.processDic valueForKey:@"type"] isEqualToString:@"request"] && self.processDetailDic) {
            return 9;
        } if ([[self.processDic valueForKey:@"type"] isEqualToString:@"approval"] && self.processDetailDic) {
            return 7;
        }
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"interaction"] && self.processDetailDic) {
            return 9;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
    if (self.messageObject) {
        [self setMessageContent:indexPath.row andCell:cell];
        return cell;
    }
    else if (self.processDic){
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"incident"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setIncidentProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }if ([[self.processDic valueForKey:@"type"] isEqualToString:@"change"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setChangeProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }if ([[self.processDic valueForKey:@"type"] isEqualToString:@"problem"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setProblemProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }if ([[self.processDic valueForKey:@"type"] isEqualToString:@"request"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setRequestProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }if ([[self.processDic valueForKey:@"type"] isEqualToString:@"approval"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setApprovalProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }
        if ([[self.processDic valueForKey:@"type"] isEqualToString:@"interaction"]) {
            ProcessitemTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProcessitemTableViewCell class]) owner:self options:nil] lastObject];
            [self setInteractionProcesscontent:indexPath.row andCell:cell];
            return  cell;
        }
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{        ProcessitemTableViewCell *cell = (ProcessitemTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark 流程消息设置内容
-(void)setIncidentProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"标题:" andContent:[self.processDetailDic valueForKey:@"title"]];
    } else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    } else  if (index==2) {
        [cell initCellWithTitle:@"阶段:" andContent:[self.processDetailDic valueForKey:@"phase"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"优先级:" andContent:[self getStatus:[self.processDetailDic valueForKey:@"priority"]]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"受理人:" andContent:[self.processDetailDic valueForKey:@"assignee"]];
    }else  if (index==5) {
        [cell initCellWithTitle:@"打开人:" andContent:[self.processDetailDic valueForKey:@"openedBy"]];
    }else  if (index==6) {
        [cell initCellWithTitle:@"服务:" andContent:[self.processDetailDic valueForKey:@"service"]];
    }else  if (index==7) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }else  if (index==8) {
        [cell initCellWithTitle:@"描述:" andContent:[self.processDetailDic valueForKey:@"description"]];
    }
}

-(void)setInteractionProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"标题:" andContent:[self.processDetailDic valueForKey:@"title"]];
    } else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    } else  if (index==2) {
        [cell initCellWithTitle:@"阶段:" andContent:[self.processDetailDic valueForKey:@"phase"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"优先级:" andContent:[self getStatus:[self.processDetailDic valueForKey:@"priority"]]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"呼叫人:" andContent:[self.processDetailDic valueForKey:@"callOwner"]];
    }else  if (index==5) {
        [cell initCellWithTitle:@"收件人:" andContent:[self.processDetailDic valueForKey:@"serviceRecipient"]];
    }else  if (index==6) {
        [cell initCellWithTitle:@"影响服务:" andContent:[self.processDetailDic valueForKey:@"affectedService"]];
    }else  if (index==7) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }else  if (index==8) {
        [cell initCellWithTitle:@"描述:" andContent:[self.processDetailDic valueForKey:@"description"]];
    }
}

-(void)setApprovalProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"类型:" andContent:[self.processDetailDic valueForKey:@"type"]];
    } else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    } else  if (index==2) {
        [cell initCellWithTitle:@"分组:" andContent:[self.processDetailDic valueForKey:@"groups"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"文件名:" andContent:[self.processDetailDic valueForKey:@"fileName"]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"请求人:" andContent:[self.processDetailDic valueForKey:@"requestedBy"]];
    }else  if (index==5) {
        [cell initCellWithTitle:@"排序:" andContent:[self.processDetailDic valueForKey:@"sequence"]];
    }else  if (index==6) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }
}


-(void)setRequestProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"标题:" andContent:[self.processDetailDic valueForKey:@"title"]];
    }else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    }else  if (index==2) {
        [cell initCellWithTitle:@"验收状态:" andContent:[self.processDetailDic valueForKey:@"approvalStatus"]];
    }else  if (index==2) {
        [cell initCellWithTitle:@"阶段:" andContent:[self.processDetailDic valueForKey:@"phase"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"优先级:" andContent:[self getStatus:[self.processDetailDic valueForKey:@"priority"]]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"受理人:" andContent:[self.processDetailDic valueForKey:@"assignedTo"]];
    }else  if (index==6) {
        [cell initCellWithTitle:@"分类:" andContent:[self.processDetailDic valueForKey:@"category"]];
    }else  if (index==7) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }else  if (index==8) {
        [cell initCellWithTitle:@"描述:" andContent:[self.processDetailDic valueForKey:@"description"]];
    }
}


-(void)setChangeProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"标题:" andContent:[self.processDetailDic valueForKey:@"title"]];
    } else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    } else  if (index==2) {
        [cell initCellWithTitle:@"阶段:" andContent:[self.processDetailDic valueForKey:@"phase"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"优先级:" andContent:[self getStatus:[self.processDetailDic valueForKey:@"priority"]]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"创建人:" andContent:[self.processDetailDic valueForKey:@"initiatedBy"]];
    }else  if (index==5) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }else  if (index==6) {
        [cell initCellWithTitle:@"描述:" andContent:[self.processDetailDic valueForKey:@"description"]];
    }
}


-(void)setProblemProcesscontent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        [cell initCellWithTitle:@"标题:" andContent:[self.processDetailDic valueForKey:@"title"]];
    } else  if (index==1) {
        [cell initCellWithTitle:@"状态:" andContent:[self.processDetailDic valueForKey:@"status"]];
    } else  if (index==2) {
        [cell initCellWithTitle:@"阶段:" andContent:[self.processDetailDic valueForKey:@"phase"]];
    } else  if (index==3) {
        [cell initCellWithTitle:@"优先级:" andContent:[self getStatus:[self.processDetailDic valueForKey:@"priority"]]];
    }else  if (index==4) {
        [cell initCellWithTitle:@"受理人:" andContent:[self.processDetailDic valueForKey:@"assignee"]];
    }else  if (index==5) {
        [cell initCellWithTitle:@"服务:" andContent:[self.processDetailDic valueForKey:@"service"]];
    }else  if (index==6) {
        NSString *openTime = [NSString stringWithFormat:@"%@",[self.processDetailDic valueForKey:@"openTime"]];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"时间:" andContent:openTime];
    }else  if (index==7) {
        [cell initCellWithTitle:@"描述:" andContent:[self.processDetailDic valueForKey:@"description"]];
    }
}

/**
 "1 - 严重", "2 - 高", "3 - 一般", "4 - 低"
 */
-(NSString *)getStatus:(NSString *)status{
    
    if ([status integerValue] == 1) {
        return @"严重";
    }
    if ([status integerValue] == 2) {
        return @"高";
    }
    if ([status integerValue] == 3) {
        return @"一般";
    }
    if ([status integerValue] == 4) {
        return @"低";
    }
    return nil;
}

-(NSMutableAttributedString *)setAttributeString:(NSString *)string andRange:(NSRange)range{
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    // 改变颜色
    //[noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:range];
    return noteStr;
    
}
//告警消息设置内容
-(NSMutableAttributedString *)setCellTextWithIndex:(NSInteger)index{
        if (index==0){
            NSString *flag;
            if ([self.object.severity isEqualToString:@"critical"]) {
                flag=@"严重";
            }else if ([self.object.severity isEqualToString:@"major"]){
                flag=@"重大";
            }else if ([self.object.severity isEqualToString:@"minor"]){
                flag=@"轻微";
            }else if ([self.object.severity isEqualToString:@"warning"]){
                flag=@"警告";
            }else if ([self.object.severity isEqualToString:@"normal"]){
                flag=@"正常";
            }else if ([self.object.severity isEqualToString:@"unknown"]){
                flag=@"未知";
            }
        NSString *str=[NSString stringWithFormat:@"严重性:%@",flag];
        return [self setAttributeString:str andRange:NSMakeRange(0, 4)];
    }
    else if (index==1){
        NSString *flag;
        if ([self.object.state isEqualToString:@"open"]) {
            flag=@"未处理";
        }else if ([self.object.state isEqualToString:@"in progress"]){
            flag=@"进行中";
        }else if ([self.object.state isEqualToString:@"resolved"]){
            flag=@"已解决";
        }else if ([self.object.state isEqualToString:@"close"]){
            flag=@"已关闭";
        }
        NSString *str=[NSString stringWithFormat:@"状态:%@",flag];
       return [self setAttributeString:str andRange:NSMakeRange(0, 3)];
    }
    else if (index==2){
        NSString *flag;
        if ([self.object.priority isEqualToString:@"lowest"]) {
            flag=@"最低";
        }else if ([self.object.priority isEqualToString:@"low"]){
            flag=@"低";
        }else if ([self.object.priority isEqualToString:@"medium"]){
            flag=@"中";
        }else if ([self.object.priority isEqualToString:@"high"]){
            flag=@"高";
        }else if ([self.object.priority isEqualToString:@"highest"]){
            flag=@"最高";
        }else if ([self.object.priority isEqualToString:@"none"]){
            flag=@"无";
        }
        NSString *str=[NSString stringWithFormat:@"优先级:%@",flag];
       return [self setAttributeString:str andRange:NSMakeRange(0, 4)];
    }
    else if (index==3){
        NSString *str=[NSString stringWithFormat:@"分配用户:%@",self.object.assignedUserLoginName];
       return [self setAttributeString:str andRange:NSMakeRange(0, 5)];
    }
    else if (index==4){
        NSString *str=[NSString stringWithFormat:@"创建时间:%@",self.object.timeCreated];
        return [self setAttributeString:str andRange:NSMakeRange(0, 5)];
    }
    else if (index==5){
        NSString *str=[NSString stringWithFormat:@"接收时间:%@",self.object.timeReceived];
        return [self setAttributeString:str andRange:NSMakeRange(0, 5)];
    }
    else if (index==6){
        NSString *str=[NSString stringWithFormat:@"变更时间:%@",self.object.timeChanged];
       return [self setAttributeString:str andRange:NSMakeRange(0, 5)];    }
    else if (index==7){
        NSString *str=[NSString stringWithFormat:@"标题:%@",self.object.title];
        return [self setAttributeString:str andRange:NSMakeRange(0, 3)];
    }
    return nil;
}


-(void)setMessageContent:(NSInteger)index andCell:(ProcessitemTableViewCell *)cell{
    if (index==0) {
        NSString *flag;
        if ([self.messageObject.severity isEqualToString:@"critical"]) {
            flag=@"严重";
        }else if ([self.messageObject.severity isEqualToString:@"major"]){
            flag=@"重大";
        }else if ([self.messageObject.severity isEqualToString:@"minor"]){
            flag=@"轻微";
        }else if ([self.messageObject.severity isEqualToString:@"warning"]){
            flag=@"警告";
        }else if ([self.messageObject.severity isEqualToString:@"normal"]){
            flag=@"正常";
        }else if ([self.messageObject.severity isEqualToString:@"unknown"]){
            flag=@"未知";
        }
        [cell initCellWithTitle:@"严重性:" andContent:flag];
    } else  if (index==1) {
        NSString *flag;
        if ([self.messageObject.state isEqualToString:@"open"]) {
            flag=@"未处理";
        }else if ([self.messageObject.state isEqualToString:@"in progress"]){
            flag=@"进行中";
        }else if ([self.messageObject.state isEqualToString:@"resolved"]){
            flag=@"已解决";
        }else if ([self.messageObject.state isEqualToString:@"close"]){
            flag=@"已关闭";
        }
        [cell initCellWithTitle:@"状态:" andContent:flag];
    } else  if (index==2) {
        NSString *flag;
        if ([self.messageObject.priority isEqualToString:@"lowest"]) {
            flag=@"最低";
        }else if ([self.messageObject.priority isEqualToString:@"low"]){
            flag=@"低";
        }else if ([self.messageObject.priority isEqualToString:@"medium"]){
            flag=@"中";
        }else if ([self.messageObject.priority isEqualToString:@"high"]){
            flag=@"高";
        }else if ([self.messageObject.priority isEqualToString:@"highest"]){
            flag=@"最高";
        }else if ([self.messageObject.priority isEqualToString:@"none"]){
            flag=@"无";
        }
        [cell initCellWithTitle:@"优先级:" andContent:flag];
    } else  if (index==3) {
        [cell initCellWithTitle:@"分配用户:" andContent:self.messageObject.assignedUserLoginName];
    }else  if (index==4) {
        //[cell initCellWithTitle:@"创建时间:" andContent:[self.processDetailDic valueForKey:@"assignee"]];
        NSString *openTime = [NSString stringWithFormat:@"%@",self.messageObject.timeCreated];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"创建时间:" andContent:openTime];
    }else  if (index==5) {
       // [cell initCellWithTitle:@"接收时间:" andContent:[self.processDetailDic valueForKey:@"service"]];
        NSString *openTime = [NSString stringWithFormat:@"%@",self.messageObject.timeReceived];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"接收时间:" andContent:openTime];
    }else  if (index==6) {
        NSString *openTime = [NSString stringWithFormat:@"%@",self.messageObject.timeChanged];
        openTime = [openTime ConvertStrToTime:openTime andFormat:@"yyyy-MM-dd HH:mm:ss"];
        [cell initCellWithTitle:@"变更时间:" andContent:openTime];
    }else  if (index==7) {
        [cell initCellWithTitle:@"标题:" andContent:self.messageObject.title];
    }
}

@end
