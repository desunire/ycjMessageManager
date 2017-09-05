//
//  AppDelegate.m
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavgationViewController.h"
#import "ViewController.h"
#import "IndexViewController.h"
#import <UserNotifications/UserNotifications.h>
#define JPushAppId @"3af91e4e7d054f39b8f22bec"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseNavgationViewController *vc;
    if ([self isLoadSystem]) {
        UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IndexViewController *vcc =[main instantiateViewControllerWithIdentifier:@"Index"];
        vc =[[BaseNavgationViewController alloc] initWithRootViewController:vcc];
    }
    else{
        UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *vcc =[main instantiateViewControllerWithIdentifier:@"loadView"];
        vc =[[BaseNavgationViewController alloc] initWithRootViewController:vcc];
    }
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    [self setJPush:launchOptions];
    return YES;
}


#pragma mark 极光推送设置
//设置极光推送
-(void)setJPush:(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppId
                          channel:@"app store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [self registerAPNs];
    NSLog(@"registrationID:%@",[JPUSHService registrationID]);
    
}


- (void)registerAPNs
{
    //iOS 10  设置授权能访问
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"setting:%@",settings);
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];  // ios
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [JPUSHService handleRemoteNotification:userInfo];
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    //    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //        [JPUSHService handleRemoteNotification:userInfo];
    //    }
    //    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        /// iOS10处理远程推送
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
        
    }else{
        /// iOS10处理本地通知 添加到通知栏 ==============================
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    }
    
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{    
    NSLog(@"成功");
    NSLog(@"My token is: %@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];//注册设备token 这行代码很重要啊；
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"失败");
}

#pragma mark 用户是否登录判断
-(BOOL)isLoadSystem{
    
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
   
    NSLog(@"%@...%@",[userDefault valueForKey:@"name"],[userDefault valueForKey:@"pwd"]);
    if ([userDefault valueForKey:@"name"]&&[userDefault valueForKey:@"pwd"]) {
        return true;
    }
    return  false;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //进入系统后设置角标为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; //清除角标
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
