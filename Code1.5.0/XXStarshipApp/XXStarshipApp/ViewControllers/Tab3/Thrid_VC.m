//
//  Thrid_VC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "Thrid_VC.h"
#import "TGBRecordVC.h"
#import "GLRecordVC.h"
#import "MySetVC.h"
#import "GLTaskVC.h"
#import "GLTaskVC2.h"
#import "SecretBooksVC.h"
#import "IntroduceVC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "TGMJ_VC.h"
#import "QuestionVC.h"
#import "AddressVC.h"
#import "ShopRecordVC.h"
#import "AddFriendVC.h"
#import "AddFriendWebVC.h"


@interface Thrid_VC ()
{
    UIScrollView *scView;
    
    UIImageView *imgHead;
    UILabel *labelName;
    UILabel *labelNO;
    UILabel *labelDay;
    
    UIView *viewMid;
}
@end

@implementation Thrid_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self layoutUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self getUserInfo];
    
    // 设置状态栏字体颜色为白色
    barStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
}


-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}

#pragma mark --- 布局UI
-(void) layoutUI
{

    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 300);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (!IS_IPHONE_X_MORE)
         {
            scView.height += 20;
         }
        else
         {
            scView.height += 64;
         }
    }
    else
     {
        scView.top -= 20;
        scView.height += 40;
        
        
     }
    
    int iTopY = 0;
    int iLeftX = 15;
    UIImageView *viewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavHeight)];
    [scView addSubview:viewHead];
    //viewHead.backgroundColor = UIColorFromRGB(0x96b3c3);
    viewHead.image = [UIImage imageNamed:@"tab3_head_top"];
    viewHead.userInteractionEnabled = YES;

    iTopY +=NavHeight;
    
    UIImageView *viewBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 160)];
    [scView addSubview:viewBG2];
    viewBG2.image = [UIImage imageNamed:@"tab3_head_bg"];
    viewBG2.userInteractionEnabled = YES;
    
    
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 200)];
    [scView addSubview:viewBG];
    //viewBG.image = [UIImage imageNamed:@"tab3_head_bg"];
    viewBG.userInteractionEnabled = YES;
    
    //添加手势
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionImg)];
    gesture.numberOfTapsRequired  = 1;
    [viewBG addGestureRecognizer:gesture];
    
    
    iTopY = NavHeight - 20;
    UIButton *btnSet = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, iTopY, 25, 23)];
    [scView addSubview:btnSet];
    [btnSet setBackgroundImage:[UIImage imageNamed:@"tab3_set"] forState:UIControlStateNormal];
    [btnSet addTarget:self action:@selector(actionSet) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY =NavHeight +20;
    
    imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 120, 120)];
    [scView addSubview:imgHead];
    imgHead.image = [UIImage imageNamed:@"tab3_head2"];
    //imgHead.backgroundColor = [UIColor yellowColor];
    imgHead.cornerRadius = imgHead.width/2;
    imgHead.layer.masksToBounds = YES;
    imgHead.userInteractionEnabled = YES;
    
    //添加手势
    UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionImg)];
    gesture2.numberOfTapsRequired  = 1;
    [imgHead addGestureRecognizer:gesture2];
    

    
    iTopY += 20;
    labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 140, iTopY, 200, 20)];
    [scView addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:17];
    labelName.textColor = [UIColor whiteColor];
    labelName.text = @"去登录";
    
    iTopY += 30;
    labelNO = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 140, iTopY, 200, 20)];
    [scView addSubview:labelNO];
    labelNO.font = [UIFont systemFontOfSize:14];
    labelNO.textColor = UIColorFromRGB(0xc0dceb);
    labelNO.text = @"";
    
    iTopY += 30;
    labelDay = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 140, iTopY, 200, 20)];
    [scView addSubview:labelDay];
    labelDay.font = [UIFont systemFontOfSize:14];
    labelDay.textColor = UIColorFromRGB(0xc0dceb);
    labelDay.text = @"";
    
    iTopY += labelDay.height + 40;

    viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1000)];
    [scView addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];

    [self layoutMidView];
    

}

