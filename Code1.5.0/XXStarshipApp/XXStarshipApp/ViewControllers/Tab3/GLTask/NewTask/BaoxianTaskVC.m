//
//  BaoxianTaskVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/23.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "BaoxianTaskVC.h"
#import "QuestionVC.h"

@interface BaoxianTaskVC ()
{
    UIScrollView  *scView;
    
    
    
    int identityStatus;  // 1 表示实名认证
    int followWxStatus;  // 1 表示关注微信号成功
    int joinWxQunStatus; // 1 表示加入群聊成功
    int joinQqQunStatus; // 1 表示加入QQ群成功
    int joinByQunStatus;
}
@end

@implementation BaoxianTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"保险任务"];
    [self layoutUI];

}


#pragma  mark  ---  布局UI
-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NavHeight);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    scView.userInteractionEnabled = YES;
    
    
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    int iTopY = 0;
    UIImageView  *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 160)];
    [scView addSubview:imgTop];
    imgTop.image = [UIImage imageNamed:@"Task2_base_bj"];
    
    
    iTopY = 46;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [scView addSubview:lableTitle];
    lableTitle.textColor = [UIColor whiteColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:26];
    lableTitle.text = @"保险任务";
    
    iTopY += lableTitle.height + 25;
    int iGLBtnLeftX = 60;
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(iGLBtnLeftX, iTopY, SCREEN_WIDTH - 2*iGLBtnLeftX, 25)];
    [scView addSubview:btnGL];
    //btnGL.layer.borderColor = [UIColor whiteColor].CGColor;
    //btnGL.layer.borderWidth = 0.5;
    btnGL.backgroundColor = UIColorFromRGBA(0x000734, 0.2);
    btnGL.cornerRadius = btnGL.height/2;
    [btnGL setTitle:@"狗粮越多，生长的天狗币越多" forState:UIControlStateNormal];
    [btnGL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGL.titleLabel.font = [UIFont systemFontOfSize:14];
    
    iTopY = imgTop.height + 10;
    int iBtnLeftX = 15;
    int iBtnWdith = (SCREEN_WIDTH- 3*iBtnLeftX) /2;
    int iBtnHeight = 150;
    
    
    //NSString *strGZGZH = [NSString stringWithFormat:@"+%@长期狗粮",_dicData[@"fllowWxReward"]];
    NSString *strInsuranceMessage = _dicData[@"insuranceMessage"];

    
    NSArray *arrImg = @[@"BT_lqywx"];
    NSArray *arrName = @[@"免费领取意外险"];
    NSArray *arrSubTitle = @[strInsuranceMessage];
    int iBtnCount = (int)[arrImg count];
    
    for (int i = 0; i < iBtnCount; i ++)
     {
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, iBtnWdith, iBtnHeight)];
        [scView addSubview:btnTemp];
        btnTemp.backgroundColor = UIColorFromRGB(0xecf3fb);
        btnTemp.cornerRadius = 10;
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionTask:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView  *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWdith - 40)/2, 20, 40, 40)];
        [btnTemp addSubview:imgTemp];
        imgTemp.image = [UIImage imageNamed:arrImg[i]];
        
        UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, iBtnWdith, 20)];
        [btnTemp addSubview:labelTemp];
        labelTemp.textAlignment = NSTextAlignmentCenter;
        labelTemp.font = [UIFont systemFontOfSize:15];
        labelTemp.textColor = [ResourceManager color_1];
        labelTemp.text = arrName[i];
        
        UILabel *label3 = [[UILabel alloc]  initWithFrame:CGRectMake((iBtnWdith- 100)/2, 110, 100, 25)];
        [btnTemp addSubview:label3];
        label3.backgroundColor = [ResourceManager mainColor2];
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = arrSubTitle[i];
        
        int iTemp = i +1;
        if (iTemp %2 == 0)
         {
            iTopY += iBtnHeight + 15;
            iBtnLeftX  = 15;
         }
        else
         {
            iBtnLeftX += iBtnWdith + 15;
         }
        
        
        
        
        if (0 == i)
         {
            // 1 表示领取过意外保险
            
            int insuranceStatus = [_dicData[@"insuranceStatus"] intValue];
            
            if(insuranceStatus == 1)
             {
                
                label3.backgroundColor = [UIColor clearColor];
                label3.textColor = [ResourceManager color_1];
                label3.text =  [NSString stringWithFormat:@"      %@",_dicData[@"insuranceMessage"]];
                
                
                UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
                [label3 addSubview:imgLeft];
                imgLeft.image = [UIImage imageNamed:@"task_gou"];
             }
         }
        

     }
    
}



#pragma mark ---  action
-(void) actionTask:(UIButton*) sender
{
    int identityStatus = [_dicData[@"identityStatus"] intValue];
    
    int  iTag = (int)sender.tag;
    if (0 == iTag)
     {
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }

        int  insuranceStatus = [_dicData[@"insuranceStatus"] intValue];
        if (insuranceStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经领取过了" toView:self.view];
            return;
         }
        
        [self actionPop];
        
        
     }

}


-(void) actionPop
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>是否确认领取</font>"]];
    
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    viewTemp.userInteractionEnabled = YES;
    UIImageView *imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [viewTemp addSubview:imgGou];
    imgGou.image = [UIImage imageNamed:@"com_gou_sel"];
    
    UILabel *labelXY = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 185, 30)];
    [viewTemp addSubview:labelXY];
    labelXY.font = [UIFont systemFontOfSize:15];
    labelXY.textColor = [ResourceManager lightGrayColor];
    labelXY.text = @"确定即同意《保险协议》";
    
    
    NSString *strNO = @"《保险协议》";//  @"10501";
    NSString *strAll = @"确定即同意《保险协议》";
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:stringRange];
    labelXY.attributedText = noteString;
    
    
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionHtml)];
    gesture.numberOfTapsRequired  = 1;
    [viewTemp addGestureRecognizer:gesture];
    
    [alertView addView:viewTemp leftX:0];
    
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self comitYWBX];
        
    }];
    
    [alertView addCanelButton:@"再看看" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

-(void) actionHtml
{
    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@pages/agreement_Insurance.html",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"保险协议";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 网络通讯
-(void) getTaskInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGTaskBaseInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) comitYWBX
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGsendInsuranceByTask];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"insuranceFlag"] = @"1";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}




-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (1001 == operation.tag)
     {
        [MBProgressHUD showSuccessWithStatus:@"领取成功" toView:self.view];
        // 在延迟后执行
        [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
     }
    
}


-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
