//
//  FeedbackVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/28.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()<UITextViewDelegate>
{
    UITextView *textAdivseView;
    UILabel *labelTotal;
}
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"意见反馈"];
    
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
    textAdivseView = [[UITextView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 200)];
    [self.view addSubview:textAdivseView];
    textAdivseView.delegate = self;
    textAdivseView.layer.borderColor = [ResourceManager color_5].CGColor;
    textAdivseView.layer.borderWidth = 1;
    textAdivseView.cornerRadius = 5;
    textAdivseView.text = @"请输入您的宝贵意见";
    textAdivseView.font = [UIFont systemFontOfSize:14];
    textAdivseView.textColor = [ResourceManager lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange) name:UITextViewTextDidChangeNotification object:nil];
    
    iTopY += textAdivseView.height + 5;
    labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200 - iLeftX, iTopY, 200, 20)];
    [self.view addSubview:labelTotal];
    labelTotal.font = [UIFont systemFontOfSize:14];
    labelTotal.textColor = [ResourceManager color_1];
    labelTotal.textAlignment = NSTextAlignmentRight;
    labelTotal.text = @"0/200";
    
    iTopY += labelTotal.height;
    UILabel *labelDes = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:labelDes];
    labelDes.numberOfLines = 0;
    labelDes.textColor = [ResourceManager blackGrayColor];
    labelDes.font = [UIFont systemFontOfSize:13];
    labelDes.text = @"* 所有的意见我们将进行审核，经采纳的有效建议在72小时内联系用户(联系号码为注册时默认电话号码)";
    
    
    iTopY += labelDes.height + 100;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"提交意见" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
    btnOK.cornerRadius = 20;
    [btnOK addTarget:self  action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && textView.text.length >= 200) {
        [MBProgressHUD showErrorWithStatus:@"不能超过200字" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)didChange
{
    NSLog(@"noti -- didChange");
    int iLength = (int) textAdivseView.text.length;
    NSString *strTemp = [NSString stringWithFormat:@"%d/200",iLength];
    labelTotal.text = strTemp;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的宝贵意见"])
     {
        textView.text = @"";
        textView.textColor = [ResourceManager color_1];
     }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text == nil || textView.text.length < 1) {
        textView.text = @"请输入您的宝贵意见";
        textView.textColor = [ResourceManager lightGrayColor];
    }
}

#pragma mark --- action
-(void) actionCommit
{
    
    if ([textAdivseView.text isEqualToString:@"请输入您的宝贵意见"]||
        textAdivseView.text.length <= 0)
     {
        [LoadView showErrorWithStatus:@"请输入您的宝贵意见" toView:self.view];
        return;
     }
    
    NSString *strAdivse = textAdivseView.text;
    if ([NSString isContainsEmoji:strAdivse])
     {
        [LoadView showErrorWithStatus:@"请去除特殊字符串" toView:self.view];
        return;
     }
    
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGfeedBack];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"content"] = textAdivseView.text;
    //parmas[@"realName"] = textName.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [LoadView showSuccessWithStatus:@"提交意见成功" toView:self.view];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
    
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
    
}



@end
