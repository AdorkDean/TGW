//
//  MyRewardVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/31.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "MyRewardVC.h"
#import "AddBankViewController.h"
#import "PutForwardVC.h"
#import "PutForwardRecordVC.h"
#import "IncomVC.h"

@interface MyRewardVC ()
{
    NSDictionary *dicIncome;
    
    float  fUsableAmount;  //   可用余额
    int    iMinWithdrawAmt; //  最低提现额度
}
@end

@implementation MyRewardVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getIncomeFromWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"我的奖励"];

}


#pragma mark  --- 布局UI
- (void) layoutUI
{
    int iTopY = NavHeight;
    int iLeftX = 0;
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 100)];
    [self.view addSubview:imgTop];
    imgTop.image = [UIImage imageNamed:@"rd_top_bg"];
    
    UILabel *lableT1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 20)];
    [imgTop addSubview:lableT1];
    //lableT1.font = [UIFont systemFontOfSize:16];
    [lableT1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    lableT1.textColor = [UIColor whiteColor];
    lableT1.textAlignment = NSTextAlignmentCenter;
    lableT1.text = @"总收入";
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH/2, 20)];
    [imgTop addSubview:btnLeft];
    NSString *strTemp = [NSString stringWithFormat:@"  现金: %d元", [dicIncome[@"sumReward"] intValue]] ;
    [btnLeft setTitle:strTemp forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnLeft setImage:[UIImage imageNamed:@"rd_xianjing"] forState:UIControlStateNormal];

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 55, SCREEN_WIDTH/2, 20)];
    [imgTop addSubview:btnRight];
    strTemp = [NSString stringWithFormat:@"  魔法狗粮: %d包", [dicIncome[@"sumAbilityReward"] intValue]];
    [btnRight setTitle:strTemp forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight setImage:[UIImage imageNamed:@"rd_mfgl"] forState:UIControlStateNormal];
    
    // 中间布局
    iTopY += imgTop.height;
    UIView *viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 110)];
    [self.view addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, 1, 75)];
    [viewMid addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 中间的左边
    UILabel *lableT2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:lableT2];
    lableT2.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
    lableT2.textColor = [UIColor blackColor];
    lableT2.textAlignment = NSTextAlignmentCenter;
    lableT2.text = @"今日收入";
    UILabel *labelMFGL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:labelMFGL1];
    labelMFGL1.font = [UIFont systemFontOfSize:13];
    labelMFGL1.textColor = [ResourceManager color_1];
    labelMFGL1.textAlignment = NSTextAlignmentCenter;
    strTemp = [NSString stringWithFormat:@"魔法狗粮: %d包",[dicIncome[@"toDayAbilityReward"] intValue]];
    labelMFGL1.text = strTemp;
    UILabel *labelXJ1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:labelXJ1];
    labelXJ1.font = [UIFont systemFontOfSize:13];
    labelXJ1.textColor = [ResourceManager color_1];
    labelXJ1.textAlignment = NSTextAlignmentCenter;
    strTemp = [NSString stringWithFormat:@"现       金: ￥%d",[dicIncome[@"toDayReward"] intValue]];
    labelXJ1.text = strTemp;
    
    
    // 中间的右边
    UILabel *lableT3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:lableT3];
    lableT3.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
    lableT3.textColor = [UIColor blackColor];
    lableT3.textAlignment = NSTextAlignmentCenter;
    lableT3.text = @"预期收入";
    UILabel *labelMFGL2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 45, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:labelMFGL2];
    labelMFGL2.font = [UIFont systemFontOfSize:13];
    labelMFGL2.textColor = [ResourceManager color_1];
    labelMFGL2.textAlignment = NSTextAlignmentCenter;
    strTemp = [NSString stringWithFormat:@"魔法狗粮: %d包",[dicIncome[@"preAbilityReward"] intValue]];
    labelMFGL2.text = strTemp;
    UILabel *labelXJ2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 65, SCREEN_WIDTH/2, 20)];
    [viewMid addSubview:labelXJ2];
    labelXJ2.font = [UIFont systemFontOfSize:13];
    labelXJ2.textColor = [ResourceManager color_1];
    labelXJ2.textAlignment = NSTextAlignmentCenter;
    strTemp = [NSString stringWithFormat:@"现       金: ￥%d",[dicIncome[@"preReward"] intValue]];
    labelXJ2.text = strTemp;
    
    iTopY += viewMid.height +10;
    UIView *viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH - 2* iLeftX, 100)];
    [self.view addSubview:viewTail];
    viewTail.backgroundColor = [UIColor whiteColor];

    
    NSArray *arrImg = @[@"rd_srmx",@"rd_txjl"];
    NSArray *arrName = @[@"收入明细",@"提现记录",];
    
    int iViewYuan2TopY = 0;
    for (int i = 0; i < [arrImg count]; i++)
     {
        [self addYuanView:viewTail andNO:i  Top:iViewYuan2TopY imgName:arrImg[i] Name:arrName[i]];
        iViewYuan2TopY += 50;
     }
    viewTail.height = iViewYuan2TopY;
    
    UIButton *btnTX = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 50)];
    //[self.view addSubview:btnTX];
    [btnTX setTitle:@"申请提现" forState:UIControlStateNormal];
    [btnTX setTitleColor:[ResourceManager mainColor2] forState:UIControlStateNormal];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:15];
    btnTX.layer.borderColor = [ResourceManager mainColor2].CGColor;
    btnTX.layer.borderWidth = 1;
    [btnTX addTarget:self action:@selector(actionTX) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void) addYuanView:(UIView*)viewParent  andNO:(int)iNO  Top:(int) iTopY
            imgName:(NSString*)imgName  Name:(NSString*)Name
{
    int iViewWdith = viewParent.width;
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iViewWdith, 50)];
    [viewParent addSubview:viewTemp];
    viewTemp.backgroundColor = [UIColor clearColor];
    viewTemp.tag = iNO;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 17.5, 15, 15)];
    [viewTemp addSubview:imgView];
    imgView.image = [UIImage imageNamed:imgName];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 150, 20)];
    [viewTemp addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = Name;
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iViewWdith - 30, 15, 12, 20)];
    [viewTemp addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, iViewWdith-30, 1)];
    [viewTemp addSubview:labelFG];
    labelFG.backgroundColor = [ResourceManager color_5];
    
    
    UIButton *btnTemp = [[UIButton alloc] initWithFrame:viewTemp.frame];
    [viewParent addSubview:btnTemp];
    btnTemp.tag = iNO;
    [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --- 网络请求
-(void) getIncomeFromWeb
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryReward];
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
    operation.tag = 1000;
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
    
    if (1000 == operation.tag)
     {
        dicIncome = dic;
        [self layoutUI];
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
#pragma mark --- action
-(void) actionBtn:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 收入明细
        IncomVC *VC =  [[IncomVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (1 == iTag)
     {
        // 提现记录
        PutForwardRecordVC *VC =  [[PutForwardRecordVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
}

-(void) actionTX
{
    [self getBindCard];
}



@end
