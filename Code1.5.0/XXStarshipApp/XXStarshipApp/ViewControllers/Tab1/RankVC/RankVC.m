//
//  RankVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/9.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "RankVC.h"

@interface RankVC ()
{
    UIScrollView  *scView;
    UILabel *labelListDes;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    int iListType;
    
    UIView *viewList; //排行榜
    NSArray *arrList;
    NSArray *arrListTGB;
    NSArray *arrListGL;
    
    NSString *abilityRankingMessage;
    NSString *coinRankingMessage;

}
@end

@implementation RankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"天狗排行榜"];
    nav.backdropImg.image = [UIImage imageNamed:@"rk_nav"];
    
    [self layoutUI];
    
    [self getRankGL];
    [self getRankTBG];
}

- (void) layoutUI
{
    int iTopY = NavHeight;
    int iLeftX = 0;
    
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 2000);
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
    
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 160)];
    [self.view addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"rk_bg"];
    
    iTopY += 100;
    UIImageView *imgLane = [[UIImageView alloc] initWithFrame:CGRectMake(60, iTopY, SCREEN_WIDTH - 120, 30)];
    [self.view addSubview:imgLane];
    imgLane.image = [UIImage imageNamed:@"rk_lan"];
    
    labelListDes = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [self.view addSubview:labelListDes];
    labelListDes.font = [UIFont systemFontOfSize:12];
    if (IS_IPHONE_5)
     {
        labelListDes.font = [UIFont systemFontOfSize:11];
     }
    labelListDes.textAlignment= NSTextAlignmentCenter;
    labelListDes.textColor = [UIColor whiteColor];
    labelListDes.text = @"排行榜近七天数据每天00:00更新一次";
    
    
    iTopY = NavHeight + imgBG.height;
    UIView *viewBtnBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 60)];
    [self.view addSubview:viewBtnBG];
    viewBtnBG.backgroundColor = [UIColor whiteColor];
    
    int iBtnWdith = (SCREEN_WIDTH - 90)/2;
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(30, 12, iBtnWdith, 36)];
    [viewBtnBG addSubview:btnLeft];
    btnLeft.backgroundColor = UIColorFromRGB(0x5953ff);
    btnLeft.cornerRadius = btnLeft.height/2;
    [btnLeft setTitle:@"天狗币排行榜" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLeft addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(60 + iBtnWdith, 12, iBtnWdith, 36)];
    [viewBtnBG addSubview:btnRight];
    btnRight.backgroundColor = [ResourceManager lightGrayColor];
    btnRight.cornerRadius = btnRight.height/2;
    [btnRight setTitle:@"狗粮排行榜" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRight addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += viewBtnBG.height - NavHeight;
    viewList = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 600)];
    [scView addSubview:viewList];
    viewList.backgroundColor = [UIColor whiteColor];
    
    
}

