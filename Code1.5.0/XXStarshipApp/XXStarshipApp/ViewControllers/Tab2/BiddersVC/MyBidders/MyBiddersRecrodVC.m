//
//  MyBiddersRecrodVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/18.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "MyBiddersRecrodVC.h"
#import "MyBiddersInfoVC.h"
#import "AddressVC.h"
#import "BatretInfoVC.h"
#import "BiddersVC.h"


const int  iHeadHeight   = 60;
const int  iTCellHeight   = 225;

@interface MyBiddersRecrodVC ()
{
    NSMutableArray *arrBtnHead;  // 头部按钮
    NSMutableArray *arrImgHead;  // 头部img
    
    int iSelHead;      // （0全部 1待发货 2待收货）
    int iSelNoCell;  //  选中的cell的序号
}
@end

@implementation MyBiddersRecrodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"我的竞拍"];
    
    [self layoutHead];
    
    // 隐藏分割线
    _tableView.separatorColor = [UIColor clearColor];
    
    //[self getAppPlist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GrabSuccess) name:GrabSuccessNotification object:nil];
    

}

-(void) GrabSuccess
{
    if (self.dataArray)
     {
        [self.dataArray removeAllObjects];
        [self reloadData];
     }
}

- (void) layoutHead
{
    int iTopY = NavHeight;
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iHeadHeight)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [ResourceManager viewBackgroundColor];
    
    arrBtnHead = [[NSMutableArray alloc] init];
    arrImgHead = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"全部",@"待发货",@"待收货"];
    int iBtnCount = (int)[arr count];
    int iBtnWidth = SCREEN_WIDTH/ iBtnCount;
    int iBtnHegiht = iHeadHeight - 10;
    int iBtnLeftX = 0;
    int iBtnTopY = 0;
    int iImgLeftX = (iBtnWidth - 50)/2;
    UIButton *btnFirst = nil;
    for (int i = 0; i < iBtnCount;  i++)
     {
        //按钮
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWidth, iBtnHegiht)];
        [viewHead addSubview:btnTemp];
        [btnTemp setTitle:arr[i] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:15];
        btnTemp.backgroundColor = [UIColor whiteColor];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (0 == i)
         {
            btnFirst = btnTemp;
         }
        
        iBtnLeftX +=iBtnWidth;
        
        // 按钮底部的img
        UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX, iBtnHegiht-2, 50, 2)];
        [btnTemp addSubview:imgTemp];
        imgTemp.backgroundColor = [ResourceManager mainColor];
        
        
        // 元素加入数组
        [arrBtnHead addObject:btnTemp];
        [arrImgHead addObject:imgTemp];
     }
    
    
    if (btnFirst)
     {
        [self actionBtn:btnFirst];
     }
    
    
    
    
}

