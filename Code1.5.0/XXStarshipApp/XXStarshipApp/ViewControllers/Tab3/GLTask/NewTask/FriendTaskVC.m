//
//  FriendTaskVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/23.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "FriendTaskVC.h"
#import "AttentionWechatVC.h"
#import "JoinGruopVC.h"

@interface FriendTaskVC ()
{
    UIScrollView  *scView;
    
    UILabel *labelYQHY;
    UILabel *labelSMRZ;
    
    
    int identityStatus;  // 1 表示实名认证
    int followWxStatus;  // 1 表示关注微信号成功
    int joinWxQunStatus; // 1 表示加入群聊成功
    int joinQqQunStatus; // 1 表示加入QQ群成功
    int joinByQunStatus;
}
@end

@implementation FriendTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"交友任务"];
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
    lableTitle.text = @"交友任务";
    
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
    
    
    NSString *strGZGZH = [NSString stringWithFormat:@"+%@长期狗粮",_dicData[@"fllowWxReward"]];
    NSString *strBYQ = [NSString stringWithFormat:@"+%@长期狗粮",_dicData[@"joinWxQunReward"]];
    NSString *strQQ = [NSString stringWithFormat:@"+%@长期狗粮",_dicData[@"joinQqQunReward"]];
    NSString *strWX = [NSString stringWithFormat:@"+%@长期狗粮",_dicData[@"joinByQunReward"]];
    
    NSArray *arrImg = @[@"BT_gzgzh",@"BT_jrbyq",@"BT_jrqq",@"BT_jrwxq"];
    NSArray *arrName = @[@"关注公众号",@"加入币用群",@"加入QQ群",@"加入微信群"];
    NSArray *arrSubTitle = @[strGZGZH,strBYQ,strQQ,strWX];
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
            // 1 表示关注微信号成功
            followWxStatus = [_dicData[@"followWxStatus"] intValue];
            if(followWxStatus == 1)
             {

                label3.backgroundColor = [UIColor clearColor];
                label3.textColor = [ResourceManager color_1];
                label3.text = [NSString stringWithFormat:@"   +%@长期狗粮",_dicData[@"fllowWxReward"]];
                
                
                UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
                [label3 addSubview:imgLeft];
                imgLeft.image = [UIImage imageNamed:@"task_gou"];
             }
         }
        
        if (i == 1)
         {
            joinByQunStatus = [_dicData[@"joinByQunStatus"] intValue];
            if(joinByQunStatus == 1)
             {

                label3.backgroundColor = [UIColor clearColor];
                label3.textColor = [ResourceManager color_1];
                label3.text = [NSString stringWithFormat:@"   +%@长期狗粮",_dicData[@"joinByQunReward"]];
                
                UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
                [label3 addSubview:imgLeft];
                imgLeft.image = [UIImage imageNamed:@"task_gou"];
             }
         }
        
        if (2 == i)
         {
            joinQqQunStatus = [_dicData[@"joinQqQunStatus"] intValue];
            if(joinQqQunStatus == 1)
             {

                label3.backgroundColor = [UIColor clearColor];
                label3.textColor = [ResourceManager color_1];
                label3.text = [NSString stringWithFormat:@"   +%@长期狗粮",_dicData[@"joinWxQunReward"]];//@"  已完成";
                
                
                UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
                [label3 addSubview:imgLeft];
                imgLeft.image = [UIImage imageNamed:@"task_gou"];
             }
            
         }
        
        if (3 == i)
         {
            joinWxQunStatus = [_dicData[@"joinWxQunStatus"] intValue];
            if(joinWxQunStatus == 1)
             {
                
                label3.backgroundColor = [UIColor clearColor];
                label3.textColor = [ResourceManager color_1];
                label3.text = [NSString stringWithFormat:@"   +%@长期狗粮",_dicData[@"joinQqQunReward"]];//@"  已完成";
                
                
                UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 20, 20)];
                [label3 addSubview:imgLeft];
                imgLeft.image = [UIImage imageNamed:@"task_gou"];
             }
            
         }
     }
    
}

-(void) setUIHead:(NSDictionary*) dicData
{
    
}

#pragma mark ---  action
-(void) actionTask:(UIButton*) sender
{
    int identityStatus = [_dicData[@"identityStatus"] intValue];
    
    int  iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 关注公众号
        if (followWxStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经关注过了" toView:self.view];
            return;
         }
        // 关注微信公众号
        AttentionWechatVC *VC = [[AttentionWechatVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
        
     }
    else if (1 == iTag)
     {
        // 币用群
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        if (joinByQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 2;
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (2 == iTag)
     {
        // QQ群
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        if (joinQqQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 1;
        [self.navigationController pushViewController:VC animated:YES];
        
     }
    else if (3 == iTag)
     {
        // 微信群
        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }
        
        if (joinWxQunStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"已经加入过了" toView:self.view];
            return;
         }
        
        // 加入群聊
        JoinGruopVC *VC = [[JoinGruopVC alloc] init];
        VC.joinType = 0;
        [self.navigationController pushViewController:VC animated:YES];
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
