//
//  AuthenticationVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/28.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AuthenticationVC.h"

@interface AuthenticationVC ()
{
    UITextField  *textName;
    UITextField  *textCard;
}
@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"实名认证"];

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
    int iTopY = NavHeight + 50;
    

    
    
    textName = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 40)];
    [self.view addSubview:textName];
    textName.textColor = [ResourceManager color_1];
    textName.font = [UIFont systemFontOfSize:14];
    textName.placeholder = @"请输入姓名";
    
    UILabel *labelFG1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + textName.height, SCREEN_WIDTH - 2 *iLeftX,1)];
    [self.view addSubview:labelFG1];
    labelFG1.backgroundColor = [ResourceManager color_5];
    
    iTopY += textName.height + 20;
    textCard = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 40)];
    [self.view addSubview:textCard];
    textCard.textColor = [ResourceManager color_1];
    textCard.font = [UIFont systemFontOfSize:14];
    textCard.placeholder = @"请输入身份证号";
    
    UILabel *labelFG2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + textName.height, SCREEN_WIDTH - 2 *iLeftX,1)];
    [self.view addSubview:labelFG2];
    labelFG2.backgroundColor = [ResourceManager color_5];
    
    
    iTopY += textCard.height + 150;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 45)];
    [self.view addSubview:btnOK];
    [btnOK setTitle:@"提交信息" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    btnOK.backgroundColor =  [ResourceManager mainColor];
    btnOK.cornerRadius = 45/2;
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma  mark  ---  action
-(void) actionOK
{
    if (textName.text.length  <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入姓名" toView:self.view];
        return;
     }
    if (textCard.text.length  <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入身份证号码" toView:self.view];
        return;
     }
    [self sendNiekNameToWeb];
}


#pragma mark --- 网络通讯
-(void) sendNiekNameToWeb
{
    [LoadView showHUDNavAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGidentify];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"cardNo"] = textCard.text;
    parmas[@"realName"] = textName.text;
    
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
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (operation.tag == 1000) {
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
        //跳转首页
        //[[DDGUserInfoEngine engine] finishDoBlock];
        //[[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        [LoadView showSuccessWithStatus:@"实名认证成功" toView:self.view];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [LoadView hideAllHUDsForView:self.view animated:YES];
    [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


@end
