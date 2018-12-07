//
//  WXLoginViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 17/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WXLoginViewController_2.h"
#import "PassWordViewController.h"
#import "SetNikeNameVC.h"



@interface WXLoginViewController_2 ()
{
    NSString *smsTokenId;  // 短信防刷Token
    int   sign;  // 0为登录成功跳转主界面；1为跳转昵称填写页
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSafeAreaTopHeight;
@property (weak, nonatomic) IBOutlet UIButton *OkBtn;

@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;

@end

@implementation WXLoginViewController_2

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layoutSafeAreaTopHeight.constant = 100 * ScaleSize;
    
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    // 加入协议
    int iTopY = _OkBtn.top + 180;
    UILabel *labelXY = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [self.view  addSubview:labelXY];
    labelXY.textAlignment = NSTextAlignmentCenter;
    labelXY.font = [UIFont systemFontOfSize:14];
    labelXY.textColor = [ResourceManager color_1];
    
    
    NSString *strCount = @"《用户协议》";
    NSString *strAll = [NSString stringWithFormat:@"登录即表示同意%@",strCount];
    
    if ([PDAPI isTestUser])
     {
        _labelSubTitle.text = @"互联网生态圈";
        strAll = [NSString stringWithFormat:@"登录即表示同意注册,%@",strCount];
     }
    //获取需要改变的字符串在完整字符串的范围
    NSRange rang = [strAll rangeOfString:strCount];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:strAll];
    //设置文字大小
    [attributStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:rang];
    labelXY.attributedText = attributStr;
    
    
    //添加手势点击空白处隐藏键盘
    labelXY.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionXY)];
    gesture1.numberOfTapsRequired  = 1;
    [labelXY addGestureRecognizer:gesture1];
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

-(void) actionXY
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/loanProtocol",[PDAPI WXSysRouteAPI]];
    url = @"http://www.tiangouwo.com/pages/agreement.html";
    if ([PDAPI isTestUser])
     {
        url = @"http://www.tiangouwo.com/pages/agreement2.html";
     }
    
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"天狗窝用户协议"];

    
}

//返回按钮
-(void)clickNavButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//下一步
- (IBAction)next:(id)sender {
    

    if (![_phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (self.VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入短信验证码" toView:self.view];
        return;
    }else{
        [self loginOrReg];
    }
}




//获取验证码
- (IBAction)verify:(id)sender {
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([self.phoneTextField.text isMobileNumber]) {
        
        [self getSMSFrist];
        

        
    }else{
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_VerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _VerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%02d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_VerifyBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                
                _VerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}





#pragma mark  --- 网络请求
-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    
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
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGnologin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,self.phoneTextField.text];
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

-(void)loginOrReg
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGkjLogin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    parmas[@"randomNo"] = self.VerifyTextField.text;
    
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

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (operation.tag == 998) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
    }else if (operation.tag == 999) {
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", self.phoneTextField.text];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }else if (operation.tag == 1000){
        if (operation.jsonResult.signId && operation.jsonResult.signId.length > 0) {
            [[DDGSetting sharedSettings] setSignId:operation.jsonResult.signId];
        }
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            sign = [dic[@"sign"] intValue];
            
            if (1 == sign)
             {
                SetNikeNameVC *vc = [[SetNikeNameVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
             }
         }
        
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];
        //跳转首页
        //[[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];

    }else if (operation.tag == 1001) {
        //微信登陆
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
        for (NSString *key in dic.allKeys) {   //避免NULL字段
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];
        //跳转首页
        //[[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
    }
    
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


@end
