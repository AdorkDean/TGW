//
//  DDGTabBarViewController.m
//  DDGProject
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "XXJRTabBarViewController.h"
#import "AppDelegate.h"

#import "DDGUserInfoEngine.h"
#import "AccountOperationController.h"
#import "LocationManager.h"
#import "WCAlertview.h"
#import "WCAlertview2.h"

NSString  *APP_URL = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.xxjr.xxjr_manage";

@interface XXJRTabBarViewController ()< WCALertviewDelegate>
{
    Frist_VC *ctl1;
    Second_VC *ctl2;
    GLTaskVC2 *ctl3;
    Thrid_VC *ctl4;
    
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
    UINavigationController *nav4;
    
}

/*!
 @brief     进入后台时间
 */
@property (nonatomic, strong) NSDate *intoBackground;


@end

@implementation XXJRTabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark === TabBarButtons
-(XXJRSelectButton *)tab1_Button{
    if (_tab1_Button == nil){
        _tab1_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH/4, TabbarHeight)];
        [_tab1_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab1_Button.tag = 100;
        
    }
    return _tab1_Button;
}

-(XXJRSelectButton *)tab2_Button{
    if (_tab2_Button == nil){
//        _tab2_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, -15, SCREEN_WIDTH/3, TabbarHeight + 15)];
        
        _tab2_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, TabbarHeight)];
        [_tab2_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab2_Button.tag = 101;
        _tab2_Button.backgroundColor = RandomColor;
    }
    return _tab2_Button;
}

-(XXJRSelectButton *)tab3_Button{
    if (_tab3_Button == nil){
        _tab3_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 2, 0, SCREEN_WIDTH/4, TabbarHeight)];
        [_tab3_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab3_Button.tag = 102;
    }
    return _tab3_Button;
}

-(XXJRSelectButton *)tab4_Button{
    if (_tab4_Button == nil){
        _tab4_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 3, 0, SCREEN_WIDTH/4, TabbarHeight)];
        [_tab4_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab4_Button.tag = 103;
    }
    return _tab4_Button;
}

-(UINavigationController *)homeViewController{
    return _homeViewController = (UINavigationController *)self.selectedViewController;
}


#pragma mark === init
-(id)init{
    self = [super init];
    
    if (self) {
        
        self.view.frame = [[UIScreen mainScreen] bounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucess:) name:DDGAccountEngineDidLogoutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDidEnterBackgroudNotificaiton:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillEnterForegroundNotificaiton:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        // userInfo需要更新通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DDGNotificationAccountNeedRefresh object:nil];
        
        // 推送消息处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:DDGPushNotification object:nil];
        
        // 首页切换到别的页面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchTab:) name:DDGSwitchTabNotification object:nil];
        
        // token过期通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenOutOfData:) name:DDGUserTokenOutOfDataNotification object:nil];
        
        // 名片信息完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUserInfo) name:@"FinishInfoNotification" object:nil];
        
        // 登录成功时，检测是否需要更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCheckVersion2) name:DDGAccountEngineDidLoginNotification object:nil];
        
        
        // 屏蔽掉地图定位
        //[[LocationManager shareManager] getUserLocationSuccess:nil failedBlock:nil];
    }
    
    
    // 禁止侧滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    

    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    [self getUserInfo];
    
    
    // 企业版本， 所以先出现界面
    [self layoutViews];
    // 版本检测
    [self onCheckVersion2];
    
//    // 个人版本
//     [self onCheckVersion];
}

