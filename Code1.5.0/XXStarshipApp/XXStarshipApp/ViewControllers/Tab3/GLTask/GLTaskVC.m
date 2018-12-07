//
//  GLTaskVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/27.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "GLTaskVC.h"
#import "SiginDayVC.h"
#import "AuthenticationVC.h"
#import "AddFriendFristVC.h"
#import "AttentionWechatVC.h"
#import "JoinGruopVC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "AddFriendWebVC.h"
#import "QuestionVC.h"
#import "CreditCardWebVC.h"

@interface GLTaskVC ()
{
    UIScrollView *scView;

    NSDictionary *dicData;
    
    UIView *viewJCRW;
    UILabel *labelYQHY;
    UILabel *labelSMRZ;
    int iBtnWidth;
    
    UIView *viewDJRW;
    UILabel *labelWXGZ;
    UILabel *labelJRQL;
    UILabel *labelJRQQ;
    UILabel *labelYWBX;
    
    
    int identityStatus;  // 1 表示实名认证
    int followWxStatus;  // 1 表示关注微信号成功
    int joinWxQunStatus; // 1 表示加入群聊成功
    int joinQqQunStatus; // 1 表示加入QQ群成功
    int insuranceStatus; // 1 表示意外保险领取成功
    
    
    
    UIView *viewDJRW2;
    UILabel *labelJRBY;
    
    int joinByQunStatus; // 1 表示加入币用群成功
}
@end

@implementation GLTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"狗粮任务"];
    
    

}

-(void) viewWillAppear:(BOOL)animated
{
    [self getTaskInfo];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 300);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 0 ;
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 170)];
    [scView addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"TGB_bg"];
    viewBG.userInteractionEnabled = YES;
    
    iTopY = 30;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [scView addSubview:lableTitle];
    lableTitle.textColor = [UIColor whiteColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:46];
    lableTitle.text = @"狗粮";
    
    iTopY += lableTitle.height + 15;
    int iBtnLeftX = 80;
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, SCREEN_WIDTH - 2*iBtnLeftX, 30)];
    [scView addSubview:btnGL];
    btnGL.layer.borderColor = [UIColor whiteColor].CGColor;
    btnGL.layer.borderWidth = 0.5;
    btnGL.cornerRadius = 15;
    [btnGL setTitle:@"促进天狗技能的神秘能量" forState:UIControlStateNormal];
    [btnGL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGL.titleLabel.font = [UIFont systemFontOfSize:14];
    
    int iLeftX = 15;
    iTopY = viewBG.height + 20;
    UILabel*labelJCRW = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scView addSubview:labelJCRW];
    labelJCRW.textColor = [ResourceManager color_1];
    //labelJCRW.textAlignment = NSTextAlignmentCenter;
    labelJCRW.font = [UIFont systemFontOfSize:15];
    labelJCRW.text = @"基础任务";
    
    iTopY += labelJCRW.height + 20;
    viewJCRW = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX , 130)];
    [scView addSubview:viewJCRW];
    viewJCRW.backgroundColor = [UIColor whiteColor];
    viewJCRW.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    viewJCRW.layer.borderWidth = 1;
    viewJCRW.cornerRadius = 5;
    
    [self setViewJCRW];
    
    if ([PDAPI isTestUser])
     {
        return;
     }
    
    iTopY += viewJCRW.height + 20;
    UILabel*labelDJRW = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scView addSubview:labelDJRW];
    labelDJRW.textColor = [ResourceManager color_1];
    //labelJCRW.textAlignment = NSTextAlignmentCenter;
    labelDJRW.font = [UIFont systemFontOfSize:15];
    labelDJRW.text = @"独家任务";

    iTopY += labelDJRW.height + 20;
    viewDJRW = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX , 130)];
    [scView addSubview:viewDJRW];
    viewDJRW.backgroundColor = [UIColor whiteColor];
    viewDJRW.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    viewDJRW.layer.borderWidth = 1;
    viewDJRW.cornerRadius = 5;
    
    [self setViewDJRW];
    
    iTopY += viewDJRW.height + 20;
    viewDJRW2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, (SCREEN_WIDTH - 2*iLeftX) , 130)];
    [scView addSubview:viewDJRW2];
    viewDJRW2.backgroundColor = [UIColor whiteColor];
    viewDJRW2.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    viewDJRW2.layer.borderWidth = 1;
    viewDJRW2.cornerRadius = 5;
    
    [self setViewDJRW2];
    
    iTopY += viewDJRW2.height + 10;
    scView.contentSize =  CGSizeMake(0, iTopY);
    
