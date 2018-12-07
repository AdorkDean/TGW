//
//  GameRechargeVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/12/3.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "GameRechargeVC.h"
#import "DCPaymentView.h"
#import "WithdrawTGW_VC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"


@interface GameRechargeVC ()<UITextFieldDelegate>
{
    NSArray *arrTitle;
    NSMutableArray *arrBtn;
    int iSelRecharge;  // -1 表示 未选择
    
    UITextField  *fieldInputMoney;
    NSMutableArray *arrCZFSBtn;  // 充值方式按钮数组
    int iSelWay;   // -1 表示 未选择
    NSString *strAccid;  // 天狗窝地址
    
    UILabel *labelTGW;
    int  iRechargeTGW;  // 充值天狗窝
    
    UIView *viewPopBG;
    UITextField *filedPassWord;
}
@end

@implementation GameRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"充值"];
    
    [self initData];
    
    [self layoutUI];

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    

}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

-(void) initData
{
    iSelRecharge = 1;
    iSelWay = -1;
    iRechargeTGW = -1;
    arrBtn = [[NSMutableArray alloc] init];
    arrCZFSBtn = [[NSMutableArray alloc] init];
    arrTitle = @[@"100", @"200",@"500",@"1000",@"2000"];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iTopY = NavHeight;
    int iLeftX = 10;
    
    UILabel *lableT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 30)];
    [self.view addSubview:lableT1];
    lableT1.textColor = [ResourceManager color_1];
    lableT1.font = [UIFont systemFontOfSize:14];
    lableT1.text = @"充值金额";
    
    iTopY += lableT1.height;
    int iBtnWidth = (SCREEN_WIDTH - 4 *iLeftX)/3;
    int iBtnLeftX = iLeftX;
    int iBtnHeight = 40;
    
    //arrTitle = @[@"100", @"200",@"500",@"1000",@"2000"];
    UIButton *fristBtn = nil;
    for (int i = 0; i < [arrTitle count]; i++)
     {
        UIButton  *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, iBtnWidth, iBtnHeight)];
        [self.view addSubview:btnTemp];
        btnTemp.tag = i;
        btnTemp.cornerRadius = 5;
        btnTemp.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
        btnTemp.layer.borderWidth = 1;
        [btnTemp setTitle:arrTitle[i] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnTemp addTarget:self action:@selector(actionSelCharge:) forControlEvents:UIControlEventTouchUpInside];
        
        if ((i+1)%3 == 0)
         {
            iTopY += iBtnHeight + 10;
            iBtnLeftX = iLeftX;
         }
        else
         {
            iBtnLeftX += iLeftX + iBtnWidth;
         }
        
        if (i == 0)
         {
            fristBtn = btnTemp;
         }
        
        [arrBtn addObject:btnTemp];
     }
    
    
    
    iTopY += iBtnHeight + 20;
    fieldInputMoney = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 35)];
    [self.view addSubview:fieldInputMoney];
    fieldInputMoney.layer.borderWidth = 1;
    fieldInputMoney.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    fieldInputMoney.layer.cornerRadius = 5;
    fieldInputMoney.textAlignment = NSTextAlignmentCenter;
    fieldInputMoney.font = [UIFont systemFontOfSize:14];
    fieldInputMoney.placeholder = @"可手动输入充值金额";
    fieldInputMoney.keyboardType = UIKeyboardTypeNumberPad;
    fieldInputMoney.delegate = self;
    
    iTopY += fieldInputMoney.height + 20;
    UILabel *lableT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [self.view addSubview:lableT2];
    lableT2.textColor = [ResourceManager color_1];
    lableT2.font = [UIFont systemFontOfSize:14];
    lableT2.text = @"充值方式";
    
    // 天狗窝充值方式
    iTopY += lableT2.height + 10;
    UIImageView *imgTGW = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 25, 25)];
    [self.view addSubview:imgTGW];
    imgTGW.image = [UIImage imageNamed:@"gr_tgw"];
    
    UILabel *lableCZ1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 100, 25)];
    [self.view addSubview:lableCZ1];
    lableCZ1.textColor = [ResourceManager color_1];
    lableCZ1.font = [UIFont systemFontOfSize:14];
    lableCZ1.text = @"天狗窝";
    
    UIButton *btnTGW = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, iTopY+3, 18, 18)];
    [self.view addSubview:btnTGW];
    [btnTGW setBackgroundImage:[UIImage imageNamed:@"qb_gou1"] forState:UIControlStateNormal];
    btnTGW.tag = 0;
    [btnTGW addTarget:self action:@selector(actionSelWay:) forControlEvents:UIControlEventTouchUpInside];
    [arrCZFSBtn addObject:btnTGW];
    
    // 天狗钱包充值方式
    iTopY += lableCZ1.height + 10;
    UIImageView *imgTGQB = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 25, 25)];
    [self.view addSubview:imgTGQB];
    imgTGQB.image = [UIImage imageNamed:@"gr_tgkd"];
    
    UILabel *lableCZ2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 100, 25)];
    [self.view addSubview:lableCZ2];
    lableCZ2.textColor = [ResourceManager color_1];
    lableCZ2.font = [UIFont systemFontOfSize:14];
    lableCZ2.text = @"天狗钱包";
    
    UIButton *btnTGQB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, iTopY+3, 18, 18)];
    [self.view addSubview:btnTGQB];
    btnTGQB.tag = 1;
    [btnTGQB addTarget:self action:@selector(actionSelWay:) forControlEvents:UIControlEventTouchUpInside];
    [btnTGQB setBackgroundImage:[UIImage imageNamed:@"qb_gou1"] forState:UIControlStateNormal];
    [arrCZFSBtn addObject:btnTGQB];
    
    
    iTopY = SCREEN_HEIGHT - 40;
    labelTGW = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH/2, 40)];
    [self.view addSubview:labelTGW];
    labelTGW.textColor = [ResourceManager mainColor];
    labelTGW.font = [UIFont systemFontOfSize:14];
    labelTGW.textAlignment = NSTextAlignmentCenter;
    labelTGW.text = @"TGW:";
    
    if (fristBtn)
     {
         [self actionSelCharge:fristBtn];
     }
    
    UIButton *btnRecharge = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, SCREEN_WIDTH/2, 40)];
    [self.view addSubview:btnRecharge];
    [btnRecharge setTitle:@"立即充值" forState:UIControlStateNormal];
    btnRecharge.titleLabel.font = [UIFont systemFontOfSize:14];
    btnRecharge.backgroundColor = [ResourceManager mainColor];
    [btnRecharge addTarget:self action:@selector(actionRecharge) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setRechargeText
{
    iRechargeTGW = -1;
    if (iSelRecharge == -1)
     {
        if (fieldInputMoney.text.length > 0)
         {
            labelTGW.text = [NSString stringWithFormat:@"TGW:%@", fieldInputMoney.text];
            iRechargeTGW = [fieldInputMoney.text intValue];
         }
        else
         {
            labelTGW.text = [NSString stringWithFormat:@"TGW:"];
            iRechargeTGW = -1;
         }
     }
    else
     {
        labelTGW.text = [NSString stringWithFormat:@"TGW:%@", arrTitle[iSelRecharge]];
        iRechargeTGW = [arrTitle[iSelRecharge] intValue];
     }
}

#pragma mark --- action
-(void) actionPay
{
    
  
    if (iSelWay == 1 &&
        (!strAccid||
         strAccid.length <= 0))
     {
        // 选择天狗口袋地址
        [self actionTXTGW];
        return;
     }
    
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"确认支付";
    payAlert.iAmount = iRechargeTGW;
    payAlert.iType = iSelWay;
    if (iSelWay == 1)
     {
        payAlert.accid = strAccid;
     }
    [payAlert show];
    
    // 支付密码完成时
    __weak typeof(DCPaymentView *) weakSelf = payAlert;
    
    payAlert.completeHandle = ^(NSString *inputPwd) {
        
        
        [weakSelf dismiss];
        
        if (iSelWay == 1)
         {
            // 输入密码
            [self actionInputPassWord];
            return;
         }
        
        [self gameRechargeToWeb];
    };
    
}

-(void) actionSelCharge:(UIButton*) sender
{
    fieldInputMoney.text = @"";
    [self.view endEditing:YES];
 
    for (int i = 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrBtn[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.layer.borderWidth = 1;
     }
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [ResourceManager mainColor];
    sender.layer.borderWidth = 0;
    iSelRecharge = (int)sender.tag;
    
    [self setRechargeText];
}

-(void) actionSelWay:(UIButton*) sender
{
    strAccid = @"";
    for (int i = 0; i < [arrCZFSBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrCZFSBtn[i];
        [btnTemp setBackgroundImage:[UIImage imageNamed:@"qb_gou1"] forState:UIControlStateNormal];
     }
    
    [sender setBackgroundImage:[UIImage imageNamed:@"qb_gou2"] forState:UIControlStateNormal];
    iSelWay = (int)sender.tag;
    
    if (iSelWay == 1)
     {
        // 选择天狗口袋地址
        [self actionTXTGW];
     }
}


-(void) actionTXTGW
{
    //    [MBProgressHUD showErrorWithStatus:@"天狗币提现将在下一个版本开放" toView:self.view];
    //    return;
    
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
    VC.isSelAddr = YES;
    VC.selAddrBlock = ^(NSString *string) {
        strAccid = string;
    };
    [self.navigationController pushViewController:VC animated:YES];
    
    
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
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>需要先进行实名认证，才能提现!</font>"]];
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

#pragma mark ---  天狗钱包密码输入弹框
-(void) actionInputPassWord
{
    viewPopBG = [[UIView alloc] init];
    [self.view addSubview:viewPopBG];
    viewPopBG.frame = [UIScreen mainScreen].bounds;
    viewPopBG.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    
    
    UIView *viewPop = [[UIView alloc] initWithFrame:CGRectMake(30, NavHeight + 90, SCREEN_WIDTH-60, 200)];
    [viewPopBG addSubview:viewPop];
    viewPop.backgroundColor = [UIColor whiteColor];
    viewPop.cornerRadius = 15;
    
    int iPopWidth = viewPop.width;
    int iTopY = 20;
    UILabel *lableT = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iPopWidth, 20)];
    [viewPop addSubview:lableT];
    lableT.font = [UIFont systemFontOfSize:15];
    lableT.textColor = [ResourceManager color_1];
    lableT.textAlignment = NSTextAlignmentCenter;
    lableT.text = @"输入天狗钱包密码";
    
    iTopY += lableT.height + 12;
    UILabel *lableValue = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iPopWidth, 20)];
    [viewPop addSubview:lableValue];
    lableValue.font = [UIFont systemFontOfSize:16];
    lableValue.textColor = [ResourceManager mainColor];
    lableValue.textAlignment = NSTextAlignmentCenter;
    lableValue.text = [NSString stringWithFormat:@"%dTGW", iRechargeTGW];
    
    
    iTopY += lableValue.height + 12;
    filedPassWord = [[UITextField alloc] initWithFrame:CGRectMake(20, iTopY, iPopWidth - 40, 35)];
    [viewPop addSubview:filedPassWord];
    filedPassWord.layer.borderWidth = 1;
    filedPassWord.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    filedPassWord.layer.cornerRadius = 5;
    filedPassWord.textAlignment = NSTextAlignmentCenter;
    filedPassWord.font = [UIFont systemFontOfSize:14];
    filedPassWord.placeholder = @"请输入密码";
    filedPassWord.secureTextEntry = YES;

    
    iTopY += filedPassWord.height + 20;
    UIButton  *btnOK  = [[UIButton alloc] initWithFrame:CGRectMake(20, iTopY, iPopWidth - 40, 40)];
    [viewPop addSubview:btnOK];
    [btnOK setTitle:@"立即支付" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    btnOK.backgroundColor = [ResourceManager mainColor];
    btnOK.cornerRadius = btnOK.height/2;
    [btnOK addTarget:self action:@selector(gameRechargeToWeb) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void) actionRecharge
{
    if (iRechargeTGW <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入或选择充值的天狗币" toView:self.view];
        return;
     }
    
    if (iSelWay == -1)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择充值方式" toView:self.view];
        return;
     }
    
    [self actionPay];
}

#pragma mark === UITextFieldDelegate
//开始编辑时
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    iSelRecharge = -1;
    for (int i = 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrBtn[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.layer.borderWidth = 1;
     }
    [self setRechargeText];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    iSelRecharge = -1;
    [self setRechargeText];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    iSelRecharge = -1;
    for (int i = 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrBtn[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.layer.borderWidth = 1;
     }
    [self setRechargeText];
    return YES;
}

#pragma mark --- 网络通讯
-(void) gameRechargeToWeb
{
    [viewPopBG removeFromSuperview];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGtgwDiceRecharge];
    
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"coinValue"] = @(iRechargeTGW);
    
    
    if (iSelWay == 1)
     {
        strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGtgkdDiceRecharge];
        parmas[@"tradePwd"] = filedPassWord.text;
        parmas[@"accid"] = strAccid;
        parmas[@"rechargeValue"] = @(iRechargeTGW);
        
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message        toView:self.view ];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    if (1000 == operation.tag)
     {
        // 在延迟后执行
        [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];

        
        // WEB 页面刷新通知
        NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGWebRefshNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifcation];
        
        [MBProgressHUD showSuccessWithStatus:@"充值成功" toView:self.view];
        

     }
}

-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
