//
//  Frist_VC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "Frist_VC.h"
#import "AnimationButton.h"
#import "TGBRecordVC.h"
#import "GLRecordVC.h"
#import "SKAutoScrollLabel.h"
#import "LSMarqueeView.h"
#import "GLTaskVC.h"
#import "AddFriendFristVC.h"
#import "SecretBooksVC.h"
#import "SetNikeNameVC.h"
#import "LockTBGVC.h"
#import "QuestionVC.h"
#import "TGMJ_VC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "UIImage+GIF.h"
#import "AddFriendWebVC.h"
#import "MyBiddersRecrodVC.h"
#import "RankVC.h"
#import "AddFriendVC.h"
#import "CreditCardWebVC.h"
#import "CreditCardInfoVC.h"
#import "XcodeWebVC.h"
#import "MoreActivityVC.h"
#import "WithdrawTGW_VC.h"
#import "GameRechargeVC.h"



int   MAX_SHOW_ENERGYCOUNT =     8;     //  一屏幕最多显示的能量数
int   SCROLLVIEW_WIDTH  =  0;      // 滚动屏幕的最大宽度 (0为默认的宽度)
int   HOME_WIDTH = 0;

@interface Frist_VC ()<ButtonDelegateWithParameter>
{
    UIScrollView  *scView;
    UIView *popView;
    
    UIImageView *homeView;
    int iHomeLeftX;
    
    UIImageView *leftView;
    UIImageView *rightView;
    
    UIScrollView  *scViewTail;  // 底部的滚动view
    
    BOOL  isFirstLoad;

    UIImageView  *viewMain; // 主页面（能量展示，收集页面）
    NSMutableArray *arrBtn; // 显示的能量按钮（数组）
    
    SKAutoScrollLabel *paoma;
    
    AnimationButton  *btnGrowing;  // 正在生长的按钮
    BOOL isPopVC;  // 是否通过pop动作，回到主页面
    BOOL isShow;  // 页面是否在展示
    BOOL isNextNoShow; // 下次不再显示“邀请办卡”
    
    UIButton     *btnLogin; // 登录按钮
    
    UIImageView *viewCenter;  // 中间的飞船和狗的图片
    
    UIButton  *btnLanch;  // 点击大笑的辅助按钮（在天狗站的星球上）
    BOOL isLanchAndMessage;  // 是否正在大笑并且说话
    int  iLangchCount;    // 大笑计数器
    
    UIImageView *imgMessage;  // 狗狗说话的弹框
    UILabel *labelTGMessage;
    
    
    UILabel *labelTGB;
    UILabel *labelGL;
    UILabel *labelMrdl;
    UIView *viewMrdl;
    float fTGB;
    NSString  *strTGB;
    float fGL;
    float fFrozenCoin;  //冻结的币的个数
    
    UIImageView *imgLock;  // 锁的图片
    
    int iCenterImgHeight;
    int iCenterImgTopY;
    
    NSMutableArray *arrEnergyFromWeb; // 从web获取的所有能量
    NSLock *lockEngeryWeb;   // WEB能量队列锁
    NSMutableArray *arrSend;   //终端收集能量后，需要发送到后台的缓冲队列
    NSLock *lockEngerySend;    //发送队列锁
    
    NSString *strCountdown;  // 距离小奶狗变天狗还剩13小时39分 , 空字符串表示已经变成大狗了
    UILabel *labelSmall;
    UIImageView *imgText;
    
    UIImageView *gifImageView;  // 点击的gif
    
    dispatch_source_t _timer1;  // 定时器1
    
    UIView  *viewTail; // 底部页面（排行榜）
    UIButton *btnRK_TGB;
    UIButton *btnRK_GL;
    
    UIView *viewList; //排行榜
    UILabel *labelListDes;
 
    
    NSArray *arrTask; // 任务数组
    
    UIView *background;  //弹框背景
    
}
@end

// 能量的处理逻辑  begin

//一 星舰币展示和获取处理
//1 APP前端每隔30S或列表领取完了自动请求星舰币列表数（展示个数要控制）
//2 用户领取星舰币，APP前端先自主累加星舰币数，并且缓存用户领取过的星舰币信息(JOSN 格式)
//
//APP 前端上传星舰币缓存时间：
//1 如果缓存存在，每隔10s上传缓存信息，后端实时处理，不用MQ，并且支持批量
//2 在请求星舰币列表时，需判断缓存是否存在，存在，需要先请求上传缓存的接口，再请求星舰币列表接口
//3 上传缓存信息成功后，APP需要清空用户领取过的缓存信息

// 能量的处理逻辑  end

@implementation Frist_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidEnterBackgroudNotificaiton:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillEnterForegroundNotificaiton:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:DDGAccountEngineDidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DDGAccounSMRZNotification object:nil];
    
    
    
    
    [self initData];

    [self layoutUI];

    
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isPopVC  &&
        [[DDGAccountManager sharedManager] isLoggedIn])
     {
        [LoadView showHUDAddedTo:self.view animated:YES];
     }

    [self getUserInfo];
    
    // 设置状态栏字体颜色为白色
    barStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    // 禁止侧滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    iLangchCount = 0;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isShow = YES;
    
    [self getTaskRecord];
    
    
    
    if (iHomeLeftX > 0)
     {
        [scView setContentOffset:CGPointMake(iHomeLeftX - 20*ScaleSize,0) animated:YES];
     }

    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        
        homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_unlogin"];
        viewCenter.userInteractionEnabled = NO;
        gifImageView.hidden = YES;
        btnLogin.hidden = NO;
        btnGrowing.hidden = YES;


        // 清除所有能量的按钮
        for (int i = 0; i < [arrBtn count]; i++)
         {
            AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
            [btnTemp removeFromSuperview];
         }


        return;
     }

    homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_bg"];
    btnLogin.hidden = YES;

    if (!isFirstLoad)
     {
        [LoadView showHUDAddedTo:self.view animated:YES];
        isFirstLoad = YES;
     }

    [self repeatAnimation];

    // 启动定时器
    [self creatTime];


    [self getEnergyFromWeb];

    [self getNoteInfo];

    // 获取是否竞拍成功
    [self getAuctionOrder];
    
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    isShow = NO;
    
    [self sendEnergy];
    
    
    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
     }
}

#pragma mark ---  notification
- (void)handleDidEnterBackgroudNotificaiton:(NSNotification *)notification{
    //程序退到后台
    [self sendEnergy];
}

- (void)handleWillEnterForegroundNotificaiton:(NSNotification *)notification{
    //程序从后台切换到前台
    [self repeatAnimation];
    
    [self updateLoginTime];
}

-(void)loginSucess:(NSNotification *)notification
{
    // 清除所有能量的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
     }
    
    [arrEnergyFromWeb removeAllObjects];
    
}


#pragma mark --- 数据操作
-(void) initData
{
    fTGB = 0.0;
    
    fGL = 0.0;
    
    lockEngeryWeb =  [[NSLock alloc] init];
    
    lockEngerySend =  [[NSLock alloc] init];
    
    arrBtn = [[NSMutableArray alloc] init];  // 显示的能量按钮（数组）
    
    arrEnergyFromWeb = [[NSMutableArray alloc] init]; // 从web获取的所有能量
    
//    long lRand = arc4random();
//    for (int i = 0; i < 24; i++)
//     {
//        lRand += 1;
//        long lValue = arc4random()%1000;
//        float fValue = (float)lValue / (1000*100);
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        dic[@"sendId"] = @(lRand);
//        dic[@"coinValue"] = @(fValue);
//        [arrEnergyFromWeb addObject:dic];
//     }
    
    arrSend = [[NSMutableArray alloc] init];   //终端收集能量后，需要发送到后台的缓冲队列
}

-(void) delArrEnergyForwWeb:(long) lID
{
    [lockEngeryWeb lock];
    for (int i = 0; i < [arrEnergyFromWeb count]; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        if (dic)
         {
            long lTemp = [dic[@"sendId"] longValue];
            if (lTemp == lID)
             {
                // 从web能量数组中删除此数据
                [arrEnergyFromWeb removeObject:dic];
                
                //[lockEngerySend lock];
                // 加入发送队列
                // [arrSend addObject:dic];
                
                NSMutableDictionary *dicObj = [[NSMutableDictionary alloc] init];
                dicObj[@"sendId"] = @(lTemp);
                [arrSend addObject:dicObj];
                
                //[lockEngerySend unlock];
                
                break;
             }
         }
     }
    [lockEngeryWeb unlock];
    
    NSLog(@"delArrEnergyForwWeb  arrEnergyFromWeb.count :%d", (int)arrEnergyFromWeb.count);
}

-(void) sendEnergy
{
    if ([arrSend count] > 0)
     {
        // 发送能量数据到后台
        [self sendEnergyToWeb];
     }
    else
     {
        // 获取数据
        [self getEnergyFromWeb];
     }
    NSLog(@"sendEnergy arrEnergyFromWeb.count :%d", (int)arrEnergyFromWeb.count);
    NSLog(@"sendEnergy arrSend.count :%d", (int)arrSend.count);
}


-(void) getArrEnergyForwWeb:(NSArray*) arr
{
    int iLastengeryCount = (int)[arrEnergyFromWeb count];
    [lockEngeryWeb lock];
    if ([arrEnergyFromWeb count] == 0 )
     {
        [arrEnergyFromWeb addObjectsFromArray:arr];
     }
    else
     {
        for (int i = 0; i < [arr count]; i++)
         {
            NSDictionary *dic = arr[i];
 
            long lTemp = [dic[@"sendId"] longValue];
            long lTemp2 = 0;
            int j = 0;
            for (j = 0; j < [arrEnergyFromWeb count]; j++)
            {
               NSDictionary *dic2 = arrEnergyFromWeb[j];
               lTemp2 = [dic2[@"sendId"] longValue];
               if (lTemp2 == lTemp)
                {
                   break;
                }
            }
            
            // 如果arrEnergyFromWeb中没有 dic, 则加入dic
            if (j >= [arrEnergyFromWeb count])
             {
                [arrEnergyFromWeb addObject:dic];
             }
            
         }
     }
    
    [lockEngeryWeb unlock];
    
    // 如果网络能量缓冲有改变， 刷新能量按钮
    if ([arrEnergyFromWeb count] != iLastengeryCount)
     {
        [self layoutAryBtn];
     }
}


#pragma mark  布局




