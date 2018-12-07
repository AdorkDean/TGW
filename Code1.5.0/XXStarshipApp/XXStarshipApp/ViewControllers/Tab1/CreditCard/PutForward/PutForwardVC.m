//
//  PutForwardVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/5/31.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "PutForwardVC.h"
#import "VerificatioPhoneVC.h"
#import "CDWAlertView.h"
#import "PutForwardRecordVC.h"
#import "MyBankViewController.h"

@interface PutForwardVC ()
{
    UIView *viewHead;
    UIImageView  *imgBank;
    NSString* imageBankUrl;
    UILabel *labelBank;
    UILabel *labelBankNO;
    UILabel *labelName;
    
    UIView *viewMid;
    UITextField *fieldMoney;
    UILabel *labelTXJE2;
    
    UIView *viewTail;
    UIButton *btnTX;

}
@end

@implementation PutForwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:@"申请提现"];
    
    
    float fRightBtnTopY = NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f,fRightBtnTopY,80.f, 35.0f)];
    [rightNavBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor]forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionRecord) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];

    [self layoutUI];
    
    [self dataUI];
    
    
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"申请提现"];
    
    [self getMyBank];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"申请提现"];
}

#pragma mark   ---  布局UI
-(void) layoutUI
{
    int iTopY = NavHeight;
    int iLeftX = 0;
    viewHead = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY,SCREEN_WIDTH, 60)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    [self layoutHead];
    
    iTopY += viewHead.height+10;
    viewMid  = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 150)];
    [self.view addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];
    
    [self layoutMid];
    
    iTopY += viewMid.height + 10;
    viewTail  = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 300)];
    [self.view addSubview:viewTail];
    //viewTail.backgroundColor = [UIColor whiteColor];
    
    [self layoutTail];
    
}

-(void) layoutHead
{
    imgBank = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,10 ,40 , 40)];
    imgBank.backgroundColor = [UIColor clearColor];
    [viewHead addSubview:imgBank];
    
    
    
    labelBank  = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
    [viewHead addSubview:labelBank];
    labelBank.textColor = [ResourceManager color_1];
    labelBank.font = [UIFont systemFontOfSize:15];
    labelBank.text =  _strBankName;//@"招商银行";
    
    labelBankNO  = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 20)];
    [viewHead addSubview:labelBankNO];
    labelBankNO.textColor = [UIColor grayColor];
    labelBankNO.font = [UIFont systemFontOfSize:14];
    labelBankNO.text = _strHideCardCode;//@"尾号为4001";
    
    labelName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 15, 75, 20)];
    [viewHead addSubview:labelName];
    labelName.textColor = [UIColor grayColor];
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.text = _strHideName;//@"*李";
    labelName.textAlignment = NSTextAlignmentRight;
    
    UIImageView * viewRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-23, 15, 12, 17)];
    viewRight.image = [UIImage imageNamed:@"arrow-2"];
    [viewHead addSubview:viewRight];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionBank)];
    gesture.numberOfTapsRequired  = 1;
    viewHead.userInteractionEnabled = YES;
    [viewHead addGestureRecognizer:gesture];
}

-(void) layoutMid
{
    int iTopY = 10;
    UILabel *labelTXJE  = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 200, 20)];
    [viewMid addSubview:labelTXJE];
    labelTXJE.textColor = [UIColor grayColor];
    labelTXJE.font = [UIFont systemFontOfSize:14];
    
    NSString *strNO = @"(手续费1元)";
    NSString *strAll = [NSString stringWithFormat:@"提现金额 %@",strNO];
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    //[noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager redColor1] range:stringRange];
    labelTXJE.attributedText = noteString;
    
    iTopY +=labelTXJE.height + 15;
    UILabel *label1  = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 30, 20)];
    [viewMid addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:25];
    label1.text = @"¥";
    
    
    fieldMoney = [[UITextField alloc] initWithFrame:CGRectMake(40, iTopY, 300, 20)];
    [viewMid addSubview:fieldMoney];
    fieldMoney.textColor = [ResourceManager color_1];
    fieldMoney.font = [UIFont systemFontOfSize:15];
    NSString *strTemp = [NSString stringWithFormat:@"请输入提现金额，%d元起", _iMinWithdrawAmt];
    fieldMoney.placeholder = strTemp;
    [fieldMoney addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    fieldMoney.keyboardType = UIKeyboardTypeNumberPad;
    //[fieldMoney becomeFirstResponder];
    
    iTopY += label1.height + 15;
    labelTXJE2  = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 200, 20)];
    [viewMid addSubview:labelTXJE2];
    labelTXJE2.textColor = [ResourceManager color_1];
    labelTXJE2.font = [UIFont systemFontOfSize:14];
    NSString *strMoney = [NSString stringWithFormat:@"可提现金额： %.2f元", _fAllMoney];
    labelTXJE2.text = strMoney;
    
    UIButton *btnTX = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, iTopY-10, 90, 40)];
    //[viewMid addSubview:btnTX];
    [btnTX setTitle:@"全部提现" forState:UIControlStateNormal];
    [btnTX setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnTX addTarget:self action:@selector(actionQBTX) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY +=btnTX.height;
    viewMid.height = iTopY;
}

