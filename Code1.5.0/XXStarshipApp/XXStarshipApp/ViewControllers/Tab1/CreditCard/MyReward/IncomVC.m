//
//  IncomVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/31.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "IncomVC.h"

@interface IncomVC ()
{
    NSMutableArray *arrBtnHead;  // 头部按钮
    NSMutableArray *arrImgHead;  // 头部img
    NSMutableArray *arrBtnHead2;  // 头部按钮2
    UILabel *labelTotal;
    
    UIView *viewBG;
    UIView *viewBG1;
    UIView *viewBG2;
    
    int iSelHead;      // （1待确认 2未通过 3已结算）
    int iSelHead2;      // （1自己办卡 2一级好友办卡 3二级好友办卡）
    int iSelNoCell;  //  选中的cell的序号
}
@end


const int  iInCreditHeadHeight   = 15;
const int  iInCreditHeadHeight2   = 40;
const int  iInCreditHeadHeight3   = 20;
const int  iInCreditTCellHeight   = 97;

@implementation IncomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"收入明细"];
    [self layoutHead];
    
    // 隐藏分割线
    _tableView.separatorColor = [UIColor clearColor];
    //_tableView.backgroundColor = [UIColor blueColor];
}


#pragma mark  ---  布局UI
- (void) layoutHead
{
    iSelHead = 1;
    iSelHead2 = 1;
    
    int iTopY = NavHeight;
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iInCreditHeadHeight)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIColor *colrSel = UIColorFromRGB(0x5953ff);
    arrBtnHead = [[NSMutableArray alloc] init];
    arrImgHead = [[NSMutableArray alloc] init];
    arrBtnHead2 = [[NSMutableArray alloc] init];

    
    
    // 头部按钮2
    NSArray *arr = @[@"自己办卡",@"一级好友办卡",@"二级好友办卡"];
    int  iBtnBetwwen = 20;
    int iBtnCount = (int)[arr count];
    int iBtnWidth = SCREEN_WIDTH/ iBtnCount - 2*iBtnBetwwen;
    int iBtnHegiht = iInCreditHeadHeight2 - 15;
    int iBtnLeftX = iBtnBetwwen;
    int iBtnTopY = NavHeight + iInCreditHeadHeight;
    UIButton *btnFirst2 = nil;
    
    UIView *viewTopBG = [[UIView alloc] initWithFrame:CGRectMake(0, iBtnTopY-5, SCREEN_WIDTH, iBtnHegiht + 10 + iInCreditHeadHeight3+10)];
    [self.view addSubview:viewTopBG];
    viewTopBG.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < iBtnCount;  i++)
     {
        //按钮
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWidth, iBtnHegiht)];
        [self.view addSubview:btnTemp];
        [btnTemp setTitle:arr[i] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager blackGrayColor] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:11];
        btnTemp.backgroundColor = [UIColor clearColor];
        btnTemp.cornerRadius = 5;
        btnTemp.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
        btnTemp.layer.borderWidth = 1;
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionBtn2:) forControlEvents:UIControlEventTouchUpInside];
        if (0 == i)
         {
            btnFirst2 = btnTemp;
         }
        
        iBtnLeftX += 2*iBtnBetwwen +iBtnWidth;
        
        
        // 元素加入数组
        [arrBtnHead2 addObject:btnTemp];
     }
    
    if (btnFirst2)
     {
        [self actionBtn2:btnFirst2];
     }
    
    // 头部的最下面
    iTopY = NavHeight + iInCreditHeadHeight + iInCreditHeadHeight2-10;
    
    
    labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY+5, SCREEN_WIDTH-30, 15)];
    [self.view addSubview:labelTotal];
    labelTotal.backgroundColor = [ResourceManager viewBackgroundColor];
    labelTotal.font = [UIFont systemFontOfSize:13];
    labelTotal.textColor = [ResourceManager color_1];
    labelTotal.text = @"  累计0张";
    
    
    
    
    
    
}


