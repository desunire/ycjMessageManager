//
//  ProcessitemTableViewCell.m
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "ProcessitemTableViewCell.h"

@implementation ProcessitemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initCellWithTitle:(NSString *)title andContent:(NSString *)content{
    
    self.titleLabel.text = title;
    
    self.contentlabel.text = content;
    
     float height = [[SCJToolManager setInstance] autoCalculateWidthOrHeight:MAXFLOAT width:SCREEN_WIDTH fontsize:17.0 content:content];
    //设置frame
    if (height>44-20) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+20);
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }
}

@end