- (void) layoutMidView
{
    int iTopY = 10;
    int iLeftX = 15;
    
    int iBtnWidth = (SCREEN_WIDTH - 15*3)/2;
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, iBtnWidth, 80)];
    [viewMid addSubview:btnLeft];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"tab3_yqhy"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(actionYQHY) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 150, 30)];
    [btnLeft addSubview:labelLeft];
    labelLeft.textColor = [UIColor whiteColor];
    labelLeft.font = [UIFont systemFontOfSize:15];
    labelLeft.text = @"邀请好友";
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(2*15 + iBtnWidth, iTopY, iBtnWidth, 80)];
    [viewMid addSubview:btnRight];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"tab3_wdzc"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(actionWDZC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 150, 30)];
    [btnRight addSubview:labelRight];
    labelRight.textColor = [UIColor whiteColor];
    labelRight.font = [UIFont systemFontOfSize:15];
    labelRight.text = @"我的资产";


    // 第一个圆圈
    iTopY += btnLeft.height + 10;
    UIView *viewYuan1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2* iLeftX, 150)];
    [viewMid addSubview:viewYuan1];
    viewYuan1.backgroundColor = [UIColor whiteColor];
    viewYuan1.cornerRadius = 10;
    viewYuan1.layer.shadowColor =  [ResourceManager lightGrayColor].CGColor;
    viewYuan1.layer.shadowOffset = CGSizeMake(4, 5);
    viewYuan1.layer.shadowOpacity = 0.5;
    viewYuan1.layer.shadowRadius = 15;
    
    NSArray *arrImg = @[@"tab3_my_smrz",@"tab3_my_yqjl",@"tab3_my_gl",@"tab3_my_hqgl"];
    NSArray *arrName = @[@"实名认证",@"邀请记录",@"我的狗粮",@"获取狗粮"];
    
//    if ([PDAPI isTestUser])
//     {
//        arrName = @[@"我的天狗积分",@"我的狗粮",@"获取狗粮"];
//     }
    
    int iViewYuan1TopY = 0;
    for (int i = 0; i < [arrImg count]; i++)
     {
        [self addYuanView:viewYuan1 andNO:i  Top:iViewYuan1TopY imgName:arrImg[i] Name:arrName[i]];
        iViewYuan1TopY += 50;
     }
    viewYuan1.height = iViewYuan1TopY;
    
    // 第二个圆圈
    iTopY +=viewYuan1.height + 20;
    UIView *viewYuan1_A = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2* iLeftX, 100)];
    [viewMid addSubview:viewYuan1_A];
    viewYuan1_A.backgroundColor = [UIColor whiteColor];
    viewYuan1_A.cornerRadius = 10;
    viewYuan1_A.layer.shadowColor =  [ResourceManager lightGrayColor].CGColor;
    viewYuan1_A.layer.shadowOffset = CGSizeMake(4, 5);
    viewYuan1_A.layer.shadowOpacity = 0.5;
    viewYuan1_A.layer.shadowRadius = 15;
    
    arrImg = @[@"tab3_my_shop",@"tab3_my_shdz"];
    arrName = @[@"商城记录",@"收货地址",];
    
    int iViewYuan2TopY = 0;
    for (int i = 0; i < [arrImg count]; i++)
     {
        [self addYuanView:viewYuan1_A andNO:10+i  Top:iViewYuan2TopY imgName:arrImg[i] Name:arrName[i]];
        iViewYuan2TopY += 50;
     }
    viewYuan1_A.height = iViewYuan2TopY;
    
    
    // 第三个圆圈
    iTopY +=viewYuan1_A.height + 20;
    UIView *viewYuan1_B = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2* iLeftX, 100)];
    [viewMid addSubview:viewYuan1_B];
    viewYuan1_B.backgroundColor = [UIColor whiteColor];
    viewYuan1_B.cornerRadius = 10;
    viewYuan1_B.layer.shadowColor =  [ResourceManager lightGrayColor].CGColor;
    viewYuan1_B.layer.shadowOffset = CGSizeMake(4, 5);
    viewYuan1_B.layer.shadowOpacity = 0.5;
    viewYuan1_B.layer.shadowRadius = 15;
    
    arrImg = @[@"tab3_my_wfjs"];
    arrName = @[@"玩法介绍"];
    
    int iViewYuan3TopY = 0;
    for (int i = 0; i < [arrImg count]; i++)
     {
        [self addYuanView:viewYuan1_B andNO:20+i  Top:iViewYuan3TopY imgName:arrImg[i] Name:arrName[i]];
        iViewYuan3TopY += 50;
     }
    viewYuan1_B.height = iViewYuan3TopY;
    
    
    
    // 第四个圆圈
    iTopY +=viewYuan1_B.height + 20;
    UIView *viewYuan2 =  [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2* iLeftX, 150)];
    [viewMid addSubview:viewYuan2];
    viewYuan2.backgroundColor = [UIColor whiteColor];
    viewYuan2.cornerRadius = 10;
    viewYuan2.layer.shadowColor =  [ResourceManager lightGrayColor].CGColor;
    viewYuan2.layer.shadowOffset = CGSizeMake(4, 5);
    viewYuan2.layer.shadowOpacity = 0.5;
    viewYuan2.layer.shadowRadius = 15;
    [self layoutUIViewYuan2:viewYuan2];
    
    iTopY += viewYuan2.height + 30;
    UILabel *lableWZ = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewMid addSubview:lableWZ];
    lableWZ.textColor = [ResourceManager lightGrayColor];
    lableWZ.font = [UIFont systemFontOfSize:13];
    lableWZ.textAlignment = NSTextAlignmentCenter;
    lableWZ.text = @"天狗窝官方网址 www.tiangouwo.com";
    
    
    iTopY = NavHeight  + viewMid.top +  viewYuan1.height + viewYuan1_A.height + viewYuan1_B.height  + viewYuan2.height + 155 ;
    if (IS_IPHONE_X_MORE)
     {
        iTopY += 30;
     }
    scView.contentSize = CGSizeMake(0, iTopY);
    
    
}