-(void) layoutUI
{
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, 0);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    scView.userInteractionEnabled = YES;
    
    
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    

    // 左边view 布局
    int ViewHeight = SCREEN_HEIGHT - TabbarHeight;
    int iLeftViewWidth =  200 * ScaleSize;
    if (IS_IPHONE_X_MORE)
     {
        iLeftViewWidth =  220 * ScaleSize;
     }
    
    leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iLeftViewWidth, ViewHeight)];
    [scView addSubview:leftView];
    leftView.image = [UIImage imageNamed:@"new_tab1_mid_home_left"];
    leftView.userInteractionEnabled = YES;
    
    //添加手势(右边的view)
    UITapGestureRecognizer * gestureL = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionLeftView)];
    gestureL.numberOfTapsRequired  = 1;
    [leftView addGestureRecognizer:gestureL];

    // 中间view布局
    iHomeLeftX = iLeftViewWidth;
    int iHomeWidth = SCREEN_WIDTH-50 *ScaleSize;
    homeView = [[UIImageView alloc] initWithFrame:CGRectMake(iHomeLeftX, 0, iHomeWidth, ViewHeight)];
    [scView addSubview:homeView];
    homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_bg"];
    
    // 右边view布局
    int iRightViewLeftX = iLeftViewWidth + iHomeWidth;
    int iRightViewWidth = 230 * ScaleSize;
    if (IS_IPHONE_X_MORE)
     {
        iRightViewWidth =  250 * ScaleSize;
     }
    rightView = [[UIImageView alloc] initWithFrame:CGRectMake(iRightViewLeftX, 0, iRightViewWidth, ViewHeight)];
    [scView addSubview:rightView];
    rightView.image = [UIImage imageNamed:@"new_tab1_mid_home_right"];
    
    // 设置滚动的屏幕宽度
    SCROLLVIEW_WIDTH = iRightViewLeftX + iRightViewWidth;
    scView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, 0);
    
    
    rightView.userInteractionEnabled = YES;
    //添加手势(右边的view)
    UITapGestureRecognizer * gestureR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionRightView)];
    gestureR.numberOfTapsRequired  = 1;
    [rightView addGestureRecognizer:gestureR];
    
    viewMain = [[UIImageView alloc] initWithFrame:CGRectMake(iHomeLeftX, 0, iHomeWidth + 28*ScaleSize, ViewHeight)];
    [scView addSubview:viewMain];
    viewMain.userInteractionEnabled = YES;
    //viewMain.backgroundColor = [UIColor yellowColor];
    
    //添加手势解决按钮不响应
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    gesture.numberOfTapsRequired  = 1;
    [viewMain addGestureRecognizer:gesture];
    //viewMain.backgroundColor = [UIColor whiteColor];
    
    [self layoutMain];
    
    // 加入天狗的图标
    iCenterImgHeight = (SCREEN_HEIGHT-TabbarHeight)/4;
    iCenterImgTopY = (SCREEN_HEIGHT-TabbarHeight)/2 -130;
    
    if (!IS_IPHONE_X_MORE)
     {
        iCenterImgTopY = (SCREEN_HEIGHT-TabbarHeight)/2 - (100);
        iCenterImgHeight = (SCREEN_HEIGHT-TabbarHeight)/4 -20;
     }
    if (IS_IPHONE_Plus)
     {
        iCenterImgTopY -= 30;
     }
    
    
    //  创建登录按钮
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake((iHomeWidth - 80)/2, iCenterImgTopY, 70, 80)];
    [viewMain addSubview:btnLogin];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"taber1_login"] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.hidden = YES;
    
    
    // 创建正在生长的按钮
    btnGrowing  = [[AnimationButton alloc] initWithFrame:CGRectMake((iHomeWidth - 60)/2  , iCenterImgTopY-30, 60, 50)];
    [viewMain addSubview:btnGrowing];
    btnGrowing.backgroundColor = [UIColor clearColor];
    // 设置开始动画
    [btnGrowing setSatrtAnimationHegit:3];
    // 设置文字和图片
    NSString *strValue = @"正在生长中";
    [btnGrowing setText:strValue];
    
    btnGrowing.hidden = YES;

    
    //添加点击手势（小天狗时，才反应）
    viewCenter = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, iCenterImgTopY, 100, iCenterImgHeight)];
    [viewMain addSubview:viewCenter];
    //viewCenter.backgroundColor = [UIColor yellowColor];
    viewCenter.userInteractionEnabled = YES;
//    //viewCenter.image = [UIImage imageNamed:@"taber1_home_center"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionPop)];
    [viewCenter addGestureRecognizer:tapGesture];
    
    // 加入狗狗说话弹框
    int iImgTopY =  iCenterImgTopY + iCenterImgHeight-20;
    int iImgLeftX = (SCREEN_WIDTH-130)/2-30;
    imgMessage = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX, iImgTopY, 130, 70)];
    [viewMain addSubview:imgMessage];
    imgMessage.image = [UIImage imageNamed:@"new_tab1_mid_mesage"];
    imgMessage.hidden = YES;
    
    labelTGMessage = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 110, 40)];
    [imgMessage addSubview:labelTGMessage];
    labelTGMessage.font = [UIFont systemFontOfSize:12];
    labelTGMessage.textColor = [UIColor whiteColor];
    labelTGMessage.numberOfLines = 0;
    //labelTGMessage.text =@"主人，你猜我爱天狗币还是爱狗粮主人，你猜我爱天狗币还是爱狗粮";
    
    // 狗狗大笑的辅助弹框
    btnLanch = [[UIButton alloc] initWithFrame:CGRectMake(60, iImgTopY,SCREEN_WIDTH - 180 , 100)];
    [viewMain addSubview:btnLanch];
    [btnLanch addTarget:self action:@selector(actionPop) forControlEvents:UIControlEventTouchUpInside];
    //btnLanch.backgroundColor = [UIColor yellowColor];
    
    
    // 加入 点击手势gif
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dianji" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2,iCenterImgTopY+iCenterImgHeight/2,60,60)];
    [viewMain addSubview:gifImageView];
    gifImageView.image = image;
    gifImageView.hidden = YES;
    
    
    // 加入小奶狗变大的背景图片
    imgText = [[UIImageView alloc] initWithFrame:CGRectMake(10, iCenterImgTopY +iCenterImgHeight, 290, 40)];
    [viewMain addSubview:imgText];
    imgText.image = [UIImage imageNamed:@"taber1_home_center_text"];
    imgText.hidden = YES;
    
    labelSmall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imgText.width, imgText.height)];
    [imgText addSubview:labelSmall];
    labelSmall.text = @"";
    labelSmall.textAlignment = NSTextAlignmentCenter;
    labelSmall.textColor = [UIColor whiteColor];
    labelSmall.font = [UIFont systemFontOfSize:13];

    
    
    //  底部的任务布局
    int iTaskBtnHeight = 120 * ScaleSize;
    int iTaskBtnWidth = 120 * ScaleSize;
    int iTailTopY = ViewHeight - iTaskBtnHeight-40;
    scViewTail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTailTopY, SCREEN_WIDTH, iTaskBtnHeight+20 + 10 * ScaleSize)];
    [self.view addSubview:scViewTail];
    scViewTail.showsVerticalScrollIndicator = FALSE;
    scViewTail.showsHorizontalScrollIndicator = FALSE;
    scViewTail.contentSize = CGSizeMake(1000, 0);
    //scViewTail.backgroundColor = [UIColor blueColor];
    

    
    
//    NSArray *arrTitlt1 =  @[@"重磅上线",@"办信用卡",@"办理贷款",@"好友助力",@"天狗排行榜",@"更多福利等你来"];
//    NSArray *arrTitlt2 = @[@"天狗口袋",@"现金+天狗币",@"最高可借50万",@"邀请好友",@"每天更新数据",@"更多功能"];
//    NSArray *arrTitlt3 = @[@"分享创造价值",@"一键分享轻松获佣",@"正规专业 方便快捷",@"人脉就是最大的财富",@"分享创造价值",@"点击进入"];
//    NSArray *arrImg = @[@"newTask_tgkd",@"newTask_xyk",@"newTask_rmhd",@"newTask_yqhy",@"newTask_phb",@"newTask_more"];
    
    NSArray *arrTitlt1 = @[@"重磅上线",@"热门活动",@"购物达人分享",@"好友助力",@"天狗排行榜",@"更多福利等你来"];
    NSArray *arrTitlt2 = @[@"天狗口袋",@"玩转双十二",@"特惠商城",@"邀请好友",@"每天更新数据",@"更多功能"];
    NSArray *arrTitlt3 = @[@"分享创造价值",@"创造属于你的价值",@"独家海量优惠券大放送",@"人脉就是最大的财富",@"分享创造价值",@"点击进入"];
    NSArray *arrImg = @[@"newTask_tgkd",@"newTask_tgsj",@"Tab4-12",@"newTask_yqhy",@"newTask_phb",@"newTask_more"];
    int iSCLeft = 15;
    int iArrCount = (int)[arrTitlt1 count];
    for (int i = 0 ; i< iArrCount; i++)
     {
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(iSCLeft, 0, iTaskBtnWidth, iTaskBtnHeight)];
        [scViewTail addSubview:testView];
        UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(0, 10 * ScaleSize, iTaskBtnWidth, iTaskBtnHeight)];
        [testView addSubview:btnTest];
        btnTest.backgroundColor = UIColorFromRGB(0x212848);
        btnTest.cornerRadius = 10;
        btnTest.tag = i;
        [btnTest addTarget:self action:@selector(actionTask:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0 ||
            i == 1  ) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((btnTest.bounds.size.width/4 * 3), 10 * ScaleSize - 15 * ScaleSize/2, 32 * ScaleSize, 15 * ScaleSize)];
            [testView addSubview:imgView];
            imgView.image = [UIImage imageNamed:@"Tab4-9"];
        }
        
        int iBtnTopY = 0;
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iBtnTopY, iTaskBtnWidth, 30* ScaleSize)];
        [btnTest addSubview:labelTitle];
        labelTitle.font = [UIFont systemFontOfSize:11];
        labelTitle.textColor = UIColorFromRGB(0x8b92b0);
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = arrTitlt1[i]; //@"天狗排行榜";
        
        int iImgWidth = 40 * ScaleSize;
        int iImgTopY = 30 * ScaleSize;
        int iImgLeftX = (iTaskBtnWidth - iImgWidth) /2;
        UIImageView *imgBtn = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX, iImgTopY, iImgWidth, iImgWidth)];
        [btnTest addSubview:imgBtn];
        //imgBtn.backgroundColor = [UIColor yellowColor];
        imgBtn.image =  [UIImage imageNamed:arrImg[i]];
        
        iBtnTopY +=iImgTopY + iImgWidth ;
        UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iBtnTopY, iTaskBtnWidth, 30* ScaleSize)];
        [btnTest addSubview:labelTitle2];
        labelTitle2.font = [UIFont systemFontOfSize:14];
        labelTitle2.textColor = [UIColor whiteColor];
        labelTitle2.textAlignment = NSTextAlignmentCenter;
        labelTitle2.text = arrTitlt2[i];
        
        
        iBtnTopY += labelTitle2.height;
        UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, iBtnTopY, iTaskBtnWidth, 12* ScaleSize)];
        [btnTest addSubview:labelTitle3];
        labelTitle3.font = [UIFont systemFontOfSize:11];
        labelTitle3.textColor = UIColorFromRGB(0x8b92b0);
        labelTitle3.textAlignment = NSTextAlignmentCenter;
        labelTitle3.text = arrTitlt3[i];
        
        
        
        iSCLeft += iTaskBtnWidth + 10;
     }
    scViewTail.contentSize = CGSizeMake(iArrCount * ( iTaskBtnWidth + 20), 0);
    
    
   
    


    
}