//    iBtnWidth = viewJCRW.width/3;
//    UIButton *btnDJRW = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 150)];
//    [scView addSubview:btnDJRW];
//    btnDJRW.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
//    btnDJRW.layer.borderWidth = 1;
//    btnDJRW.cornerRadius = 5;
//
//    UIImageView *imgBtn = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth-50)/2, 30, 50, 50)];
//    [btnDJRW addSubview:imgBtn];
//    imgBtn.image = [UIImage imageNamed:@"task_yanfa"];
//
//    UILabel *labelBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, iBtnWidth, 20)];
//    [btnDJRW addSubview:labelBtn];
//    labelBtn.textColor = [ResourceManager color_1];
//    labelBtn.font = [UIFont systemFontOfSize:14];
//    labelBtn.textAlignment = NSTextAlignmentCenter;
//    labelBtn.text = @"研发途中";
    
    
}

-(void) setViewJCRW
{
    int iWdith = viewJCRW.width/3;
    int iHeight = viewJCRW.height;
    int iLeftX = 0;
    int iTopY = 20;
    
    NSString *strMRDL = [NSString stringWithFormat:@"登录获得%@狗粮",dicData[@"loginReward"]];
    NSString *strRZ = [NSString stringWithFormat:@"认证获得%@狗粮",dicData[@"identityReward"]];
    NSString *strRZ2 = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"identityReward"]];
    
    NSArray *arrImg = @[@"task_yqhy",@"task_mrdl",@"task_smrz"];
    NSArray *arrName = @[@"邀请好友",@"每日登录",@"实名认证"];
    NSArray *arrSubTitle = @[@"好友越多狗粮越多",strMRDL,strRZ];
    NSArray *arrSu2Title = @[@"获取长期狗粮",@"+2长期狗粮",strRZ2];
    for (int i = 0;  i < 3; i++)
     {
    
        UIButton *btnYQHY = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, iWdith, iHeight)];
        [viewJCRW addSubview:btnYQHY];
        btnYQHY.tag = i;
        [btnYQHY addTarget:self  action:@selector(actionJCRW:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake( (iWdith-60)/2, iTopY, 60, 30)];
        [btnYQHY addSubview:imgTop];
        imgTop.image = [UIImage imageNamed:arrImg[i]];
        
        iTopY += imgTop.height + 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
        [btnYQHY addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = arrName[i];
//        if(0 == i)
//         {
//            label1.font = [UIFont systemFontOfSize:13];
//         }
        
        iTopY += label1.height + 10;
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
//        [btnYQHY addSubview:label2];
////        label2.textColor = [ResourceManager lightGrayColor];
////        label2.font = [UIFont systemFontOfSize:10];
////        label2.textAlignment = NSTextAlignmentCenter;
////        label2.text = arrSubTitle[i];//@"邀请好友获取狗粮";
        
        
        //iTopY += label2.height + 5;
        UILabel *label3 = [[UILabel alloc]  initWithFrame:CGRectMake(15, iTopY, iWdith - 30, 20)];
        [btnYQHY addSubview:label3];
        label3.backgroundColor = [ResourceManager mainColor];
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = arrSu2Title[i];//@"邀请好友";
        
        if (i == 0)
         {
            labelYQHY = label3;
         }
        
        if (i == 1)
         {
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [ResourceManager color_1];
            label3.text = [NSString stringWithFormat:@"  +%@长期狗粮",dicData[@"loginReward"]];//@"  已完成";
            
            //label3.left = 10;
            //label3.width = iWdith - 20;

            UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
            [label3 addSubview:imgLeft];
            imgLeft.image = [UIImage imageNamed:@"task_gou"];
         }
    
        if (i == 2)
         {
            labelSMRZ = label3;
         }
        
        
        iLeftX += iWdith;
        iTopY = 20;
     }
    
    

    
    // 加入分割线
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iWdith, 35, 1, 65)];
    [viewJCRW addSubview:viewFG1];
    viewFG1.backgroundColor = UIColorFromRGB(0xededed);
    
    
    // 加入分割线
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(2*iWdith, 35, 1, 65)];
    [viewJCRW addSubview:viewFG2];
    viewFG2.backgroundColor = UIColorFromRGB(0xededed);
    
    
}

