//
//  TXTGWRecordVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "TXTGWRecordVC.h"

@interface TXTGWRecordVC ()
{
    UIScrollView  *scView;
    
    UIImageView *viewHead;
    
    UILabel *labelLJTX;
    UILabel *labelSYKTX;

    
    UIView *viewTail;
    NSArray *arrData;
}
@end

@implementation TXTGWRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"提现记录"];
    
    [self layoutUI];
    
    [self loadData];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"qb_bg"];
    
    int iTopY  = NavHeight + 25;
    UIView *viewKuang   = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, imgBG.height - 25)];
    [self.view addSubview:viewKuang];
    viewKuang.backgroundColor = [UIColor whiteColor];
    viewKuang.cornerRadius = 8;
    
    iTopY = 20;
    labelSYKTX = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewKuang.width, 20)];
    [viewKuang addSubview:labelSYKTX];
    labelSYKTX.font = [UIFont systemFontOfSize:14];
    labelSYKTX.textColor = [ResourceManager mainColor];
    labelSYKTX.textAlignment = NSTextAlignmentCenter;
    

    labelLJTX = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, viewKuang.width, 20)];
    [viewKuang addSubview:labelLJTX];
    labelLJTX.font = [UIFont systemFontOfSize:13];
    labelLJTX.textColor = [ResourceManager color_1];

    
    
    iTopY += 60;
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, viewKuang.width , viewKuang.height - iTopY)];
    [viewKuang addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500.f);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    //scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewKuang.width, scView.height)];
    [scView addSubview:viewTail];
    //viewTail.backgroundColor = [ResourceManager yellowColor];
}

-(void) dataWithViewTail
{
    [viewTail removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    for (int i = 0; i < [arrData count]; i++)
     {
        NSDictionary *dicTemp = arrData[i];
        
        UIView *viewDateGB = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, viewTail.width, 50)];
        [viewTail addSubview:viewDateGB];
        viewDateGB.backgroundColor = [ResourceManager  viewBackgroundColor];
        
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
            label2.text = dicCell[@"typeName"];
            
            // 天狗币
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 , 0, 100, 50)];
            [viewCell addSubview:label3];
            label3.textColor = [ResourceManager mainColor2];
            label3.font = [UIFont systemFontOfSize:14];
            label3.text = dicCell[@"coinValue"];
            
            
            
            iTopY += viewCell.height;
         }
        
        
     }
    
    viewTail.height = iTopY;
    
    int iTotoalY = viewTail.top + viewTail.height;
    scView.contentSize = CGSizeMake(0, iTotoalY);
    
}

#pragma mark ---  网络请求
-(void) loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],   kDDGwithdrawRecord];


    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    

    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (1000 == operation.tag)
     {
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            arrData = arr;
            [self dataWithViewTail];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            //float  fTemp =  [dic[@"totalTxValue"] floatValue];
            NSString *strTemp = [NSString stringWithFormat:@"累计提现：%@", dic[@"totalTxValue"]];
            labelLJTX.text = strTemp;
            
            // 用户剩余币  useXjCoinCount
            strTemp = [NSString stringWithFormat:@"剩余可提现：%@", dic[@"useXjCoinCount"]];
            labelSYKTX.text = strTemp;
         }
        
     }
    
    
}

@end
