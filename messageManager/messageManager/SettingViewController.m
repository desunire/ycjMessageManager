//
//  SettingViewController.m
//  messageManager
//
//  Created by desunire on 2017/8/28.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "SettingViewController.h"
#import "LMJDropdownMenu.h"
@interface SettingViewController ()<LMJDropdownMenuDelegate>

@property(strong,nonatomic)NSArray *pushType;//推送类型

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pushType=@[@"全部",@"严重",@"重大",@"轻微",@"警告",@"正常",@"未知"];
    
    LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:CGRectMake(90, 64, [UIScreen mainScreen].bounds.size.width-90, 60)];
    [dropdownMenu setMenuTitles:self.pushType rowHeight:30];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *title=@"全部";//默认是
    if ([userDefault valueForKey:@"pushType"]) {
        title=[userDefault valueForKey:@"pushType"];
    }
    [dropdownMenu setmainBtnTitle:title];
    dropdownMenu.delegate = self;
    [self.backView addSubview:dropdownMenu];
    self.quitBtn.layer.masksToBounds=YES;
    self.quitBtn.layer.cornerRadius=5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏标题字体颜色
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 导航栏左右按钮字体颜色
    
    self.navigationController.navigationBar.tintColor =
    [UIColor whiteColor];
    
    self.navigationItem.title = @"设置";
}

-(void)setPushTypeNet:(NSInteger)index{
    
    /**
     pushType：
     all 全部
     critical 严重
     major 重大
     minor 轻微
     warning 警告
     normal 正常
     unknown 未知
    */
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *name=[userDefault valueForKey:@"name"];
    NSString *pwd=[userDefault valueForKey:@"pwd"];
    NSString *pushType;
    if (index==0) {
        pushType=@"all";
    }if (index==1) {
        pushType=@"critical";
    }if (index==2) {
        pushType=@"major";
    }if (index==3) {
        pushType=@"minor";
    }if (index==4) {
        pushType=@"warning";
    }if (index==5) {
        pushType=@"normal";
    }if (index==6) {
        pushType=@"unknown";
    }
    [SVProgressHUD show];
    NSDictionary *pare=@{@"loginName":name,@"password":pwd,@"pushType":pushType};
//    [[HttpRequest sharedInstance] postWithURLString:@"http://192.168.1.139:8088/tour/a/sys/user/setPushType" parameters:pare success:^(id responseObject) {
//        NSDictionary *dic=responseObject;
//        NSLog(@"dic%@",dic);
//        if ([[dic valueForKey:@"success"] boolValue]) {
//            //本地缓存上次选择的推送类型
//            [[NSUserDefaults standardUserDefaults] setObject:[self.pushType objectAtIndex:index] forKey:@"pushType"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [SVProgressHUD dismiss];
//        }
//        else{
//            [self show:@"设置失败"];
//        }
//        
//    } failure:^(NSError *error) {
//        [self show:@"网络异常,操作失败"];
//
//    }];
    
    
    [[YCJHttpRequest sharedInstance] setPushType:pare complete:^(NSError *error, BOOL isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            //本地缓存上次选择的推送类型
            [[NSUserDefaults standardUserDefaults] setObject:[self.pushType objectAtIndex:index] forKey:@"pushType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            if (error) {
                [self show:@"网络异常,操作失败"];
            }else{
                [self show:@"设置失败"];
            }
        }
    }];
}

//登录页面提示
-(void)show:(NSString *)title{
    [SVProgressHUD showWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    //设置推送类型
    [self setPushTypeNet:number];
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}
//退出登录
- (IBAction)quitLoad:(id)sender {
    
    //弹出确认框
    UIAlertController *vc=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"绑定和解绑rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
        }];
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"pwd"];
        UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *vcc =[main instantiateViewControllerWithIdentifier:@"loadView"];
        [self.navigationController pushViewController:vcc animated:YES];
    }];
    
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:sure];
    [vc addAction:cancel];
    [self presentViewController:vc animated:YES completion:nil];
   
}
@end
