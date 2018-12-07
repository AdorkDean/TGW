//
//  SetNikeNameVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "SetNikeNameVC.h"

@interface SetNikeNameVC ()
{
    UITextField  *textInvitationCode;
    UITextField  *textNikeName;
    
}
@end

@implementation SetNikeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self layoutWhiteNaviBarViewWithTitle:@"设置昵称"];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

#pragma mark  ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iLeftX = 30;
    int iTopY = 100 * ScaleSize; //NavHeight + 30;
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:label1];
    label1.font = [UIFont systemFontOfSize:17];
    label1.textColor = [ResourceManager mainColor];
    label1.text = @"天狗窝";
    
    iTopY += label1.height;
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:label2];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [ResourceManager mainColor];
    label2.text = @"互联网区块链生态圈";
    
    
    iTopY += label2.height + 80;
    textInvitationCode = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 40)];
    [self.view addSubview:textInvitationCode];
    textInvitationCode.textColor = [ResourceManager color_1];
    textInvitationCode.font = [UIFont systemFontOfSize:14];
    textInvitationCode.placeholder = @"请输入邀请码(选填)";
    
    UILabel *labelFG1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + textInvitationCode.height, SCREEN_WIDTH - 2 *iLeftX,1)];
    [self.view addSubview:labelFG1];
    labelFG1.backgroundColor = [ResourceManager color_5];
    
    iTopY += textInvitationCode.height + 20;
    textNikeName = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 40)];
    [self.view addSubview:textNikeName];
    textNikeName.textColor = [ResourceManager color_1];
    textNikeName.font = [UIFont systemFontOfSize:14];
    textNikeName.placeholder = @"请输入昵称(设置后不可修改)";
    
    UILabel *labelFG2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + textInvitationCode.height, SCREEN_WIDTH - 2 *iLeftX,1)];
    [self.view addSubview:labelFG2];
    labelFG2.backgroundColor = [ResourceManager color_5];
    
    
    iTopY += textNikeName.height + 40;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 45)];
    [self.view addSubview:btnOK];
    [btnOK setTitle:@"立即开启" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    btnOK.backgroundColor =  [ResourceManager mainColor];
    btnOK.cornerRadius = 45/2;
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    // 加入协议
    iTopY += btnOK.height + 20;
    UILabel *labelXY = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [self.view  addSubview:labelXY];
    labelXY.textAlignment = NSTextAlignmentCenter;
    labelXY.font = [UIFont systemFontOfSize:14];
    labelXY.textColor = [ResourceManager color_1];
    
    
    NSString *strCount = @"《用户协议》";
    NSString *strAll = [NSString stringWithFormat:@"登录即表示同意%@",strCount];
    if ([PDAPI isTestUser])
     {
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

#pragma  mark  ---  action
-(void) actionOK
{
    if (textNikeName.text.length  <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请设置昵称" toView:self.view];
        return;
     }
    
    NSString *strNikeName = textNikeName.text;
    if ([NSString isContainsEmoji:strNikeName])
     {
        [LoadView showErrorWithStatus:@"请去除特殊字符串" toView:self.view];
        return;
     }
    
    [self sendNiekNameToWeb];
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
   

#pragma mark --- 网络通讯
-(void) sendNiekNameToWeb
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGsaveNickName];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"nickName"] = textNikeName.text;
    parmas[@"referCode"] = textInvitationCode.text;
    
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
    if (operation.tag == 1000) {

        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}




@end
