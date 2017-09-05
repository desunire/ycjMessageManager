//
//  IndexViewController.m
//  messageManager
//
//  Created by desunire on 2017/8/25.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "IndexViewController.h"
#import "ViewController.h"
#import "MessageTableViewCell.h"
#import "MJRefresh.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "SCJChangeItemView.h"
@interface IndexViewController ()
<UITableViewDelegate,UITableViewDataSource,MessageViewControllerDelegate,SCJDropDownMultiSelectMenuDelegate,SCJChangeItemViewDelegate>

@property(strong,nonatomic)NSMutableArray *messageListArray;


@property(strong,nonatomic)NSMutableArray *processListArray;


@property(strong,nonatomic)SCJDropDownMultiSelectMenu * dropdownMenu;

@property(strong,nonatomic)UIView *lineView;

//分页的页数
@property(assign,nonatomic)NSInteger pageNo;

//每个分页的size
@property(assign,nonatomic)NSInteger pageSize;

//选择的object
@property(strong,nonatomic)MessageObject *chooseObject;

@property(strong,nonatomic)NSArray *chooseServiety;//选中的严重性

//是否选中了严重性
@property(strong,nonatomic)NSString *severity;


//列表状态 0-告警信息 1-流程消息
@property(assign,nonatomic)NSInteger status;

@property(strong,nonatomic)SCJChangeItemView *topView;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageListArray=[NSMutableArray array];
    
   // self.navigationController.title = @"信息管理平台";
    
    //右边收藏按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initView];
    [self getNetData];
    
}

#pragma mark 网络处理的封装

/**
 首页整个网络请求封装
 @param parameters 网络请求的参数
 @param isSelected 是否是选中报警程度后的网络请求
 @param isPullUp 是否是上拉加载更多
 */
-(void)getWebData:(NSDictionary *)parameters andIsSelected:(BOOL)isSelected andIsPullUp:(BOOL)isPullUp{
    [SVProgressHUD show];
    [[YCJHttpRequest sharedInstance] getIndexWebData:parameters complete:^(NSArray *response, BOOL isSuccess) {
        [SVProgressHUD dismiss];
        //请求成功  //不同情况分别的页面逻辑处理
        if (isSuccess) {
            NSArray *data = response;
            //第一种是上拉加载
            if (isPullUp) {
                for (int i=0; i<data.count; i++) {
                    NSDictionary *dict=[data objectAtIndex:i];
                    MessageObject *message=[MessageObject mj_objectWithKeyValues:dict];
                    [self.messageListArray addObject:message];
                }
                if (data.count<25) {
                    [self.indexTableView.mj_footer setState:MJRefreshStateNoMoreData];
                }else{
                    [self.indexTableView.mj_footer endRefreshing];
                }
                [self.indexTableView reloadData];
            }//第二种选中了报警程度和下拉刷新数据处理是一样的
            else{
                self.messageListArray = [NSMutableArray array];//清空数据
                for (int i=0; i<data.count; i++) {
                    NSDictionary *dict=[data objectAtIndex:i];
                    MessageObject *message=[MessageObject mj_objectWithKeyValues:dict];
                    [self.messageListArray addObject:message];
                }
                [self.indexTableView reloadData];
            }
         }
        //请求失败
        else{
            if(isPullUp) {
                [self.indexTableView.mj_footer endRefreshing];
            }
        }
    }];
}



//下拉刷新数据--第一次加载数据
-(void)getNetData{
    if (self.messageListArray.count==0) {
        self.pageSize=25;
    }else{
        self.pageSize=self.messageListArray.count;
    }
    self.pageNo=1;//重置pageNo
    
    NSDictionary *dic;
    
    if (self.severity) {
        dic = @{@"pageSize":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"pageNo":@"1",@"severity":self.severity};
    } else {
        dic = @{@"pageSize":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"pageNo":@"1"};
    }
    [self getWebData:dic andIsSelected:false andIsPullUp:false];
}


//上拉加载更多数据
-(void)getMoreNetData{
    
    NSDictionary *dic;
    
    if (self.severity) {
        dic = @{@"pageSize":@"25",@"pageNo":[NSString stringWithFormat:@"%ld",self.pageNo],@"severity":self.severity};
    } else {
        dic = @{@"pageSize":@"25",@"pageNo":[NSString stringWithFormat:@"%ld",self.pageNo],@"pageNo":@"1"};
    }
    
    [self getWebData:dic andIsSelected:false andIsPullUp:true];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:navColor];
    
    // 导航栏标题字体颜色
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 导航栏左右按钮字体颜色
    
    self.navigationController.navigationBar.tintColor =
    [UIColor whiteColor];
    
    self.navigationItem.title = @"信息管理平台";
}

