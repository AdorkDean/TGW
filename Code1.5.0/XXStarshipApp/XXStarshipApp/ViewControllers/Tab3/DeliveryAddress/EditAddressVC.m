//
//  EditAddressVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/13.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "EditAddressVC.h"
#import "SelectCityViewController.h"

@interface EditAddressVC ()
{
    UIScrollView  *scView;
    UITextField  *fieldName;
    UITextField  *fieldPhone;
    UILabel      *labelCity;
    UITextField  *fieldAddress;
    
    NSString *strProvince;
    NSString *strCity;
    NSString *strArea;
    
    UIButton  *btnSetDefalut;
    int   isDefaultAddress; // 是否默认地址   1 - 是
}
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"编辑地址"];
    
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


-(void) viewWillAppear:(BOOL)animated
{
    //barStyle = UIStatusBarStyleDefault;
    //[[UIApplication sharedApplication] setStatusBarStyle:barStyle];
}

#pragma mark  ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    int iTopY = NavHeight;
    int iLeftX = 15;
    int iCellWidth = SCREEN_WIDTH - 2*iLeftX;
    int iCellHeight = 65;
    // 姓名
    fieldName = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iCellWidth, iCellHeight)];
    [self.view addSubview:fieldName];
    fieldName.font = [UIFont systemFontOfSize:15];
    fieldName.textColor = [ResourceManager color_1];
    fieldName.placeholder = @"请输入收货人姓名";
    fieldName.text = _dicData[@"realname"];
    
    iTopY +=iCellHeight;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, iCellWidth, 1)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 手机号
    fieldPhone = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iCellWidth, iCellHeight)];
    [self.view addSubview:fieldPhone];
    fieldPhone.font = [UIFont systemFontOfSize:15];
    fieldPhone.textColor = [ResourceManager color_1];
    fieldPhone.placeholder = @"请输入收货人手机号码";
    fieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    fieldPhone.text = _dicData[@"telphone"];
    
    iTopY +=iCellHeight;
    viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, iCellWidth, 1)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 城市区域
    labelCity = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iCellWidth, iCellHeight)];
    [self.view addSubview:labelCity];
    labelCity.font = [UIFont systemFontOfSize:15];
    labelCity.textColor = [ResourceManager lightGrayColor];
    labelCity.text = @"请选择所在地区";
    if (_dicData[@"province"])
     {
        strProvince = [_dicData objectForKey:@"province"];
        strCity = [_dicData objectForKey:@"city"];
        strArea = [_dicData objectForKey:@"area"];
        labelCity.text = [NSString stringWithFormat:@"%@-%@-%@",[_dicData objectForKey:@"province"],[_dicData objectForKey:@"city"],[_dicData objectForKey:@"area"]];
        labelCity.textColor = [ResourceManager color_1];
     }
    
    //添加手势
    labelCity.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCity)];
    gesture.numberOfTapsRequired  = 1;
    [labelCity addGestureRecognizer:gesture];
    
    iTopY +=iCellHeight;
    viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, iCellWidth, 1)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 详细地址
    fieldAddress = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iCellWidth, iCellHeight)];
    [self.view addSubview:fieldAddress];
    fieldAddress.font = [UIFont systemFontOfSize:15];
    fieldAddress.textColor = [ResourceManager color_1];
    fieldAddress.placeholder = @"请输入详细地址：如道路、门牌号、小区等";
    fieldAddress.text = _dicData[@"street"];
    
    iTopY +=iCellHeight;
    viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, iCellWidth, 1)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    iTopY +=  15;
    btnSetDefalut = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 130, 30)];
    [self.view addSubview:btnSetDefalut];
    [btnSetDefalut setTitle:@"  设为默认地址" forState:UIControlStateNormal];
    [btnSetDefalut setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    btnSetDefalut.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSetDefalut setImage:[UIImage imageNamed:@"com_gou_unsel"] forState:UIControlStateNormal];
    //btnSetDefalut.backgroundColor = [UIColor yellowColor];
    isDefaultAddress = [_dicData[@"isDefaultAddress"] intValue];
    if (1 == isDefaultAddress)
     {
        [btnSetDefalut setImage:[UIImage imageNamed:@"com_gou_sel"] forState:UIControlStateNormal];
     }
    [btnSetDefalut addTarget:self action:@selector(actionDefalut) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDel = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iTopY, 90, 30)];
    [self.view addSubview:btnDel];
    [btnDel setTitle:@"删掉地址" forState:UIControlStateNormal];
    [btnDel setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnDel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnDel addTarget:self action:@selector(actionDel) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    iTopY = SCREEN_HEIGHT - 65;
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [self.view addSubview:btnAdd];
    btnAdd.backgroundColor = [ResourceManager mainColor];
    btnAdd.cornerRadius = 45/2;
    [btnAdd setTitle:@"保存地址" forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnAdd addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma  mark ---  action
//选择城市区域
-(void)selectCity{
    [self.view endEditing:YES];
    
    //选择城市区域
    SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
    ctl.rootVC = self;
    //选择区域
    ctl.area = YES;
    ctl.block = ^(id city){
        NSDictionary * dic = city;
        
        strProvince = [dic objectForKey:@"province"];
        strCity = [dic objectForKey:@"areaName"];
        strArea = [dic objectForKey:@"area"];
        labelCity.text = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
        labelCity.textColor = [ResourceManager color_1];
    };
    [self.navigationController pushViewController:ctl animated:YES];
    
}

-(void) actionSave
{
    if (fieldName.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入收货人姓名" toView:self.view];
        return;
     }
    if (fieldPhone.text.length <= 0||
        ![fieldPhone.text isMobileNumber] )
     {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的收货人手机号" toView:self.view];
        return;
     }
    if ([labelCity.text isEqualToString:@"请选择所在地区"])
     {
        [MBProgressHUD showErrorWithStatus:@"请选择所在地区" toView:self.view];
        return;
     }
    if (fieldAddress.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入详细地址" toView:self.view];
        return;
     }
    
    [self savaAddressToWeb];
}

-(void) actionDefalut
{
    isDefaultAddress  = !isDefaultAddress;
    if (1 == isDefaultAddress)
     {
        [btnSetDefalut setImage:[UIImage imageNamed:@"com_gou_sel"] forState:UIControlStateNormal];
     }
    else
     {

        [btnSetDefalut setImage:[UIImage imageNamed:@"com_gou_unsel"] forState:UIControlStateNormal];
     }
    
}

-(void) actionDel
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGdeleteCustAddress];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"addressId"] = _dicData[@"addressId"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      //[self handleData:operation];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"删除成功" toView:self.view];
                                                                                      
                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                      
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    [operation start];
}

#pragma mark --- 网络通讯
-(void) savaAddressToWeb
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGupdateCustAddress];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    parmas[@"realname"] = fieldName.text;
    parmas[@"telphone"] = fieldPhone.text;
    parmas[@"province"] = strProvince;
    parmas[@"city"] = strCity;
    parmas[@"area"] = strArea;
    parmas[@"street"] = fieldAddress.text;
    parmas[@"addressId"] = _dicData[@"addressId"];
    parmas[@"isDefaultAddress"] = @(isDefaultAddress);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      //[self handleData:operation];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"保存成功" toView:self.view];
                                                                                      
                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        [self.navigationController popViewControllerAnimated:YES];
     }
    
}

-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
