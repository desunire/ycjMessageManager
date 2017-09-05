//
//  MessageViewController.h
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageViewControllerDelegate <NSObject>

-(void)changeMessageState:(NSString *)flag andId:(NSString *)ID;

-(void)changeProcessMessageState:(NSString *)flag andId:(NSString *)ID;

@end

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)MessageObject *object;

@property(strong,nonatomic)NSDictionary *processDic;

@property(weak,nonatomic)id <MessageViewControllerDelegate>delegate;

@end