-(void) addYuanView:(UIView*)viewParent  andNO:(int)iNO  Top:(int) iTopY
            imgName:(NSString*)imgName  Name:(NSString*)Name
{
    int iViewWdith = viewParent.width;
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iViewWdith, 50)];
    [viewParent addSubview:viewTemp];
    viewTemp.backgroundColor = [UIColor clearColor];
    viewTemp.tag = iNO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [viewTemp addSubview:imgView];
    imgView.image = [UIImage imageNamed:imgName];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 150, 20)];
    [viewTemp addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = Name;
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iViewWdith - 30, 15, 12, 20)];
    [viewTemp addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, iViewWdith, 1)];
    [viewTemp addSubview:labelFG];
    labelFG.backgroundColor = [ResourceManager color_5];
    

    UIButton *btnTemp = [[UIButton alloc] initWithFrame:viewTemp.frame];
    [viewParent addSubview:btnTemp];
    btnTemp.tag = iNO;
    [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) layoutUIViewYuan2:(UIView*) viewParent
{
    int iViewWdith = viewParent.width;
    int iTopY = 10;
    int iLeftX = 15;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [viewParent addSubview:label1];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [ResourceManager color_1];
    label1.text = @"天狗窝介绍";
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iViewWdith - 30, iTopY, 12, 20)];
    [viewParent addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow-2"];
    
    //添加手势
    label1.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTGWJS)];
    gesture2.numberOfTapsRequired  = 1;
    [label1 addGestureRecognizer:gesture2];
    
    iTopY = 40;
    UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iViewWdith, 1)];
    [viewParent addSubview:labelFG];
    labelFG.backgroundColor = [ResourceManager color_5];
    
    iTopY += 20;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewParent addSubview:label2];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [ResourceManager color_1];
    label2.text = @"去中心化价值交流生态圈";

    
    UIImageView *imgQiu = [[UIImageView alloc] initWithFrame:CGRectMake(iViewWdith - 90, iTopY, 55, 42)];
    [viewParent addSubview:imgQiu];
    imgQiu.image = [UIImage imageNamed:@"tab3_my_jlzx"];
    
    iTopY += 20;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewParent addSubview:label3];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [ResourceManager lightGrayColor];
    label3.text = @"价值贡献者参与价值分享";
    
    if ([PDAPI isTestUser])
     {
        label2.text = @"交流生态圈";
        label3.text = @"";
     }
    
    //添加手势
    viewParent.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTGWJS)];
    gesture3.numberOfTapsRequired  = 1;
    [viewParent addGestureRecognizer:gesture3];
    
}