-(void)initView{
    
    /**
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
     */
    self.status = 0;
    NSArray *title=@[@"告警信息",@"流程消息"];
    self.topView=[[SCJChangeItemView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) anditemArray:title];
    [self.topView changeStateWithTag:1000];
    self.topView.delegate=self;
    [self.view insertSubview:self.topView belowSubview:self.navigationController.navigationBar];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    self.lineView.hidden=YES;
    [self.view addSubview:self.lineView];
    
    
    self.chooseServiety = @[@"critical",@"major",@"minor",@"warning",@"normal",@"unknown"];
    self.dropdownMenu = [[SCJDropDownMultiSelectMenu alloc] init];
    [_dropdownMenu setFrame:CGRectMake(0, 64+41, self.view.bounds.size.width, 60)];
    [_dropdownMenu setMenuTitles:@[@"严重",@"重大",@"轻微",@"警告",@"正常",@"未知"] rowHeight:40];
    [_dropdownMenu setmainBtnTitle:@"选择告警级别"];
    _dropdownMenu.delegate = self;
    [self.view insertSubview:_dropdownMenu belowSubview:self.topView];
    //[self.view insertSubview:dropdownMenu aboveSubview:self.indexTableView];
    
    self.indexTableView.delegate=self;
    self.indexTableView.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.indexTableView.contentInset=UIEdgeInsetsMake(_dropdownMenu.bounds.size.height+self.topView.bounds.size.height, 0, 0, 0);
    self.indexTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddownData)];
    // 设置文字
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"没有更多数据了.." forState:MJRefreshStateNoMoreData];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    //header.lastUpdatedTimeLabel.textColor = barBackColor;
    header.lastUpdatedTimeLabel.hidden=YES;
    self.indexTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadUpData)];
    // 设置文字
    [footer setTitle:@"上拉加载更多数据..." forState:MJRefreshStateIdle];
    [footer setTitle:@"松开即可加载..." forState: MJRefreshStatePulling];
    [footer setTitle:@"正在加载更多数据..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了..." forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
    // 设置颜色255  192   203
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    // 设置footer
    self.indexTableView.mj_footer = footer;
   
    
    [self setUIWithStatus:0];
    
   
}

#pragma mark 获取流程消息列表
-(void)getProcessList{
    
    [SVProgressHUD show];
    
    self.processListArray = [NSMutableArray array];
    
    NSDictionary *dic =[NSDictionary dictionary];
    
    [[YCJHttpRequest sharedInstance] getProcessList:dic complete:^(NSArray *response, BOOL isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            self.processListArray = [NSMutableArray arrayWithArray:response];
            [self.indexTableView reloadData];
            NSLog(@"返回结果%@",response);
        }
        else{
            [[SCJToolManager setInstance] showMessage:@"请求失败"];
        }
    }];
}


#pragma mark 设置界面UI
-(void)setUIWithStatus:(NSInteger)status{
    if (status == 0) {
        self.indexTableView.contentInset=UIEdgeInsetsMake(_dropdownMenu.bounds.size.height+self.topView.bounds.size.height, 0, 0, 0);
        self.lineView.hidden = YES;
        self.indexTableView.mj_footer.hidden = NO;
    }else{
         self.indexTableView.contentInset=UIEdgeInsetsMake(self.topView.bounds.size.height, 0, 30, 0);
         self.lineView.hidden = NO;
         self.indexTableView.mj_footer.hidden = YES;
     }
    [self.indexTableView reloadData];
}


#pragma mark SCJChangeItemViewDelegate
-(void)changeChooseItemInView:(SCJChangeItemView *)view andItem:(NSInteger)itemTag{
    //切换视图操作
    if (self.status == itemTag) {
        //重复点击不做处理
    }else{
        self.status = itemTag;
        if (self.status==0) {
            //获取告警信息列表
            self.processListArray = nil;
            self.dropdownMenu.hidden=NO;
            [self chooseSelectseverity:self.severity];//获取当前告警信息页面数据（可能有筛选条件）
        }else{
            //获取流程消息
            self.messageListArray = nil;
            self.dropdownMenu.hidden=YES;
            [self getProcessList];
        }
        [self setUIWithStatus:itemTag];
    }
}

-(void)changeChooseItemInView:(SCJChangeItemView *)view andtitle:(NSInteger)titleTag{
   //NSLog(@"%ld", (long)titleTag);
}


