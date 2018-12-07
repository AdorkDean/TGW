//
//  LockTBGVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/7/10.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "LockTBGVC.h"

@interface LockTBGVC ()
{
    UIScrollView *scView;
    UIView  *viewTail;
    NSArray *arrData;
    
}
@end

@implementation LockTBGVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"解冻记录"];
    
    [self layoutUI];
    
    [self getLockRecord];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500.f);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    
    
    UIImageView *viewHead = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 0, SCREEN_WIDTH+100, 220 * ScaleSize)];
    [scView addSubview:viewHead];
    //viewHead.backgroundColor = UIColorFromRGB(0x96b3c3);
    viewHead.image = [UIImage imageNamed:@"tab1_lock_bg"];
    viewHead.userInteractionEnabled = YES;
    
    int iTopY = 0;
    iTopY = viewHead.height;
    UIView *viewMid =  [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [scView addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];

   
    UILabel *labelRecrod = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    [viewMid addSubview:labelRecrod];
    labelRecrod.textColor = [ResourceManager color_1];
    labelRecrod.font = [UIFont systemFontOfSize:17];
    labelRecrod.textAlignment = NSTextAlignmentLeft;
    labelRecrod.text = @"解冻记录";
    
    iTopY = viewHead.height + viewMid.height;
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 600)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [ResourceManager viewBackgroundColor];
    
}

-(void) dataWithViewTail
{
    int iTopY = 0;
    int iLeftX = 15;
    for (int i = 0; i < [arrData count]; i++)
     {
        NSDictionary *dicTemp = arrData[i];
        
        NSString* strDate = dicTemp[@"date"];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 50)];
        [viewTail addSubview:labelDate];
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
            
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
            viewCell.backgroundColor = [UIColor whiteColor];
            [viewTail addSubview:viewCell];
            
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
            
            
            // 收支类型
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50 + 20 , 0, 200, 50)];
            [viewCell addSubview:label2];
            label2.textColor = [ResourceManager blackGrayColor];
            label2.font = [UIFont systemFontOfSize:14];
            label2.text = dicCell[@"sendStatusStr"];
            
            // 狗粮
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 , 0, 100, 50)];
            [viewCell addSubview:label3];
            label3.textColor =  [ResourceManager mainColor];
            label3.font = [UIFont systemFontOfSize:14];
            label3.text = dicCell[@"abilityValue"];
            
            iTopY += viewCell.height;
         }
     }
    
    viewTail.height = iTopY;
    
    int iTotoalY = viewTail.top + viewTail.height;
    scView.contentSize = CGSizeMake(0, iTotoalY);
}


#pragma mark --- 网络通讯
- (void)getLockRecord
{
    [LoadView showHUDNavAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetThawRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //                                                                                      [LoadView hideAllHUDsForView:self.view animated:YES];
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            arrData = arr;
            [self dataWithViewTail];
         }
        
     }
}




@end