#pragma mark === initData
- (CGRect)tableViewFrame
{
    return CGRectMake(0, NavHeight + iHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - iHeadHeight);
}

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > indexPath.row)
     {
        iSelNoCell = (int)indexPath.row;
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        // 竞拍状态（0空 1进行中 2活动结束）
        int iAuctionStatus = [dic[@"auctionStatus"] intValue];
        // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
        int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
       
        //if (2 == iAuctionStatus )
        if (2 == iAuctionStatus &&
            4 == iLogisticsStatus )
         {
            //活动已经结束，并且未竞的
            BiddersVC  *VC = [[BiddersVC alloc] init];
            VC.dicData = dic;
            VC.isEnd = YES;
            [self.navigationController pushViewController:VC animated:YES];
            return;
         }
        
        if(iAuctionStatus !=2)
         {
            return;
         }
        
        if (iLogisticsStatus == 0 ||
            iLogisticsStatus == 1 ||
            iLogisticsStatus == 2 ||
            iLogisticsStatus == 4 ||
            iLogisticsStatus == 8 ||
            iLogisticsStatus == 9)
         {
            return;
         }
        
        MyBiddersInfoVC  *VC = [[MyBiddersInfoVC alloc] init];
        VC.dicData = dic;
        [self.navigationController pushViewController:VC animated:YES];
     }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count?:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return  SCREEN_HEIGHT;
     }
    return iTCellHeight;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"cell";
    UITableViewCell * cell = nil;
    
    int iCellHeight = iTCellHeight - 10;
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iCellHeight)];
        [cell addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        viewCell.userInteractionEnabled = YES;
        viewCell.tag = indexPath.row;
        
        int iCellLeftX = 15;
        int iCellTopY = 15;
        int iCellImgWidht = 130;
        // 商品的图片
        UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellImgWidht, iCellImgWidht)];
        imgReal.backgroundColor = [ResourceManager viewBackgroundColor];
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
        


        // 竞拍状态（0空 1进行中 2活动结束）
        int iAuctionStatus = [dic[@"auctionStatus"] intValue];
        // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
        int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
        
        NSString *strStatus = @"进行中";
        if (0 == iAuctionStatus)
         {
            strStatus = @"进行中";
         }
        if (1 == iAuctionStatus)
         {
            strStatus = @"进行中";
         }
        if (2 == iAuctionStatus)
         {
            strStatus = @"活动结束";
         }
        
        
        iCellTopY += labelPrice.height + 8;
        UILabel *labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
        [viewCell addSubview:labelStauts];
        labelStauts.font = [UIFont systemFontOfSize:12];
        labelStauts.textColor = [ResourceManager mainColor];
        labelStauts.text = strStatus;
        
        
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
        
        iCellTopY += labelCount.height +3;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        //  底部的按钮
        NSString *strFirstBtn = @"已经结束";
        UIColor *colorFirstBtn = UIColorFromRGB(0xb2b2c4);// [ResourceManager mainColor];
        BOOL  btnUser = NO;
    
        
        // 竞拍状态（0进行中 1进行中 2活动结束）
        if (0 == iAuctionStatus ||
            1 == iAuctionStatus)
         {
            strFirstBtn = @"等待结束";
            colorFirstBtn = UIColorFromRGB(0xb2b2c4);// [ResourceManager mainColor];
            btnUser = NO;
            
            // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
            if (1 == iLogisticsStatus)
             {
                strFirstBtn = @"暂时竞得";
             }
            if (4 == iLogisticsStatus)
             {
                strFirstBtn = @"未竞得";
             }
            if (8 == iLogisticsStatus)
             {
                strFirstBtn = @"放弃领取";
             }
            if (9 == iLogisticsStatus)
             {
                strFirstBtn = @"交易结束";
             }

         }
        iCellTopY += 10;
        int iBtnHeight = 30;
        UIButton *btnFrist = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, iCellTopY, 100, iBtnHeight)];
        [viewCell addSubview:btnFrist];
        btnFrist.tag = indexPath.row;
        [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
        btnFrist.titleLabel.font = [UIFont systemFontOfSize:14];
        btnFrist.cornerRadius = iBtnHeight/2;
        btnFrist.backgroundColor = colorFirstBtn;
        btnFrist.userInteractionEnabled = btnUser;
        [btnFrist addTarget:self action:@selector(actionFirst:) forControlEvents:UIControlEventTouchUpInside];
        

        //  竞拍状态（0空 1进行中 2活动结束）
        if (0 == iAuctionStatus ||
            1 == iAuctionStatus )
         {
            goto  RETURN_CELL;
         }
        
        // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
        if (iLogisticsStatus == 4)
         {
            strFirstBtn = @"未竞得";
            colorFirstBtn = UIColorFromRGB(0xb2b2c4);// [ResourceManager mainColor];
            [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
            btnFrist.backgroundColor = colorFirstBtn;
            goto  RETURN_CELL;
         }
        else
         {
            if (5 == iLogisticsStatus ||
                7 == iLogisticsStatus)
             {
                strFirstBtn = @"确认收货";
                colorFirstBtn = [ResourceManager mainColor];
                [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
                btnFrist.backgroundColor = colorFirstBtn;
                btnFrist.userInteractionEnabled = YES;
             }
            
            if (3 == iLogisticsStatus )
             {
                strFirstBtn = @"确认收货";
                colorFirstBtn = [ResourceManager mainColor];
                [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
                btnFrist.backgroundColor = UIColorFromRGB(0xb2b2c4);;
                btnFrist.userInteractionEnabled = NO;
             }
            
            if (2 == iLogisticsStatus )
             {
                strFirstBtn = @"立即领取";
                colorFirstBtn = [ResourceManager mainColor];
                [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
                btnFrist.backgroundColor = colorFirstBtn;
                btnFrist.userInteractionEnabled = YES;
             }
            
            if (6 == iLogisticsStatus )
             {
                strFirstBtn = @"已收货";
                colorFirstBtn = UIColorFromRGB(0xb2b2c4);//[ResourceManager mainColor];
                [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
                btnFrist.backgroundColor = colorFirstBtn;
                btnFrist.userInteractionEnabled = NO;
             }
            
            if (8 == iLogisticsStatus)
             {
                strFirstBtn = @"放弃领取";
                colorFirstBtn = UIColorFromRGB(0xb2b2c4);
                btnFrist.backgroundColor = colorFirstBtn;
                [btnFrist setTitle:strFirstBtn forState:UIControlStateNormal];
             }
            
            
         }
        
        UIButton *btnSecond = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 -110, iCellTopY, 100, iBtnHeight)];
        [viewCell addSubview:btnSecond];
        btnSecond.tag = indexPath.row;
        [btnSecond setTitle:@"" forState:UIControlStateNormal];
        [btnSecond setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
        btnSecond.titleLabel.font = [UIFont systemFontOfSize:14];
        btnSecond.cornerRadius = iBtnHeight/2;
        btnSecond.backgroundColor = [UIColor whiteColor];
        btnSecond.layer.borderWidth = 1;
        btnSecond.layer.borderColor = [ResourceManager color_5].CGColor;
        [btnSecond addTarget:self action:@selector(actionSecond:) forControlEvents:UIControlEventTouchUpInside];
        
        // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
        btnSecond.hidden = NO;
        if (0 == iLogisticsStatus ||
            1 == iLogisticsStatus ||
            2 == iLogisticsStatus ||
            4 == iLogisticsStatus ||
            8 == iLogisticsStatus ||
            9 == iLogisticsStatus )
         {
            btnSecond.hidden = YES;
            

         }
        
        if (3 == iLogisticsStatus)
         {
            [btnSecond setTitle:@"修改地址" forState:UIControlStateNormal];
         }
        
        if (5 == iLogisticsStatus||
            6 == iLogisticsStatus||
            7 == iLogisticsStatus)
         {
            [btnSecond setTitle:@"换货" forState:UIControlStateNormal];
            btnSecond.hidden = YES;
         }
        
 
    }
    
RETURN_CELL:
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
     {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
    
    [self noDataView:cell.contentView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)noDataView:(UIView *)view{
    [view removeAllSubviews];
    UIView  *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280.f)];
    [view addSubview:viewBackground];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
    imageView.image = [UIImage imageNamed:@"com_noData"];
    [viewBackground addSubview:imageView];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
    lable1.text = @"没有记录～";
    
    
    lable1.textAlignment =  NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:16];
    lable1.textColor = [ResourceManager color_1];
    [viewBackground addSubview:lable1];
    
    
    //    UIButton *btnQD =  [[UIButton alloc] initWithFrame:CGRectMake(60, 50+120+70, SCREEN_WIDTH - 120, 50)];
    //    [viewBackground addSubview:btnQD];
    //    btnQD.backgroundColor = [ResourceManager redColor1];
    //    [btnQD setTitle:@"去抢直借单" forState:UIControlStateNormal];
    //    btnQD.titleLabel.font = [UIFont systemFontOfSize:14];
    //
    //    [btnQD addTarget:self action:@selector(actionQD) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark --- 网络通讯
-(void)loadData{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDGqueryOwnAucRecord];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(100);

    // （不传值 - 全部 1待发货 2待收货）
    if (iSelHead > 0)
     {
        params[@"logisticsStatus"] = @(iSelHead);
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleListData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      [self endRefresh];
                                                                                  }];
    [operation start];
    
}

-(void)handleListData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    
    if (operation.jsonResult.rows &&
        operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex > 0)
         {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
         }
        else
         {
            [self reloadTableViewWithArray:nil];
         }
        [self endRefresh];
        
        
    }
}