-(void) layoutMain
{
    int iTopY = 60;
    int iLeftX = 10;
    
    iTopY = 25;
    if (IS_IPHONE_X_MORE)
     {
        iTopY = 50;
     }
    UIView *viewNote = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 27)];
    [self.view addSubview:viewNote];
    viewNote.backgroundColor = UIColorFromRGB(0x222848);
    viewNote.layer.cornerRadius = viewNote.height/2;
    viewNote.layer.masksToBounds = YES;
    
    UIImageView *imgNote = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 15, 15)];
    [viewNote addSubview:imgNote];
    imgNote.image = [UIImage imageNamed:@"tab1_note"];
    
    UILabel *labelNote1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 35, 15)];
    [viewNote addSubview:labelNote1];
    labelNote1.font = [UIFont systemFontOfSize:12];
    labelNote1.textColor = [UIColor whiteColor];
    labelNote1.text = @"公告:";
    //labelNote1.backgroundColor = [UIColor yellowColor];
    
    paoma = [[SKAutoScrollLabel alloc] initWithFrame:CGRectMake(60, 6, SCREEN_WIDTH - 60 - 50 - 30, 15)];
    [viewNote addSubview:paoma];
    //paoma.backgroundColor = UIColorFromRGB(0xFDF9EC);
    paoma.font = [UIFont systemFontOfSize:12];
    paoma.textColor = [UIColor whiteColor];
    paoma.text = @"  新用户成功下载注册注册即送天狗币，完成实名认证可再送狗粮。";
    
    UIButton *btnNote = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50 - 30, 6, 50, 15)];
    [viewNote addSubview:btnNote];
    [btnNote setTitle:@"更多>>" forState:UIControlStateNormal];
    btnNote.titleLabel.font  = [UIFont systemFontOfSize:12];
    [btnNote addTarget:self action:@selector(actionNote) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += 35;
    // 天狗币
    UIImageView *imgTGB = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 21, 21)];
    [self.view addSubview:imgTGB];
    imgTGB.image = [UIImage imageNamed:@"taber1_tgb"];
    
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+30, iTopY, 50, 20)];
    [self.view addSubview:labelT1];
    labelT1.textColor = [UIColor whiteColor];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.text = @"天狗币";
    if ([PDAPI isTestUser])
     {
        labelT1.text = @"天狗分";
     }
    
    labelTGB = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 30 + 50, iTopY, 200, 20)];
    [self.view addSubview:labelTGB];
    labelTGB.textColor = [UIColor whiteColor];
    labelTGB.font = [UIFont systemFontOfSize:14];
    labelTGB.text = @"";
    
//    UIButton *btnTGB = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
//    [viewMain addSubview:btnTGB];
//    [btnTGB addTarget:self action:@selector(actonTGB) forControlEvents:UIControlEventTouchUpInside];
//    btnTGB.backgroundColor = [UIColor blueColor];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actonTGB)];
    gesture.numberOfTapsRequired  = 1;
    labelTGB.userInteractionEnabled = YES;
    [labelTGB addGestureRecognizer:gesture];
    
    UITapGestureRecognizer * gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actonTGB)];
    gesture1.numberOfTapsRequired  = 1;
    imgTGB.userInteractionEnabled = YES;
    [imgTGB addGestureRecognizer:gesture1];
    
    
    UIButton *btnMiJi = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, iTopY, 80, 85)];
    [self.view addSubview:btnMiJi];
    [btnMiJi addTarget:self action:@selector(actonQuick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *YJSQImgView = [[UIImageView alloc]initWithFrame:CGRectMake((btnMiJi.bounds.size.width - 61)/2, 0, 61, 62)];
    [btnMiJi addSubview:YJSQImgView];
    YJSQImgView.image = [UIImage imageNamed:@"Tab4-7"];
    YJSQImgView.userInteractionEnabled = NO;
    UILabel *YJSQLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(YJSQImgView.frame), btnMiJi.bounds.size.width, 20)];
    [btnMiJi addSubview:YJSQLabel];
    YJSQLabel.font = [UIFont systemFontOfSize:13];
    YJSQLabel.textColor = [UIColor whiteColor];
    YJSQLabel.textAlignment = NSTextAlignmentCenter;
    YJSQLabel.text = @"一键收取";
    
//    //TODO:uiview  单边圆角或者单边框
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btnMiJi.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(btnMiJi.frame.size.height/2,btnMiJi.frame.size.height/2)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btnMiJi.bounds;
    maskLayer.path = maskPath.CGPath;
    btnMiJi.layer.mask = maskLayer;


    
    
    
    iTopY += imgTGB.height + 15;
    // 狗粮
    UIImageView *imgGL = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 21, 21)];
    [self.view addSubview:imgGL];
    imgGL.image = [UIImage imageNamed:@"taber1_gl"];
    
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+30, iTopY, 50, 20)];
    [self.view addSubview:labelT2];
    labelT2.textColor = [UIColor whiteColor];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.text = @"狗粮";
    
    labelGL = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 30 + 50, iTopY, 200, 20)];
    [self.view addSubview:labelGL];
    labelGL.textColor = [UIColor whiteColor];
    labelGL.font = [UIFont systemFontOfSize:14];
    labelGL.text = @"";
    
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 120, 20)];
    [self.view addSubview:btnGL];
    //btnGL.backgroundColor = [UIColor yellowColor];
    [btnGL addTarget:self action:@selector(actonGL) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *btnActivity = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, iTopY, 48, 47)];
//    [self.view addSubview:btnActivity];
//    [btnActivity setBackgroundImage:[UIImage imageNamed:@"tab1_hd"] forState:UIControlStateNormal];
//    [btnActivity addTarget:self action:@selector(actionHD) forControlEvents:UIControlEventTouchUpInside];
    
    // 每日登录
    iTopY += imgGL.height + 5;
//    labelMrdl = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 40)];
//    [viewMain addSubview:labelMrdl];
//    labelMrdl.textColor = UIColorFromRGB(0xc0dceb);
//    labelMrdl.font = [UIFont systemFontOfSize:13];
//    labelMrdl.text = @"* 1822****3307完成每日登录\n获得2包狗粮";
    
    viewMrdl = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 250, 40)];
    [self.view addSubview:viewMrdl];
//    labelMrdl.font = [UIFont systemFontOfSize:13];
//    labelMrdl.text = @"* 1822****3307完成每日登录\n获得2包狗粮";
    
    
}

-(void) layoutAryBtn2
{
    int iTopY = iCenterImgTopY; //iCenterImgTopY - 60;
    int iLeftX = 10;
    int iBtnWdith = 40;
    int iBtnBetween = 20;
    if (IS_IPHONE_6_LATER)
     {
        iBtnWdith = 50;
     }
    int iBtnHeight = 50;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    
    
    int iCount = (int)[arrEnergyFromWeb count];
    
    if (iCount >= MAX_SHOW_ENERGYCOUNT)
     {
        iCount = MAX_SHOW_ENERGYCOUNT;
     }
    
    //  先清除所有之前的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
        
     }
    
    
    for (int i = 0; i< iCount; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        
        int iRowCount = 5;  // 每一行的个数
      
        int iRandWdith = arc4random()%20;
        int iRandHegiht = arc4random()%25;
        
        if (IS_IPHONE_Plus)
         {
            iRowCount = 6;
            iRandWdith = arc4random()%15;
         }
        
        //NSLog(@"Num:%d ,iRandWdith:%d  iRandHegiht:%d",i,iRandWdith, iRandHegiht);
        
        int iCurNum  = i +1;
        int iCurH =  iCurNum %iRowCount ;
        if ( 0 == i)
         {
            iBtnLeftX = iLeftX;
            iBtnTopY = iTopY;
         }
        else if (1 == iCurH &&
                 iCurNum >= (iRowCount +1) )
         {
            // 换行
            iBtnLeftX = iLeftX;
            iBtnTopY -= iBtnHeight + 30;
         }
        else
         {
            // 换列
            iBtnLeftX += iBtnBetween + iBtnWdith;
         }
        
        if (iBtnLeftX + iRandWdith + iBtnWdith >= SCREEN_WIDTH)
         {
            iRandWdith = 0;
         }
        
        AnimationButton *btnTemp = [[AnimationButton alloc] initWithFrame:CGRectMake(iBtnLeftX + iRandWdith , iBtnTopY + iRandHegiht, iBtnWdith, iBtnHeight)];
        [viewMain addSubview:btnTemp];
        btnTemp.tag =  [dic[@"sendId"] longValue]; //i;
        btnTemp.backgroundColor = [UIColor clearColor];
        
        // 设置开始动画
        [btnTemp setSatrtAnimationHegit:5];
        // 设置代理
        btnTemp.delegateWithParamater = self ;
        // 设置文字和图片
        NSString *strValue = [NSString  stringWithFormat:@"%.5f", [dic[@"coinValue"] floatValue]];
        [btnTemp setText:strValue];
        
        [arrBtn addObject:btnTemp];
     }
    
}

#pragma mark ---  布局能量
-(void) layoutAryBtn
{
    btnGrowing.hidden = YES;
    
    // iphone6之后的机型
    if (IS_IPHONE_Plus)
     {
        MAX_SHOW_ENERGYCOUNT = 10;
        [self layoutAryBtnPlus];
     }
    else if (IS_IPHONE_X_MORE)
     {
        MAX_SHOW_ENERGYCOUNT = 10;
        [self layoutAryBtnXMore];
     }
     else
      {
         if (IS_IPHONE_5)
          {
             MAX_SHOW_ENERGYCOUNT = 4;
             [self laytoutAry_5];
          }
         else
          {
             MAX_SHOW_ENERGYCOUNT = 8;
             [self laytoutAry_6_7_8];
          }
         
      }
}

-(void) laytoutAry_5
{
    int iTopY = iCenterImgTopY + 60; //iCenterImgTopY - 60;
    int iLeftX = 0;
    int iBtnWdith = 45;
    int iBtnBetween = 15;
    
    
    int iBtnHeight = 50;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    
    
    int iCount = (int)[arrEnergyFromWeb count];
    
    if (iCount >= MAX_SHOW_ENERGYCOUNT)
     {
        iCount = MAX_SHOW_ENERGYCOUNT;
     }
    
    //  先清除所有之前的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
     }
    
    
    for (int i = 0; i< iCount; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        
        int iRandWdith = arc4random()%15;
        int iRandHegiht = arc4random()%25;
        
        NSLog(@"Num:%d , iBtnLeftX:%d iRandWdith:%d  iRandHegiht:%d",i, iBtnLeftX, iRandWdith, iRandHegiht);
        
        // 换列
        if (iBtnLeftX + iRandWdith + iBtnWdith > (SCREEN_WIDTH - iBtnWdith - 50*ScaleSize) ||
            iBtnLeftX > (SCREEN_WIDTH - iBtnWdith) ||
            i == 2)
         {
            //NSLog(@"%d 开始换行",i);
            iBtnLeftX = iLeftX;
            iBtnTopY -= iBtnHeight + 30;
            
            // 第2排
            if (i == 2)
             {
                iBtnLeftX = 120 + arc4random()%15;
                iRandHegiht -= 20;
             }
        

         }
        // 换行
        else
         {
            if (i != 0)
             {
                iBtnLeftX += iBtnBetween + iBtnWdith;
             }
            
            // 第 1排 如果是第2个按钮
            if (i == 1)
             {
                iBtnLeftX += 130;
             }
            
            // 第二排 如果是第3个按钮，不能布局在狗头上
            if (i == 3)
             {
                iBtnLeftX +=  20 +  arc4random()%10;
                iRandHegiht -=  10 - arc4random()%15;
             }
            
            
         }
        
        if (0== i)
         {
            iRandHegiht = 10;
         }
        
        AnimationButton *btnTemp = [[AnimationButton alloc] initWithFrame:CGRectMake(iBtnLeftX + iRandWdith , iBtnTopY + iRandHegiht, iBtnWdith, iBtnHeight)];
        
        [viewMain addSubview:btnTemp];
        btnTemp.tag =  [dic[@"sendId"] longValue]; //i;
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.iCoinType = [dic[@"coinType"] intValue];
        
        // 设置开始动画
        [btnTemp setSatrtAnimationHegit:5];
        // 设置代理
        btnTemp.delegateWithParamater = self ;
        // 设置文字和图片
        NSString *strValue = [NSString  stringWithFormat:@"%.5f", [dic[@"coinValue"] floatValue]];
        //NSString *strValue = [NSString  stringWithFormat:@"%d", i];
        [btnTemp setText:strValue];
        
        [arrBtn addObject:btnTemp];
     }
}