-(void)layoutViews{
    _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - TabbarHeight, SCREEN_WIDTH, TabbarHeight)];
    _buttonsView.backgroundColor =  UIColorFromRGB(0x101117);//[UIColor whiteColor];
    _buttonsView.tag = 1010;
    _buttonsView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _buttonsView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _buttonsView.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    _buttonsView.layer.shadowRadius = 3;//阴影半径，默认3
    
    // 布置tabBar
    self.tab1_Button.normalImage = [ResourceManager tabBar_button1_gray];
    self.tab1_Button.selectedImage = [ResourceManager tabBar_button1_selected];
    self.tab2_Button.normalImage = [ResourceManager tabBar_button2_gray];
    self.tab2_Button.selectedImage = [ResourceManager tabBar_button2_selected];
    self.tab3_Button.normalImage = [ResourceManager tabBar_button3_gray];
    self.tab3_Button.selectedImage = [ResourceManager tabBar_button3_selected];
    self.tab4_Button.normalImage = [ResourceManager tabBar_button4_gray];
    self.tab4_Button.selectedImage = [ResourceManager tabBar_button4_selected];
    
    if ([PDAPI isTestUser])
     {
        self.tab2_Button.normalImage = [UIImage imageNamed:@"Tabbar_2_Test"];
        self.tab2_Button.selectedImage = [UIImage imageNamed:@"Tabbar_2_Test_H"];
     }

    //self.tab1_Button.normalBGColor = [UIColor orangeColor];;
    
    self.tab1_Button.selectedTextColor = self.tab2_Button.selectedTextColor = self.tab3_Button.selectedTextColor = self.tab4_Button.selectedTextColor = [ResourceManager blueColor];
    self.tab1_Button.normalTextColor = self.tab2_Button.normalTextColor = self.tab3_Button.normalTextColor = self.tab4_Button.normalTextColor = [ResourceManager lightBlackColor];
    
    self.tab1_Button.selectedState = YES;
    self.tab2_Button.selectedState = NO;
    self.tab3_Button.selectedState = NO;
    self.tab4_Button.selectedState = NO;
    [_buttonsView addSubview:self.tab1_Button];
    [_buttonsView addSubview:self.tab2_Button];
    [_buttonsView addSubview:self.tab3_Button];
    [_buttonsView addSubview:self.tab4_Button];
    
    [self.tabBar removeFromSuperview];
    
    
    
    [self initViewControllers];
    
    [self ShowControllers];
    
    [self tabButtonPressed:self.tab1_Button];
}

-(void)getUserInfo{
    if ([[DDGAccountManager sharedManager] isLoggedIn] && [DDGSetting sharedSettings].accountNeedRefresh) {
//        [[[AccountOperationController alloc] init] accountRequest:AccountRequestTypeGetZYQTUserInfo success:^(DDGAFHTTPRequestOperation *operation){
//            [DDGSetting sharedSettings].userInfo = operation.jsonResult.attr;
//            [DDGSetting sharedSettings].accountNeedRefresh = NO;
//        } fail:nil];
    }
}

-(void)initViewControllers{
    
    if (ctl1 == nil || ctl2 == nil) {
        ctl1=[[Frist_VC alloc] init];
        ctl1.tabBar = self.buttonsView;
        
        nav1=[[UINavigationController alloc] initWithRootViewController:ctl1];
        [nav1 setNavigationBarHidden:NO];
        [nav1.navigationBar setHidden:YES];
        
        ctl2 =[[Second_VC alloc] init];
        ctl2.tabBar = self.buttonsView;
        nav2=[[UINavigationController alloc] initWithRootViewController:ctl2];
        [nav2 setNavigationBarHidden:NO];
        [nav2.navigationBar setHidden:YES];
        
        ctl3 =[[GLTaskVC2 alloc] init];
        ctl3.tabBar = self.buttonsView;
        nav3=[[UINavigationController alloc] initWithRootViewController:ctl3];
        [nav3 setNavigationBarHidden:NO];
        [nav3.navigationBar setHidden:YES];
        
        ctl4 =[[Thrid_VC alloc] init];
        ctl4.tabBar = self.buttonsView;
        nav4=[[UINavigationController alloc] initWithRootViewController:ctl4];
        [nav4 setNavigationBarHidden:NO];
        [nav4.navigationBar setHidden:YES];
        
    }
}

-(void)ShowControllers{
    self.viewControllers=@[nav1,nav2,nav3,nav4];
}

-(void)loginSucess:(NSNotification *)notification{
    if (nav1) {
        [nav1 popToRootViewControllerAnimated:NO];
    }
    if (nav2) {
        [nav2 popToRootViewControllerAnimated:NO];
    }
    if (nav3) {
        [nav3 popToRootViewControllerAnimated:NO];
    }
    if (nav4) {
        [nav4 popToRootViewControllerAnimated:NO];
    }
    
    [self setButtonsState:self.tab1_Button];
    
    [self getUserInfo];
}

