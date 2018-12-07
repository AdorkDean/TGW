//
//  AddFriendFristVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/29.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AddFriendFristVC.h"
#import "AddFriendVC.h"
#import "FristFriendVC.h"
#import "SecondFriendVC.h"

@interface AddFriendFristVC ()
{
    UIScrollView *scView;
    
    NSDictionary *dicHead;
    
    UIView *fristLevelView;
    UILabel *labelFirst2;
    UILabel *labelFirstGL2;
    int iFirstListTopY;
    int iFirstStretchTopY;   // 扩张时的高度
    int iFirstShrinkTopY;    // 收缩时的高度
    UIButton *btnFrist; // 一级目录的伸缩按钮
    UIImageView *imgBtnFrist;  // 一级目录的按钮的图片
    UILabel  *labelBtnFristFG;  // 一级目录的按钮的分割线
    BOOL  isFisrtShrink;  // 一级目录是否收缩
    
    NSArray *arrFrist;

    BOOL isSecondShow; // 二级目录是否已经显示
    UIView *secondLevelView;
    UILabel *labelSecond2;
    UILabel *labelSecondGL2;
    int iSecondListTopY;
    int iSecondStretchTopY;   // 扩张时的高度
    int iSecondShrinkTopY;    // 收缩时的高度
    UIButton *btnSecond; // 二级目录的伸缩按钮
    UIImageView *imgSecond;  // 二级目录的按钮的图片
    UILabel  *labelBtnSecondFG;  // 二级目录的按钮的分割线
    BOOL  isSecondShrink;  // 二级目录是否收缩
    
    NSArray *arrSecond;
}
@end

@implementation AddFriendFristVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav=  [self layoutNaviBarViewWithTitle:@"邀请好友"];
    nav.backdropImg.image = [UIImage imageNamed:@"task_addfriend_frist_head"];
    
    [self layoutUI];
    
    //网络通讯
    [self getShareCount];
    [self getInviteHistory];
    //[self getSecondInviteHistory];
}

-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1100);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    
    //UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700 * ScaleSize)];
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 600*ScaleSize)];
    [scView  addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"task_addfriend_frist_bg"];
    
    // 创建一级好友view
    int iTopY= viewBG.height + 30;
    int iLeftX = 15;

    fristLevelView = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 100)];
    [scView addSubview:fristLevelView];
    fristLevelView.backgroundColor = [UIColor whiteColor];
    
    //设置阴影的颜色
    fristLevelView.layer.shadowColor =  [ResourceManager mainColor].CGColor;
    //设置阴影的偏移量，如果为正数，则代表为往右边偏移
    fristLevelView.layer.shadowOffset = CGSizeMake(0, 0);
    //设置阴影的透明度(0~1之间，0表示完全透明)
    fristLevelView.layer.shadowOpacity = 0.5;//0.2;
    fristLevelView.layer.shadowRadius = 5;
    fristLevelView.cornerRadius = 5;
    
    [self layoutFristLevelView];
    isFisrtShrink = YES;
    
    // 创建二级好友view
    iTopY += fristLevelView.height + 30;
    iLeftX = 15;

    secondLevelView = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 500)];
    [scView addSubview:secondLevelView];
    secondLevelView.backgroundColor = [UIColor clearColor];
    secondLevelView.backgroundColor = [UIColor whiteColor];
    //设置阴影的颜色
    secondLevelView.layer.shadowColor = [ResourceManager mainColor].CGColor;
    //设置阴影的偏移量，如果为正数，则代表为往右边偏移
    secondLevelView.layer.shadowOffset = CGSizeMake(0, 0);
    //设置阴影的透明度(0~1之间，0表示完全透明)
    secondLevelView.layer.shadowOpacity= 0.2;
    secondLevelView.layer.shadowRadius = 5;
    secondLevelView.cornerRadius = 5;

    [self laoutSecendLevelView];
    isSecondShrink = YES;
    
    

    iTopY= SCREEN_HEIGHT - 50;
    
    UIButton *btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnQuit];
    btnQuit.backgroundColor = [ResourceManager mainColor];
    [btnQuit setTitle:@"立即邀请" forState:UIControlStateNormal];
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:16];
    btnQuit.cornerRadius = 20;
    [btnQuit addTarget:self  action:@selector(actionYQ) forControlEvents:UIControlEventTouchUpInside];
}

