//
//  ModifyYQMVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/18.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "ModifyYQMVC.h"

@interface ModifyYQMVC ()
{
    UITextField  *fidldNike;
}
@end

@implementation ModifyYQMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"设置邀请码"];
    
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
    fidldNike.placeholder = @"请输入邀请码";
//    if (_strNikeName &&
//        _strNikeName.length >0)
//     {
//        fidldNike.text = _strNikeName;
//     }
    
    
    iTopY += fidldNike.height + 5;
    UILabel *labelSM = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    [self.view addSubview:labelSM];
    labelSM.textColor = [ResourceManager lightGrayColor];
    labelSM.font = [UIFont systemFontOfSize:12];
    labelSM.text = @"*邀请码仅限于大写英文字母或数字组合,长度为6位";
    
    
    iTopY += labelSM.height + 20;
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:btnSave];
    btnSave.backgroundColor = [ResourceManager mainColor2];
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
        [MBProgressHUD showErrorWithStatus:@"请输入邀请码" toView:self.view];
        return;
     }
    
    if (![self isUpAndDigit:fidldNike.text])
     {
         [MBProgressHUD showErrorWithStatus:@"仅限输入数字或大写英文字母" toView:self.view];
        return;
     }
    
    if (fidldNike.text.length != 6)
     {
        [MBProgressHUD showErrorWithStatus:@"邀请码长度必须为6位" toView:self.view];
        return;
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGupdateInviteCode];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"newInviteCode"] = fidldNike.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){

                                                                                      [MBProgressHUD showSuccessWithStatus:@"修改成功" toView:self.view];
                                                                                      
                                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UPWeb"
                                                                                                                                          object:nil
                                                                                                                                        userInfo:nil];

                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];

                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) isUpAndDigit:(NSString*) testString
{

    if (!testString)
     {
        return FALSE;
     }
    NSInteger alength = [testString length];
    
    
    for (int i = 0; i<alength; i++) {
        char commitChar = [testString characterAtIndex:i];
        NSString *temp = [testString substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            
            NSLog(@"字符串中含有中文");
            return FALSE;
        }else if((commitChar>64)&&(commitChar<91)){
            
            NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
            
            NSLog(@"字符串中含有小写英文字母");
            return FALSE;
        }else if((commitChar>47)&&(commitChar<58)){
            
            NSLog(@"字符串中含有数字");
        }else{
            NSLog(@"字符串中含有非法字符");
            return FALSE;
        }
    }
    
    return  TRUE;
}

@end