#pragma mark - SCJDropDownMultiSelectMenuDelegate

- (void)dropdownMenu:(SCJDropDownMultiSelectMenu *)menu selectedCellIndex:(NSMutableArray *)indexArr{
    
   
    NSMutableArray * choose =[NSMutableArray array];
    
    for (NSString *index in indexArr) {
        
        [choose addObject:[self.chooseServiety objectAtIndex:[index integerValue]]];
    }
    
    NSString *severity = @"";
    
    for (NSString *str in choose) {
        severity =[severity stringByAppendingString:[NSString stringWithFormat:@"'%@'",str]];
        severity = [severity stringByAppendingString:@","];
    }
    
    NSLog(@"---选中的严重度%@",severity);
    self.severity = [severity substringToIndex:severity.length-1];
    [self chooseSelectseverity:self.severity];
    
}

//什么都没选后确定--初始加载数据
-(void)dropdownMenuSure:(SCJDropDownMultiSelectMenu *)menu{
     self.severity = nil;
     [self chooseSelectseverity:self.severity];
}

- (void)dropdownMenuWillShow:(SCJDropDownMultiSelectMenu *)menu{
    NSLog(@"1");
    self.topView.userInteractionEnabled = NO;
}
- (void)dropdownMenuDidShow:(SCJDropDownMultiSelectMenu *)menu{
    NSLog(@"2");
}

- (void)dropdownMenuWillHidden:(SCJDropDownMultiSelectMenu *)menu{
   
}
- (void)dropdownMenuDidHidden:(SCJDropDownMultiSelectMenu *)menu{
   self.topView.userInteractionEnabled = YES;
}

//选中了筛选后确定
-(void)chooseSelectseverity:(NSString *)severity{
//    if (self.messageListArray.count==0) {
//        self.pageSize=25;
//    }else{
//        self.pageSize=self.messageListArray.count;
//    }
    self.pageSize=25;
    self.pageNo=1;//重置pageNo
    if (severity) {
        NSDictionary *dic = @{@"pageSize":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"pageNo":@"1",@"severity":severity};
        [self getWebData:dic andIsSelected:true andIsPullUp:false];
    }else{
         NSDictionary *dic = @{@"pageSize":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"pageNo":@"1"};
        [self getWebData:dic andIsSelected:true andIsPullUp:false];
    }
}


//下拉刷新
-(void)loaddownData{
    if (self.status ==0) {
        [self getNetData];
        [self.indexTableView.mj_header endRefreshing];
    }
    else{
         [self getProcessList];
         [self.indexTableView.mj_header endRefreshing];
    }
}

//上拉加载更多数据 pageNo++
-(void)loadUpData{
    if (self.status == 0) {
        self.pageNo++;
        [self getMoreNetData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.status == 0) {
        return self.messageListArray.count;
    }
    return self.processListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell *cell =[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MessageTableViewCell class]) owner:self  options:nil] lastObject];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.status == 0) {
         [cell initWithModel:(MessageObject *)[self.messageListArray objectAtIndex:indexPath.row]];
    }
    else{
        NSDictionary *dic =[self.processListArray objectAtIndex:indexPath.row];
        [cell initWithProcessObject:dic];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vcc =[main instantiateViewControllerWithIdentifier:@"message"];
    if (self.status == 0) {
        self.chooseObject=[self.messageListArray objectAtIndex:indexPath.row];
        vcc.delegate=self;
        vcc.processDic = nil;
        vcc.object=self.chooseObject;
    }else{
        vcc.processDic = [self.processListArray objectAtIndex:indexPath.row];
        vcc.object = nil;
        vcc.delegate=self;
    }
    [self.navigationController pushViewController:vcc animated:YES];
}





#pragma mark MessageViewControllerDelegate
-(void)changeMessageState:(NSString *)flag andId:(NSString *)ID{
    
    if ([flag integerValue]==1) {
        NSLog(@"改变状态");
        for (MessageObject *object in self.messageListArray) {
            if ([object.ID isEqualToString:ID]) {
                object.readFlag=@"1";
            }
        }
        [self.indexTableView reloadData];
    }
}

//暴力刷新
-(void)changeProcessMessageState:(NSString *)flag andId:(NSString *)ID{
    if ([flag integerValue]==1) {
        NSLog(@"改变流程消息状态%@",ID);
        for (NSMutableDictionary *dic in self.processListArray) {
            if ([[dic valueForKey:@"id"] isEqualToString:ID]) {
                [self getProcessList];
            }
        }
    }
}

-(void)quit{
    UIStoryboard * main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *vcc =[main instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:vcc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
