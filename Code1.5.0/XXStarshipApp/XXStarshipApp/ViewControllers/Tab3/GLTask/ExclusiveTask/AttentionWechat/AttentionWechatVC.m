//
//  AttentionWechatVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/8/27.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AttentionWechatVC.h"

@interface AttentionWechatVC ()<UITextFieldDelegate>
{
    UIScrollView *scView;
    
    UITextField *fieldCode;
    
}
@end

@implementation AttentionWechatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"关注微信公众号"];
    
    [self layoutUI];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [scView setContentOffset:CGPointMake(0,0) animated:YES];
    [self.view endEditing:YES];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    
    
    int iTopY = NavHeight;
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 300);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    iTopY = 0;
    // 贴图
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0,iTopY , SCREEN_WIDTH, 250*ScaleSize)];
    [scView addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"task_guanzhuweixin_bg"];
    
    iTopY += imgBG.height + 30;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:lableTitle];
    lableTitle.font = [UIFont systemFontOfSize:16];
    lableTitle.textColor = [ResourceManager color_1];
    lableTitle.text = @"请输入6位验证码";
    lableTitle.textAlignment = NSTextAlignmentCenter;
    
    iTopY += lableTitle.height + 46;
    fieldCode = [[UITextField alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:fieldCode];
    fieldCode.font = [UIFont systemFontOfSize:18];
    fieldCode.textColor = [ResourceManager color_1];
    fieldCode.placeholder = @"请输入6位验证码";
    fieldCode.textAlignment = NSTextAlignmentCenter;
    fieldCode.delegate = self;
    
    
    iTopY += fieldCode.height + 10;
    UIView *viewFG =  [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 1)];
    [scView addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    iTopY += 55;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 45)];
    [scView addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    btnOK.cornerRadius = 45/2;
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [scView setContentOffset:CGPointMake(0,200) animated:YES];
    return  YES;
}

#pragma mark   ---   action
-(void) actionOK
{
    if (fieldCode.text.length == 0)
     {
        [LoadView showErrorWithStatus:@"请输入6位验证码" toView:self.view];
        return;
     }
    
    [LoadView showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetfollowWxPublicAccount];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"validateCode"] = fieldCode.text;
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [LoadView showSuccessWithStatus:@"领取狗粮成功" toView:self.view];
                                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}




@end
