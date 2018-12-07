//
//  InviteCodeViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/26.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "InviteCodeViewController.h"

@interface InviteCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inviteCodeField;

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;



@end

@implementation InviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutWhiteNaviBarViewWithTitle:@"填写邀请码"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.skipBtn.layer.borderWidth = 0.5;
    self.skipBtn.layer.borderColor = UIColorFromRGB(0x5A54FF).CGColor;
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}




- (IBAction)save:(id)sender {
    
    if (_inviteCodeField.text == 0) {
        [MBProgressHUD showErrorWithStatus:@"请填写邀请码" toView:self.view];
        return;
    }
    [self referCodeUrl];
}


- (IBAction)skip:(id)sender {
    self.taskBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)referCodeUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/cust/addReferCode",[PDAPI getBaseUrlString]] parameters:@{@"referCode":_inviteCodeField.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
}

#pragma mark ---数据操作---
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super handleData:operation];
    
    self.taskBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