-(void) setUIHead:(NSDictionary*) dicData
{
    int inviteCount = [dicData[@"inviteCount"] intValue];
    if (inviteCount > 0)
     {

        
        NSString *strOut = @"  获取长期狗粮";//[NSString stringWithFormat:@"  获取狗粮",inviteCount];
        labelYQHY.text = strOut;//@" 已邀请20好友";
        labelYQHY.textColor = [ResourceManager color_1];
        labelYQHY.backgroundColor = [UIColor clearColor];
       
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelYQHY addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
        
        labelYQHY.width = 100;
        labelYQHY.left = 10;
     }
    
    
    identityStatus = [dicData[@"identityStatus"] intValue];
    if(identityStatus == 1)
     {
        labelSMRZ.backgroundColor = [UIColor clearColor];
        labelSMRZ.textColor = [ResourceManager color_1];
        NSString *strRZ = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"identityReward"]];
        labelSMRZ.text = strRZ;//@"  已认证";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelSMRZ addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
        
        //labelSMRZ.width = 100;
        //labelSMRZ.left = 5;
     }
    
    
    // 1 表示关注微信号成功
    followWxStatus = [dicData[@"followWxStatus"] intValue];
    if(followWxStatus == 1)
     {
        labelWXGZ.backgroundColor = [UIColor clearColor];
        labelWXGZ.textColor = [ResourceManager color_1];
        NSString *strRZ = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"fllowWxReward"]];
        labelWXGZ.text = strRZ;//@"  已关注";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelWXGZ addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
     }
    
    
    // 1 表示加入群聊成功
    joinWxQunStatus = [dicData[@"joinWxQunStatus"] intValue];
    if(joinWxQunStatus == 1)
     {
        labelJRQL.backgroundColor = [UIColor clearColor];
        labelJRQL.textColor = [ResourceManager color_1];
        
        //NSString *strRZ = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"fllowWxReward"]];
        NSString *strRZ2 = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"joinWxQunReward"]];
        //NSString *strRZ3 = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"joinQqQunReward"]];
        labelJRQL.text = strRZ2;//@"  已加入";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelJRQL addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
     }
    
    joinQqQunStatus = [dicData[@"joinQqQunStatus"] intValue];
    if(joinQqQunStatus == 1)
     {
        labelJRQQ.backgroundColor = [UIColor clearColor];
        labelJRQQ.textColor = [ResourceManager color_1];
        NSString *strRZ3 = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"joinQqQunReward"]];
        labelJRQQ.text = strRZ3;//@"  已加入";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelJRQQ addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
     }
    
    
    joinByQunStatus = [dicData[@"joinByQunStatus"] intValue];
    if(joinByQunStatus == 1)
     {
        labelJRBY.backgroundColor = [UIColor clearColor];
        labelJRBY.textColor = [ResourceManager color_1];
        NSString *strRZ = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"joinByQunReward"]];
        labelJRBY.text = strRZ;//@"  已加入";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelJRBY addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
     }
    
    // 意外保险
    insuranceStatus = [dicData[@"insuranceStatus"] intValue];
    if(insuranceStatus == 1)
     {
        labelYWBX.backgroundColor = [UIColor clearColor];
        labelYWBX.textColor = [ResourceManager color_1];
        NSString *strRZ = [NSString stringWithFormat:@"     %@",dicData[@"insuranceMessage"]];
        labelYWBX.text = strRZ;//@"  已加入";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        [labelYWBX addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
     }
    
    
    
}