-(void) setUIHead:(NSDictionary*) dicUser
{
    if (dicUser == nil )
     {
        labelName.text = @"去登录";
        imgHead.image = [UIImage imageNamed:@"tab3_head2"];
        labelNO.text = @"";
        labelDay.text = @"";
        return;
     }
    
    labelName.text = dicUser[@"nickName"];//@"哈哈";
    
    [imgHead sd_setImageWithURL:[NSURL URLWithString:dicUser[@"headImg"]] placeholderImage:[UIImage imageNamed:@"tab3_head1"]];
    
    NSString *strNO = [NSString stringWithFormat:@"%@", dicUser[@"rank"]];//  @"10501";
    NSString *strAll = [NSString stringWithFormat:@"天狗窝 %@ 号天狗",strNO];
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:stringRange];
    labelNO.attributedText = noteString;
    
    
    NSString *strDay = [NSString stringWithFormat:@"%@", dicUser[@"rangeDay"]];//@"58";
    strAll = [NSString stringWithFormat:@"天狗窝探索天数 %@",strDay];
    noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    stringRange =  [strAll rangeOfString:strDay];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:stringRange];
    labelDay.attributedText = noteString;
}



#pragma mark --- 网络通讯
-(void) getUserInfo
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        [self setUIHead:nil];
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
    operation.tag = 1000;
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1000 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            [self setUIHead:dic];
            
            [DDGAccountManager sharedManager].userInfo = (NSMutableDictionary*)dic;
         }
     }
}

#pragma mark ---  action
-(void) actionBtn:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (0 == iTag)
     {

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
     }
    else if (1 == iTag)
     {
        // 邀请记录
        AddFriendWebVC  *vc = [[AddFriendWebVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@pages/invitation_record.html?signId=%@",[PDAPI WXSysRouteAPI],[DDGSetting sharedSettings].signId];
        
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"邀请好友";
        [self.navigationController pushViewController:vc animated:YES];
        
        //TGBRecordVC  *vc = [[TGBRecordVC alloc] init];
        //[self.navigationController pushViewController:vc animated:YES];
     }
    else if (2 == iTag)
     {
        GLRecordVC  *vc = [[GLRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (3 == iTag)
     {
        if (![[DDGAccountManager sharedManager] isLoggedIn])
         {
            [DDGUserInfoEngine engine].parentViewController = self;
            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
            return;
         }
        
       [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3)}];
     }
    else if (10 == iTag)
     {
        // 商城记录
        ShopRecordVC   *vc = [[ShopRecordVC  alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (11 == iTag)
     {
        // 商城记录
        AddressVC   *vc = [[AddressVC  alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (20 == iTag)
     {
        TGMJ_VC  *vc = [[TGMJ_VC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@tgwproject/playIntroduce",[PDAPI WXSysRouteAPI]];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"玩法介绍";
        [self.navigationController pushViewController:vc animated:YES];
     }
}

-(void) actionYQHY
{
    AddFriendVC *VC = [[AddFriendVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionWDZC
{
    TGBRecordVC  *vc = [[TGBRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionImg
{
    //开始登录
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
     }
    
    [self actionSet];
}

-(void) actionSet
{
    MySetVC *vc = [[MySetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionTGWJS
{
    if ([PDAPI isTestUser])
     {
        SecretBooksVC *vc = [[SecretBooksVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
     }
    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/TgwExplain",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"天狗窝介绍";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionTGMJ
{
    TGMJ_VC  *vc = [[TGMJ_VC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/playIntroduce",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"玩法介绍";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