#pragma mark === initData
- (CGRect)tableViewFrame
{
    return CGRectMake(0, NavHeight + iInCreditHeadHeight + iInCreditHeadHeight2 + iInCreditHeadHeight3, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - iInCreditHeadHeight - iInCreditHeadHeight2 - iInCreditHeadHeight3);
}

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > indexPath.row)
     {
        iSelNoCell = (int)indexPath.row;
        
        //        NSDictionary *dic = self.dataArray[indexPath.row];
        //        // 竞拍状态（0空 1进行中 2活动结束）
        //        int iAuctionStatus = [dic[@"auctionStatus"] intValue];
        //        // 处理状态（0-空 1-暂时竞得 2-立即领取 3-待发货 4-未竞得 5-待收货 6-已收货 7-换货 8-放弃领取 9-交易结束）
        //        int iLogisticsStatus = [dic[@"logisticsStatus"] intValue];
        
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
    return iInCreditTCellHeight;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"cell";
    UITableViewCell * cell = nil;
    
    int iCellHeight = iInCreditTCellHeight ;
    
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
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 120 , 20)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:15];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = dic[@"applyName"];
        
        NSString *strJL = [NSString stringWithFormat:@"现金奖励: ¥%@",dic[@"amount"]];
        NSString *strMFGL = [NSString stringWithFormat:@"魔法狗粮: %@包",dic[@"abilityReward"]];

        
        UILabel *labelJL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-205, iCellTopY, 190 , 20)];
        [viewCell addSubview:labelJL];
        labelJL.font = [UIFont systemFontOfSize:14];
        labelJL.textColor = [ResourceManager color_1];
        labelJL.textAlignment = NSTextAlignmentRight;
        labelJL.text =strJL;
        
        
        
        iCellTopY += labelName.height + 10;
        UILabel *labelDes2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 120, 15)];
        [viewCell addSubview:labelDes2];
        labelDes2.font = [UIFont systemFontOfSize:14];
        labelDes2.textColor = [ResourceManager color_1];
        labelDes2.text =  dic[@"applyTel"];
        
        UILabel *labelMFGL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-205, iCellTopY, 190 , 20)];
        [viewCell addSubview:labelMFGL];
        labelMFGL.font = [UIFont systemFontOfSize:14];
        labelMFGL.textColor = [ResourceManager color_1];
        labelMFGL.textAlignment = NSTextAlignmentRight;
        labelMFGL.text =strMFGL;
        
        iCellTopY += labelDes2.height + 8;
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 150, 20)];
        [viewCell addSubview:labelTime];
        labelTime.font = [UIFont systemFontOfSize:12];
        labelTime.textColor = [ResourceManager lightGrayColor];
        labelTime.text =  [NSString stringWithFormat:@"%@", dic[@"createTime"]];
        
        UILabel *labelBank = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-205, iCellTopY, 190, 20)];
        [viewCell addSubview:labelBank];
        labelBank.font = [UIFont systemFontOfSize:12];
        labelBank.textColor = [ResourceManager lightGrayColor];
        labelBank.textAlignment = NSTextAlignmentRight;
        labelBank.text =  [NSString stringWithFormat:@"%@", dic[@"prodName"]];
        
        
        iCellTopY += labelTime.height +10;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
    }
    
    
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

#pragma mark  ---  action
// 顶部的切换按钮
-(void) actionBtn:(UIButton*) sender
{
    UIColor *colrSel = UIColorFromRGB(0x5953ff);
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
        [btnTemp setTitleColor:colrSel forState:UIControlStateNormal];
        
        UIView *viewTemp = arrImgHead[iTag];
        viewTemp.hidden = NO;
        
        iSelHead = iTag +1;
        
        [self reloadData];
     }
    
    viewBG.hidden = YES;
    viewBG1.hidden = YES;
    viewBG2.hidden = YES;
    if (iSelHead == 1)
     {
        viewBG.hidden = NO;
     }
    else if (iSelHead == 2)
     {
        viewBG1.hidden = NO;
     }
    else if (iSelHead == 3)
     {
        viewBG2.hidden = NO;
     }
    
}

-(void) actionBtn2:(UIButton*) sender
{
    UIColor *colrSel = UIColorFromRGB(0x5953ff);
    int iTag = (int)sender.tag;
    for (int i = 0; i < [arrBtnHead2 count]; i++)
     {
        UIButton *btnTemp = arrBtnHead2[i];
        [btnTemp setTitleColor:[ResourceManager blackGrayColor] forState:UIControlStateNormal];
        btnTemp.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
     }
    
    if (iTag < [arrBtnHead2 count])
     {
        if (self.dataArray)
         {
            [self.dataArray removeAllObjects];
         }
        
        UIButton *btnTemp = arrBtnHead2[iTag];
        [btnTemp setTitleColor:colrSel forState:UIControlStateNormal];
        btnTemp.layer.borderColor = colrSel.CGColor;
        
        
        
        iSelHead2 = iTag +1;
        
        [self reloadData];
     }
    
}

-(void) actionShuoMing
{
//    QuestionVC  *vc = [[QuestionVC alloc] init];
//    NSString *url = [NSString stringWithFormat:@"%@tgwproject/StateExplain",[PDAPI WXSysRouteAPI2]];
//    vc.homeUrl = [NSURL URLWithString:url];
//    vc.titleStr = @"说明";
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark --- 网络通讯
-(void)loadData{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDGqueryIncomeDtlList];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    
    //params[@"status"] = @(iSelHead); // 推广状态（1-待确认 2-未通过 3-已结算）
    params[@"rewardType"] = @(iSelHead2); // 查询标识（1-自己办卡 2-一级好友办卡 3-二级好友办卡）
    
    
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
    
    NSDictionary *dicPage =  operation.jsonResult.attr;
    NSString *strNO = [NSString stringWithFormat:@"%d",  [dicPage[@"handleNum"] intValue]];;//  @"10501";
    NSString *strAll =  [NSString stringWithFormat:@"累计%d张",  [dicPage[@"handleNum"] intValue]];;
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager redColor2] range:stringRange];
    labelTotal.attributedText = noteString;
    
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

@end
