//
//  MessageTableViewCell.m
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.masksToBounds=YES;
    self.backView.layer.borderWidth=0.5;
    self.backView.layer.cornerRadius = 10;
    self.timeLabel.layer.masksToBounds=YES;
    self.timeLabel.layer.cornerRadius=5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithModel:(MessageObject *)object{
    
    self.timeLabel.text=[object.timeCreated ConvertStrToTime:object.timeCreated andFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.messageLabel.text=object.title;
    
    float height = [[SCJToolManager setInstance] autoCalculateWidthOrHeight:MAXFLOAT width:SCREEN_WIDTH fontsize:15.0 content:object.title];
    
    self.timeLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, height+kltopHeight);
    
    self.severitylabel.frame = CGRectMake(10, 15+height+kltopHeight, SCREEN_WIDTH-40, 20);
    
    if ([object.readFlag isEqualToString:@"1"]) {
        self.unreadImageView.hidden=YES;
    }    
    NSString *flag;
    if ([object.severity isEqualToString:@"critical"]) {
        flag=@"严重";
    }else if ([object.severity isEqualToString:@"major"]){
        flag=@"重大";
    }else if ([object.severity isEqualToString:@"minor"]){
        flag=@"轻微";
    }else if ([object.severity isEqualToString:@"warning"]){
        flag=@"警告";
    }else if ([object.severity isEqualToString:@"normal"]){
        flag=@"正常";
    }else if ([object.severity isEqualToString:@"unknown"]){
        flag=@"未知";
    }
    self.severitylabel.text=[NSString stringWithFormat:@"严重性:%@",flag];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 90.0+kltopHeight);
}

-(void)initWithProcessObject:(NSDictionary *)object{
    
    
    
    self.timeLabel.text=[@"" ConvertStrToTime:[object valueForKey:@"timeCreated"] andFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.messageLabel.text=[object valueForKey:@"title"];
    
    float height = [[SCJToolManager setInstance] autoCalculateWidthOrHeight:MAXFLOAT width:SCREEN_WIDTH fontsize:15.0 content:[object valueForKey:@"title"]];
    
    self.timeLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, height+kltopHeight);
    
    self.severitylabel.frame = CGRectMake(10, 15+height+kltopHeight, SCREEN_WIDTH-40, 20);
    
    if ([[object valueForKey:@"readFlag"] isEqualToString:@"1"]) {
        self.unreadImageView.hidden=YES;
    }
    NSString *flag;
    if ([[object valueForKey:@"type"] isEqualToString:@"problem"]) {
        flag=@"问题事件";
    }else if ([[object valueForKey:@"type"] isEqualToString:@"incident"]){
        flag=@"突发事件";
    }else if ([[object valueForKey:@"type"] isEqualToString:@"interaction"]){
        flag=@"交互事件";
    }else if ([[object valueForKey:@"type"] isEqualToString:@"change"]){
        flag=@"变更事件";
    }else if ([[object valueForKey:@"type"] isEqualToString:@"approval"]){
        flag=@"审批事件";
    }else if ([[object valueForKey:@"type"] isEqualToString:@"request"]){
        flag=@"请求事件";
    }
    self.severitylabel.text=[NSString stringWithFormat:@"类型:%@",flag];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 90.0+kltopHeight);
    
}

@end
