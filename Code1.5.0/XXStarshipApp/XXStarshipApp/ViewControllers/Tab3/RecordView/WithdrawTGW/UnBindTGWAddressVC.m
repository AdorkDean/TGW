//
//  UnBindTGWAddressVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "UnBindTGWAddressVC.h"

@interface UnBindTGWAddressVC ()
{
    UIView *view1;
    UIButton *btnCode;
    UITextField  *textField;
    NSString *smsTokenId;
    
    UIView *view2;
    
    
}
@end

@implementation UnBindTGWAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"解绑天狗账号"];
    
    [self layoutUI];
}

#pragma  mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutVIew1];
    
}


-(void) layoutVIew1
{
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight )];
    [self.view addSubview:view1];
    
    int iTopY = 20;
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [view1 addSubview:labelT1];
    labelT1.textColor = [ResourceManager color_1];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.textAlignment = NSTextAlignmentCenter;
    labelT1.text = [NSString stringWithFormat:@"请输入手机号%@验证码",_hideTelephone];
    
    iTopY += labelT1.height ;
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [view1 addSubview:labelT2];
    labelT2.textColor = [ResourceManager color_1];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.textAlignment = NSTextAlignmentCenter;
    labelT2.text = @"进行身份验证";
    
    iTopY += labelT2.height + 39;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(30, iTopY, 200, 30)];
    [view1 addSubview:textField];
    textField.textColor = [ResourceManager mainColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"请输入验证码";
    
    
    btnCode = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90-30, iTopY+2, 90, 22)];
    [view1 addSubview:btnCode];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    //[btnCode setTitleColor:UIColorFromRGB(0xf8aa3b) forState:UIControlStateNormal];
    btnCode.backgroundColor = [ResourceManager mainColor];
    btnCode.cornerRadius = 3;
    btnCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCode addTarget:self action:@selector(actionCode) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += textField.height + 5;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 1)];
    [view1 addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    iTopY += viewFG.height + 39;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH- 30, 40)];
    [view1 addSubview:btnOK];
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:[ResourceManager mainColor]];
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) layoutVIew2
{
    view1.hidden = YES;
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight )];
    [self.view addSubview:view2];
    
    int iTopY = 30;
    int iLeftX = (SCREEN_WIDTH - 40)/2;
    UIImageView *imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 40)];
    [view2 addSubview:imgGou];
    imgGou.image = [UIImage imageNamed:@"com_gou_sel"];
    
    iTopY += imgGou.height +10;
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [view2 addSubview:labelT2];
    labelT2.textColor = [ResourceManager color_1];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.textAlignment = NSTextAlignmentCenter;
    labelT2.text = @"账号解绑成功";
    
    iTopY += labelT2.height + 20;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH- 30, 40)];
    [view2 addSubview:btnOK];
    [btnOK setTitle:@"返回" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:[ResourceManager mainColor]];
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK addTarget:self action:@selector(actionReturn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma  mark --- action
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
                btnCode.backgroundColor = [ResourceManager mainColor];
                //[btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btnCode setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                btnCode.backgroundColor = UIColorFromRGB(0xe5e0fc);
                
                btnCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void) actionOK
{
    if (textField.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
     }
    [self unBindAccid];
}

-(void) actionReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  --- 网络请求
-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGunBindgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = _telephone;
    
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
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGSMSunBindAcc];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = _telephone;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,_telephone];
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


-(void)unBindAccid
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGunBindAcc];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"accid"] = _accid;
    parmas[@"randomNo"] = textField.text;

    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    
    if (operation.tag == 998) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
    }else if (operation.tag == 999) {
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", _hideTelephone];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }else if (operation.tag == 1000){
     
        [self layoutVIew2];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}



@end