-(void) laytoutAry_6_7_8
{
    int iTopY = iCenterImgTopY + 50; //iCenterImgTopY - 60;
    int iLeftX = 0;
    int iBtnWdith = 40;
    int iBtnBetween = 20;
    
    
    int iBtnHeight = 50;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    
    
    
    int iCount = (int)[arrEnergyFromWeb count];
    
    if (iCount >= MAX_SHOW_ENERGYCOUNT)
     {
        iCount = MAX_SHOW_ENERGYCOUNT;
     }
    
    //  先清除所有之前的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
     }
    
    
    for (int i = 0; i< iCount; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        
        int iRandWdith = arc4random()%20;
        int iRandHegiht = arc4random()%25;
        
        NSLog(@"Num:%d , iBtnLeftX:%d iRandWdith:%d  iRandHegiht:%d",i, iBtnLeftX, iRandWdith, iRandHegiht);
        
        // 换列
        if (iBtnLeftX + iRandWdith + iBtnWdith > (SCREEN_WIDTH - iBtnWdith - 15 - 22*ScaleSize) ||
            iBtnLeftX > (SCREEN_WIDTH - iBtnWdith - 15) ||
            i == 2 ||
            i == 7)
         {
            //NSLog(@"%d 开始换行",i);
            iBtnLeftX = iLeftX;
            iBtnTopY -= iBtnHeight + 30;
            
            if (i == 7)
             {
                iBtnTopY += arc4random()%15;
                iBtnLeftX = SCREEN_WIDTH/2 + iBtnWdith + 20;
             }
            
 
            
            // 第3排 之后
//            if (i >= 10)
//             {
//                //iBtnLeftX = SCREEN_WIDTH/2 + arc4random()%10;
//                iRandHegiht = 65;
//             }
            
         }
        // 换行
        else
         {
            if (i != 0)
             {
                iBtnLeftX += iBtnBetween + iBtnWdith;
             }
            
            // 第 1排 如果是第2个按钮
            if (i == 1)
             {
                iBtnLeftX += 160;
             }
            

            
            // 第二排 如果是第5个按钮和第6个按钮，不能布局在狗头上（往上偏移）
            if (i == 4 ||
                i == 5)
             {
                iRandHegiht = arc4random()%5 - 20 ;
             }
            
            // 第2排 7个按钮
            if (i == 6)
             {
                //iBtnLeftX = SCREEN_WIDTH  - 90 ;
                iBtnLeftX += 30;
                iBtnTopY += 40;
             }
            
         }
        
        if (0== i)
         {
            iRandHegiht = 35;
         }
        
        AnimationButton *btnTemp = [[AnimationButton alloc] initWithFrame:CGRectMake(iBtnLeftX + iRandWdith , iBtnTopY + iRandHegiht, iBtnWdith, iBtnHeight)];
        
        
        [viewMain addSubview:btnTemp];
        btnTemp.tag =  [dic[@"sendId"] longValue]; //i;
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.iCoinType = [dic[@"coinType"] intValue];
        
        // 设置开始动画
        [btnTemp setSatrtAnimationHegit:5];
        // 设置代理
        btnTemp.delegateWithParamater = self ;
        // 设置文字和图片
        NSString *strValue = [NSString  stringWithFormat:@"%.5f", [dic[@"coinValue"] floatValue]];
        //NSString *strValue = [NSString  stringWithFormat:@"%d", i];
        [btnTemp setTextFont:9];
        [btnTemp setText:strValue];
        
        [arrBtn addObject:btnTemp];
     }
}

-(void) layoutAryBtnPlus
{
    int iTopY = iCenterImgTopY + 60; //iCenterImgTopY - 60;
    int iLeftX = 0;
    int iBtnWdith = 50;
    int iBtnBetween = 20;
    
    
    int iBtnHeight = 50;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    
    int iCount = (int)[arrEnergyFromWeb count];
    
    if (iCount >= MAX_SHOW_ENERGYCOUNT)
     {
        iCount = MAX_SHOW_ENERGYCOUNT;
     }
    
    //  先清除所有之前的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
     }
    
    
    for (int i = 0; i< iCount; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        
        int iRandWdith = arc4random()%20;
        int iRandHegiht = arc4random()%25;
        
        NSLog(@"Num:%d , iBtnLeftX:%d iRandWdith:%d  iRandHegiht:%d",i, iBtnLeftX, iRandWdith, iRandHegiht);
        
        // 换列
        if (iBtnLeftX + iRandWdith + iBtnWdith > (SCREEN_WIDTH - iBtnWdith -15 - 22*ScaleSize) ||
            iBtnLeftX > (SCREEN_WIDTH - iBtnWdith- 15) ||
            i == 2)
         {
            //NSLog(@"%d 开始换行",i);
            iBtnLeftX = iLeftX;
            iBtnTopY -= iBtnHeight + 30;
            
            if (i < 8)
             {
                iRandHegiht += 30;
             }
            
            // 第二排
            if (i == 2)
             {
                iRandHegiht -= (30 + arc4random()%15);
             }
            
            // 第3排按钮
            if (i == 7)
             {
                iBtnLeftX = 120 + arc4random()%35 ;
                iBtnTopY -= 20;
                iRandHegiht -= (30 + arc4random()%15);
             }
            
            
            // 第3排 之后
//            if (i == 10)
//             {
//                iBtnLeftX = 90;
//                iBtnTopY -= (10);
//                iRandHegiht = 20;
//             }
            

         }
        // 换行
        else
         {
            if (i != 0)
             {
                iBtnLeftX += iBtnBetween + iBtnWdith;
             }
            
            // 第 1排 如果是第2个按钮，不能布局在狗头上
            if (i == 1)
             {
                iBtnLeftX = SCREEN_WIDTH - 120 -  arc4random()%30;
             }
            
            // 第二排 如果是第5个按钮，不能布局在狗头上（往上偏移）
            if (i == 4 )
             {
                iRandHegiht = arc4random()%5 - 20 ;
             }
            
//            // 第二排 如果是第6个按钮，不能布局在狗头上（往上偏移）
//            if (i == 5 )
//             {
//                iRandHegiht = arc4random()%5 - 20 ;
//             }
            
            

            

         }
        

        AnimationButton *btnTemp = [[AnimationButton alloc] initWithFrame:CGRectMake(iBtnLeftX + iRandWdith , iBtnTopY + iRandHegiht, iBtnWdith, iBtnHeight)];
        
        [viewMain addSubview:btnTemp];
        btnTemp.tag =  [dic[@"sendId"] longValue]; //i;
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.iCoinType = [dic[@"coinType"] intValue];
        
        // 设置开始动画
        [btnTemp setSatrtAnimationHegit:5];
        // 设置代理
        btnTemp.delegateWithParamater = self ;
        // 设置文字和图片
        NSString *strValue = [NSString  stringWithFormat:@"%.5f", [dic[@"coinValue"] floatValue]];
        //NSString *strValue = [NSString  stringWithFormat:@"%d", i];
        [btnTemp setText:strValue];
        
        [arrBtn addObject:btnTemp];
     }
}

-(void) layoutAryBtnXMore
{
    int iTopY = iCenterImgTopY + 50; //iCenterImgTopY - 60;
    int iLeftX = 0;
    int iBtnWdith = 50;
    int iBtnBetween = 20;

    
    int iBtnHeight = 50;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    
    
    int iCount = (int)[arrEnergyFromWeb count];
    
    if (iCount >= MAX_SHOW_ENERGYCOUNT)
     {
        iCount = MAX_SHOW_ENERGYCOUNT;
     }
    
    //  先清除所有之前的按钮
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp removeFromSuperview];
     }
    
    
    for (int i = 0; i< iCount; i++)
     {
        NSDictionary *dic = arrEnergyFromWeb[i];
        
        int iRandWdith = arc4random()%20;
        int iRandHegiht = arc4random()%25;

        NSLog(@"Num:%d , iBtnLeftX:%d iRandWdith:%d  iRandHegiht:%d",i, iBtnLeftX, iRandWdith, iRandHegiht);
        
        // 换列
        if (iBtnLeftX + iRandWdith + iBtnWdith > (SCREEN_WIDTH - iBtnWdith) ||
            iBtnLeftX > (SCREEN_WIDTH - iBtnWdith) ||
            i == 2)
         {
            //NSLog(@"%d 开始换行",i);
            iBtnLeftX = iLeftX;
            iBtnTopY -= iBtnHeight + 30;
            
            if (i < 8)
             {
                iRandHegiht =50;
             }
            
            
            // 第3排按钮
            if (i == 7)
             {
                iBtnLeftX = 120 + arc4random()%35 ;
            
                iRandHegiht -= (30 + arc4random()%15);
             }

         }
        // 换行
        else
         {
            if (i != 0)
             {
                iBtnLeftX += iBtnBetween + iBtnWdith;
             }
            
            // 第 1排 如果是第2个按钮，不能布局在狗头上
            if (i == 1)
             {
                iBtnLeftX = SCREEN_WIDTH - 120 -  arc4random()%30;
                iRandHegiht += 10;
             }

            
             // 第二排 后面2个按钮 和 第3排后面两个按钮 统一往下偏移
            if(i == 5 ||
               i == 6 ||
               i == 8 ||
               i == 9 )
             {
                iRandHegiht += 10;
             }

         }
        
        if (i ==0)
         {
            iRandHegiht = 50;
         }
        
        AnimationButton *btnTemp = [[AnimationButton alloc] initWithFrame:CGRectMake(iBtnLeftX + iRandWdith , iBtnTopY + iRandHegiht, iBtnWdith, iBtnHeight)];

        [viewMain addSubview:btnTemp];
        btnTemp.tag =  [dic[@"sendId"] longValue]; //i;
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.iCoinType = [dic[@"coinType"] intValue];
        
        // 设置开始动画
        [btnTemp setSatrtAnimationHegit:5];
        // 设置代理
        btnTemp.delegateWithParamater = self ;
        // 设置文字和图片
        NSString *strValue = [NSString  stringWithFormat:@"%.5f", [dic[@"coinValue"] floatValue]];
        //NSString *strValue = [NSString  stringWithFormat:@"%d", i];
        [btnTemp setText:strValue];
        
        [arrBtn addObject:btnTemp];
     }
    
}



// 重置动画
-(void) repeatAnimation
{
//    if (isPopVC)
//     {
//        [LoadView showHUDAddedTo:self.view animated:YES];
//     }
    // 页面切换后，动画要重置
    if ([arrBtn count] > 0)
     {
        for (int i = 0; i < [arrBtn count]; i++)
         {
            AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
            [btnTemp setSatrtAnimationHegit:5];
         }
        
        btnGrowing.hidden = YES;
     }
    else
     {
        if ([[DDGAccountManager sharedManager] isLoggedIn])
         {
            btnGrowing.hidden = NO;
            [btnGrowing setSatrtAnimationHegit:3];
         }
     }
    
    [self performSelector:@selector(deleayFun) withObject:@"" afterDelay:1.0];
}