-(void) layoutList
{
    [viewList removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    
    UIView *viewBGTilte = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 40)];
    [viewList addSubview:viewBGTilte];
    viewBGTilte.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 40)];
    [viewList addSubview:labelT1];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.textColor = [ResourceManager lightGrayColor];
    labelT1.text = @"名次";
    
    UILabel *labelT1_a = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+50, iTopY, 100, 40)];
    [viewList addSubview:labelT1_a];
    labelT1_a.font = [UIFont systemFontOfSize:14];
    labelT1_a.textColor = [ResourceManager lightGrayColor];
    labelT1_a.text = @"昵称";
    
    
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, iTopY, 100, 40)];
    [viewList addSubview:labelT2];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.textColor = [ResourceManager color_1];
    labelT2.text = @"天狗币";
    if ([PDAPI isTestUser])
     {
        labelT2.text = @"天狗积分";
     }
    
    
    
    iTopY +=labelT1.height;
    int iCellHeight = 60;
    for (int i = 0;  i < [arrList count]; i++)
     {
        NSDictionary *dic = arrList[i];
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelNo = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX +10, 0, 40, iCellHeight)];
        [viewCell addSubview:labelNo];
        NSString *strNo = [NSString stringWithFormat:@"%d", i+1];
        labelNo.textColor = [ResourceManager color_1];
        labelNo.font = [UIFont systemFontOfSize:14];
        labelNo.text = strNo;
        
        
        if (i <= 2)
         {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, 10, 30, 35)];
            [viewCell addSubview:imgView];
            imgView.image = [UIImage imageNamed:@"rk_frist"];
            
            if (i == 1)
             {
                imgView.image = [UIImage imageNamed:@"rk_second"];
             }
            
            if (i == 2)
             {
                imgView.image = [UIImage imageNamed:@"rk_thrid"];
             }
         }
        
        
        UILabel *labelNikeName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50, 0, 100, iCellHeight)];
        [viewCell addSubview:labelNikeName];
        labelNikeName.textColor = [ResourceManager color_1];
        labelNikeName.font = [UIFont systemFontOfSize:14];
        NSString *strName = dic[@"nickName"]? dic[@"nickName"]:@"" ;
        labelNikeName.text = strName;
        
        
        UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1/2+50, 0, SCREEN_WIDTH*1/2 - 50 , iCellHeight)];
        [viewCell addSubview:labelValue];
        labelValue.textColor = [ResourceManager color_1];
        labelValue.font = [UIFont systemFontOfSize:14];
        NSString *strValue = [NSString stringWithFormat:@"%@", dic[@"xjCoinCount"]];
        if (2 == iListType)
         {
            strValue = [NSString stringWithFormat:@"%@", dic[@"abilityValue"]];
         }
        labelValue.text = strValue;
        
        
        //分割线
        UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight -1, SCREEN_WIDTH - iLeftX, 1)];
        [viewCell addSubview:labelFG];
        labelFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellHeight;
     }
    
    viewList.height = iTopY + iCellHeight + 30;
    int iViewHeight = viewList.top + viewList.height;
    if (IS_IPHONE_X_MORE)
     {
        iViewHeight += 30;
     }
    scView.contentSize = CGSizeMake(0, iViewHeight);
    
}

