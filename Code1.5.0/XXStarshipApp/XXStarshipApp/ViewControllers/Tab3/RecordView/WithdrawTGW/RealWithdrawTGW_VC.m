//
//  RealWithdrawTGW_VC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "RealWithdrawTGW_VC.h"
#import "TXTGWRecordVC.h"

@interface RealWithdrawTGW_VC ()<UITextFieldDelegate>
{
    UITextField  *fidldNike;
}
@end

@implementation RealWithdrawTGW_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"提现天狗币"];
    
    float fRightBtnTopY = NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f,fRightBtnTopY,70.f, 35.0f)];
    [rightNavBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:UIColorFromRGB(0x264fc0)  forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionRecord) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];
    
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


#pragma  mark --- 布局UI 
-(void) layoutUI
{
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [self.view addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"qb_bg"];
    
    int iTopY  = NavHeight + 25;
    UIView *viewKuang   = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 231)];
    [self.view addSubview:viewKuang];
    viewKuang.backgroundColor = [UIColor whiteColor];
    viewKuang.cornerRadius = 8;
    
    iTopY = 15;
    int iLeftX = 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-10, 20)];
    label1.font = [UIFont systemFontOfSize:13];
    label1.text =   @"天狗窝钱包地址";
    label1.textColor = [ResourceManager color_1];
    [viewKuang addSubview:label1];
    
    iTopY += 15;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, viewKuang.width - 2*iLeftX, 50)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [ResourceManager color_1];
    label2.text =  _accid;
    label2.numberOfLines = 0;
    [viewKuang addSubview:label2];
    
    iTopY += label2.height + 10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, viewKuang.width- 2*iLeftX, 1)];
    [viewKuang addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    iTopY += viewFG.height + 10;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-10, 20)];
    label3.font = [UIFont systemFontOfSize:13];
    label3.text =   @"天狗币数量";
    label3.textColor = [ResourceManager color_1];
    [viewKuang addSubview:label3];
    
    
    iTopY += label3.height + 10;
    fidldNike = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, viewKuang.width - 2*iLeftX, 45)];
    [viewKuang addSubview:fidldNike];
    fidldNike.delegate = self;
    fidldNike.backgroundColor = UIColorFromRGB(0xf5f4fa);
    fidldNike.cornerRadius = 8;
    fidldNike.keyboardType = UIKeyboardTypeDecimalPad;
    fidldNike.font = [UIFont systemFontOfSize:14];
    fidldNike.placeholder = @"请输入天狗币数量";
    
    fidldNike.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 0)];
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 23, 23)];
    imageViewPwd.image=[UIImage imageNamed:@"qb_tgb"];
    [fidldNike addSubview:imageViewPwd];
    //设置显示模式为永远显示(默认不显示)
    fidldNike.leftViewMode = UITextFieldViewModeAlways;
    

    iTopY += fidldNike.height + 15;
    UILabel *labelTGB = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-10, 20)];
    labelTGB.font = [UIFont systemFontOfSize:13];
    labelTGB.text =   [NSString stringWithFormat:@"最多可提取 %@ 个天狗币",_allCoinValue];
    labelTGB.textColor = [ResourceManager lightGrayColor];
    [viewKuang addSubview:labelTGB];
    
    

    iTopY = NavHeight + 15 + viewKuang.height + 15;
    UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH -30, 20)];
    [self.view addSubview:labelT];
    labelT.textColor = UIColorFromRGB(0xdbd8dd);
    labelT.font = [UIFont systemFontOfSize:12];
    labelT.text = @"到帐受区块链确认时间限制，可能略有延迟。";
    
    iTopY += labelT.height +15;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH- 30, 40)];
    [self.view addSubview:btnOK];
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:UIColorFromRGB(0x264fc0)];
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


#pragma mark --- aciton
-(void) actionOK
{
    if (fidldNike.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入天狗币数量"  toView:self.view];
        return;
     }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradeValue"] = fidldNike.text;
    params[@"accid"] = _accid;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGaccWithdraw]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD showSuccessWithStatus:@"提现成功" toView:self.view];
                                                                                      
                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    [operation start];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}

-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionRecord
{
    TXTGWRecordVC *VC = [[TXTGWRecordVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma  mark --- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 5;//小数点后需要限制的个数
    for (int i = (int)futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}


@end
