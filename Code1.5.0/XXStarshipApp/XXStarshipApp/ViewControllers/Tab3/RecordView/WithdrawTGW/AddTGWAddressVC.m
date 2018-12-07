//
//  AddTGWAddressVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "AddTGWAddressVC.h"

@interface AddTGWAddressVC ()<UITextViewDelegate>
{
    UITextView *textAdivseView;
}
@end

@implementation AddTGWAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"添加天狗钱包地址"];
    
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


-(void) layoutUI
{
    int iTopY = NavHeight + 20;
    int iLeftX = 15;
    textAdivseView = [[UITextView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 60)];
    [self.view addSubview:textAdivseView];
    textAdivseView.delegate = self;
    textAdivseView.layer.borderColor = [ResourceManager color_5].CGColor;
    textAdivseView.layer.borderWidth = 1;
    textAdivseView.cornerRadius = 5;
    textAdivseView.text = @"请输入天狗钱包的地址";
    textAdivseView.font = [UIFont systemFontOfSize:14];
    textAdivseView.textColor = [ResourceManager lightGrayColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange) name:UITextViewTextDidChangeNotification object:nil];
    
    
    iTopY += textAdivseView.height +5;
    UILabel *labelDes = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:labelDes];
    labelDes.numberOfLines = 0;
    labelDes.textColor = [ResourceManager blackGrayColor];
    labelDes.font = [UIFont systemFontOfSize:13];
    labelDes.text = @"* 钱包地址由英文字母+数字组合";
    
    
    iTopY += labelDes.height + 20;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"保存" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
    btnOK.cornerRadius = 20;
    [btnOK addTarget:self  action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += btnOK.height + 10;
    UIButton *btnRegsiter = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnRegsiter];
    [btnRegsiter setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnRegsiter.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnRegsiter addTarget:self  action:@selector(actionRegsiter) forControlEvents:UIControlEventTouchUpInside];
    
  
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"注册钱包地址"];
    //设置下划线...
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor]  range:NSMakeRange(0,[tncString length])];
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:[ResourceManager mainColor] range:(NSRange){0,[tncString length]}];
    [btnRegsiter setAttributedTitle:tncString forState:UIControlStateNormal];
    
    
}

#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && textView.text.length >= 200) {
        [MBProgressHUD showErrorWithStatus:@"不能超过200字" toView:self.view];
        return NO;
    }
    return YES;
}

//- (void)didChange
//{
//    NSLog(@"noti -- didChange");
//    int iLength = (int) textAdivseView.text.length;
//    NSString *strTemp = [NSString stringWithFormat:@"%d/200",iLength];
//    labelTotal.text = strTemp;
//}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入天狗钱包的地址"])
     {
        textView.text = @"";
        textView.textColor = [ResourceManager color_1];
     }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text == nil || textView.text.length < 1) {
        textView.text = @"请输入天狗钱包的地址";
        textView.textColor = [ResourceManager lightGrayColor];
    }
}

#pragma mark --- action
-(void) actionCommit
{
    
    if ([textAdivseView.text isEqualToString:@"请输入天狗钱包的地址"]||
        textAdivseView.text.length <= 0)
     {
        [LoadView showErrorWithStatus:@"请输入天狗钱包的地址" toView:self.view];
        return;
     }
    
    NSString *strAdivse = textAdivseView.text;
    if ([NSString isContainsEmoji:strAdivse])
     {
        [LoadView showErrorWithStatus:@"请去除特殊字符串" toView:self.view];
        return;
     }
    
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGbindAcc];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"accid"] = textAdivseView.text;
    // @"0532f170f21e40baad458a24b7b2fe6370b9e62b";  测试环境， 密码09123456
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [LoadView showSuccessWithStatus:@"绑定钱包成功" toView:self.view];
                                                                                      
                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
    
}

-(void) actionRegsiter
{
    //https://www.tiangouwo.com/tgwproject/dogbag
    NSURL* url = [[ NSURL alloc ] initWithString :@"https://www.tiangouwo.com/tgwproject/dogbag"];
    [[UIApplication sharedApplication] openURL:url];
}


-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
