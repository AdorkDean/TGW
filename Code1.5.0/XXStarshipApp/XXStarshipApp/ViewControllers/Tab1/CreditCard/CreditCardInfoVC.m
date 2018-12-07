//
//  CreditCardInfoVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/15.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "CreditCardInfoVC.h"
#import "CreditCardTGVC.h"
#import "QuestionVC.h"
#import "CreditCardKFVC.h"
#import "AddBankViewController.h"
#import "PutForwardVC.h"
#import "MyRewardVC.h"

@interface CreditCardInfoVC ()
{
    UIScrollView *scView;
    
    float  fUsableAmount;  //   可用余额
    int    iMinWithdrawAmt; //  最低提现额度
}
@end

@implementation CreditCardInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"个人中心"];
    [self getInfo];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getInfo];
}


-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 600);
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
    
    // 设置背景
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT - NavHeight + 10)];
    [scView addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"CC_bg"];
    
    if (imgBG.height < 600)
     {
        imgBG.height = 610;
     }
    
    
    // 顶部View
    int iViewWidth = SCREEN_WIDTH - 2*10;
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(10, 80, iViewWidth, 200)];
    [scView addSubview:viewTop];
    viewTop.backgroundColor = [UIColor whiteColor];
    viewTop.cornerRadius = 5;
    
    // 设置头像
    int iImgWidth = 80;
    UIView  *viewHeadBG = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - iImgWidth/2 -2, 80 - iImgWidth/2-2, iImgWidth+4, iImgWidth+4)];
    [scView addSubview:viewHeadBG];
    viewHeadBG.backgroundColor = [UIColor whiteColor];
    viewHeadBG.cornerRadius = viewHeadBG.height/2;
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - iImgWidth/2, 80 - iImgWidth/2, iImgWidth, iImgWidth)];
    [scView addSubview:imgHead];
    if (dicUI[@"headImg"])
     {
        [imgHead setImageWithURL:[NSURL URLWithString:dicUI[@"headImg"]] placeholderImage:[UIImage imageNamed:@"tab3_head1"]];
     }
    else
     {
        imgHead.image = [UIImage imageNamed:@"tab3_head1"];
     }
    imgHead.layer.cornerRadius = imgHead.height/2;
    imgHead.layer.masksToBounds = YES;
    
    int iTopY = iImgWidth/2 +5;
    UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iViewWidth, 30)];
    [viewTop addSubview:labelT];
    labelT.textColor = [UIColor blackColor];
    labelT.font = [UIFont systemFontOfSize:17];
    labelT.textAlignment = NSTextAlignmentCenter;
    labelT.text = @"累计收入";
    
    // 现金
    int iLabelWidth = 130;
    if (IS_IPHONE_5_OR_LESS)
     {
        iLabelWidth = 110;
     }
    iTopY += labelT.height +5;
    int iLeftX = 25;
    UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 17, 17)];
    [viewTop addSubview:imgLeft];
    imgLeft.image = [UIImage imageNamed:@"CC_Money"];
    
    UILabel* labelXJ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 25, iTopY, iLabelWidth, 17)];
    [viewTop addSubview:labelXJ];
    labelXJ.textColor = [ResourceManager color_1];
    labelXJ.font = [UIFont systemFontOfSize:15];
    //labelXJ.backgroundColor = [UIColor yellowColor];
    labelXJ.text = [NSString stringWithFormat:@"现金: %@元",dicUI[@"sumReward"]];//@"现金：28元";
    
    // 魔法狗粮
    iLeftX = SCREEN_WIDTH/2;
    iLeftX += 10;
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 17, 17)];
    [viewTop addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"CC_MFGL"];
    
    UILabel* labelMFGL = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 25, iTopY, iLabelWidth, 17)];
    [viewTop addSubview:labelMFGL];
    labelMFGL.textColor = [ResourceManager color_1];
    labelMFGL.font = [UIFont systemFontOfSize:15];
    //labelMFGL.backgroundColor = [UIColor yellowColor];
    labelMFGL.text = [NSString stringWithFormat:@"魔法狗粮: %@包",dicUI[@"sumAbilityReward"]];//@"魔法狗粮：1122";
    
    // 分割线
    iTopY += labelXJ.height + 15;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, iViewWidth-20, 1)];
    [viewTop addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    int iLabelWdith2 = iViewWidth/3;
    iTopY += 15;
    UILabel *labelYJTX = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iLabelWdith2, 17)];
    [viewTop addSubview:labelYJTX];
    labelYJTX.textColor = [ResourceManager lightGrayColor];
    labelYJTX.font = [UIFont systemFontOfSize:15];
    labelYJTX.textAlignment = NSTextAlignmentCenter;
    labelYJTX.text = [NSString stringWithFormat:@"￥%@",dicUI[@"withdrawAmt"]];// @"￥0";
    
    
    UILabel *labelKTX = [[UILabel alloc] initWithFrame:CGRectMake(iLabelWdith2, iTopY, iLabelWdith2, 17)];
    [viewTop addSubview:labelKTX];
    labelKTX.textColor = [ResourceManager color_1];
    labelKTX.font = [UIFont systemFontOfSize:15];
    labelKTX.textAlignment = NSTextAlignmentCenter;
    labelKTX.text = [NSString stringWithFormat:@"￥%@",dicUI[@"putForwardAmt"]];//@"￥155";
    

    
    int iBtnTXLeftX = iViewWidth - 75;
    UIButton *btnTX = [[UIButton alloc] initWithFrame:CGRectMake(iBtnTXLeftX, iTopY+20, 60, 30)];
    [viewTop addSubview:btnTX];
    btnTX.backgroundColor = UIColorFromRGB(0x5953ff);
    [btnTX setTitle:@"提现"  forState:UIControlStateNormal];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:17];
    btnTX.cornerRadius = 5;
    [btnTX addTarget:self action:@selector(actionTX) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += labelYJTX.height + 15;
    UILabel *labelYJTX2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iLabelWdith2, 17)];
    [viewTop addSubview:labelYJTX2];
    labelYJTX2.textColor = [ResourceManager lightGrayColor];
    labelYJTX2.font = [UIFont systemFontOfSize:15];
    labelYJTX2.textAlignment = NSTextAlignmentCenter;
    labelYJTX2.text = @"已提现";
    
    UILabel *labelKTX2 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelWdith2, iTopY, iLabelWdith2, 17)];
    [viewTop addSubview:labelKTX2];
    labelKTX2.textColor = [ResourceManager color_1];
    labelKTX2.font = [UIFont systemFontOfSize:15];
    labelKTX2.textAlignment = NSTextAlignmentCenter;
    labelKTX2.text = @"可提现";
    
    
    iTopY =  80 + viewTop.height + 20;
    // 底部view
    UIView *viewTail = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, iViewWidth, 200)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [UIColor whiteColor];
    viewTail.cornerRadius = 5;
    [self layoutTail:viewTail];
    

    
}

