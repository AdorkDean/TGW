//
//  MoreActivityVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/7.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "MoreActivityVC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "CreditCardWebVC.h"
#import "XcodeWebVC.h"
#import "AddFriendVC.h"
#import "RankVC.h"
#import "QuestionVC.h"
#import "WithdrawTGW_VC.h"

@interface MoreActivityVC ()
{
    UIScrollView  *scView;
    
    UIView *viewTail;
}
@end

@implementation MoreActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"更多活动"];
    
    [self layoutUI];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccounSMRZNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}

-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 600);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.userInteractionEnabled = YES;
    
    
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    int iTopY = 0;
    //int iLeftX = 15;
    
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    [scView addSubview:imgTop];
    imgTop.image = [UIImage imageNamed:@"More_bg"];
    
    
    iTopY += imgTop.height -50;
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 500)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = UIColorFromRGB(0x130f42);
    
    NSArray *arrTitlt1 = @[@"重磅上线",@"办信用卡",@"办理贷款",@"购物达人分享",@"好友助力",@"天狗排行榜",@"热门活动",@"争霸宇宙",@"天狗食月",@"休闲时光"];
    NSArray *arrTitlt2 = @[@"天狗口袋",@"现金+天狗币",@"最高可借50万",@"特惠商城",@"邀请好友",@"每天更新数据",@"天狗洒金",@"成为星主",@"游戏",@"阅读小说"];
    NSArray *arrTitlt3 = @[@"分享创造价值",@"一键分享轻松获佣",@"正规专业 方便快捷",@"独家海量优惠券大放送",@"人脉就是最大的财富",@"分享创造价值",@"创造属于你的价值",@"百万天狗等你来指挥",@"动动手指赚狗粮",@"停下来享受闲暇时光"];
    NSArray *arrImg = @[@"More_tgkd",@"More_banka",@"More_jieqian",@"More_tgsc",@"More_yqhy",@"More_phb",@"More_tgsj",@"More_cwxz",@"More_game",@"More_book"];
    
//    NSArray *arrTitlt1 = @[@"重磅上线",@"购物达人分享",@"好友助力",@"天狗排行榜",@"热门活动",@"争霸宇宙",@"天狗食月"];
//    NSArray *arrTitlt2 = @[@"天狗口袋",@"特惠商城",@"邀请好友",@"每天更新数据",@"天狗洒金",@"成为星主",@"游戏"];
//    NSArray *arrTitlt3 = @[@"分享创造价值",@"独家海量优惠券大放送",@"人脉就是最大的财富",@"分享创造价值",@"创造属于你的价值",@"百万天狗等你来指挥",@"动动手指赚狗粮"];
//    NSArray *arrImg = @[@"More_tgkd",@"More_tgsc",@"More_yqhy",@"More_phb",@"More_tgsj",@"More_cwxz",@"More_game"];
    
    int iImgWidth = (SCREEN_WIDTH - 3*15)/2;
    int iCount = (int)[arrTitlt1 count];
    
    int iImgTopY = 10;
    int iImgLeftX = 15;
    
    for (int i = 0; i < iCount; i++)
     {
        UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(iImgLeftX, iImgTopY, iImgWidth, iImgWidth)];
        [viewTail addSubview:viewTemp];
        viewTemp.backgroundColor = UIColorFromRGB(0x3048b5);
        viewTemp.cornerRadius = 8;
        
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:viewTemp.frame];
        [viewTail addSubview:btnTemp];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionTask:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iImgWidth, iImgWidth/4)];
        [viewTemp addSubview:label1];
        label1.font = [UIFont systemFontOfSize:13];
        label1.textColor = UIColorFromRGB(0xa0b5ff);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = arrTitlt1[i];
        
        UIImageView *imgICON = [[UIImageView alloc] initWithFrame:CGRectMake( (iImgWidth -  iImgWidth*2/5)/2, iImgWidth/4, iImgWidth*2/5, iImgWidth*2/5)];
        [viewTemp addSubview:imgICON];
        imgICON.image = [UIImage imageNamed:arrImg[i]];
        
        UILabel *label12= [[UILabel alloc] initWithFrame:CGRectMake(0, iImgWidth*3/5+5, iImgWidth, iImgWidth/4)];
        [viewTemp addSubview:label12];
        label12.font = [UIFont systemFontOfSize:16];
        label12.textColor = [UIColor whiteColor];
        label12.textAlignment = NSTextAlignmentCenter;
        label12.text = arrTitlt2[i];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, label12.top + 20 + 2, iImgWidth, iImgWidth/4)];
        [viewTemp addSubview:label3];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = UIColorFromRGB(0xa0b5ff);
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = arrTitlt3[i];
        
        
        int iNo = i+1;

        if (iNo%2 == 0 &&
            iNo != 1)
         {
            iImgLeftX =  15;
            iImgTopY += iImgWidth +15;
         }
        else
         {
            iImgLeftX += iImgWidth + 15;
         }

     }
    if (iCount %2 == 1)
     {
        iImgTopY += iImgWidth +15;
     }
    viewTail.height = iImgTopY;
    scView.contentSize = CGSizeMake(0, imgTop.height - 50 + viewTail.height);
    
    
    
}


#pragma mark --- action
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
        //[MBProgressHUD showErrorWithStatus:@"即将上线" toView:self.view];
        
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
        
        WithdrawTGW_VC  *VC = [[WithdrawTGW_VC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (iNO++ == iTag)
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

        // 信用卡
        CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];

     }
    else if (iNO++ == iTag)
     {
        // 借钱
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/BorrowMoney";
        vc.titleStr = @"办理贷款";
        [self.navigationController pushViewController:vc animated:YES];

     }
    else if (iNO++ == iTag)
     {
        // 购物商城
        QuestionVC  *vc = [[QuestionVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"https://j.youzan.com/MM8cV9"];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"商城";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (iNO++ == iTag)
     {
        // 邀请好友
        AddFriendVC *VC = [[AddFriendVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (iNO++ == iTag)
     {
        // 天狗排行榜
        RankVC  *VC  = [[RankVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (iNO++ == iTag)
     {
        // 热门活动
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/activity";
        vc.titleStr = @"热门活动";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (iNO++ == iTag)
     {
        // 成为星主
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/starSign";
        vc.titleStr = @"成为星主";
        [self.navigationController pushViewController:vc animated:YES];
        
     }
    else if (iNO++ == iTag)
     {
        // 游戏
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        //CreditCardWebVC  *vc = [[CreditCardWebVC alloc] init];
        vc.homeUrl = @"tgwproject/games";
        vc.titleStr = @"游戏";
        vc.jumpType = @"game";
        [self.navigationController pushViewController:vc animated:YES];
        
     }
    else if (iNO++ == iTag)
     {
        // 读书
        QuestionVC  *vc = [[QuestionVC alloc] init];
        //NSString *url = [NSString stringWithFormat:@"http://t.mediaway.cn/HZ7Fz"];
         NSString *url = [NSString stringWithFormat:@"https://book.mediaway.cn/bookweb/App/book/h5/index.html?lid=969&pid=146#/home/quality"];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"读书";
        [self.navigationController pushViewController:vc animated:YES];
        
     }

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




@end
