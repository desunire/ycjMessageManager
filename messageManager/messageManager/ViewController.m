//
//  ViewController.m
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "ViewController.h"
#import "IndexViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
   
    self.userImageView.layer.cornerRadius = 50;
    self.userImageView.layer.masksToBounds = YES;
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    if ([userDefault valueForKey:@"name"]) {
        self.nameTextField.text=[userDefault valueForKey:@"name"];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loadSystem:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    if (![self.nameTextField.text isEqualToString:@""]&&![self.pwdTextField.text isEqualToString:@""]) {
        [SVProgressHUD show];
        NSDictionary *para=@{@"loginName":self.nameTextField.text,@"password":self.pwdTextField.text};
        NSLog(@"%@",para);
//        [[HttpRequest sharedInstance] postWithURLString:@"http://192.168.1.250:8089/login" parameters:para success:^(id responseObject) {
//            NSDictionary *dic=responseObject;
//            [SVProgressHUD dismiss];
//            if ([[dic valueForKey:@"success"] boolValue]) {
//                        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//                        [userDefault setObject:self.nameTextField.text forKey:@"name"];
//                        [userDefault setObject:self.pwdTextField.text forKey:@"pwd"];
//                        [userDefault synchronize];
//                
//                        //设置极光推送的alias
//                NSSet *set=[NSSet setWithObject:@"user"];
//                [JPUSHService setTags:set alias:self.nameTextField.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                    NSLog(@">>>>>%d??%@??%@",iResCode,iTags,iAlias);
//                    
//                }];
//                
//                        UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        IndexViewController *vcc =[main instantiateViewControllerWithIdentifier:@"Index"];
//                        [self.navigationController pushViewController:vcc animated:YES];
//            }else{
//                [self show:@"用户名或密码错误"];
//            }
//            
//        } failure:^(NSError *error) {
//            [self show:@"网络异常,登录失败"];
//        }];
        
        
        [[YCJHttpRequest sharedInstance] loadSystem:para complete:^(BOOL isSuccess) {
            [SVProgressHUD dismiss];
            if (isSuccess) {
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault setObject:self.nameTextField.text forKey:@"name"];
                [userDefault setObject:self.pwdTextField.text forKey:@"pwd"];
                [userDefault synchronize];
                //设置极光推送的alias
                NSSet *set=[NSSet setWithObject:@"user"];
                [JPUSHService setTags:set alias:self.nameTextField.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    NSLog(@">>>>>%d??%@??%@",iResCode,iTags,iAlias);
                    
                }];
                
                UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                IndexViewController *vcc =[main instantiateViewControllerWithIdentifier:@"Index"];
                [self.navigationController pushViewController:vcc animated:YES];
            }else{
                [self show:@"登录失败"];
            }
            
        }];
    }else{
        [self show:@"请完善信息"];
    }
    
}


//登录页面提示
-(void)show:(NSString *)title{
    [SVProgressHUD showWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
     [self.nameTextField resignFirstResponder];
     [self.pwdTextField resignFirstResponder];
}
@end
