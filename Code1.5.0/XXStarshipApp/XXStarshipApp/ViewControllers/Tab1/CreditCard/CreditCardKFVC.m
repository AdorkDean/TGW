//
//  CreditCardKFVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/17.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "CreditCardKFVC.h"
#import "QuestionVC.h"

@interface CreditCardKFVC ()

@end

@implementation CreditCardKFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"专属平台客服"];
    
    [self layoutUI];
    
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight + 10, SCREEN_WIDTH, 180)];
    [self.view addSubview:viewTop];
    viewTop.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 20;
    int iImgWidth = 50;
    int iLeftX = (SCREEN_WIDTH - iImgWidth)/2;
    UIImageView *imgWX = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iImgWidth, iImgWidth)];
    [viewTop addSubview:imgWX];
    imgWX.image = [UIImage imageNamed:@"com_weixin"];
    
    iTopY += imgWX.height +10;
    UIButton *btnTJ = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX-20, iTopY, iImgWidth+40, 20)];
    [viewTop addSubview:btnTJ];
    [btnTJ setTitle:@"加微信" forState:UIControlStateNormal];
    [btnTJ setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnTJ.titleLabel.font = [UIFont systemFontOfSize:14];
    btnTJ.backgroundColor = [ResourceManager midGrayColor];
    [btnTJ addTarget:self action:@selector(actionJWX) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnTJ.height +10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewTop addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    
 
    

    NSString *strNO = [NSString stringWithFormat:@"%@",[CommonInfo getKey:K_CREDIT_WEIXING]];;//  @"10501";
    NSString *strAll =  [NSString stringWithFormat:@"添加客服微信 %@",strNO];
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x5953ff) range:stringRange];
    label1.attributedText = noteString;
    
    iTopY += label1.height;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewTop addSubview:label2];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"第一时间了解平台最新活动";
    
    
    iTopY = NavHeight + 10 + viewTop.height  + 20;
    UIButton *btnCJWT = [[UIButton alloc] initWithFrame:CGRectMake(20, iTopY, SCREEN_WIDTH - 40, 45)];
    [self.view addSubview:btnCJWT];
    btnCJWT.backgroundColor = UIColorFromRGB(0x5953ff);
    [btnCJWT setTitle:@"常见问题"  forState:UIControlStateNormal];
    btnCJWT.titleLabel.font = [UIFont systemFontOfSize:17];
    btnCJWT.cornerRadius = 5;
    [btnCJWT addTarget:self action:@selector(actionCJWT) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark  --- action
-(void) actionCJWT
{
    // 常见问题
    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/help",[PDAPI WXSysRouteAPI2]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"常见问题";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionJWX
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:self.view];
        return;
     }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}



@end
