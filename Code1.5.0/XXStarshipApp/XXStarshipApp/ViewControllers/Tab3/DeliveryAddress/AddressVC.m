//
//  AddressVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AddressVC.h"
#import "AddAddressVC.h"
#import "EditAddressVC.h"
#import "SelectCityViewController.h"

@interface AddressVC ()
{
    UIView  *viewBG;
    
    UIScrollView *scList;
    NSArray *arrAddress;
}
@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"收货地址"];
    
    [self layoutUI];
    
    [self getAddressList];
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_haveAppeared)
     {
        [self getAddressList];
     }
}

- (void) layoutUI
{
    //self.view.backgroundColor = [UIColor whiteColor];
    int iLeftX = 15;
    int iTopY = NavHeight;
    
    int iSCViewHeight = SCREEN_HEIGHT - NavHeight - 85;
    viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, iSCViewHeight)];
    [self.view addSubview:viewBG];
    viewBG.backgroundColor = [UIColor whiteColor];
    
    [self layoutNoAddress];
    
    iTopY = SCREEN_HEIGHT - 65;
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:btnAdd];
    btnAdd.backgroundColor = [ResourceManager mainColor];
    btnAdd.cornerRadius = 45/2;
    [btnAdd setTitle:@"+ 添加新地址" forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnAdd addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
}

-(void) layoutNoAddress
{
    [viewBG removeAllSubviews];
    
    UIView  *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 280.f)];
    [viewBG addSubview:viewBackground];
    //viewBackground.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
    imageView.image = [UIImage imageNamed:@"com_noData"];
    [viewBackground addSubview:imageView];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
    lable1.text = @"没有收货地址～";
    lable1.textAlignment =  NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:16];
    lable1.textColor = [ResourceManager color_1];
    [viewBackground addSubview:lable1];
}

-(void) layoutHaveData:(NSArray*) arrData
{
    if (!arrData ||
        [arrData count] <= 0)
     {
        return;
     }
    
    [viewBG removeAllSubviews];
    
    int iTopY =  15;
    int iLeftX = 15;
    
    if (_isSelAddr)
     {
        UILabel *labelNote = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [viewBG addSubview:labelNote];
        labelNote.textColor = [ResourceManager mainColor];
        labelNote.backgroundColor = [ResourceManager viewBackgroundColor];
        labelNote.font = [UIFont systemFontOfSize:15];
        labelNote.text = @"   请点击，选择收货地址。   ";
        
        iTopY += 30;
     }
    
    

    
    NSDictionary *dicDefalut = arrData[0];
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewBG addSubview:labelName];
    if (IS_IPHONE_5_OR_LESS)
     {
        labelName.width = 150;
     }
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = [NSString stringWithFormat:@"收货人：%@", dicDefalut[@"realname"]];
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, iTopY, 100, 20)];
    [viewBG addSubview:labelPhone];
    labelPhone.font = [UIFont systemFontOfSize:15];
    labelPhone.textColor = [ResourceManager color_1];
    labelPhone.text = [NSString stringWithFormat:@"%@", dicDefalut[@"telphone"]];
    //labelPhone.backgroundColor = [UIColor blueColor];
    
    iTopY +=labelPhone.height + 10;
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-55, 40)];
    [viewBG addSubview:labelAddress];
    labelAddress.font = [UIFont systemFontOfSize:13];
    labelAddress.textColor = [ResourceManager lightGrayColor];
    labelAddress.numberOfLines = 0;
    labelAddress.text = [NSString stringWithFormat:@"收货地址：%@%@%@ %@", dicDefalut[@"province"],dicDefalut[@"city"],dicDefalut[@"area"],dicDefalut[@"street"]];
    [labelAddress sizeToFit];
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, iTopY-5, 25, 30)];
    [viewBG addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"ad_ditu"];
    
    // 默认地址的分割线
    iTopY += 50;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [viewBG addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIImageView  *imgFG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    [viewFG addSubview:imgFG];
    imgFG.image = [UIImage imageNamed:@"ad_caitiao"];
    
    UIButton *btnCell = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [viewBG addSubview:btnCell];
    btnCell.tag = 0;
    [btnCell addTarget:self action:@selector(actionCell:) forControlEvents:UIControlEventTouchUpInside];
    
    // 滚动列表
    iTopY +=30;
    scList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, viewBG.height - iTopY)];
    [viewBG addSubview:scList];
    //scList.backgroundColor = [UIColor yellowColor];
    scList.contentSize = CGSizeMake(0, viewBG.height - iTopY);
    scList.pagingEnabled = NO;
    scList.bounces = NO;
    scList.showsVerticalScrollIndicator = FALSE;
    scList.showsHorizontalScrollIndicator = FALSE;
    
    [self layoutList:arrData];

}

