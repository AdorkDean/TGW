//
//  BarterLogisticsVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/20.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "BarterLogisticsVC.h"

@interface BarterLogisticsVC ()
{
    UITextField *field1;
    UITextField *field2;
}
@end

@implementation BarterLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"填写换货物流"];
    
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

#pragma mark --- 布局UI
-(void) layoutUI
{
    int iTopY = NavHeight + 25;
    int iLeftX = 15;
    int iViewWdith = SCREEN_WIDTH - 2*iLeftX;
    int iViewHeight = 60;
    
    // 物流公司view
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, iViewHeight)];
    [self.view addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    view1.cornerRadius = 5;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, iViewHeight)];
    [view1 addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"物流公司";
    
    field1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, iViewWdith-110, iViewHeight)];
    [view1 addSubview:field1];
    field1.placeholder = @"请输入物流公司";
    field1.textColor = [ResourceManager color_1];
    field1.font = [UIFont systemFontOfSize:15];
    
    //快递单号View
    iTopY += view1.height + 15;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, iViewHeight)];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor whiteColor];
    view2.cornerRadius = 5;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, iViewHeight)];
    [view2 addSubview:label2];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"快递单号";
    
    field2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, iViewWdith-110, iViewHeight)];
    [view2 addSubview:field2];
    field2.placeholder = @"请输入快递单号";
    field2.textColor = [ResourceManager color_1];
    field2.font = [UIFont systemFontOfSize:15];
    
    iTopY += view2.height + 15;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"提交" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    btnOK.cornerRadius = btnOK.height/2;
    
}

#pragma mark --- action
-(void) actionOK
{
    
}

#pragma mark --- 网络通讯
-(void) comitWLInfo
{
    
}





@end