-(void) layoutTail:(UIView *) viewTail
{
    int iTopY = 0;
    int iViewHeight = 110;
    int iViewWdith = viewTail.width/2;
    int iImgWidth = 40;
    int iImgLeftX = (iViewWdith - iImgWidth)/2;
    int iLeftX = 0;
    
    NSArray *arrImg = @[@"CC_TuiGuang",@"CC_JianLi",@"CC_Note",@"CC_kefu",@"CC_JDCX"];
    NSArray *arrTitle = @[@"我的推广",@"我的奖励",@"平台公告",@"专属客服",@"进度查询"];
    
    for (int i = 0; i < [arrImg count]; i ++)
     {
        if (i%2 == 0 &&
            i != 0)
         {
            iTopY += iViewHeight;
            iLeftX = 0;
         }
        else if (i%2 == 1)
         {
            iLeftX += iViewWdith;
         }
    
        UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY,iViewWdith , iViewHeight)];
        [viewTail addSubview:viewTemp];
        
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:viewTemp.frame];
        [viewTail addSubview:btnTemp];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];

        
        UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX, 30, iImgWidth, iImgWidth)];
        [viewTemp addSubview:imgTemp];
        imgTemp.image = [UIImage imageNamed:arrImg[i]];
        
        
        UILabel  *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + iImgWidth +10 , iViewWdith, 30)];
        [viewTemp addSubview:labelTemp];
        labelTemp.textColor = [ResourceManager color_1];
        labelTemp.font = [UIFont systemFontOfSize:14];
        labelTemp.textAlignment = NSTextAlignmentCenter;
        labelTemp.text = arrTitle[i];
        
     }
    
    iTopY += iViewHeight +20;
    viewTail.height = iTopY;
    viewTail.cornerRadius = 5;
    
    
    
}