-(void) layoutList:(NSArray *) arrList
{
    [scList removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 10;
    int iCellHeight = 85;
    for (int i = 0;  i < [arrList count]; i++)
     {
        NSDictionary *dicDefalut = arrList[i];
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [scList addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UIButton *btnCell = [[UIButton alloc] initWithFrame:viewCell.frame];
        [scList addSubview:btnCell];
        btnCell.tag = i;
        [btnCell addTarget:self action:@selector(actionCell:) forControlEvents:UIControlEventTouchUpInside];
        //btnCell.backgroundColor = [UIColor yellowColor];
        
        int iCellTopY =  15;
        int iCellLeftX = 15;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 150, 20)];
        [viewCell addSubview:labelName];
        if (IS_IPHONE_5_OR_LESS)
         {
            labelName.width = 150;
         }
        labelName.font = [UIFont systemFontOfSize:15];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = [NSString stringWithFormat:@"%@", dicDefalut[@"realname"]];
        
        UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(170, iCellTopY, 100, 20)];
        [viewCell addSubview:labelPhone];
        labelPhone.font = [UIFont systemFontOfSize:15];
        labelPhone.textColor = [ResourceManager color_1];
        labelPhone.text = [NSString stringWithFormat:@"%@", dicDefalut[@"telphone"]];
        //labelPhone.backgroundColor = [UIColor blueColor];
        
        iCellTopY +=labelPhone.height + 10;
        UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH-55, 40)];
        [viewCell addSubview:labelAddress];
        labelAddress.font = [UIFont systemFontOfSize:13];
        labelAddress.textColor = [ResourceManager lightGrayColor];
        labelAddress.numberOfLines = 0;
        labelAddress.text = [NSString stringWithFormat:@"%@%@%@ %@", dicDefalut[@"province"],dicDefalut[@"city"],dicDefalut[@"area"],dicDefalut[@"street"]];
        [labelAddress sizeToFit];
        
        
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, iCellTopY-5, 20, 20)];
        [viewCell addSubview:btnRight];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"com_edit"] forState:UIControlStateNormal];
        btnRight.tag = i;
        [btnRight addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        
        iCellTopY +=labelAddress.height +10;
        if (labelAddress.height <= 20)
         {
            iCellTopY += 20;
         }
        
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY-1, SCREEN_WIDTH, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellTopY;
     }
    
    scList.contentSize = CGSizeMake(0, iTopY+iCellHeight);
}

#pragma mark ---  action
-(void) actionAdd
{
    AddAddressVC *VC = [[AddAddressVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


-(void) actionEdit:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [arrAddress count])
     {
        EditAddressVC *VC = [[EditAddressVC alloc] init];
        VC.dicData = arrAddress[iTag];
        [self.navigationController pushViewController:VC animated:YES];
     }
}



-(void) actionCell:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [arrAddress count])
     {
        NSDictionary *dic = arrAddress[iTag];
        if (_isSelAddr)
         {
            
            if (_selblock)
             {
                [self.navigationController popViewControllerAnimated:YES];
                _selblock(dic);
                
             }
            return;
         }
        
        EditAddressVC *VC = [[EditAddressVC alloc] init];
        VC.dicData = dic;
        [self.navigationController pushViewController:VC animated:YES];
     }
}

#pragma mark  ---  网络通讯
-(void) getAddressList
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryCustAddress];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1000 == operation.tag)
     {
        arrAddress = operation.jsonResult.rows;
        if ([arrAddress count] > 0)
         {
            [self layoutHaveData:arrAddress];
            
         }
        else
         {
            [self layoutNoAddress];
         }
     }
}




@end