-(void) setViewDJRW
{
    int iWdith = viewDJRW.width/3;
    int iHeight = viewDJRW.height;
    int iLeftX = 0;
    int iTopY = 20;
    
    NSString *strMRDL = [NSString stringWithFormat:@"加入群聊获得%@狗粮",dicData[@"joinWxQunReward"]];
    NSString *strQQ = [NSString stringWithFormat:@"加入群聊获得%@狗粮",dicData[@"joinQqQunReward"]];
    NSString *strRZ = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"fllowWxReward"]];
    NSString *strRZ2 = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"joinWxQunReward"]];
    NSString *strRZ3 = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"joinQqQunReward"]];
    
    NSArray *arrImg = @[@"task_wx",@"task_weixin",@"task_qq"];
    NSArray *arrName = @[@"关注微信公众号",@"加入微信群聊",@"加入QQ群聊"];
    NSArray *arrSubTitle = @[@"关注\"天狗窝区块链\"",strMRDL,strQQ];
    NSArray *arrSu2Title = @[strRZ,strRZ2,strRZ3];
    for (int i = 0;  i < 3; i++)
     {
        
        UIButton *btnYQHY = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, iWdith, iHeight)];
        [viewDJRW addSubview:btnYQHY];
        btnYQHY.tag = i;
        [btnYQHY addTarget:self  action:@selector(actionDJWR:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake( (iWdith-60)/2, iTopY, 60, 30)];
        [btnYQHY addSubview:imgTop];
        imgTop.image = [UIImage imageNamed:arrImg[i]];
        
        iTopY += imgTop.height + 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
        [btnYQHY addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = arrName[i];
        //        if(0 == i)
        //         {
        //            label1.font = [UIFont systemFontOfSize:13];
        //         }
        
//        iTopY += label1.height;
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
//        [btnYQHY addSubview:label2];
//        label2.textColor = [ResourceManager lightGrayColor];
//        label2.font = [UIFont systemFontOfSize:10];
//        label2.textAlignment = NSTextAlignmentCenter;
//        label2.text = arrSubTitle[i];//@"邀请好友获取狗粮";
        
        
        iTopY += label1.height + 10;
        UILabel *label3 = [[UILabel alloc]  initWithFrame:CGRectMake(15, iTopY, iWdith - 30, 20)];
        [btnYQHY addSubview:label3];
        label3.backgroundColor = [ResourceManager mainColor];
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = arrSu2Title[i];//@"邀请好友";
        

        
        if (i == 0)
         {
            labelWXGZ = label3;
         }
        if (i == 1)
         {
            labelJRQL = label3;
         }
        if (i == 2)
         {
            labelJRQQ = label3;
         }
        
        
        iLeftX += iWdith;
        iTopY = 20;
     }
    
    
//    iBtnWidth = viewJCRW.width/3;
//    UIButton *btnDJRW = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, iBtnWidth, 150)];
//    [viewDJRW addSubview:btnDJRW];
//    //btnDJRW.backgroundColor = [UIColor orangeColor];
//    //btnDJRW.layer.borderWidth = 1;
//    //btnDJRW.cornerRadius = 5;
//
//    UIImageView *imgBtn = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth-50)/2, 30, 50, 50)];
//    [btnDJRW addSubview:imgBtn];
//    imgBtn.image = [UIImage imageNamed:@"task_yanfa"];
//
//    UILabel *labelBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, iBtnWidth, 20)];
//    [btnDJRW addSubview:labelBtn];
//    labelBtn.textColor = [ResourceManager color_1];
//    labelBtn.font = [UIFont systemFontOfSize:14];
//    labelBtn.textAlignment = NSTextAlignmentCenter;
//    labelBtn.text = @"未完待续";
    
    // 加入分割线
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iWdith, 35, 1, 65)];
    [viewDJRW addSubview:viewFG1];
    viewFG1.backgroundColor = UIColorFromRGB(0xededed);
    
    
    // 加入分割线
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(2*iWdith, 35, 1, 65)];
    [viewDJRW addSubview:viewFG2];
    viewFG2.backgroundColor = UIColorFromRGB(0xededed);
    
    
    
    
}