-(void) layoutFristLevelView
{
    int iTopY = 15;
    int iLeftX = 15;
    int iWdith = fristLevelView.width;
    UIColor *colorFG = UIColorFromRGB(0xe5e5e5);
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [fristLevelView addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:17];
    lable1.textColor = [ResourceManager color_1];
    lable1.text = @"一级好友记录";
    
    iTopY += lable1.height  + 15;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 0.5)];
    [fristLevelView addSubview:viewFG];
    viewFG.backgroundColor = colorFG;
    
    iTopY +=  15;
    UILabel *labelFirst1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [fristLevelView addSubview:labelFirst1];
    labelFirst1.font = [UIFont systemFontOfSize:15];
    labelFirst1.textColor = [ResourceManager mainColor];
    labelFirst1.text = @"一级好友";
    
    labelFirst2 = [[UILabel alloc] initWithFrame:CGRectMake(iWdith - 120, iTopY, 100, 20)];
    [fristLevelView addSubview:labelFirst2];
    labelFirst2.font = [UIFont systemFontOfSize:15];
    labelFirst2.textColor = [ResourceManager mainColor];
    labelFirst2.text = @"0";
    labelFirst2.textAlignment = NSTextAlignmentRight;
    
    iTopY += labelFirst1.height  + 15;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 0.5)];
    [fristLevelView addSubview:viewFG1];
    viewFG1.backgroundColor = colorFG;
    
    iTopY +=  15;
    UILabel *labelFirstGL1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [fristLevelView addSubview:labelFirstGL1];
    labelFirstGL1.font = [UIFont systemFontOfSize:15];
    labelFirstGL1.textColor = [ResourceManager mainColor];
    labelFirstGL1.text = @"狗粮";
    
    labelFirstGL2 = [[UILabel alloc] initWithFrame:CGRectMake(iWdith - 120, iTopY, 100, 20)];
    [fristLevelView addSubview:labelFirstGL2];
    labelFirstGL2.font = [UIFont systemFontOfSize:15];
    labelFirstGL2.textColor = [ResourceManager mainColor];
    labelFirstGL2.text = @"0";
    labelFirstGL2.textAlignment = NSTextAlignmentRight;
    
    iTopY += labelFirstGL2.height + 15 ;
    iFirstListTopY = iTopY;
    fristLevelView.height = iTopY;
    
    [self setUIData:dicHead];

}

-(void) laoutSecendLevelView
{
    int iTopY = 15;
    int iLeftX = 15;
    int iWdith = secondLevelView.width;
    UIColor *colorFG = UIColorFromRGB(0xe5e5e5);
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [secondLevelView addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:17];
    lable1.textColor = [ResourceManager color_1];
    lable1.text = @"二级好友记录";
    
    iTopY += lable1.height  + 15;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 0.5)];
    [secondLevelView addSubview:viewFG];
    viewFG.backgroundColor = colorFG;
    
    iTopY +=  15;
    UILabel *labelSecond1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [secondLevelView addSubview:labelSecond1];
    labelSecond1.font = [UIFont systemFontOfSize:15];
    labelSecond1.textColor = [ResourceManager mainColor];
    labelSecond1.text = @"二级好友";
    
    labelSecond2 = [[UILabel alloc] initWithFrame:CGRectMake(iWdith - 120, iTopY, 100, 20)];
    [secondLevelView addSubview:labelSecond2];
    labelSecond2.font = [UIFont systemFontOfSize:15];
    labelSecond2.textColor = [ResourceManager mainColor];
    labelSecond2.text = @"0";
    labelSecond2.textAlignment = NSTextAlignmentRight;
    
    iTopY += labelSecond2.height  + 15;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 0.5)];
    [secondLevelView addSubview:viewFG1];
    viewFG1.backgroundColor = colorFG;
    
    iTopY +=  15;
    UILabel *labelSecondGL1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [secondLevelView addSubview:labelSecondGL1];
    labelSecondGL1.font = [UIFont systemFontOfSize:15];
    labelSecondGL1.textColor = [ResourceManager mainColor];
    labelSecondGL1.text = @"狗粮";
    
    labelSecondGL2 = [[UILabel alloc] initWithFrame:CGRectMake(iWdith - 120, iTopY, 100, 20)];
    [secondLevelView addSubview:labelSecondGL2];
    labelSecondGL2.font = [UIFont systemFontOfSize:15];
    labelSecondGL2.textColor = [ResourceManager mainColor];
    labelSecondGL2.text = @"0";
    labelSecondGL2.textAlignment = NSTextAlignmentRight;
    
    iTopY += labelSecondGL2.height + 15;
    iSecondListTopY = iTopY;
    secondLevelView.height = iTopY;
    
    [self setUIData:dicHead];

}