-(void)logoutSucess:(NSNotification *)notification{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate getStartUpViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * TabBar按钮显示状态
 */
- (void)tabButtonPressed:(XXJRSelectButton *)button
{
    [self setButtonsState:button];
}

-(void)setButtonsState:(XXJRSelectButton *)button{
    
    [_tab1_Button setSelectedState:NO];
    [_tab2_Button setSelectedState:NO];
    [_tab3_Button setSelectedState:NO];
    [_tab4_Button setSelectedState:NO];
    if (button.tag == 100) {
        _tab1_Button.selectedState = YES;
        [ctl1 addButtonView];
    }else if (button.tag == 101) {
        _tab2_Button.selectedState = YES;
        [ctl2 addButtonView];
    }else if (button.tag == 102) {
        _tab3_Button.selectedState = YES;
        [ctl3 addButtonView];
    }else if (button.tag == 103) {
        _tab4_Button.selectedState = YES;
        [ctl4 addButtonView];
    }
    
    self.selectedIndex = button.tag - 100;
}

/**
 *	关闭UIAlertView、UIActionSheet模态框
 */
- (void)closeModalView
{
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        for (UIView *view in window.subviews)
        {
            [self dismissActionSheetAndAletrtViewInView:view];
        }
    }
}

/**
 *	逐层遍历view的子view里有没UIAlertView、UIActionSheet，有的话将其关闭
 *
 *	@param	view	要遍历的view
 */
- (void)dismissActionSheetAndAletrtViewInView:(UIView *)view
{
    if ([view isKindOfClass:[UIActionSheet class]])
    {
        UIActionSheet *actionSheet = (UIActionSheet *)view;
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    }
    else if ([view isKindOfClass:[UIAlertView class]])
    {
        UIAlertView *alertView = (UIAlertView *)view;
        [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
    }
    else
    {
        for (UIView *subView in view.subviews)
        {
            [self dismissActionSheetAndAletrtViewInView:subView];
        }
    }
}


#pragma mark -
#pragma mark notification
-(void)switchTab:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.object);

    
    int tab = [[(NSDictionary *)notification.object objectForKey:@"tab"] intValue];
    if (1 == tab)
     {
        [self setButtonsState:_tab1_Button];
     }
    else if (2 == tab)
     {
        [self setButtonsState:_tab2_Button];
     }
    else if (3 == tab)
     {
        [self setButtonsState:_tab3_Button];
     }
    else if (4 == tab)
     {
        [self setButtonsState:_tab4_Button];
     }
}

-(void)tokenOutOfData:(NSNotification *)notification{
    // 注销推送
    //[APService setAlias:@"" callbackSelector:nil object:nil];
    
    [[DDGAccountManager sharedManager] deleteUserData];
    
    [self loginSucess:nil];
    
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [MBProgressHUD showErrorWithStatus:@"登录超时，请重新登录" toView:[DDGUserInfoEngine engine].loginViewController.view];
    }
}

-(void)finishUserInfo{
    //[ctl1 loadData];
}

-(void)pushNotification:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.userInfo);
}

- (void)handleDidEnterBackgroudNotificaiton:(NSNotification *)notification{
    //程序退到后台的时间
    self.intoBackground = [NSDate date];
}

- (void)handleWillEnterForegroundNotificaiton:(NSNotification *)notification{
    CFRunLoopRunInMode(kCFRunLoopDefaultMode,0.4, NO);
}