-(void) setViewDJRW2
{
    int iWdith = (SCREEN_WIDTH - 30)/3; //viewDJRW.width/3;
    int iHeight = viewDJRW2.height;
    int iLeftX = 0;
    int iTopY = 20;
    
    NSString *strMRDL = [NSString stringWithFormat:@"加入群聊获得%@狗粮",dicData[@"joinByQunReward"]];
    NSString *strQQ = [NSString stringWithFormat:@"加入群聊获得%@狗粮",dicData[@"joinQqQunReward"]];
    NSString *strRZ = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"joinByQunReward"]];
    NSString *strRZ3 = [NSString stringWithFormat:@"+%@长期狗粮",dicData[@"joinQqQunReward"]];
    
    NSString *strInsuranceMessage = [NSString stringWithFormat:@"%@",dicData[@"insuranceMessage"]];
    NSString *creditMessage = [NSString stringWithFormat:@"%@",dicData[@"creditMessage"]];
    NSString *creditReward = [NSString stringWithFormat:@"%@",dicData[@"creditReward"]];
    
    NSArray *arrImg = @[@"tast_by",@"task_lqywx",@"task_credit"];
    NSArray *arrName = @[@"加入币用群聊",@"免费领取意外险",creditMessage];
    NSArray *arrSu2Title = @[strRZ,strInsuranceMessage,creditReward];
    for (int i = 0;  i < 3; i++)
     {
        
        UIButton *btnYQHY = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, iWdith, iHeight)];
        [viewDJRW2 addSubview:btnYQHY];
        btnYQHY.tag = 3 + i ;
        [btnYQHY addTarget:self  action:@selector(actionDJWR:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake( (iWdith-60)/2, iTopY, 60, 30)];
        [btnYQHY addSubview:imgTop];
        imgTop.image = [UIImage imageNamed:arrImg[i]];
        
        iTopY += imgTop.height + 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
        [btnYQHY addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = arrName[i];
        //        if(0 == i)
        //         {
        //            label1.font = [UIFont systemFontOfSize:13];
        //         }
        
//        iTopY += label1.height;
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 20)];
//        [btnYQHY addSubview:label2];
//        label2.textColor = [ResourceManager lightGrayColor];
//        label2.font = [UIFont systemFontOfSize:10];
//        label2.textAlignment = NSTextAlignmentCenter;
//        label2.text = arrSubTitle[i];//@"邀请好友获取狗粮";
        
        
        iTopY += label1.height + 10;
        UILabel *label3 = [[UILabel alloc]  initWithFrame:CGRectMake(15, iTopY, iWdith - 30, 20)];
        [btnYQHY addSubview:label3];
        label3.backgroundColor = [ResourceManager mainColor];
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = arrSu2Title[i];//@"邀请好友";
        
        
        
        if (i == 0)
         {
            labelJRBY = label3;
         }
        if (i == 1)
         {
            labelYWBX = label3;
         }
//        if (i == 2)
//         {
//            labelJRQQ = label3;
//         }
        
        
        iLeftX += iWdith;
        iTopY = 20;
     }
    

    
