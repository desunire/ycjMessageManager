//
//  SettingViewController.h
//  messageManager
//
//  Created by desunire on 2017/8/28.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
- (IBAction)quitLoad:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
