//
//  ProcessitemTableViewCell.h
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessitemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;

-(void)initCellWithTitle:(NSString *)title andContent:(NSString *)content;

@end