-(void) deleayFun
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
}


-(void) layoutTail
{
    int iTopY = 30;
    int iLeftX = 10;
    
    UIView *viewTail_Head = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 90+15)];
    [viewTail addSubview:viewTail_Head];
    viewTail_Head.backgroundColor = [UIColor whiteColor];
    
    iTopY = -1;
    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 60)];
    [viewTail addSubview:viewYuan];
    viewYuan.backgroundColor = [UIColor whiteColor];
    viewYuan.cornerRadius = 30;
    // 设置阴影
    viewYuan.layer.shadowColor =  [ResourceManager lightGrayColor].CGColor;
    viewYuan.layer.shadowOffset = CGSizeMake(4, 5);
    viewYuan.layer.shadowOpacity = 0.5;
    viewYuan.layer.shadowRadius = 5;
    
    [self layoutYuan:viewYuan];
    
    iTopY = 45;
    labelListDes = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [viewTail_Head addSubview:labelListDes];
    //labelListDes.backgroundColor = [UIColor yellowColor];
    labelListDes.textColor = [ResourceManager lightGrayColor];
    labelListDes.font = [UIFont systemFontOfSize:12];
    labelListDes.textAlignment = NSTextAlignmentCenter;
    labelListDes.text = @"排行榜数据每天00:00更新一次";
    
    iTopY += 5;
    btnRK_TGB = [[UIButton alloc] initWithFrame:CGRectMake(0,  iTopY, SCREEN_WIDTH/2, 60)];
    [viewTail_Head addSubview:btnRK_TGB];
    btnRK_TGB.backgroundColor = [UIColor clearColor];
    [btnRK_TGB addTarget:self action:@selector(actionRK_TGB) forControlEvents:UIControlEventTouchUpInside];
    [btnRK_TGB setTitle:@"天狗币排行" forState:UIControlStateNormal];
    if ([PDAPI isTestUser])
     {
        [btnRK_TGB setTitle:@"天狗积分排行" forState:UIControlStateNormal];
     }
    [btnRK_TGB setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnRK_TGB.titleLabel.font = [UIFont systemFontOfSize:16];
    
    btnRK_GL = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1/2,  iTopY, SCREEN_WIDTH/2, 60)];
    [viewTail_Head addSubview:btnRK_GL];
    btnRK_GL.backgroundColor = [UIColor clearColor];
    [btnRK_GL addTarget:self action:@selector(actionRK_GL) forControlEvents:UIControlEventTouchUpInside];
    [btnRK_GL setTitle:@"狗粮排行榜" forState:UIControlStateNormal];
    [btnRK_GL setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRK_GL.titleLabel.font = [UIFont systemFontOfSize:16];
    

    
    iTopY += btnRK_GL.height +30 ;
    viewList = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 600)];
    [viewTail addSubview:viewList];
    viewList.backgroundColor = [UIColor clearColor];
    
    
   
    
    
}


-(void) layoutYuan:(UIView*) viewYuan
{
    int iYuanWidth = viewYuan.width;
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(0,  0, iYuanWidth/2, 60)];
    [viewYuan addSubview:btnGL];
    [btnGL addTarget:self action:@selector(actionGetGL) forControlEvents:UIControlEventTouchUpInside];
    //[btnGL addTarget:self action:@selector(actionHD) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView  *imgGL = [[UIImageView alloc] initWithFrame:CGRectMake(iYuanWidth/8, 15, 25, 30)];
    [btnGL addSubview:imgGL];
    imgGL.image = [UIImage imageNamed:@"rk_gl"];
    
    UILabel *labelGL = [[UILabel alloc] initWithFrame:CGRectMake(iYuanWidth/8 + 40, 15, 100, 30)];
    [btnGL addSubview:labelGL];
    labelGL.textColor = [ResourceManager color_1];
    labelGL.font = [UIFont systemFontOfSize:15];
    labelGL.text = @"获取狗粮";
    
    // 分割线
    UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(iYuanWidth/2, 15, 1, 30)];
    [viewYuan addSubview:labelFG];
    labelFG.backgroundColor = [ResourceManager color_5];
    
    UIButton *btnYQ = [[UIButton alloc] initWithFrame:CGRectMake(iYuanWidth/2,  0, iYuanWidth/2, 60)];
    [viewYuan addSubview:btnYQ];
    [btnYQ addTarget:self action:@selector(actionYQ) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView  *imgYQ = [[UIImageView alloc] initWithFrame:CGRectMake(iYuanWidth/8, 15, 28, 28)];
    [btnYQ addSubview:imgYQ];
    imgYQ.image = [UIImage imageNamed:@"rk_friend"];
    
    UILabel *labelYQ = [[UILabel alloc] initWithFrame:CGRectMake(iYuanWidth/8 + 40, 15, 100, 30)];
    [btnYQ addSubview:labelYQ];
    labelYQ.textColor = [ResourceManager color_1];
    labelYQ.font = [UIFont systemFontOfSize:15];
    labelYQ.text = @"邀请好友";
}




// 每日登录，获取狗粮弹框
-(void) popMessage:(NSString *) strMessage
{
    int iLeftX = (SCREEN_WIDTH - 200)/2;
    int iTopY = SCREEN_HEIGHT/2 - 100;
    popView = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 100)];
    [self.view addSubview:popView];
    popView.backgroundColor = [UIColor whiteColor];
    popView.cornerRadius = 10;
    
    UILabel *labelGL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 35)];
    [popView addSubview:labelGL];
    labelGL.textAlignment = NSTextAlignmentCenter;
    labelGL.textColor = [ResourceManager mainColor];
    labelGL.font = [UIFont systemFontOfSize:35];
    labelGL.text = strMessage;
    
    UILabel *labelMRDL = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 200, 20)];
    [popView addSubview:labelMRDL];
    labelMRDL.textAlignment = NSTextAlignmentCenter;
    labelMRDL.textColor = [ResourceManager mainColor];
    labelMRDL.font = [UIFont systemFontOfSize:13];
    labelMRDL.text = @"每日登录，获得狗粮";
    
    [self performSelector:@selector(deleayRemove) withObject:@"" afterDelay:2.0];
    
}

-(void) deleayRemove
{
    [popView removeFromSuperview];
}

#pragma mark --- 根据网络数据来布局UI
-(void) setUIofDate
{
    labelTGB.text = [NSString stringWithFormat:@"%.5f", fTGB];
    labelGL.text = [NSString stringWithFormat:@"%d", (int)fGL];
    
    // 如果有冻结的货币
    if(fFrozenCoin > 0.00)
     {
        labelTGB.text = [NSString stringWithFormat:@"%5.2f/%d", fTGB,(int)fFrozenCoin];
        [labelTGB sizeToFit];
        
        if (!imgLock)
         {
            int iImgLeftX =  labelTGB.left + labelTGB.width+5;
            imgLock = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX,
                                                                    labelTGB.top, 15, 16)];
            [self.view addSubview:imgLock];
            imgLock.image = [UIImage imageNamed:@"tab1_lock"];
            imgLock.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionLock)];
            gesture.numberOfTapsRequired  = 1;
            imgLock.userInteractionEnabled = YES;
            [imgLock addGestureRecognizer:gesture];
         }
        else
         {
            imgLock.hidden = NO;
         }
     }
    else
     {
        imgLock.hidden = YES;
     }
    
    if (strCountdown &&
        strCountdown.length > 0)
     {
        // 换成小条狗的图标
        //viewCenter.image =  [UIImage imageNamed:@"taber1_home_center_small"];
        homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_samll"];
        imgText.hidden = NO;
        NSString *strOut = [NSString stringWithFormat:@"/////  %@   /////",strCountdown];
        labelSmall.text = strOut;
        viewCenter.userInteractionEnabled = YES;
        gifImageView.hidden = NO;
        btnGrowing.hidden = YES;
     }
    else
     {
        //viewCenter.image =  [UIImage imageNamed:@"taber1_home_center"];
        homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_bg"];
        imgText.hidden = YES;
        viewCenter.userInteractionEnabled = YES;
        gifImageView.hidden = YES;
     }
}

-(void) getTaskViewofData:(NSArray*) arrTask
{
    [viewMrdl removeAllSubviews];
    
    NSMutableArray *tempArr = @[].mutableCopy;
    for (int i = 0; i < [arrTask count]; i++)
     {
        NSDictionary *dic = arrTask[i];
        UILabel *labelOne = [[UILabel alloc] init];
        labelOne.font = [UIFont systemFontOfSize:13];
        NSString *strOut = [NSString stringWithFormat:@"%@\n%@",dic[@"task1"],dic[@"task2"]];
        labelOne.text = strOut;//@"asdflkjaslfkjas~a;sjfklasfasadaaadd12345678\n哈哈";
        labelOne.textColor = UIColorFromRGB(0xc0dceb);//[UIColor whiteColor];
        labelOne.numberOfLines = 0;
        labelOne.textAlignment = NSTextAlignmentLeft;
        [tempArr addObject:labelOne];
     }
    

    
    if (viewMrdl)
     {
        LSMarqueeView *marqueeView = [[LSMarqueeView alloc] initWithFrame:CGRectMake(0, 0, viewMrdl.width, viewMrdl.height) andLableArr:tempArr];
        [viewMrdl addSubview:marqueeView];
        
        [marqueeView startCountdown];
     }
}

#pragma mark ---  弹出红包
- (void) popHongbao
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iKuangWdith = 330;
    int iKuangHeight = 350;
    // 创建按钮的背景框
    UIImageView *viewKuang = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2, 85, iKuangWdith , iKuangHeight  ) ];
    //viewKuang.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [bgView addSubview:viewKuang];
    viewKuang.image = [UIImage imageNamed:@"hb_btn"];
    
    
    
    

    
    int iKuangTopY = iKuangHeight - 90;
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake((iKuangWdith - 150)/2, iKuangTopY, 150, 50)];
    [viewKuang addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"hb_bg"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = NO;
    //caseBackBtn.backgroundColor = [UIColor yellowColor];
    
    iKuangTopY -= (caseBackBtn.height);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iKuangTopY, iKuangWdith, 30)];
    [viewKuang addSubview:label1];
    
    NSString *strJL = @"20TGB+20包狗粮";
    NSDictionary *dicUsr = [DDGAccountManager sharedManager].userInfo;
    if ([dicUsr count] > 0)
     {
        strJL = [NSString stringWithFormat:@"%@TBG+%@包狗粮",dicUsr[@"abilityValue"],dicUsr[@"xjCoinCount"]];
     }
    label1.text = strJL;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:28];
    label1.textColor = UIColorFromRGB(0xfcd64f);
    
    iKuangTopY -= (label1.height + 10);
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iKuangTopY, iKuangWdith, 30)];
    [viewKuang addSubview:label2];
    label2.text = @"恭喜您获得";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:18];
    
    

    
    viewKuang.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [viewKuang addGestureRecognizer:tapGesture];
    
    //[self shakeToShow:bgView];//放大过程中的动画
}

-(void) closeView
{
    [self getHongBao];
    [background removeFromSuperview];
}