//    // 加入分割线
//    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(2*iWdith, 35, 1, 65)];
//    [viewDJRW2 addSubview:viewFG1];
//    viewFG1.backgroundColor = UIColorFromRGB(0xededed);
//
//
//
//    iBtnWidth = viewJCRW.width/3;
//    UIButton *btnDJRW = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, iBtnWidth, iHeight)];
//    [viewDJRW2 addSubview:btnDJRW];
//
//
//    UIImageView *imgBtn = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth-40)/2, 25, 40, 35)];
//    [btnDJRW addSubview:imgBtn];
//    imgBtn.image = [UIImage imageNamed:@"task_yanfa"];
//
//    UILabel *labelBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, iBtnWidth, 20)];
//    [btnDJRW addSubview:labelBtn];
//    labelBtn.textColor = [ResourceManager color_1];
//    labelBtn.font = [UIFont systemFontOfSize:14];
//    labelBtn.textAlignment = NSTextAlignmentCenter;
//    labelBtn.text = @"未完待续";
    
    
    
    
}


-(void) actionPop
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>是否确认领取</font>"]];
    
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    viewTemp.userInteractionEnabled = YES;
    UIImageView *imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [viewTemp addSubview:imgGou];
    imgGou.image = [UIImage imageNamed:@"com_gou_sel"];
    
    UILabel *labelXY = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 185, 30)];
    [viewTemp addSubview:labelXY];
    labelXY.font = [UIFont systemFontOfSize:15];
    labelXY.textColor = [ResourceManager lightGrayColor];
    labelXY.text = @"确定即同意《保险协议》";
    
    
    NSString *strNO = @"《保险协议》";//  @"10501";
    NSString *strAll = @"确定即同意《保险协议》";
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:stringRange];
    labelXY.attributedText = noteString;
    
    
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionHtml)];
    gesture.numberOfTapsRequired  = 1;
    [viewTemp addGestureRecognizer:gesture];
    
    [alertView addView:viewTemp leftX:0];
    
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self comitYWBX];
       
    }];
    
    [alertView addCanelButton:@"再看看" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

-(void) actionHtml
{
    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@pages/agreement_Insurance.html",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"保险协议";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- action
-(void) actionJCRW:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 邀请好友

        AddFriendWebVC  *vc = [[AddFriendWebVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@pages/invitation_record.html?signId=%@",[PDAPI WXSysRouteAPI],[DDGSetting sharedSettings].signId];
        
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"邀请好友";
        [self.navigationController pushViewController:vc animated:YES];
        
        
     }
    else if (1 == iTag)
     {
        // 签到日历
        SiginDayVC *vc = [[SiginDayVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
     }
    else if (2 == iTag)
     {
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
        
//        AuthenticationVC *vc = [[AuthenticationVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
     }
}

-(void)actionDJWR:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (0 == iTag)
     {
        if (followWxStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经关注过了" toView:self.view];
            return;
         }
        // 关注微信公众号
        AttentionWechatVC *VC = [[AttentionWechatVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    if (1 == iTag)
     {
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        if (joinWxQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 0;
        [self.navigationController pushViewController:VC animated:YES];
     }
    if (2 == iTag)
     {
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }

        if (joinQqQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 1;
        [self.navigationController pushViewController:VC animated:YES];
     }
    if (3 == iTag)
     {
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }

        
        if (joinByQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 2;
        [self.navigationController pushViewController:VC animated:YES];
     }
    if (4 == iTag)
     {
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        if (insuranceStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经领取过了" toView:self.view];
            return;
         }
        
        [self actionPop];
       
        
     }
    
    if (5 == iTag)
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
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        // 信用卡
        //CreditCardInfoVC *VC = [[CreditCardInfoVC alloc] init];
        CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }


}

#pragma mark --- 网络通讯
-(void) getTaskInfo
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGTaskBaseInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) comitYWBX
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGsendInsuranceByTask];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"insuranceFlag"] = @"1";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}




-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (1000 == operation.tag)
     {
        dicData = operation.jsonResult.attr;
        if ([dicData count] > 0)
         {
            [self layoutUI];
            [self setUIHead:dicData];
         }
     }
    if (1001 == operation.tag)
     {
        [self getTaskInfo];
     }

}


@end