-(void)comitReceive:(NSDictionary*) dicAdderss
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDrightOffReceive];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *dicBidders = self.dataArray[iSelNoCell];
    params[@"ownId"] = dicBidders[@"ownId"];
    params[@"addressId"] = dicAdderss[@"addressId"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      [self endRefresh];
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
    
}

-(void)comitModifyAddr:(NSDictionary*) dicAdderss
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDmodifyOrderAddr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *dicBidders = self.dataArray[iSelNoCell];
    params[@"orderId"] = dicBidders[@"orderId"];
    params[@"addressId"] = dicAdderss[@"addressId"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      [self endRefresh];
                                                                                  }];
    
    operation.tag = 1001;
    [operation start];
    
}

- (void) comitCollectGoods
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDconfirmCollectGoods];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *dicBidders = self.dataArray[iSelNoCell];
    params[@"orderId"] = dicBidders[@"orderId"];
    
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

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (1000  == operation.tag)
     {
        // 领取成功，刷新列表
        [MBProgressHUD showSuccessWithStatus:@"领取成功，请等待发货。" toView:self.view];
        
        NSNotification *notifcation = [[NSNotification alloc]initWithName:GrabSuccessNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifcation];
     }
    else if (1003  == operation.tag)
     {
        // 确认收货成功，刷新列表
        [MBProgressHUD showSuccessWithStatus:@"确认收货成功" toView:self.view];
        
        NSNotification *notifcation = [[NSNotification alloc]initWithName:GrabSuccessNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifcation];
     }

}