-(void) setUIData:(NSDictionary*) dicData
{
    if (!dicData &&
        [dicData count] == 0)
     {
        return;
     }
//    inviteCount = 2;
//    inviteReward = 20;
//    secondInviteCount = 1;
//    secondInviteReward = 5;
    labelFirst2.text = [NSString stringWithFormat:@"%@", dicData[@"inviteCount"]];
    labelFirstGL2.text = [NSString stringWithFormat:@"%@", dicData[@"inviteReward"]];
    
    labelSecond2.text = [NSString stringWithFormat:@"%@", dicData[@"secondInviteCount"]];
    labelSecondGL2.text = [NSString stringWithFormat:@"%@", dicData[@"secondInviteReward"]];
    
}

-(void) dataWithFristViewTail:(NSArray*) arrData
{
    [fristLevelView removeAllSubviews];
    [self layoutFristLevelView];
    
    int iTopY = iFirstListTopY;
    int iLeftX = 15;
    int iWidth = fristLevelView.width;
    int iArrCount = (int)[arrData count];
    int iNO = 0;
    for (iNO = 0; iNO < iArrCount; iNO++)
     {
        
        if(isFisrtShrink)
         {
            
            iFirstShrinkTopY = iTopY; //收缩时的高度
            break;
         }
        
        NSDictionary *dicTemp = arrData[iNO];
        NSString* strDate = dicTemp[@"date"];
        
        UIView *viewDateBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 50)];
        [fristLevelView addSubview:viewDateBG];
        viewDateBG.backgroundColor = [ResourceManager viewBackgroundColor];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 50)];
        [fristLevelView addSubview:labelDate];
        labelDate.textColor = [ResourceManager blackGrayColor];
        labelDate.font = [UIFont systemFontOfSize:14];
        labelDate.text = strDate;
        
        iTopY += labelDate.height;
        
        NSArray *arrCell = dicTemp[@"row"];
        if (!arrCell)
         {
            continue;
         }
        

        
        for (int i = 0; i < [arrCell count]; i++)
         {
            NSDictionary *dicCell = arrCell[i];
            if (!dicCell)
             {
                continue;
             }
            
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 50)];
            viewCell.backgroundColor = [UIColor whiteColor];
            [fristLevelView addSubview:viewCell];
            
            // 时间
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 50, 50)];
            [viewCell addSubview:label1];
            label1.textColor = [ResourceManager blackGrayColor];
            label1.font = [UIFont systemFontOfSize:14];
            label1.text = dicCell[@"createTime"];
            
            // 分割线
            UILabel *labFG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 50 + 4.5 , 0, 1, 50)];
            [viewCell addSubview:labFG];
            labFG.backgroundColor = UIColorFromRGB(0xe5e5e5);//[ResourceManager color_5];
            
            // 小圆圈
            UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + 50, 20, 10, 10)];
            [viewCell addSubview:viewYuan];
            viewYuan.backgroundColor =  UIColorFromRGB(0xe5e5e5);
            viewYuan.layer.cornerRadius = 5;
            viewYuan.layer.masksToBounds = YES;
            
            
            // 账号
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50 + 20 , 0, 200, 50)];
            [viewCell addSubview:label2];
            label2.textColor = [ResourceManager blackGrayColor];
            label2.font = [UIFont systemFontOfSize:14];
            label2.text = [NSString stringWithFormat:@"%@%@",dicCell[@"telephone"],dicCell[@"typeDesc"]];
                           
            // 狗粮
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iWidth - 100 , 0, 85, 50)];
            [viewCell addSubview:label3];
            label3.textColor =  [ResourceManager mainColor];
            label3.font = [UIFont systemFontOfSize:14];
            label3.textAlignment = NSTextAlignmentRight;
            label3.text = [NSString stringWithFormat:@"+%@", dicCell[@"inviteReward"]];
            
            iTopY += viewCell.height;
         }
        

     }
    
    

    
    
    if(iArrCount > 0 )
     {
        iFirstStretchTopY = iTopY; // 扩张时的高度
        
        btnFrist = [[UIButton alloc] initWithFrame:CGRectMake(0, iFirstShrinkTopY, iWidth, 50)];
        [fristLevelView addSubview:btnFrist];
        btnFrist.backgroundColor = [UIColor whiteColor];
        [btnFrist addTarget:self action:@selector(actionFirist) forControlEvents:UIControlEventTouchUpInside];
        
        labelBtnFristFG = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iWidth, 1)];
        [btnFrist addSubview:labelBtnFristFG];
        labelBtnFristFG.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        imgBtnFrist = [[UIImageView alloc] initWithFrame:CGRectMake((iWidth - 19)/2, (50 - 17)/2, 19, 17)];
        [btnFrist addSubview:imgBtnFrist];
        imgBtnFrist.image = [UIImage imageNamed:@"arrow_down1"];
        
        fristLevelView.height = iFirstShrinkTopY + 50;
        
        
        secondLevelView.top = fristLevelView.top + fristLevelView.height + 30;
     }
    else
     {
        
        fristLevelView.height = iTopY;
        
        secondLevelView.top = fristLevelView.top + fristLevelView.height + 30;
     }
    
    if (!isSecondShow)
     {
        [self getSecondInviteHistory];
        isSecondShow = YES;
     }
    
}

