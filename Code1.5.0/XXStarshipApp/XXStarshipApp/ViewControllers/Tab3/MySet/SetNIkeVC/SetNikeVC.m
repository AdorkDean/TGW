//
//  SetNikeVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/8/27.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "SetNikeVC.h"

@interface SetNikeVC ()
{
    UITextField  *fidldNike;
}
@end

@implementation SetNikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"设置昵称"];
    
    [self layoutUI];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    int iTopY  = NavHeight + 20;
    int iLeftX = 15;
    fidldNike = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:fidldNike];
    fidldNike.backgroundColor = [UIColor whiteColor];
    fidldNike.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    fidldNike.layer.borderWidth = 0.3;
    fidldNike.layer.cornerRadius = 5;
    fidldNike.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示)
    fidldNike.leftViewMode = UITextFieldViewModeAlways;
    fidldNike.font = [UIFont systemFontOfSize:14];
    fidldNike.placeholder = @"请输入昵称";
    if (_strNikeName &&
        _strNikeName.length >0)
     {
        fidldNike.text = _strNikeName;
     }
    
    
    iTopY += fidldNike.height + 20;
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:btnSave];
    btnSave.backgroundColor = [ResourceManager mainColor];
    btnSave.cornerRadius = 45/2;
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSave addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
}

#pragma  mark ---  action
-(void) actionSave
{
    if (fidldNike.text.length == 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入昵称" toView:self.view];
        return;
     }
    
    [self actionPopSMRZ];
    

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
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>修改昵称，需要消耗10个天狗币。</font>"]];
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"确认修改" color:[ResourceManager mainColor] actionBlock:^{
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGupdateCustName];
        NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
        parmas[@"nickName"] = fidldNike.text;
        DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                                   parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                      success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                          
                                                                                          [MBProgressHUD showSuccessWithStatus:@"保存昵称成功" toView:self.view];
                                                                                          
                                                                                          // 在延迟后执行
                                                                                          [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                          
                                                                                      }
                                                                                      failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                          
                                                                                          [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      }];
        operation.tag = 1000;
        [operation start];
        
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
