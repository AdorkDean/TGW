//
//  WithdrawTGW_VC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "WithdrawTGW_VC.h"
#import "AddTGWAddressVC.h"
#import "UnBindTGWAddressVC.h"
#import "RealWithdrawTGW_VC.h"

@interface WithdrawTGW_VC ()
{
    NSMutableArray *arrImg;
    
    int  iSelNoCell;
    NSString *allCoinValue;
    NSString *hideTelephone;
    NSString *telephone;
    
}
@end

@implementation WithdrawTGW_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav =  [self layoutWhiteNaviBarViewWithTitle:@"天狗窝钱包地址列表"];
    
    float fRightBtnTopY = NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 46;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50.f,fRightBtnTopY,40.f, 35.0f)];
    [rightNavBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:UIColorFromRGB(0x264fc0)  forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [nav addSubview:rightNavBtn];
    
    [self layoutUI];
    
    arrImg = [[NSMutableArray alloc] init];
    iSelNoCell = -1;
}

#pragma mark   ---  布局UI
-(void) layoutUI
{
    //隐藏分割线
    _tableView.separatorColor = [UIColor clearColor];
    // 设置背景
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"set_join_bg"]];
    
    
    
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 46, SCREEN_WIDTH- 30, 40)];
    [self.view addSubview:btnOK];
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:UIColorFromRGB(0x264fc0)];
    btnOK.cornerRadius = btnOK.height/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark === initData
- (CGRect)tableViewFrame
{
    return CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50);
}

#pragma mark --- 网络请求
-(void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    //params[kPage] = @(self.pageIndex);
    params[kPage] = @(1); // 不分页了，写死请求第一个页面
    params[kPageSize] = @(50);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGbindAccList]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = operation.jsonResult.attr;
    if (dic)
     {
        allCoinValue = [NSString  stringWithFormat:@"%@", dic[@"allCoinValue"]];
        hideTelephone = [NSString  stringWithFormat:@"%@", dic[@"hideTelephone"]];
        telephone = [NSString  stringWithFormat:@"%@", dic[@"telephone"]];
     }
    
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        
        if (!self.pullDown)
         {
            // 如果是下拉， 取消刷新
            [self endRefresh];
            return;
         }
        
        [arrImg removeAllObjects];
        
        [self reloadTableViewWithArray:operation.jsonResult.rows];
        
        
    }else{
        self.pageIndex --;
        if (self.pageIndex > 0)
         {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
         }
        [self endRefresh];
    }
}

#pragma  mark ---  tabelDelgte
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > indexPath.row)
     {
        iSelNoCell = (int)indexPath.row;
        int iArrImgCount = (int)[arrImg count];
        if (iSelNoCell < iArrImgCount)
         {
            UIImageView *imgTemp;
            for (int i = 0;  i < iArrImgCount; i++)
             {
                imgTemp = arrImg[i];
                imgTemp.image = [UIImage imageNamed:@"qb_gou1"];
             }
            imgTemp = arrImg[iSelNoCell];
            imgTemp.image = [UIImage imageNamed:@"qb_gou2"];
         }

        
     }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ?: 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray ||
        self.dataArray.count  == 0)
     {
        return  SCREEN_HEIGHT;
     }
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"RecLoanRecordCell";
    UITableViewCell * cell = nil;
    
    if (cell == nil) {
        int iNO = (int)indexPath.row +1;
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        
        
        
        int iTopY = 15;
        int iLeftX = 30;
    
        UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH-20, 130)];
        [cell addSubview:viewBG];
        viewBG.backgroundColor = [UIColor whiteColor];
        viewBG.cornerRadius = 8;
        
        UIImageView  *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(7, iTopY, 18, 18)];
        [viewBG addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"qb_gou1"];
        
        int iArrCount = (int)[arrImg count];
        if (iArrCount < iNO)
         {
            [arrImg addObject:imgLeft];
         }
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-10, 20)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text =   [NSString stringWithFormat:@"天狗窝钱包%d", iNO];
        label1.textColor = [ResourceManager color_1];
        [viewBG addSubview:label1];
        
        
        iTopY += 25;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, viewBG.width - iLeftX - 10, 50)];
        label2.font = [UIFont systemFontOfSize:15];
        label2.textColor = [ResourceManager color_1];
        label2.text =  [NSString  stringWithFormat:@"%@",  dic[@"accid"]];
        label2.numberOfLines = 0;
        [viewBG addSubview:label2];
        
        
        iTopY += 50;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(viewBG.width - 100, iTopY, 90, 20)];
        label3.font = [UIFont systemFontOfSize:14];
        label3.textColor = UIColorFromRGB(0x938ad2);
        label3.text = @"解除绑定";
        label3.textAlignment = NSTextAlignmentRight;
        label3.tag = iNO-1;
        [viewBG addSubview:label3];
        // 添加下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"解除绑定" attributes:attribtDic];
        label3.attributedText = attribtStr;
        //添加手势点击空白处隐藏键盘
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionUnBind:)];
        gesture.numberOfTapsRequired  = 1;
        label3.userInteractionEnabled = YES;
        [label3 addGestureRecognizer:gesture];

        
        
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    
    return  cell;
    
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
    UIView  *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380.f)];
    [view addSubview:viewBackground];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
    imageView.image = [UIImage imageNamed:@"com_noData"];
    [viewBackground addSubview:imageView];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
    lable1.text = @"没有记录～";
    lable1.textAlignment =  NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:16];
    lable1.textColor = [UIColor whiteColor];
    [viewBackground addSubview:lable1];
    
    
    UIButton *btnQD =  [[UIButton alloc] initWithFrame:CGRectMake(60, 50+160+60, SCREEN_WIDTH - 120, 40)];
    [viewBackground addSubview:btnQD];
    btnQD.backgroundColor = UIColorFromRGB(0x264fc0);
    btnQD.cornerRadius = btnQD.height/2;
    [btnQD setTitle:@"添加钱包地址" forState:UIControlStateNormal];
    btnQD.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnQD addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark ---  action
-(void) actionAdd
{
    AddTGWAddressVC  *VC = [[AddTGWAddressVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionOK
{
    if (iSelNoCell < 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择天狗窝钱包" toView:self.view];
        return;
     }
    
    if (_isSelAddr)
     {
        NSDictionary *dic = self.dataArray[iSelNoCell];
        NSString *strAddr =  dic[@"accid"];
        if (_selAddrBlock)
         {
            _selAddrBlock(strAddr);
         }
        [self.navigationController popViewControllerAnimated:YES];
        return;
     }
    
    NSDictionary *dic = self.dataArray[iSelNoCell];
    RealWithdrawTGW_VC  *VC = [[RealWithdrawTGW_VC alloc] init];
    VC.accid = dic[@"accid"];
    VC.allCoinValue = allCoinValue;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionUnBind:(UITapGestureRecognizer*) sender
{
    //用tag传值判断
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    int  index = (int)view.tag;
    
    NSDictionary *dic = self.dataArray[index];
    UnBindTGWAddressVC *VC = [[UnBindTGWAddressVC alloc] init];
    VC.accid = dic[@"accid"];
    VC.hideTelephone = hideTelephone;
    VC.telephone = telephone;
    [self.navigationController pushViewController:VC animated:YES];
}




@end