#pragma mark ---  弹出竞拍成功
- (void) popJingPai:(NSArray*)  arrJP
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iKuangWdith = 270;
    int iKuangHeight = 280;
    // 创建按钮的背景框
    UIImageView *viewKuang = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, 155, iKuangWdith , iKuangHeight  ) ];
    //viewKuang.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [bgView addSubview:viewKuang];
    viewKuang.image = [UIImage imageNamed:@"bid_success"];
    viewKuang.userInteractionEnabled = YES;
    

    
    int iKuangTopY = iKuangHeight - 50;
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake((iKuangWdith - 150)/2, iKuangTopY, 150, 50)];
    [viewKuang addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"bid_btn_ok"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = YES;
    [caseBackBtn addTarget:self action:@selector(actionCKXQ) forControlEvents:UIControlEventTouchUpInside];

    
    int iImgWdith = 110;
    iKuangTopY -= (caseBackBtn.height +iImgWdith -40) ;
    NSDictionary *dic = arrJP[0];
    if (dic)
     {

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake( (iKuangWdith - iImgWdith)/2, iKuangTopY, iImgWdith, iImgWdith)];
        [viewKuang addSubview:imgView];
        
        NSString *strImgUrl = dic[@"imgUrl"];
        if (strImgUrl)
         {
            [imgView setImageWithURL:[NSURL URLWithString:strImgUrl]];
         }
     }
    
    
    
    bgView.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView2)];
    [bgView addGestureRecognizer:tapGesture];
    
    //[self shakeToShow:bgView];//放大过程中的动画
}

-(void) closeView2
{
    [background removeFromSuperview];
    //MyBiddersRecrodVC *VC = [[MyBiddersRecrodVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---  弹出自己办卡或邀请好友办卡
- (void) popYQHY
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iKuangWdith = 250;
    int iKuangHeight = 330;
    
    int iImgBGTopY = 175;
    // 背景图片
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, iImgBGTopY, iKuangWdith , iKuangHeight-30 )];
    [bgView addSubview:imgBG];
    imgBG.userInteractionEnabled = YES;
    imgBG.image = [UIImage imageNamed:@"pop_bk_bg"];
    
    // 创建按钮的背景框
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, 125, iKuangWdith , iKuangHeight+100 )];
    [bgView addSubview:viewKuang];

    
    // 创建关闭按钮
    int iKuangTopY = 0;
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(iKuangWdith+30, iImgBGTopY-40, 25, 25)];
    [bgView addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"pop_bk_colse"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(closeView3) forControlEvents:UIControlEventTouchUpInside];
    

    iKuangTopY = iKuangHeight - 50;
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, iKuangTopY, 110, 50)];
    [viewKuang addSubview:caseBackBtn];
    [caseBackBtn setBackgroundImage:[UIImage imageNamed:@"pop_bk_sqbk"] forState:UIControlStateNormal];
    [caseBackBtn addTarget:self action:@selector(actionSQBK) forControlEvents:UIControlEventTouchUpInside];
   // caseBackBtn.backgroundColor = [UIColor yellowColor];
    
    
    UIButton * caseBackBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(125, iKuangTopY, 110, 50)];
    [viewKuang addSubview:caseBackBtn2];
    [caseBackBtn2 setBackgroundImage:[UIImage imageNamed:@"pop_bk_yqhy"] forState:UIControlStateNormal];
    [caseBackBtn2 addTarget:self action:@selector(actionSQBK2) forControlEvents:UIControlEventTouchUpInside];
    //caseBackBtn2.backgroundColor = [UIColor yellowColor];
    
    iKuangTopY = iKuangHeight + 40 ;
    UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(50, iKuangTopY, 20, 20)];
    [viewKuang addSubview:btnCheck];
    btnCheck.userInteractionEnabled = YES;
    [btnCheck setImage:[UIImage imageNamed:@"pop_bk_gb1"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(actionBtnCheck:) forControlEvents:UIControlEventTouchUpInside];
    isNextNoShow = NO;
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, iKuangTopY, 200, 20)];
    [viewKuang addSubview:labelTitle];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text = @"今天不再显示";
    
    

}


#pragma mark ---  弹出广告弹框
- (void) popGuangGao:(NSString *) strImgBG    andNO:(int) iNO
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iKuangWdith = 250;
    int iKuangHeight = 330;
    
    int iImgBGTopY = 175;
    // 背景图片
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, iImgBGTopY, iKuangWdith , iKuangHeight-30 )];
    [bgView addSubview:imgBG];
    imgBG.userInteractionEnabled = YES;
    imgBG.image = [UIImage imageNamed:strImgBG];
    
    // 创建按钮的背景框
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, 125, iKuangWdith , iKuangHeight+100 )];
    [bgView addSubview:viewKuang];
    
    
    UIButton *btnAction = [[UIButton alloc] initWithFrame:imgBG.frame];
    [bgView addSubview:btnAction];
    btnAction.tag = iNO;
    [btnAction addTarget:self action:@selector(actionGuangGao:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 创建关闭按钮
    int iKuangTopY = 0;
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(iKuangWdith+30, iImgBGTopY-40, 25, 25)];
    [bgView addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"pop_bk_colse"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(closeView3) forControlEvents:UIControlEventTouchUpInside];
    
    
//    iKuangTopY = iKuangHeight - 50;
//    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, iKuangTopY, 110, 50)];
//    [viewKuang addSubview:caseBackBtn];
//    [caseBackBtn setBackgroundImage:[UIImage imageNamed:@"pop_bk_sqbk"] forState:UIControlStateNormal];
//    [caseBackBtn addTarget:self action:@selector(actionSQBK) forControlEvents:UIControlEventTouchUpInside];
//    // caseBackBtn.backgroundColor = [UIColor yellowColor];
//
//
//    UIButton * caseBackBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(125, iKuangTopY, 110, 50)];
//    [viewKuang addSubview:caseBackBtn2];
//    [caseBackBtn2 setBackgroundImage:[UIImage imageNamed:@"pop_bk_yqhy"] forState:UIControlStateNormal];
//    [caseBackBtn2 addTarget:self action:@selector(actionSQBK2) forControlEvents:UIControlEventTouchUpInside];
//    //caseBackBtn2.backgroundColor = [UIColor yellowColor];
    
    iKuangTopY = iKuangHeight + 40 ;
    UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(50, iKuangTopY, 20, 20)];
    [viewKuang addSubview:btnCheck];
    btnCheck.userInteractionEnabled = YES;
    [btnCheck setImage:[UIImage imageNamed:@"pop_bk_gb1"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(actionBtnCheck:) forControlEvents:UIControlEventTouchUpInside];
    isNextNoShow = NO;
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, iKuangTopY, 200, 20)];
    [viewKuang addSubview:labelTitle];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text = @"今天不再显示";
    
    
    
}

-(void) actionBtnCheck:(UIButton*) sender
{
    isNextNoShow = !isNextNoShow;
    if (isNextNoShow)
     {
        [sender setImage:[UIImage imageNamed:@"pop_bk_gb2"] forState:UIControlStateNormal];
     }
    else
     {
         [sender setImage:[UIImage imageNamed:@"pop_bk_gb1"] forState:UIControlStateNormal];
     }
}

-(void) closeView3
{
    [background removeFromSuperview];
    
    if (isNextNoShow)
     {

        [CommonInfo setKey:K_IS_NO_POP_GG withValue:@"1"];
     }
    
    
}


-(void) actionCKXQ
{
    [background removeFromSuperview];
    MyBiddersRecrodVC *VC = [[MyBiddersRecrodVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}



#pragma mark ---  ButtonDelegateWithParameter
-(void)delegateFunctionWithParameter:(id)parameter
{
    AnimationButton* btnTemp = (AnimationButton*)parameter;
    int  iCoinType = btnTemp.iCoinType;
    long lTag = (long)btnTemp.tag;
    NSLog(@"lTog:%ld", lTag);
    
    [self delArrEnergyForwWeb:lTag];
    
    [arrBtn removeObject:btnTemp];
    
    int iBtnCount = (int)arrBtn.count;
    NSLog(@"arrBtn.count:%d", iBtnCount);
    
    NSString *strValue = [btnTemp getLabelText];
    float fVlaue = [strValue floatValue];
    if (fVlaue > 0.000 &&
        iCoinType == 1)
     {
        fTGB += fVlaue;
        [self setUIofDate];
     }
    
    
    if (iBtnCount == 0)
     {
        [self sendEnergy];
        
        if ([arrEnergyFromWeb count] == 0)
         {
            btnGrowing.hidden = NO;
            [btnGrowing  setSatrtAnimationHegit:3];
         }
     }
    
    // 当前页面能量收集光，并且后台能量缓存中还有数据
    if (iBtnCount == 0 &&
        [arrEnergyFromWeb count] > 0)
     {
        //[self layoutAryBtn];
        [self performSelector:@selector(layoutAryBtn) withObject:nil afterDelay:1.5];
     }
    
    
    
    
}

#pragma mark  ---  action
// 解决按钮上加入动画， 按钮不响应的BUG
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:self.view];
    //NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    
    CGPoint point2 = [sender locationInView:viewMain];
    //NSLog(@"handleSingleTap!pointx:%f,y:%f",point2.x,point2.y);
    
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];

        // 点击的范围，在按钮的 presentationLayer层上
        if (CGRectContainsPoint(((CALayer *)[btnTemp.layer presentationLayer]).frame, point))
         {
            [btnTemp setEndAnimation];
            [self delegateFunctionWithParameter:btnTemp];
         }
        else if (CGRectContainsPoint(((CALayer *)[btnTemp.layer presentationLayer]).frame, point2))
         {
            [btnTemp setEndAnimation];
            [self delegateFunctionWithParameter:btnTemp];
         }

     }
}

-(void) actionRightView
{
//    static int iCount = 0;
//    iCount++;
//    NSArray *arrName = @[@"new_tab1_right_note1",@"new_tab1_right_note2",@"new_tab1_right_note3"];
//    int iNo = iCount%3;
//    rightView.image = [UIImage imageNamed:arrName[iNo]];
//
//    [self performSelector:@selector(delayFun) withObject:nil afterDelay:3];
    
}

-(void) actionLeftView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(1)}];
}



//-(void) actionTask:(UIButton*) sender
//{
//    int iTag = (int)sender.tag;
//    NSLog(@"actionTask:%d" ,iTag);
//
//    if (![[DDGAccountManager sharedManager] isLoggedIn]){
//        [DDGUserInfoEngine engine].parentViewController = self;
//        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//        return;
//     }
//
//
//    if (0 == iTag)
//     {
//
//        int identityStatus = 0;
//        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
//        if ([dic count] > 0)
//         {
//            identityStatus = [dic[@"identityStatus"] intValue];
//         }
//
//        // 认证
//        if(identityStatus != 1)
//         {
//            [self actionPopSMRZ];
//            return;
//         }
//
//        // 信用卡
//        CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//
//     }
//    if (1 == iTag)
//     {
//        // 玩转双十一
//        [CCWebViewController showWithContro:self withUrlStr:@"http://tkyh.tiangouwo.com" withTitle:@"天狗折扣淘商城"];
//
//     }
//    if (2 == iTag)
//     {
//        // 邀请好友
//        //[self actionYQ];
//
//        AddFriendVC *VC = [[AddFriendVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//
//     }
//    if (3 == iTag)
//     {
//        // 天狗排行榜
//        RankVC  *VC  = [[RankVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//     }
//    if (4 == iTag)
//     {
//        // 热门活动
//        [self actionHD];
//     }
//    if (5 == iTag)
//     {
//        // 成为星主
//        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
//        vc.homeUrl = @"tgwproject/starSign";
//        vc.titleStr = @"成为星主";
//        [self.navigationController pushViewController:vc animated:YES];
//
//     }
//    if (6 == iTag)
//     {
//        // 游戏
//        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
//        vc.homeUrl = @"tgwproject/game/index";
//        vc.titleStr = @"天狗食月";
//        vc.jumpType = @"game";
//        [self.navigationController pushViewController:vc animated:YES];
//
//     }
//    if (7 == iTag)
//     {
//        // 读书
//        QuestionVC  *vc = [[QuestionVC alloc] init];
//        NSString *url = [NSString stringWithFormat:@"https://book.mediaway.cn/bookweb/App/book/h5/index.html?lid=969&pid=146#/home/quality"];
//        vc.homeUrl = [NSURL URLWithString:url];
//        vc.titleStr = @"读书";
//        [self.navigationController pushViewController:vc animated:YES];
//
//     }
//}

