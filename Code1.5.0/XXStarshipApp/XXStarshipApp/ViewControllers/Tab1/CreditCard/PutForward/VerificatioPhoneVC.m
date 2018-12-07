//
//  VerificatioPhoneVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/6/1.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "VerificatioPhoneVC.h"
#import "IdentifyAlertView.h"

@interface VerificatioPhoneVC ()
{
    UILabel *labelNote;
    UITextField *fieldPhoneCode;
    UIButton *btnCode;
    NSString *smsTokenId;
    
}
@end

@implementation VerificatioPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"短信验证"];
    
    [self layoutUI];
}

#pragma mark  --- 布局UI
- (void) layoutUI
{
    int iTopY = NavHeight + 15;
    int iLeftX = 10;
    
    labelNote = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [self.view addSubview:labelNote];
    labelNote.textColor = [UIColor grayColor];
    labelNote.font = [UIFont systemFontOfSize:14];
    NSString *strLabel = [NSString stringWithFormat:@"请输入您手机%@的短信验证码",_strHideTelephone];
    labelNote.text = strLabel;//@"输入您手机132****476的短信验证码";
    
    iTopY += labelNote.height + 15;
    UIView *viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [self.view addSubview:viewPhone];
    viewPhone.backgroundColor = [UIColor whiteColor];
    
    fieldPhoneCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
    [viewPhone addSubview:fieldPhoneCode];
    fieldPhoneCode.textColor = [ResourceManager color_1];
    fieldPhoneCode.font = [UIFont systemFontOfSize:14];
    fieldPhoneCode.placeholder = @"请输入短信验证码";
    
    UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 15, 1, 20)];
    [viewPhone addSubview:labelFG];
    labelFG.backgroundColor = [ResourceManager color_5];
    
    btnCode = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 90, 50)];
    [viewPhone addSubview:btnCode];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCode addTarget:self action:@selector(actionCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += viewPhone.height + 25;
    UIButton *btnTX = [[UIButton alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, 40)];
    [self.view addSubview:btnTX];
    [btnTX setTitle:@"申请提现" forState:UIControlStateNormal];
    [btnTX setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTX.backgroundColor = [ResourceManager mainColor2];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnTX addTarget:self action:@selector(actionTX) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark ---  action
-(void) actionCode
{
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }

    
    [self getSMSFrist];
    
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btnCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btnCode setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                
                btnCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = _strTelephone;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 998;
    [operation start];
}


-(void)getSMSSecond
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGxjSmsWithdraws];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = _strTelephone;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,_strTelephone];
    parmas[@"smsEnc"] = [strTemp stringTGWToMD5];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 999;
    [operation start];
}


-(void) actionTX
{
    if (fieldPhoneCode.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
     }
    [self withdrawApply];
}


#pragma mark --- 网络通讯
-(void) withdrawApply
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"randomNo"] = fieldPhoneCode.text;
    parmas[@"amount"] = @(_amount);
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGxjwithdraw]
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){

                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];

    operation.tag = 101;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (101 == operation.tag)
     {
        if (_okBlock)
         {
            _okBlock(@"");
         }
     }
    
    
    if (operation.tag == 998) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
    }else if (operation.tag == 999) {
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", _strTelephone];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}



@end
