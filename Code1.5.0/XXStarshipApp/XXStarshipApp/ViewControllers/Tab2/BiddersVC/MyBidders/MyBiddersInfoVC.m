//
//  MyBiddersInfoVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/20.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "MyBiddersInfoVC.h"
#import "BarterLogisticsVC.h"
#import "AddressVC.h"
#import "BatretInfoVC.h"

@interface MyBiddersInfoVC ()
{
    UILabel *labelWLDH;
}
@end

@implementation MyBiddersInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"商品详情"];
    
    [self getOwnAucDetail];
}

#pragma mark  ---  布局UI
- (void) layoutUI:(NSDictionary*) dicData
{
    int iTopY = NavHeight;
    
    int iTempViewHight = 80;
    NSString *expressNo = dicData[@"expressNo"];
    // 物流信息
    if (expressNo &&
        expressNo.length > 0)
     {
        UIView *viewWL = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iTempViewHight)];
        [self.view addSubview:viewWL];
        viewWL.backgroundColor = [UIColor whiteColor];
       
        int iTempLeftX = 15;
        int iTempTopY = 15;
        UIImageView *imgWL = [[UIImageView alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 46, 46)];
        [viewWL addSubview:imgWL];
        imgWL.image =[UIImage imageNamed:@"bid_wl"];
        
        iTempLeftX = 15 + imgWL.width + 10;
        iTempTopY +=5;
        UILabel *labe11 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 50, 15)];
        [viewWL addSubview:labe11];
        labe11.font = [UIFont systemFontOfSize:14];
        labe11.textColor = [ResourceManager lightGrayColor];
        labe11.text = @"物流公司:";
        [labe11 sizeToFit];
        
        UILabel *label1V = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX + labe11.width + 5, iTempTopY, 100, 15)];
        [viewWL addSubview:label1V];
        label1V.font = [UIFont systemFontOfSize:14];
        label1V.textColor = [ResourceManager color_1];
        label1V.text = dicData[@"logisticsName"];//@"中通快递";
        
        iTempTopY += labe11.height + 5;
        UILabel *labe12 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 50, 15)];
        [viewWL addSubview:labe12];
        labe12.font = [UIFont systemFontOfSize:14];
        labe12.textColor = [ResourceManager lightGrayColor];
        labe12.text = @"物流单号:";
        [labe12 sizeToFit];
        
        iTempLeftX = 15 + imgWL.width + 10 + labe12.width + 5;
        labelWLDH = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, SCREEN_WIDTH - iTempLeftX - 90, 15)];
        [viewWL addSubview:labelWLDH];
        labelWLDH.font = [UIFont systemFontOfSize:14];
        labelWLDH.textColor = [ResourceManager color_1];
        labelWLDH.text = expressNo;//@"12234124324123";
        //label2V.backgroundColor = [UIColor yellowColor];
        
        UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, iTempTopY-7, 70, 25)];
        [viewWL addSubview:btnCopy];
        btnCopy.borderWidth = 1;
        btnCopy.borderColor = [ResourceManager color_5];
        btnCopy.cornerRadius = btnCopy.height/2;
        [btnCopy setTitle:@"复制" forState:UIControlStateNormal];
        [btnCopy setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnCopy.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnCopy addTarget:self action:@selector(actionCopy) forControlEvents:UIControlEventTouchUpInside];
        
        iTopY += viewWL.height + 10;
     }

    
    // 物流信息
    NSString *custAddress = dicData[@"custAddress"];
    if (custAddress &&
        custAddress.length > 0)
     {
        UIView *viewWL = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iTempViewHight)];
        [self.view addSubview:viewWL];
        viewWL.backgroundColor = [UIColor whiteColor];
        
        int iTempLeftX = 15;
        int iTempTopY = 15;
        UIImageView *imgWL = [[UIImageView alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 46, 46)];
        [viewWL addSubview:imgWL];
        imgWL.image =[UIImage imageNamed:@"bid_address"];
        
        iTempLeftX = 15 + imgWL.width + 10;
        iTempTopY +=5;
        UILabel *labe11 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 50, 15)];
        [viewWL addSubview:labe11];
        labe11.font = [UIFont systemFontOfSize:14];
        labe11.textColor = [ResourceManager color_1];
        labe11.text = @"收货人:";
        [labe11 sizeToFit];
        
        UILabel *label1V = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX + labe11.width + 5, iTempTopY, 100, 15)];
        [viewWL addSubview:label1V];
        label1V.font = [UIFont systemFontOfSize:14];
        label1V.textColor = [ResourceManager color_1];
        label1V.text = dicData[@"realname"];//@"雷小峰";
        
        UILabel *label1_1V = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, iTempTopY, 105, 15)];
        [viewWL addSubview:label1_1V];
        label1_1V.font = [UIFont systemFontOfSize:14];
        label1_1V.textColor = [ResourceManager color_1];
        label1_1V.text = dicData[@"telphone"];//@"19011223344";
        
        
        
        iTempTopY += labe11.height + 5;
        UILabel *labe12 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, SCREEN_WIDTH-iTempLeftX -10, 45)];
        [viewWL addSubview:labe12];
        labe12.font = [UIFont systemFontOfSize:12];
        labe12.textColor = [ResourceManager lightGrayColor];
        labe12.text =  [NSString stringWithFormat:@"收货地址:   %@", custAddress]; 
        labe12.numberOfLines = 0;
        [labe12 sizeToFit];
        
        
        // 调整view大小
        iTempTopY += labe12.height +15;
        viewWL.height = iTempTopY;
        iTopY += viewWL.height + 10;
     }


    UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 220)];
    [self.view addSubview:viewCell];
    viewCell.backgroundColor = [UIColor whiteColor];
    viewCell.userInteractionEnabled = YES;
    
    int iCellLeftX = 15;
    int iCellTopY = 15;
    int iCellImgWidht = 130;
    
    NSDictionary *dic = dicData;
    
    // 商品的图片
    UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellImgWidht, iCellImgWidht)];
    imgReal.layer.cornerRadius = 10;
    imgReal.layer.masksToBounds = YES;
    [viewCell addSubview:imgReal];
    NSString *strImgUrl = dic[@"detailImgUrl"];
    if (strImgUrl)
     {
        [imgReal setImageWithURL:[NSURL URLWithString:strImgUrl]];
     }
    
    iCellLeftX += imgReal.width + 10;
    iCellTopY += 5;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX , 30)];
    [viewCell addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = dic[@"auctionName"];//@"幸运币";
    labelName.numberOfLines = 0;
    [labelName sizeToFit];
    
    iCellTopY += 30 + 10;
    UILabel *labelDes2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
    [viewCell addSubview:labelDes2];
    labelDes2.font = [UIFont systemFontOfSize:12];
    labelDes2.textColor = [ResourceManager lightGrayColor];
    labelDes2.text =  dic[@"priceDesc"]; //@"当前价(幸运币)";
    
    iCellTopY += labelDes2.height + 8;
    UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
    [viewCell addSubview:labelPrice];
    labelPrice.font = [UIFont systemFontOfSize:18];
    labelPrice.textColor = [ResourceManager mainColor];
    labelPrice.text =  [NSString stringWithFormat:@"%@", dic[@"auctionPrice"]]; //@"100";
    
    
    iCellTopY += labelPrice.height + 8;
    UILabel *labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
    [viewCell addSubview:labelStauts];
    labelStauts.font = [UIFont systemFontOfSize:12];
    labelStauts.textColor = [ResourceManager mainColor];
    labelStauts.text = @"已结束";
    
    
    iCellTopY += labelStauts.height;
    NSString *strYourPrcie = [NSString stringWithFormat:@"您的出价：%@", dic[@"ownHighPrice"]];
    UILabel *labeYouPrcie = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
    [viewCell addSubview:labeYouPrcie];
    labeYouPrcie.font = [UIFont systemFontOfSize:12];
    labeYouPrcie.textColor = [ResourceManager color_1];
    labeYouPrcie.text = strYourPrcie;//@"参与次数 6";
    
    
    iCellTopY += labelStauts.height;
    NSString *strcountValue = [NSString stringWithFormat:@"参与次数 %@", dic[@"joinCount"]];
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
    [viewCell addSubview:labelCount];
    labelCount.font = [UIFont systemFontOfSize:12];
    labelCount.textColor = [ResourceManager lightGrayColor];
    labelCount.text = strcountValue;//@"参与次数 6";
    
    iCellTopY += labelCount.height +8;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
    [viewCell addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 底部的按钮
    NSString *strFirstBtn = @"确认收货";
    UIColor *colorBtnUnAble = UIColorFromRGB(0xb2b2c4);
    iCellTopY += 10;
    int iBtnHeight = 30;
    UIButton *btnFrist = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, iCellTopY, 100, iBtnHeight)];
    [viewCell addSubview:btnFrist];
    [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
    btnFrist.titleLabel.font = [UIFont systemFontOfSize:14];
    btnFrist.cornerRadius = iBtnHeight/2;
    btnFrist.backgroundColor = [ResourceManager mainColor];
    [btnFrist addTarget:self action:@selector(actionFirst) forControlEvents:UIControlEventTouchUpInside];
    


    UIButton *btnSecond = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 -110, iCellTopY, 100, iBtnHeight)];
    [viewCell addSubview:btnSecond];
    [btnSecond setTitle:@"修改地址" forState:UIControlStateNormal];
    [btnSecond setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnSecond.titleLabel.font = [UIFont systemFontOfSize:14];
    btnSecond.cornerRadius = iBtnHeight/2;
    btnSecond.backgroundColor = [UIColor whiteColor];
    btnSecond.layer.borderWidth = 1;
    btnSecond.layer.borderColor = [ResourceManager color_5].CGColor;
    [btnSecond addTarget:self action:@selector(actionSecond) forControlEvents:UIControlEventTouchUpInside];
    
    // 处理状态状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货）
    int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
    if (2 == iLogisticsStatus )
     {
        strFirstBtn = @"立即领取";
      
        [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
        btnFrist.userInteractionEnabled = YES;
        
        btnSecond.hidden = YES;
     }
    else if (3 == iLogisticsStatus)
     {
        [btnSecond setTitle: @"修改地址" forState:UIControlStateNormal];
        btnFrist.backgroundColor = colorBtnUnAble;
        btnFrist.userInteractionEnabled = YES;
     }
    else if (5 == iLogisticsStatus||
        6 == iLogisticsStatus||
        7 == iLogisticsStatus)
     {
        [btnSecond setTitle:@"换货" forState:UIControlStateNormal];
        btnSecond.hidden = YES;
        
        if (6 == iLogisticsStatus)
         {
            [btnFrist setTitle: @"已经收货" forState:UIControlStateNormal];
            btnFrist.backgroundColor = colorBtnUnAble;
            btnFrist.userInteractionEnabled = NO;
         }
     }
    else
     {
        btnSecond.hidden = YES;
     }
    
    
}

#pragma  mark ---  action
-(void) actionFirst
{
    //状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
    int logisticsStatus = [_dicData[@"logisticsStatus"] intValue];
    
    if (2 == logisticsStatus)
     {
        // 立即领取
        AddressVC *VC = [[AddressVC alloc] init];
        VC.isSelAddr = YES;
        VC.selblock = ^(id obj) {
            NSDictionary *dic = obj;
            
            [self comitReceive:dic];
            
        };
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (5 == logisticsStatus||
             7 == logisticsStatus)
     {
        // 确认收货
        [self comitCollectGoods];
     }
    
  
}

-(void) actionSecond
{
    //状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
    int logisticsStatus = [_dicData[@"logisticsStatus"] intValue];
    
    if (3 == logisticsStatus)
     {
         // 修改地址
         // 修改地址
        AddressVC *VC = [[AddressVC alloc] init];
        VC.isSelAddr = YES;
        VC.selblock = ^(id obj) {
            NSDictionary *dic = obj;
            [self comitModifyAddr:dic];
        };
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if ( 5 == logisticsStatus ||
             6 == logisticsStatus ||
             7 == logisticsStatus)
     {
        [MBProgressHUD showErrorWithStatus:@"请联系客服人员换货。" toView:self.view];
        return;
//        // 换货
//        BatretInfoVC  *VC = [[BatretInfoVC alloc] init];
//        VC.dicData = _dicData;
//        [self.navigationController pushViewController:VC animated:YES];
     }
}


-(void) actionCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = labelWLDH.text;
    [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:self.view];
}

#pragma mark  --- 网络通讯
-(void) getOwnAucDetail
{
    // 我的竞拍—— 详情页面
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDqueryOwnAucDetail];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    parmas[@"ownId"] = _dicData[@"ownId"];
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

-(void)comitReceive:(NSDictionary*) dicAdderss
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDrightOffReceive];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ownId"] = _dicData[@"ownId"];
    params[@"addressId"] = dicAdderss[@"addressId"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1001;
    [operation start];
    
}

-(void)comitModifyAddr:(NSDictionary*) dicAdderss
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDmodifyOrderAddr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = _dicData[@"orderId"];
    params[@"addressId"] = dicAdderss[@"addressId"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1002;
    [operation start];
    
}

- (void) comitCollectGoods
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDconfirmCollectGoods];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = _dicData[@"orderId"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1003;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    
    
    if (1000 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
   
        [self layoutUI:dic];
     }
    else if (1001  == operation.tag)
     {
        // 领取成功，刷新列表
        [MBProgressHUD showSuccessWithStatus:@"领取成功，请等待发货。" toView:self.view];
        [self getOwnAucDetail];
        
        NSNotification *notifcation = [[NSNotification alloc]initWithName:GrabSuccessNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifcation];
     }
    else if (1002  == operation.tag)
     {
        // 修改地址成功，刷新列表
        [MBProgressHUD showSuccessWithStatus:@"修改地址成功" toView:self.view];
        [self getOwnAucDetail];
        
     }
    else if (1003  == operation.tag)
     {
        // 确认收货成功，刷新列表
        [MBProgressHUD showSuccessWithStatus:@"确认收货成功" toView:self.view];
        [self getOwnAucDetail];
        
        NSNotification *notifcation = [[NSNotification alloc]initWithName:GrabSuccessNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifcation];
     }
}

@end
