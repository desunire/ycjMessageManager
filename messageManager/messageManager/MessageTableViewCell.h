//
//  MessageTableViewCell.h
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kltopHeight 20

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *unreadImageView;
@property (weak, nonatomic) IBOutlet UILabel *severitylabel;

-(void)initWithModel:(MessageObject *)object;

-(void)initWithProcessObject:(NSDictionary *)object;

@end
