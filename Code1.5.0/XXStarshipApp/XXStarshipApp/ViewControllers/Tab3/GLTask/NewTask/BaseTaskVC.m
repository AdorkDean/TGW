//
//  BaseTaskVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/23.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "BaseTaskVC.h"
#import "AddFriendWebVC.h"
#import "AddFriendVC.h"
#import "SiginDayVC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"

@interface BaseTaskVC ()
{
    UIScrollView  *scView;
    
    UILabel *labelYQHY;
    UILabel *labelSMRZ;
}
@end

@implementation BaseTaskVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"基础任务"];

    [self layoutUI];
    [self setUIHead:_dicData];
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
    lableTitle.text = @"基础任务";
    
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
    
    NSArray *arrImg = @[@"BT_yqhy",@"BT_mrdl",@"BT_smrz"];
    NSArray *arrName = @[@"邀请好友",@"每日登录",@"实名认证"];
    NSArray *arrSubTitle = @[@"+20长期狗粮/人",@"+30长期狗粮",@"+20长期狗粮"];
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
        
        
        if (i == 1)
         {
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [ResourceManager color_1];
            label3.text = [NSString stringWithFormat:@"  +%@长期狗粮",_dicData[@"loginReward"]];//@"  已完成";

            
            UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
            [label3 addSubview:imgLeft];
            imgLeft.image = [UIImage imageNamed:@"task_gou"];
         }
        
        if (0 == i)
         {
            labelYQHY = label3;
            UILabel *labelSMRZ;
         }
        
        if (2 == i)
         {
            labelSMRZ = label3;

         }
     }
    
}

-(void) setUIHead:(NSDictionary*) dicData
{
    int inviteCount = [dicData[@"inviteCount"] intValue];
    if (inviteCount > 0)
     {
        
        
        NSString *strOut = @"     获取长期狗粮";//[NSString stringWithFormat:@"  获取狗粮",inviteCount];
        labelYQHY.text = strOut;//@" 已邀请20好友";
        labelYQHY.textColor = [ResourceManager color_1];
        labelYQHY.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
        [labelYQHY addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
        
        //labelYQHY.width = 100;
        //labelYQHY.left = 10;
     }
    
    
    int identityStatus = [dicData[@"identityStatus"] intValue];
    if(identityStatus == 1)
     {
        labelSMRZ.backgroundColor = [UIColor clearColor];
        labelSMRZ.textColor = [ResourceManager color_1];
        NSString *strRZ = [NSString stringWithFormat:@"     +%@长期狗粮",dicData[@"identityReward"]];
        labelSMRZ.text = strRZ;//@"  已认证";
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
        [labelSMRZ addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"task_gou"];
        
        //labelSMRZ.width = 100;
        //labelSMRZ.left = 5;
     }
}

#pragma mark ---  action
-(void) actionTask:(UIButton*) sender
{
    int  iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 邀请好友
        AddFriendVC *VC = [[AddFriendVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
        
     }
    else if (1 == iTag)
     {
        // 签到日历
        SiginDayVC *vc = [[SiginDayVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
     }
    else if (2 == iTag)
     {
        int identityStatus = [_dicData[@"identityStatus"] intValue];
        
        // 认证
        if(identityStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"您已经通过认证 " toView:self.view];
            return;
         }
        
        
        
        
        
        if (identityStatus == 0 ||
            identityStatus == 1 ||
            identityStatus == 2) {
            ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
            [self.navigationController pushViewController: ctl animated:YES];
        }else{
            ApproveViewController *ctl = [[ApproveViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        
     }
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


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (1000 == operation.tag)
     {
//        dicData = operation.jsonResult.attr;
//        if ([dicData count] > 0)
//         {
//            [self layoutUI];
//            [self setUIHead:dicData];
//         }
     }
    
}

@end