-(void) dataWithSecondViewTail:(NSArray*) arrData
{
    [secondLevelView removeAllSubviews];
    [self laoutSecendLevelView];
    
    int iTopY = iSecondListTopY;
    int iLeftX = 15;
    int iWidth = secondLevelView.width;
    int iArrCount = (int)[arrData count];
    int iNO = 0;
    for (iNO = 0; iNO < iArrCount; iNO++)
     {
        
        if(isSecondShrink)
         {
            iSecondShrinkTopY = iTopY; //收缩时的高度
            break;
         }
        
        NSDictionary *dicTemp = arrData[iNO];
        NSString* strDate = dicTemp[@"date"];
        
        UIView *viewDateBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 50)];
        [secondLevelView addSubview:viewDateBG];
        viewDateBG.backgroundColor = [ResourceManager viewBackgroundColor];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 50)];
        [secondLevelView addSubview:labelDate];
        labelDate.textColor = [ResourceManager blackGrayColor];
        labelDate.font = [UIFont systemFontOfSize:14];
        labelDate.text = strDate;
        
        iTopY += labelDate.height;
        
        NSArray *arrCell = dicTemp[@"row"];
        if (!arrCell)
         {
            continue;
         }
        
        for (int i = 0; i < [arrCell count]; i++)
         {
            NSDictionary *dicCell = arrCell[i];
            if (!dicCell)
             {
                continue;
             }
            
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 50)];
            viewCell.backgroundColor = [UIColor whiteColor];
            [secondLevelView addSubview:viewCell];
            
            // 时间
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 50, 50)];
            [viewCell addSubview:label1];
            label1.textColor = [ResourceManager blackGrayColor];
            label1.font = [UIFont systemFontOfSize:14];
            label1.text = dicCell[@"createTime"];
            
            // 分割线
            UILabel *labFG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 50 + 4.5 , 0, 1, 50)];
            [viewCell addSubview:labFG];
            labFG.backgroundColor = UIColorFromRGB(0xe5e5e5);//[ResourceManager color_5];
            
            // 小圆圈
            UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + 50, 20, 10, 10)];
            [viewCell addSubview:viewYuan];
            viewYuan.backgroundColor =  UIColorFromRGB(0xe5e5e5);
            viewYuan.layer.cornerRadius = 5;
            viewYuan.layer.masksToBounds = YES;
            
            
            // 账号
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50 + 20 , 0, 200, 50)];
            [viewCell addSubview:label2];
            label2.textColor = [ResourceManager blackGrayColor];
            label2.font = [UIFont systemFontOfSize:14];
            label2.text = [NSString stringWithFormat:@"%@%@",dicCell[@"telephone"],dicCell[@"typeDesc"]];;
            
            // 狗粮
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iWidth - 100 , 0, 85, 50)];
            [viewCell addSubview:label3];
            label3.textColor =  [ResourceManager mainColor];
            label3.font = [UIFont systemFontOfSize:14];
            label3.textAlignment = NSTextAlignmentRight;
            label3.text =  [NSString stringWithFormat:@"+%@",dicCell[@"parendInviteReward"]];
            
            
            iTopY += viewCell.height;
         }
        

     }
    
    
    if(iArrCount > 0 )
     {
        iSecondStretchTopY = iTopY; // 扩张时的高度
        
        btnSecond = [[UIButton alloc] initWithFrame:CGRectMake(0, iSecondShrinkTopY, iWidth, 50)];
        [secondLevelView addSubview:btnSecond];
        btnSecond.backgroundColor = [UIColor whiteColor];
        [btnSecond addTarget:self action:@selector(actionSecond) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        labelBtnSecondFG = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iWidth, 1)];
        [btnSecond addSubview:labelBtnSecondFG];
        labelBtnSecondFG.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        imgSecond = [[UIImageView alloc] initWithFrame:CGRectMake((iWidth - 19)/2, (50 - 17)/2, 19, 17)];
        [btnSecond addSubview:imgSecond];
        imgSecond.image = [UIImage imageNamed:@"arrow_down1"];
        
        secondLevelView.height = iSecondStretchTopY + 50;
        

     }
    else
     {
        
        secondLevelView.height = iTopY;
        
        //secondLevelView.top = fristLevelView.top + fristLevelView.height + 30;
     }
    
    //secondLevelView.height = iTopY;
    

    
    int iTotoalY = secondLevelView.top + secondLevelView.height +10;
    scView.contentSize = CGSizeMake(0, iTotoalY);
    
}