-(void) actionTask:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    NSLog(@"actionTask:%d" ,iTag);
    
    if (![[DDGAccountManager sharedManager] isLoggedIn]){
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    
    int iNO = 0;
    if (iNO++ == iTag)
     {
        
        int identityStatus = 0;
        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
        if ([dic count] > 0)
         {
            identityStatus = [dic[@"identityStatus"] intValue];
         }
        
        // 认证
        if(identityStatus != 1)
         {
            [self actionPopSMRZ];
            return;
         }
        
        // 天狗口袋
        WithdrawTGW_VC  *VC = [[WithdrawTGW_VC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
//    if (1 == iTag)
//     {
//
//        int identityStatus = 0;
//        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
//        if ([dic count] > 0)
//         {
//            identityStatus = [dic[@"identityStatus"] intValue];
//         }
//
//        // 认证
//        if(identityStatus != 1)
//         {
//            [self actionPopSMRZ];
//            return;
//         }
//
//        // 信用卡
//        CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//
//     }
//    if (2 == iTag)
//     {
//        // 借钱
//        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
//        vc.homeUrl = @"tgwproject/BorrowMoney";
//        vc.titleStr = @"办理贷款";
//        [self.navigationController pushViewController:vc animated:YES];
//
//     }
    if (iNO++ == iTag)
     {
        // 热门活动
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/activity";
        vc.titleStr = @"热门活动";
        [self.navigationController pushViewController:vc animated:YES];
     }
    if (iNO++ == iTag)
     {
        // 购物商城
        QuestionVC  *vc = [[QuestionVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"https://j.youzan.com/MM8cV9"];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"商城";
        [self.navigationController pushViewController:vc animated:YES];
     }
    if (iNO++ == iTag)
     { 
        // 邀请好友
        AddFriendVC *VC = [[AddFriendVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    if (iNO++ == iTag)
     {
        // 天狗排行榜
        RankVC  *VC  = [[RankVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    if (iNO++ == iTag)
     {
        // 更多活动
        MoreActivityVC  *VC = [[MoreActivityVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    
}

-(void) actonQuick
{
    // 一键领取
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp setEndAnimation];
     }
    
    
    // 快速发送天狗币
    [arrSend removeAllObjects];
    [arrEnergyFromWeb removeAllObjects];
    [arrBtn removeAllObjects];
    
    
    for (int i = 0; i < [arrBtn count]; i++)
     {
        AnimationButton *btnTemp = (AnimationButton*)arrBtn[i];
        [btnTemp setEndAnimation];
     }
    
    [self quickSendEnergyToWeb];
    
    
    // 在延迟后执行
    [self actionPopFormQuick];

}


-(void) delayPop
{
    [self popYQHY];
}

-(void) actionGetGL
{

    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
     }
    
    isPopVC = YES;
    GLTaskVC *VC = [[GLTaskVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionYQ
{
    AddFriendVC *VC = [[AddFriendVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    [self closeView3];
    
}

-(void) actionSQBK
{
    int identityStatus = 0;
    NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
    if ([dic count] > 0)
     {
        identityStatus = [dic[@"identityStatus"] intValue];
     }
    
    // 认证
    if(identityStatus != 1)
     {
        [MBProgressHUD showErrorWithStatus:@"请先实名认证" toView:self.view];
        return;
     }
    
    // 信用卡
    CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    [self closeView3];
}


-(void) actionSQBK2
{

    
    CreditCardWebVC  *vc = [[CreditCardWebVC alloc] init];
    vc.homeUrl = @"tgwproject/cardAward";
    vc.titleStr = @"天狗窝";
    [self.navigationController pushViewController:vc animated:YES];
    
    [self closeView3];
}


-(void) actonGL
{
    isPopVC = YES;
    GLRecordVC  *vc = [[GLRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actonTGB
{
    isPopVC = YES;
    TGBRecordVC  *vc = [[TGBRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionLogin
{

    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    return;
    
}


-(void) actionLock
{
    LockTBGVC *VC = [[LockTBGVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionHD
{
    XcodeWebVC  *vc = [[XcodeWebVC alloc] init];

    //NSString *url = [NSString stringWithFormat:@"%@pages/invite.html?signId=%@",[PDAPI WXSysRouteAPI],[DDGSetting sharedSettings].signId];
    //vc.homeUrl = [NSURL URLWithString:url];
    
    vc.homeUrl = @"tgwproject/activity";
    vc.titleStr = @"热门活动";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void) actionNote
{
    //http://www.tiangouwo.com/pages/tgwNotice.html
    
    QuestionVC  *vc = [[QuestionVC alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@pages/tgwNotice.html",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"天狗公告";
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) actionPop
{
    if (![[DDGAccountManager sharedManager] isLoggedIn]){
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    if (!strCountdown ||
        strCountdown.length <= 0 )
     {
        [self actionLanchAndMesseg];
        return;
     }
    
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>实名认证</font>"]];

    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>可加速小奶狗生长哦</font>"]];
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"立即实名" color:[ResourceManager mainColor] actionBlock:^{
        
        
        int identityStatus = 0;
        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
        if ([dic count] > 0)
         {
            identityStatus = [dic[@"identityStatus"] intValue];
         }
        
        // 认证
        if(identityStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"您已经通过认证 " toView:self.view];
            return;
         }
        
        if (identityStatus == 0 ||
            identityStatus == 1 ||
            identityStatus == 2) {
            ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
            [self.navigationController pushViewController: ctl animated:YES];
        }else{
            ApproveViewController *ctl = [[ApproveViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }

    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

-(void) actionPopSMRZ
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>提示</font>"]];
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>请实名认证后，再参加此活动。</font>"]];
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"立即实名" color:[ResourceManager mainColor] actionBlock:^{
        
        
        int identityStatus = 0;
        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
        if ([dic count] > 0)
         {
            identityStatus = [dic[@"identityStatus"] intValue];
         }
        
        // 认证
        if(identityStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"您已经通过认证 " toView:self.view];
            return;
         }
        
        if (identityStatus == 0 ||
            identityStatus == 1 ||
            identityStatus == 2) {
            ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
            [self.navigationController pushViewController: ctl animated:YES];
        }else{
            ApproveViewController *ctl = [[ApproveViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

// 天狗变笑脸，并且说话
-(void) actionLanchAndMesseg
{
    //
//    if (isLanchAndMessage)
//     {
//        return;
//     }
    isLanchAndMessage = YES;
    homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_lanch"];
    //homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_bg"];
    
    imgMessage.hidden = NO;  // 狗狗说话的弹框
    
    
    iLangchCount++;
    
    NSArray *arrTitle = @[@"主人，你猜我爱天狗币还是爱狗粮",
                          @"不，爱你",
                          @"你猜我最想喝什么",
                          @"呵护你",
                          @"主人，我好像有点感冒",
                          @"我对你完全没有抵抗力",
                          @"主人，你今天好讨厌",
                          @"讨人喜欢百看不厌",
                          @"主人，我有超能力",
                          @"超级喜欢你",
                          @"主人，你今天有点怪",
                          @"怪好看的",
                          @"主人，我想去旅游了",
                          @"去你的世界你的心里",
                          @"主人你知道我的缺点吗",
                          @"缺点你",
                          @"你知道我明天打算干什么吗",
                          @"越来越爱你",
                          @"主人，我是九你是三",
                          @"除了是你还是你",
                          @"主人，猜猜我的心在哪边",
                          @"在你那边",
                          @"主人，你闻到什么味道了吗",
                          @"你一来空气都好甜",
                          @"主人，你为什么要害我",
                          @"害我那么喜欢你",
                          @"主人，你知道现在几点了吗",
                          @"我们幸福的起点",
                          @"主人，我知道你在什么地方",
                          @"离我心脏最近的地方",
                          @"主人，我知道你是哪里人",
                          @"我的心上人",
                          @"主人，你猜我什么星座的",
                          @"为你量身定做",
                          @"主人，你脸上有点东西",
                          @"有点好看",
                          @"主人，123不许动",
                          @"对不起，我心动了",
                          @"主人，你猜我想吃什么",
                          @"痴痴望着你",
                          @"主人，你猜我属什么",
                          @"我属于你",
                          @"主人，我好想你来",
                          @"来，我们的未来",
                          @"主人，我一点都不想你",
                          @"除了一点都在想你",
                          @"主人，我这么努力是为什么",
                          @"为了配的上你",
                          @"主人，天气越来越冷了呢",
                          @"别怕，有我的热情",
                          @"主人，你不在，我都瘦了呢",
                          @"主人，今天有好好吃饭吗？",
                          @"主人，每天都要开开心心哦~",
                          @"主人，狗粮越多，本领越强哦",
                          @"主人，我发现我越来越爱你了",
                          @"主人，嘘，抱抱~",
                          @"你是我唯一的主人，么么哒",
                          @"我最乖了，你多来陪我玩好吗？",
                          @"能跟着主人，是我最大的荣幸。",
                          @"主人，你当上了星主吗？",
                          @"主人，好友越多狗粮越多呢",
                          @"主人，多分享多创造价值哟",
                          @"主人，好期待你在排行榜前十呢",
                          @"主人，又出新活动了你知道吗",
                          @"主人，竞拍商城又上新品了哟",
                          @"主人，你终于来了",
                          @"主人，我们要约定永远在一起哦",
                          @"主人，最好的岁月就是和你在一起",
                          @"主人，好想好想抱抱你",
                          @"主人，享受每一刻的小时光",
                          @"我要努力锻炼，本领才能更强",
                          @"主人来的越多，我就会越强壮呢",
                          @"金子总会发光，天狗币也会发光哟",
                          @"听说幸运的时候会有幸运币呢",
                          @"主人，优秀的人在一起会更优秀",
                          @"主人，你是不是也最爱我呢",
                          @"主人，你不在的时候我会乖乖的",
                          @"主人，我最害怕孤单",
                          @"主人，你说我可爱不可爱",
                          @"每天的任务都不要偷懒哦",
                          @"幸福就是和你在一起",
                          @"哇喔，主人你好厉害哦~",
                          @"我要永远守护你，我的主人",
                          @"主人，谢谢你陪我一起成长",
                          @"我有各种爱好，但最爱是你",
                          @"主人，不要丢下我，好吗",
                          @"有什么困难，我们一起度过",
                          @"主人，我有一些小秘密告诉你",
                          @"主人，感恩每一次的相遇",
                          @"我无法改变过去，但能改变未来。",
                          @"主人，让我们一起来实现梦想",
                          @"主人，人生的巅峰我们一起走",
                          @"主人，我所需要的时间其实很少",
                          @"主人，狗粮能激发我的无线潜能",
                          @"主人一定能过上自己想要的生活",
                          @"主人，美好的明天在等着我们哦",
                          @"主人，爱我你就抱抱我",
                          @"主人，你不要调皮啦",
                          @"主人，死心塌地的跟着你",
                          @"主人，有你这一生一世无怨无悔",
                          @"遇见你，是我最大的小幸运",
                          @"主人，你今天真的是怪好看的",
                          @"付出的越多，得到的越多",
                          @"难过的时候不要怕，有我在",
                          @"只要一眼，我就知道你是我的",
                          @"主人努力让我产生更大的价值吧",
                          @"千万千万不要放弃我，主人",
                          @"天涯海角不如在你心里",
                          @"只要有你，我就是最幸福的天狗",
                          @"主人，我对你完全没有抵抗力",
                          @"主人，我爱狗粮更爱你",
                          @"主人，我永远属于你"
                        ];
    
    static int iMeesageNO  = 0;
    int arrTitleCount = (int)[arrTitle count];
    iMeesageNO  = iMeesageNO %arrTitleCount;
    labelTGMessage.text = arrTitle[iMeesageNO];
    iMeesageNO++;
    [self performSelector:@selector(delayFun) withObject:nil afterDelay:3];
}



-(void) delayFun
{
    homeView.image = [UIImage imageNamed:@"new_tab1_mid_home_bg"];
    isLanchAndMessage = NO;
    iLangchCount--;
    if (0 == iLangchCount)
     {
        imgMessage.hidden = YES;
     }
}

-(void) actionPopFormQuick
{
    //#define  K_IS_NO_POP_GG  @"K_IS_NoPop_GG"         // 是否 不再弹框广告
    //#define  K_POP_NO    @"K_Pop_No"             // 弹框的当前计数器 0 —— N -1
    //#define  K_POP_DATE  @"K_Pop_Date"           // 弹框的当前日期
    NSString *strPopNo = [CommonInfo getKey:K_POP_NO];
    NSString *strPopDate = [CommonInfo getKey:K_POP_DATE];
    NSString *strISNotPop = [CommonInfo getKey:K_IS_NO_POP_GG];
    int iPopNo = [strPopNo intValue];

    
    //获取当前时间日期
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    
    // 如果日期相等 并且不再显示标记位为1  直接退出
    if ([strPopDate isEqualToString:dateStr] &&
        [strISNotPop isEqualToString:@"1"])
     {
        return;
     }
    else
     {
        [CommonInfo setKey:K_IS_NO_POP_GG withValue:@"0"];
     }
    
    // 如果当前弹框日期不等于当前日期，多加一天
    if (![strPopDate isEqualToString:dateStr] &&
        strPopNo.length >0)
     {
        iPopNo++;
        strPopNo = [NSString stringWithFormat:@"%d", iPopNo];
     }

    // 存储当前日期，为弹框日期
    [CommonInfo setKey:K_POP_DATE withValue:dateStr];
    
   if (iPopNo == 0)
    {
       [self popYQHY];
       [CommonInfo setKey:K_POP_NO withValue:@"0"];
       return;
    }
    
    //NSArray *arrName = @[@"办信用卡",@"贷款",@"好友助力",@"竞拍",@"每日任务",@"天狗食月",@"天狗星座",@"优惠券",@"最新活动"];
    NSArray *arrImg = @[@"pop_bk_bg",@"pop_bg_dk",@"pop_bg_hyzl",@"pop_bg_jp",@"pop_bg_mrrw",@"pop_bg_game",@"pop_bg_tgxz",@"pop_bg_yhq",@"pop_bg_zxhd"];
    if (iPopNo < [arrImg count])
     {
        NSString *strImg = arrImg[iPopNo];
        [self popGuangGao:strImg andNO:iPopNo];
        
        [CommonInfo setKey:K_POP_NO withValue:strPopNo];
     }
    else
     {
        [CommonInfo setKey:K_POP_NO withValue:@""];
     }
    
}

-(void) actionGuangGao:(UIButton*) sender
{
    //NSArray *arrName = @[@"办信用卡",@"贷款",@"好友助力",@"竞拍",@"每日任务",@"天狗食月",@"天狗星座",@"优惠券",@"最新活动"];
    int iTag = (int)sender.tag;
    if (1 == iTag)
     {
        // 贷款
        // 借钱
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/BorrowMoney";
        vc.titleStr = @"办理贷款";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (2 == iTag)
     {
        // 好友助力
        AddFriendVC *VC = [[AddFriendVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (3 == iTag)
     {
        // 竞拍
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2)}];
     }
    else if (4 == iTag)
     {
        // 每日任务
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3)}];
     }
    else if (5 == iTag)
     {
        // 天狗食月
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/game/index";
        vc.titleStr = @"天狗食月";
        vc.jumpType = @"game";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (6 == iTag)
     {
        // 天狗星座
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/starSign";
        vc.titleStr = @"成为星主";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (7 == iTag)
     {
        // 优惠券
        [CCWebViewController showWithContro:self withUrlStr:@"http://tkyh.tiangouwo.com" withTitle:@"天狗折扣淘商城"];
     }
    else if (8 == iTag)
     {
        // 最新活动
        [self actionHD];
     }
    
    
    [self closeView3];

}

#pragma mark ---  定时器
-(void) creatTime
{
    static long long  llTimeCount = 0;
    
    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
     }
    
    //设置时间间隔
    NSTimeInterval period = 30.0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer1, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // block 会立马执行一遍，后面隔一定时间间隔再执行一次
    dispatch_source_set_event_handler(_timer1, ^{
        // 定时器事件回调
        llTimeCount++;
        NSLog(@"定时器%lld次运行" ,llTimeCount);
        [self sendEnergy];
        
        if (llTimeCount >= 60)
         {
            llTimeCount = 0;
         }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中实现需要的功能 （UI操作）
            
        });
        
    });
    
    dispatch_resume(_timer1);
    

        

}

#pragma mark --- 网络请求
-(void) updateLoginTime
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGupdateLoginInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    //parmas[@"nickName"] = textNikeName.text;
    //parmas[@"referCode"] = textInvitationCode.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                  }];
    operation.tag = 999;
    [operation start];
}

-(void) getEnergyFromWeb
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    
    if ([arrSend count] > 0)
     {
        [self sendEnergyToWeb];
        return;
     }
    
    if (!isFirstLoad)
     {
        [LoadView showHUDAddedTo:self.view animated:YES];
        isFirstLoad = YES;
     }
    

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryBaseInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];

    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView hideHUDForView:self.view animated:YES];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) sendEnergyToWeb
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetReceiveXjCoin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:arrSend
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    NSString *stringSend = @"";
    if (data == nil)
     {
        return;
     }
    else
     {
        stringSend = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
     }
    
    
    parmas[@"receiveCoinJson"] = stringSend;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}


-(void) quickSendEnergyToWeb
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetquickReceiveCoin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    

    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self getEnergyFromWeb];
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}



-(void)getTaskRecord
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGtaskRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                      
                                                                                  }];
    operation.tag = 1004;
    [operation start];
    
}


-(void) getUserInfo
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetUserInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1005;
    [operation start];
}



-(void) getHongBao
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGreceiveReward];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1006;
    [operation start];
}


-(void) getNoteInfo
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryNotifyInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1007;
    [operation start];
}

-(void) getAuctionOrder
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionOrder];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1008;
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    

    if (999 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        NSString *abilityValue = dic[@"abilityValue"];
        if (abilityValue &&
            abilityValue.length > 0)
         {
            NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
             int  status = [dicUser[@"status"] intValue];
            if (0 == status)
             {
                return;
             }
            
            [self popMessage:abilityValue];
         }

        
     }
    if (1000 == operation.tag)
     {
        
        if (isPopVC &&
            isShow)
         {
            //[self performSelector:@selector(deleayFun) withObject:@"" afterDelay:0.2];
            [LoadView hideAllHUDsForView:self.view animated:YES];
            isPopVC = NO;
         }
        else
         {
        
            [LoadView hideAllHUDsForView:self.view animated:YES];
         }
        
        //
        // 获取能量
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            btnGrowing.hidden = YES;
            [self getArrEnergyForwWeb:arr];
         }
        else if ([arrEnergyFromWeb count] == 0)
         {
            btnGrowing.hidden = NO;
            [btnGrowing setSatrtAnimationHegit:3];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count])
         {
            fTGB = [dic[@"xjCoinCount"] floatValue];
            fGL = [dic[@"abilityValue"] floatValue];
            fFrozenCoin = [dic[@"frozenCoin"] floatValue];
            strCountdown = dic[@"countdown"];
            [self setUIofDate];
            
            strTGB = [NSString stringWithFormat:@"%@", dic[@"xjCoinCount"]];
            labelTGB.text = strTGB;
         }
     }
    else if (1001 == operation.tag)
     {
        // 发送能量
        for (int i = 0 ; i < [arrSend count]; i++)
         {
            NSDictionary *dic = arrSend[i];
            
            [lockEngeryWeb lock];
            [arrEnergyFromWeb removeObject:dic];
            [lockEngeryWeb unlock];
         }
        [arrSend removeAllObjects];
     }
    else if (1002 == operation.tag)
     {
        [self getEnergyFromWeb];
     }
    else if (1003 == operation.tag)
     {
        // 狗粮排行榜

     }
    else if (1004 == operation.tag)
     {
        // 任务列表 (滚动提示列表)
        arrTask = operation.jsonResult.rows;
        NSLog(@"arrTask:%@", arrTask);
        if ([arrTask count] > 0)
         {
            [self getTaskViewofData:arrTask];
            //labelMrdl.text = [NSString stringWithFormat:@"%@\n%@",dic[@"task1"],dic[@"task2"]];
         }
     }
    else if (1005 == operation.tag)
     {
        // 获取是否弹红包
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            [DDGAccountManager sharedManager].userInfo = (NSMutableDictionary*)dic;
            
            [[DDGSetting sharedSettings] setUid:[dic objectForKey:@"customerId"]];
            
            NSString *strNikeName = dic[@"nickName"];
            if (!strNikeName ||
                strNikeName.length <= 0)
             {
                SetNikeNameVC *vc = [[SetNikeNameVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
             }
            NSString *wxQrCodeUrl = dic[@"wxQrCodeUrl"];
            if (wxQrCodeUrl &&
                wxQrCodeUrl.length > 0)
             {
                [CommonInfo setKey:K_WXQRCODEURL withValue:wxQrCodeUrl];
             }
            
            int  status = [dic[@"status"] intValue];
            if ( 0 == status )
             {
                [self popHongbao];
             }
            
         }

     }
    else if (1006 == operation.tag)
     {
        // 获取红包成功，刷新天狗币和狗粮
        [self getEnergyFromWeb];
     }
    else if (1007 == operation.tag)
     {
        // 公告
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            paoma.text = dic[@"appNotifyText"];
         }
     }
    else if (1008 == operation.tag)
     {
        // 查询竞拍记录接口
        NSArray *arrJP = operation.jsonResult.rows;
        if ([arrJP count] > 0)
         {
            [self popJingPai:arrJP];
         }
        else
         {
            // 更新登录时间
            [self updateLoginTime];
         }
     }

}




@end