#pragma mark  ---  action
// 顶部的切换按钮
-(void) actionBtn:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    for (int i = 0; i < [arrBtnHead count]; i++)
     {
        UIButton *btnTemp = arrBtnHead[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        
        UIView *viewTemp = arrImgHead[i];
        viewTemp.hidden = YES;
     }
    
    if (iTag < [arrBtnHead count])
     {
        if (self.dataArray)
         {
            [self.dataArray removeAllObjects];
         }
        
        UIButton *btnTemp = arrBtnHead[iTag];
        [btnTemp setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
        
        UIView *viewTemp = arrImgHead[iTag];
        viewTemp.hidden = NO;
        
        iSelHead = iTag;
        
        [self reloadData];
     }
    
}

- (void) actionFirst:(UIButton*) sender
{
    iSelNoCell = (int)sender.tag;
    if (iSelNoCell < [self.dataArray count])
     {
        NSDictionary *dic = self.dataArray[iSelNoCell];
        // 处理状态状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货）
        int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
        if (2 == iLogisticsStatus)
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
        else if ( 5 == iLogisticsStatus ||
                  7 == iLogisticsStatus)
         {
            // 确认收货
            [self comitCollectGoods];
         }
     }
}

-(void) actionSecond:(UIButton*) sender
{
    iSelNoCell = (int)sender.tag;
    
    if (iSelNoCell < [self.dataArray count])
     {
        NSDictionary *dic = self.dataArray[iSelNoCell];
        // 处理状态状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货）
        int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
        if (3 == iLogisticsStatus)
         {
            // 修改地址
            AddressVC *VC = [[AddressVC alloc] init];
            VC.isSelAddr = YES;
            VC.selblock = ^(id obj) {
                NSDictionary *dic = obj;
                [self comitModifyAddr:dic];
            };
            [self.navigationController pushViewController:VC animated:YES];
         }
        else if ( 5 == iLogisticsStatus ||
                  6 == iLogisticsStatus ||
                  7 == iLogisticsStatus)
         {
            [MBProgressHUD showErrorWithStatus:@"请联系客服人员换货。" toView:self.view];
            return;
//            // 换货
//            BatretInfoVC  *VC = [[BatretInfoVC alloc] init];
//            VC.dicData = dic;
//            [self.navigationController pushViewController:VC animated:YES];
         }
     }
}

#pragma mark ---  获取所有APP的列表
//-(void)getAppPlist
//{
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
//    //设备安装的app列表
//    NSArray *appList = [workspace performSelector:@selector(allApplications)];
//    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
//    for (LSApplicationProxy_class in appList)
//     {
//        //这里可以查看一些信息
//        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
//        NSString *version =  [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
//        NSString *shortVersionString =  [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
//
//        id name = [LSApplicationProxy_class performSelector:@selector(localizedName)];
//        NSLog(@"name:%@\n   bundleID：%@\n version： %@\n ,shortVersionString:%@\n ", name, bundleID,version,shortVersionString);
//     }
//
//
//}



@end