-(void) layoutGLList
{
    [viewList removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    
    UIView *viewBGTilte = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 40)];
    [viewList addSubview:viewBGTilte];
    viewBGTilte.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 40)];
    [viewList addSubview:labelT1];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.textColor = [ResourceManager lightGrayColor];
    labelT1.text = @"名次";
    
    UILabel *labelT1_a = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+50, iTopY, 100, 40)];
    [viewList addSubview:labelT1_a];
    labelT1_a.font = [UIFont systemFontOfSize:14];
    labelT1_a.textColor = [ResourceManager lightGrayColor];
    labelT1_a.text = @"昵称";
    
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 160, iTopY, 100, 40)];
    [viewList addSubview:labelT2];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.textColor = [ResourceManager color_1];
    labelT2.text = @"魔法狗粮";
    
    int iCQGLLeft = iLeftX + 260;
    if (IS_IPHONE_Plus)
     {
        iCQGLLeft  = iLeftX + 280;
     }
    if (IS_IPHONE_5_OR_LESS)
     {
        iCQGLLeft  = iLeftX + 230;
     }
    UILabel *labelT3 = [[UILabel alloc] initWithFrame:CGRectMake(iCQGLLeft, iTopY, 100, 40)];
    [viewList addSubview:labelT3];
    labelT3.font = [UIFont systemFontOfSize:14];
    labelT3.textColor = [ResourceManager color_1];
    labelT3.text = @"长期狗粮";
    
    iTopY +=labelT1.height;
    int iCellHeight = 60;
    for (int i = 0;  i < [arrList count]; i++)
     {
        NSDictionary *dic = arrList[i];
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelNo = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX +10, 0, 40, iCellHeight)];
        [viewCell addSubview:labelNo];
        NSString *strNo = [NSString stringWithFormat:@"%d", i+1];
        labelNo.textColor = [ResourceManager color_1];
        labelNo.font = [UIFont systemFontOfSize:14];
        labelNo.text = strNo;
        
        
        if (i <= 2)
         {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, 10, 30, 35)];
            [viewCell addSubview:imgView];
            imgView.image = [UIImage imageNamed:@"rk_frist"];
            
            if (i == 1)
             {
                imgView.image = [UIImage imageNamed:@"rk_second"];
             }
            
            if (i == 2)
             {
                imgView.image = [UIImage imageNamed:@"rk_thrid"];
             }
         }
        
        
        UILabel *labelNikeName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50, 0, 100, iCellHeight)];
        [viewCell addSubview:labelNikeName];
        labelNikeName.textColor = [ResourceManager color_1];
        labelNikeName.font = [UIFont systemFontOfSize:14];
        NSString *strName = dic[@"nickName"]? dic[@"nickName"]:@"" ;
        labelNikeName.text = strName;
        
        
        UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 160, 0, 100 , iCellHeight)];
        [viewCell addSubview:labelValue];
        labelValue.textColor = [ResourceManager color_1];
        labelValue.font = [UIFont systemFontOfSize:14];
        NSString *strValue = [NSString stringWithFormat:@"%@", dic[@"magicAbilityValue"]];
        labelValue.text = strValue;
        
        UILabel *labelValue2 = [[UILabel alloc] initWithFrame:CGRectMake(iCQGLLeft, 0, 100 , iCellHeight)];
        [viewCell addSubview:labelValue2];
        labelValue2.textColor = [ResourceManager color_1];
        labelValue2.font = [UIFont systemFontOfSize:14];
        strValue = [NSString stringWithFormat:@"%@", dic[@"longAbilityValue"]];
        labelValue2.text = strValue;
        
        
        //分割线
        UILabel *labelFG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight -1, SCREEN_WIDTH - iLeftX, 1)];
        [viewCell addSubview:labelFG];
        labelFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellHeight;
     }
    
    viewList.height = iTopY + iCellHeight + 30;
    int iViewHeight = viewList.top + viewList.height;
    if (IS_IPHONE_X_MORE)
     {
        iViewHeight += 30;
     }
    scView.contentSize = CGSizeMake(0, iViewHeight);
    
}


#pragma mark  ---  action
-(void) actionLeft
{
    iListType = 1;
    btnLeft.backgroundColor = UIColorFromRGB(0x5953ff);
    btnRight.backgroundColor = [ResourceManager lightGrayColor];
    
    arrList = arrListTGB;
    labelListDes.text = coinRankingMessage;
    [self layoutList];
}

-(void) actionRight
{
    iListType = 2;
    btnLeft.backgroundColor = [ResourceManager lightGrayColor];
    btnRight.backgroundColor = UIColorFromRGB(0x5953ff);
    
    arrList = arrListGL;
    labelListDes.text = abilityRankingMessage;
    [self layoutGLList];
}

#pragma mark --- 网络通讯
-(void) getRankTBG
{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGcoinRanking];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}

-(void) getRankGL
{

    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGabilityRanking];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1003;
    [operation start];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1002 == operation.tag)
     {
        // 天狗币排行榜
        arrList = operation.jsonResult.rows;
        if ([arrList count] > 0)
         {
            arrListTGB = arrList;
            iListType = 1;
            [self layoutList];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            coinRankingMessage = dic[@"coinRankingMessage"];
            labelListDes.text = dic[@"coinRankingMessage"];
         }
     }
    else if (1003 == operation.tag)
     {
        // 狗粮排行榜
        arrList = operation.jsonResult.rows;
        if ([arrList count] > 0)
         {
            arrListGL = arrList;
            iListType = 2;
            //[self layoutGLList];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            abilityRankingMessage =  dic[@"abilityRankingMessage"];
         }
        
     }
}

@end