-(void) layoutTail
{
    int iTopY = 20;
    int iLeftX = 10;
    
    btnTX = [[UIButton alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, 40)];
    [viewTail addSubview:btnTX];
    [btnTX setTitle:@"申请提现" forState:UIControlStateNormal];
    [btnTX setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:14];
    btnTX.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [btnTX addTarget:self action:@selector(actionTX) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY +=   btnTX.height + 20;
    int iLabelWidth = SCREEN_WIDTH - 2 *iLeftX;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [viewTail addSubview:lableTitle];
    lableTitle.textColor = UIColorFromRGB(0x808080);
    lableTitle.font = [UIFont systemFontOfSize:14];
    lableTitle.text = @"温馨提示：";
    
    iTopY += lableTitle.height + 10;
    UILabel *labelDian1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 100)];
    [viewTail addSubview:labelDian1];
    labelDian1.textColor = UIColorFromRGB(0x808080);
    labelDian1.font = [UIFont systemFontOfSize:12];
    labelDian1.text = @"1, 提现到账时间为1-3工作日";
    [labelDian1 sizeToFit];
    
    iTopY += labelDian1.height + 10;
    UILabel *labelDian2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 100)];
    [viewTail addSubview:labelDian2];
    labelDian2.textColor = UIColorFromRGB(0x808080);
    labelDian2.font = [UIFont systemFontOfSize:12];
    NSString *strTemp = [NSString stringWithFormat:@"2, 最低提现金额%d元" , _iMinWithdrawAmt];
    labelDian2.text = strTemp;
    [labelDian2 sizeToFit];
    
    iTopY += labelDian2.height + 10;
    UILabel *labelDian3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 100)];
    [viewTail addSubview:labelDian3];
    labelDian3.textColor = UIColorFromRGB(0x808080);
    labelDian3.font = [UIFont systemFontOfSize:12];
    labelDian3.text = [NSString stringWithFormat:@"3, 提现金额为%d元的整数倍" , _iMinWithdrawAmt];
    [labelDian3 sizeToFit];
//
//    iTopY += labelDian3.height + 10;
//    UILabel *labelDian4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 100)];
//    [viewTail addSubview:labelDian4];
//    labelDian4.textColor = UIColorFromRGB(0x808080);
//    labelDian4.font = [UIFont systemFontOfSize:12];
//    labelDian4.text = @"• 每月25日结算上个月的佣金，3个工作日到账（节假日顺延）";
//    [labelDian4 sizeToFit];
    
}

-(void) dataUI
{

    NSString *strAllMoney = [NSString  stringWithFormat:@"可提现金额：%.2f",  _fAllMoney];
    labelTXJE2.text = strAllMoney;
    
    labelBank.text = _strBankName;
    labelBankNO.text = _strHideCardCode;
    labelName.text = _strHideName;
    
    //银行图像
    if (imageBankUrl.length > 0)
     {
        [imgBank sd_setImageWithURL:[NSURL URLWithString:imageBankUrl]];
     }
}


-(void) popMessage
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    //降低当前高度
    //[alertView subAlertCurHeight:25];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 17 color=#676767>您的提现申请已经提交</font>"]];
    
     [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 14 color=#676767>提现到账时间为1-3个工作日</font>"]];
    
    //[alertView addAlertCurHeight:20];
    
    alertView.isBtnCenter = YES;

    [alertView addButton:@"我知道了" color:[ResourceManager mainColor2] actionBlock:^{
    
        [self performSelector:@selector(popMyBack) withObject:nil afterDelay:0.5];
        
    }];
    

    
    
    [alertView showAlertView:self.parentViewController  duration:0.0];
    


    return;
}

-(void) popMyBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark ---  action
-(void) actionBank
{
    MyBankViewController *vc = [[MyBankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionQBTX
{
     NSString *strAllMoney = [NSString  stringWithFormat:@"%.2f",  _fAllMoney];
    fieldMoney.text = strAllMoney;
    
    [self passConTextChange:fieldMoney];
}

-(void) actionTX
{
    
    float fValue = [fieldMoney.text floatValue];
    int iTemp = (int)fValue % _iMinWithdrawAmt;
    if (iTemp >0)
     {
        NSString *strTemp = [NSString stringWithFormat:@"提现金额为%d元的整数倍" , _iMinWithdrawAmt];;
        [MBProgressHUD showErrorWithStatus:strTemp toView:self.view];
        return;
     }
        
    
    if (fValue >= _iMinWithdrawAmt  &&
        fValue <= _fAllMoney)
     {
        VerificatioPhoneVC *vc = [[VerificatioPhoneVC alloc] init];
        vc.strHideTelephone = _strHideTelephone;
        vc.strTelephone = _strTelephone;
        vc.amount = fValue;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.okBlock = ^(id obj) {
            
            [self popMessage];
            
        };
     }
}

-(void) actionRecord
{
    PutForwardRecordVC *vc = [[PutForwardRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) passConTextChange:(UITextField*) filed
{
    float fValue = [filed.text floatValue];
    if (fValue >= _iMinWithdrawAmt &&
        fValue <= _fAllMoney)
     {
        btnTX.backgroundColor = [ResourceManager mainColor2];
     }
    else
     {
        btnTX.backgroundColor = UIColorFromRGB(0xe6e6e6);
     }
}

#pragma mark  --- 网络通讯
-(void) getMyBank
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGBankGetInfo]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 102;
    [operation start];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    


    if(102 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            
            NSDictionary *dicCard = dic[@"cardInfo"];
            _fAllMoney = [dic[@"usableAmount"] floatValue];
            _iMinWithdrawAmt = [dic[@"minWithdrawAmt"] intValue];
  
            _strBankName =  dicCard[@"bankName"];//[dic objectForKey:@"bankName"];
            _strHideCardCode = dicCard[@"bankCardNo"];//[dic objectForKey:@"hideCardCode"];
            _strHideName = dicCard[@"accountName"]; //[dic objectForKey:@"hideName"];
            _strTelephone = dicCard[@"realTelephone"];;
            _strHideTelephone =dicCard[@"telephone"];
            imageBankUrl = [NSString stringWithFormat:@"%@",[dicCard objectForKey:@"bankImg"]];
            [self dataUI];
 
         }
        

        
     }
}


@end