#pragma mark ---  网络通讯
-(void) getInfo
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGquerySumIncome];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}


-(void) getBindCard
{
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGBankGetInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1003;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *dic = operation.jsonResult.attr;
    NSLog(@"dic:%@",dic);
    
    if (1002 == operation.tag)
     {
        NSString *xjZsWeiXin = dic[@"xjZsWeiXin"];
        [CommonInfo setKey:K_CREDIT_WEIXING withValue:xjZsWeiXin];
        [self layoutUI:dic];
        fUsableAmount = [dic[@"putForwardAmt"] floatValue];
        
     }
    
    if (1003 == operation.tag)
     {
        int  identifyStatus = [dic[@"identityStatus"] intValue];
        if (identifyStatus != 1)
         {
            [MBProgressHUD showErrorWithStatus:@"必须实名认证，才能提现" toView:self.view];
            return;
         }
        if (dic)
         {
            NSDictionary *dicCard = dic[@"cardInfo"];
            fUsableAmount = [dic[@"usableAmount"] floatValue];
            iMinWithdrawAmt = [dic[@"minWithdrawAmt"] intValue];
            NSString *strBankName = dicCard[@"bankName"];
            NSString *strHideCardCode = dicCard[@"bankCardNo"];
            NSString *strHideName = dicCard[@"accountName"];
            NSString *strHideTelephone = dicCard[@"telephone"];
            NSString *strTelephone = dicCard[@"realTelephone"];
            if (!dicCard)
             {
                
                CDWAlertView *alertView = [[CDWAlertView alloc] init];
                
                //降低当前高度
                //[alertView subAlertCurHeight:25];
                
                alertView.textAlignment = RTTextAlignmentCenter;
                
                [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 17 color=#676767>必须先添加银行卡，才能提现。</font>"]];
                
                [alertView addAlertCurHeight:10];
                
                
                [alertView addButton:@"添加银行卡" color:[ResourceManager mainColor2] actionBlock:^{
                    
                    AddBankViewController *VC = [[AddBankViewController alloc] init];
                    [self.navigationController pushViewController:VC animated:YES];
                    
                }];
                
                [alertView addCanelButton:@"取消" actionBlock:^{
                    
                }];
                
                
                
                
                [alertView showAlertView:self.parentViewController  duration:0.0];
                
                
                
                return;
                
                
             }
            else
             {
                PutForwardVC *vc = [[PutForwardVC alloc] init];
                vc.strBankName = strBankName;
                vc.strHideCardCode = strHideCardCode;
                vc.strHideName = strHideName;
                vc.strTelephone = strTelephone;
                vc.strHideTelephone = strHideTelephone;
                vc.fAllMoney = fUsableAmount;
                vc.iMinWithdrawAmt = iMinWithdrawAmt;
                [self.navigationController pushViewController:vc animated:YES];
             }
         }
     }
}

#pragma mark ---  action
-(void) actionBtn:(UIButton*)sender
{
    int iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 我的推广
        CreditCardTGVC *VC = [[CreditCardTGVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (1 == iTag)
     {
        // 我的奖励
        MyRewardVC  *VC  = [[MyRewardVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (2 == iTag)
     {
        // 平台公告
        QuestionVC  *vc = [[QuestionVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@tgwproject/Notice",[PDAPI WXSysRouteAPI2]];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"公告";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (3 == iTag)
     {
        // 专属客服
        CreditCardKFVC *VC = [[CreditCardKFVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (4 == iTag)
     {
        // 进度查询
        QuestionVC  *vc = [[QuestionVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@tgwproject/progress",[PDAPI WXSysRouteAPI2]];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"进度查询";
        [self.navigationController pushViewController:vc animated:YES];
     }
    
}

-(void) actionTX
{
    if (fUsableAmount <= 0.0000)
     {
        [MBProgressHUD showErrorWithStatus:@"没有可提现金额" toView:self.view];
        return;
     }
    
    [self getBindCard];
}


@end