#pragma mark ---  action
-(void) actionYQ
{
    AddFriendVC *VC = [[AddFriendVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    //FristFriendVC *VC = [[FristFriendVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
    
    //SecondFriendVC *VC = [[SecondFriendVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
    
}

-(void) actionFirist
{
    isFisrtShrink = !isFisrtShrink;
    if (isFisrtShrink)
     {
        
        [self dataWithFristViewTail:arrFrist];
        
        imgBtnFrist.image = [UIImage imageNamed:@"arrow_down1"];
        labelBtnFristFG.hidden = NO;

        fristLevelView.height = iFirstShrinkTopY  + 50;
        btnFrist.top = iFirstShrinkTopY;
        

        secondLevelView.top = fristLevelView.top + fristLevelView.height + 30;
        
        
     }
    else
     {
        
        [self dataWithFristViewTail:arrFrist];
        
        imgBtnFrist.image = [UIImage imageNamed:@"arrow_up1"];
        labelBtnFristFG.hidden = YES;

        fristLevelView.height = iFirstStretchTopY + 50;
        btnFrist.top = iFirstStretchTopY;
        
        secondLevelView.top = fristLevelView.top + fristLevelView.height + 30;
        
        
     }
    
    int iTotoalY = secondLevelView.top + secondLevelView.height +10;
    scView.contentSize = CGSizeMake(0, iTotoalY);
}

-(void) actionSecond
{
    isSecondShrink = !isSecondShrink;
    if (isSecondShrink)
     {
        [self dataWithSecondViewTail:arrSecond];
        
        imgSecond.image = [UIImage imageNamed:@"arrow_down1"];
        labelBtnSecondFG.hidden = NO;
        btnSecond.top = iSecondShrinkTopY;
        
//        secondLevelView.height = iSecondShrinkTopY  + 50;

     
     }
    else
     {
        [self dataWithSecondViewTail:arrSecond];
        
        imgSecond.image = [UIImage imageNamed:@"arrow_up1"];
        labelBtnSecondFG.hidden = YES;
        btnSecond.top = iSecondStretchTopY;
     }
}

#pragma mark --- 网络通讯
-(void) getShareCount
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetInviteCount];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void) getInviteHistory
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetInviteHistory];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void) getSecondInviteHistory
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSecondInviteHistory];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1000 == operation.tag)
     {
        dicHead = operation.jsonResult.attr;
        if ([dicHead count] > 0)
         {
            [self setUIData:dicHead];
            
         }
     }
    else if (1001 == operation.tag)
     {
        arrFrist = operation.jsonResult.rows;
        [self dataWithFristViewTail:arrFrist];
            
        
     }
    else if (1002 == operation.tag)
     {
        arrSecond = operation.jsonResult.rows;
        [self dataWithSecondViewTail:arrSecond];
        
     }
}


@end
