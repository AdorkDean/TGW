//
//  FristFriendVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/13.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "FristFriendVC.h"

@interface FristFriendVC ()
{
    UIScrollView *scView;
    
    UIView *fristLevelView;
    NSArray *arrFrist;
    
}
@end

@implementation FristFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomNavigationBarView *nav=  [self layoutNaviBarViewWithTitle:@"一级好友"];
    nav.backdropImg.image = [UIImage imageNamed:@"task_addfriend_head2"];
    
    [self layoutUI];
    
    [self getInviteHistory];
}

#pragma mark  ---   布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iTopY = NavHeight;
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1100);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90*ScaleSize)];
    [scView  addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"task_addfriend_bg2"];
    
    // 创建一级好友view
    iTopY = 60;
    int iLeftX = 15;
    
    fristLevelView = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 170)];
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
    
    [self layoutFristLevelView:nil];
    
}

-(void) layoutFristLevelView:(NSArray*) arrData
{
    [fristLevelView removeAllSubviews];
    
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
    
    if (!arrData ||
        [arrData count] <= 0)
     {
        
        UILabel *labelNoData =  [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWdith, 100)];
        [fristLevelView addSubview:labelNoData];
        labelNoData.font = [UIFont systemFontOfSize:26];
        labelNoData.textColor = [ResourceManager color_1];
        labelNoData.text = @"暂无数据";
        labelNoData.textAlignment = NSTextAlignmentCenter;
        
        return;
     }
    
    iTopY += 1;
    iLeftX = 15;
    int iWidth = fristLevelView.width;
    int iArrCount = (int)[arrData count];
    int iNO = 0;
    
    for (iNO = 0; iNO < iArrCount; iNO++)
     {
        
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
    
    
    fristLevelView.height = iTopY  + 30;
    
    scView.contentSize = CGSizeMake(0, fristLevelView.height + fristLevelView.top + 20);
    
    
}

#pragma mark --- 网络通讯
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



-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1001 == operation.tag)
     {
        arrFrist = operation.jsonResult.rows;
        [self layoutFristLevelView:arrFrist];
        
        
     }

}



@end