/*!
 @brief 网络变化的通知回调
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    NSLog(@"reachabilityChanged");
    if ([XXJRUtils isNetworkReachable]){
        
    }else{
        [MBProgressHUD showNoNetworkHUDToView:self.view];
    }
}

#pragma mark - 判断版本更新
-(void)onCheckVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appID"] = @"tgwIOS";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               noJiaMiparameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self parseDic:operation.jsonResult.attr];
                                                                                      
                                                                                      
                                                                                      [self layoutViews];
                                                                                      if ([PDAPI isTestUser])
                                                                                       {
                                                                                          return;
                                                                                       }
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      
                                                                                      APP_URL = dic[@"upUrl"];
                                                                                      NSString *version =dic[@"upVersion"];
                                                                                      NSString *strV = dic[@"upVersion"];
                                                                                      version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                                                      
                                                                                      NSString *strForceUpgradeVersion = dic[@"forceUpgradeVersion"];
                                                                                      strForceUpgradeVersion = [strForceUpgradeVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                                                      
                                                                                      NSString *strMessage = @"新版本已更新，前往下载";
                                                                                      NSString *strMessageTemp = dic[@"upDesc"];
                                                                                      strMessageTemp =  [strMessageTemp stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
                                                                                      if(strMessageTemp.length > 0)
                                                                                       {
                                                                                          strMessage = strMessageTemp;
                                                                                       }
                                                                                      
                                                                                      if (currentVersion.integerValue  < version.integerValue)
                                                                                       {
                                                                                          if (strForceUpgradeVersion.integerValue >= currentVersion.integerValue )
                                                                                           {
                                                                                              
                                                                                              WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                                                                                                               Message:strMessageTemp
                                                                                                                                                 Image:[UIImage imageNamed:@"com_up_message"]
                                                                                                                                          CancelButton:@"立即升级"
                                                                                                                                              OkButton:@""];
                                                                                              alert.strVerion = strV;
                                                                                              alert.delegate = self;
                                                                                              [alert show];
                                                                                           }
                                                                                          else{
                                                                                              WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                                                                                                               Message:strMessageTemp
                                                                                                                                                 Image:[UIImage imageNamed:@"com_up_message"]
                                                                                                                                          CancelButton:@"立即升级"
                                                                                                                                              OkButton:@"下次再说"];
                                                                                              alert.delegate = self;
                                                                                              alert.strVerion = strV;
                                                                                              [alert show];
                                                                                          }
                                                                                       }
                                                                                      else
                                                                                       {
                                                                                          // 判断是否有普通消息通知
                                                                                          [self messageDic:dic];
                                                                                       }
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                      NSString *strValue = [defaults objectForKey:@"isAppReview"]; // 1 代表审核中， 0 代表 审核通过
                                                                                      
                                                                                      if (!strValue)
                                                                                       {
                                                                                          NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                          [defaults setObject:@"1" forKey:@"isAppReview"];
                                                                                          
                                                                                       }
                                                                                      
                                                                                       [self layoutViews];
                                                                                  }];
    [operation start];
}


-(void)onCheckVersion2{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appID"] = @"tgwIOS";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               noJiaMiparameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self parseDic:operation.jsonResult.attr];
                                                                                      
                                                                                      
                                                                                      
                                                                                      if ([PDAPI isTestUser])
                                                                                       {
                                                                                          return;
                                                                                       }
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      
                                                                                      APP_URL = dic[@"upUrl"];
                                                                                      NSString *version =dic[@"upVersion"];
                                                                                      NSString *strV = dic[@"upVersion"];
                                                                                      version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                                                      
                                                                                      NSString *strForceUpgradeVersion = dic[@"forceUpgradeVersion"];
                                                                                      strForceUpgradeVersion = [strForceUpgradeVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                                                                                      
                                                                                      NSString *strMessage = @"新版本已更新，前往下载";
                                                                                      NSString *strMessageTemp = dic[@"upDesc"];
                                                                                      strMessageTemp =  [strMessageTemp stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
                                                                                      if(strMessageTemp.length > 0)
                                                                                       {
                                                                                          strMessage = strMessageTemp;
                                                                                       }
                                                                                      
                                                                                      if (currentVersion.integerValue  < version.integerValue)
                                                                                       {
                                                                                          if (strForceUpgradeVersion.integerValue >= currentVersion.integerValue )
                                                                                           {
                                                                                              
                                                                                              WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                                                                                                               Message:strMessageTemp
                                                                                                                                                 Image:[UIImage imageNamed:@"com_up_message"]
                                                                                                                                          CancelButton:@"立即升级"
                                                                                                                                              OkButton:@""];
                                                                                              alert.strVerion = strV;
                                                                                              alert.delegate = self;
                                                                                              [alert show];
                                                                                           }
                                                                                          else{
                                                                                              WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                                                                                                               Message:strMessageTemp
                                                                                                                                                 Image:[UIImage imageNamed:@"com_up_message"]
                                                                                                                                          CancelButton:@"立即升级"
                                                                                                                                              OkButton:@"下次再说"];
                                                                                              alert.delegate = self;
                                                                                              alert.strVerion = strV;
                                                                                              [alert show];
                                                                                          }
                                                                                       }
                                                                                      else
                                                                                       {
                                                                                          // 判断是否有普通消息通知
                                                                                          [self messageDic:dic];
                                                                                       }
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                      NSString *strValue = [defaults objectForKey:@"isAppReview"]; // 1 代表审核中， 0 代表 审核通过
                                                                                      
                                                                                      if (!strValue)
                                                                                       {
                                                                                          NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                          [defaults setObject:@"1" forKey:@"isAppReview"];
                                                                                          
                                                                                       }
                                                                                      
                                                                                  }];
    [operation start];
}


// 判断是否审核中
-(void) parseDic:(NSDictionary*) dic
{
    if (!dic)
     {
        return;
     }
    NSLog(@"dic : %@", dic);
    
    // isTestByIos   1 表示审核中，   0  表示审核通过
    int     iisTestByIos  = [dic[@"isTestByIos"] boolValue];
    
    NSString *version = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 网络版本号 和 isTestByIos ，都匹配，才是审核中 (审核时，后台返回的版本号，要比自己的版本号小)
    if ([currentVersion floatValue] > [version floatValue] &&
        iisTestByIos == 1)
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isAppReview"];
        //[self layoutViews];
     }
    else
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isAppReview"];
        //[self layoutViews];
     }
    
}

// 判断是否弹通知
-(void) messageDic:(NSDictionary*) dicAll
{
    NSDictionary *dic = dicAll[@"notifyInfo"];
    if (!dic ||
        [dic count] <= 0)
     {
        return;
     }
    
    if ([PDAPI isTestUser])
     {
        // 如果是审核中，不弹普通消息
        return;
     }
    
    
    //    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    //
    //
    //    NSString *strNetVersion = dic[@"notifyVersion"];
    //    if (strNetVersion)
    //     {
    //        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //        strNetVersion  = [strNetVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //
    //        int iCurVersion = [currentVersion intValue];
    //        int iNetVersion = [strNetVersion intValue];
    //
    //        // 如果App版本号 大于 网络版本号
    //        if (iCurVersion > iNetVersion )
    //            return;
    //     }
    
    
    NSLog(@"dic : %@", dic);
    NSString *strMessageTemp = dic[@"content"];//@"尊敬的用户，为了优化抢单流程，小小金融抢单市场将于2017你那9月8日实行新的抢单规则。\n届时针对会员将开放‘会员特价’专区。普通单打5折，优质客户单打8折将自动取消。";
    NSString *strTitle = dic[@"title"];
    
    WCAlertview2 * alert = [[WCAlertview2 alloc] initWithTitle:strTitle
                                                       Message:strMessageTemp
                                                         Image:[UIImage imageNamed:@"com_pop_message"]
                                                  CancelButton:@"我知道了"
                                                      OkButton:@""];
    alert.strVerion = @"";
    alert.parentVC = self;
    alert.strNoteMessage = dic[@"skipText"];
    alert.strUrl = dic[@"skipUrl"];
    //alert.delegate = self;
    [alert show];
}

#pragma mark === UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        NSURL* url = [[ NSURL alloc ] initWithString :APP_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)didClickButtonAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
     {
        //NSLog(@"Click Cancel");
        NSURL* url = [[ NSURL alloc ] initWithString :APP_URL];
        [[UIApplication sharedApplication] openURL:url];
        break;
     }
        case 1:
            //NSLog(@"Click OK");
            break;
        default:
            break;
    }
}

@end
