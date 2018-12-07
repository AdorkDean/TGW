//
//  PutForwardRecordVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/6/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "PutForwardRecordVC.h"

@interface PutForwardRecordVC ()
{
    UILabel *labelMFGL1;
    UILabel *labelMFGL2;
}

@end

@implementation PutForwardRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"提现记录"];
    
    [self layoutUI];
}

#pragma mark   ---  布局UI
-(void) layoutUI
{
    
    // 绿色的色值  4bb06c
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 80)];
    [self.view addSubview:viewTop];
    viewTop.backgroundColor = [UIColor whiteColor];
    
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewTop addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 10, 2, 60)];
    [viewTop addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    // 中间的左边
    UILabel *lableT2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/2, 20)];
    [viewTop addSubview:lableT2];
    lableT2.font =  [UIFont systemFontOfSize:13];
    lableT2.textColor = [ResourceManager color_1];
    lableT2.textAlignment = NSTextAlignmentCenter;
    lableT2.text = @"已提现";
    labelMFGL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH/2, 20)];
    [viewTop addSubview:labelMFGL1];
    labelMFGL1.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    labelMFGL1.textColor = [ResourceManager color_1];
    labelMFGL1.textAlignment = NSTextAlignmentCenter;
    labelMFGL1.text = @"";

    
    
    // 中间的右边
    UILabel *lableT3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 20)];
    [viewTop addSubview:lableT3];
    lableT3.font =  [UIFont systemFontOfSize:13];
    lableT3.textColor = UIColorFromRGB(0x4bb06c);
    lableT3.textAlignment = NSTextAlignmentCenter;
    lableT3.text = @"审核中";
    labelMFGL2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 45, SCREEN_WIDTH/2, 20)];
    [viewTop addSubview:labelMFGL2];
    labelMFGL2.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];;
    labelMFGL2.textColor = [ResourceManager color_1];
    labelMFGL2.textAlignment = NSTextAlignmentCenter;
    labelMFGL2.text = @"";
 
    
    
    //去掉分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark === initData
- (CGRect)tableViewFrame
{
    return CGRectMake(0, NavHeight + 90, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 90);
}

#pragma mark --- 网络请求
-(void)loadData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGqueryWithdrawList]
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
        NSDictionary *dicWithdrawInfo = dic[@"withdrawInfo"];
        if (dicWithdrawInfo)
         {
            labelMFGL1.text = [NSString stringWithFormat:@"￥%.2f",[dicWithdrawInfo[@"succWithAmt"] floatValue]];
            labelMFGL2.text = [NSString stringWithFormat:@"￥%.2f",[dicWithdrawInfo[@"auditAmt"] floatValue]];
         }

     }
    
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ?: 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"RecLoanRecordCell";
    UITableViewCell * cell = nil;
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        int iTopY = 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, iTopY, 110, 20)];
        label1.font = [UIFont systemFontOfSize:13];
        label1.text =   [NSString stringWithFormat:@"¥ %@", dic[@"amount"]];
        label1.textAlignment = NSTextAlignmentRight;
        label1.textColor = [ResourceManager color_1];
        [cell addSubview:label1];
        
        UILabel *label1A = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, iTopY+25, 110, 20)];
        label1A.font = [UIFont systemFontOfSize:13];
        label1A.textColor = [ResourceManager color_1];
        label1A.textAlignment = NSTextAlignmentRight;
        int iStatus = [dic[@"status"] intValue];
        NSString *strStaus = [self getStatus:iStatus];
        label1A.text = strStaus;
        label1A.textColor = [self getColorByStatus:iStatus];
        [cell addSubview:label1A];
        

        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH-10, 20)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = [ResourceManager color_1];
        label2.text =  [NSString  stringWithFormat:@"%@",  dic[@"createTime"]];
        [cell addSubview:label2];
        
        
        UILabel *label2A = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY+25, SCREEN_WIDTH-10, 20)];
        label2A.font = [UIFont systemFontOfSize:13];
        label2A.textColor = [ResourceManager midGrayColor];
        label2A.text =  [NSString  stringWithFormat:@"%@",  dic[@"hideCardNo"]];
        [cell addSubview:label2A];
    
        
    }
    
    return  cell;
    
}


-(NSString *) getStatus:(int) status
{
    //status状态
    //0待审核 1审核通过 2审核失败 3交易中 4提现成功 5发放失败
    NSString *strRet = @"待审核";
    switch (status) {
        case 0:
            strRet = @"待审核";
            break;
        case 1:
            strRet = @"审核通过";
            break;
        case 2:
            strRet = @"审核失败";
            break;
        case 3:
            strRet = @"交易中";
            break;
        case 4:
            strRet = @"提现成功";
            break;
        case 5:
            strRet = @"提现失败";
            break;
            
        default:
            break;
    }
    
    return strRet;
}

-(UIColor*) getColorByStatus:(int) status
{
    //待审核  3d8def  ；  交易中  f6a752  ；  审核通过  3dbd64  ；  审核失败、提现失败  fc270b  ；  提现成功  4c4c4c
    //status状态
    //0待审核 1审核通过 2审核失败 3交易中 4提现成功 5发放失败
    UIColor* corRet = UIColorFromRGB(0x3d8def);
    switch (status) {
        case 0:
            //strRet = @"待审核";
            corRet = UIColorFromRGB(0x3d8def);
            break;
        case 1:
            //strRet = @"申请通过";
            corRet = UIColorFromRGB(0x3dbd64);
            break;
        case 2:
            //strRet = @"审核失败";
            corRet = UIColorFromRGB(0xfc270b);
            break;
        case 3:
            //strRet = @"交易中";
            corRet = UIColorFromRGB(0xf6a752);
            break;
        case 4:
            //strRet = @"提现成功";
            corRet = UIColorFromRGB(0x4c4c4c);
            break;
        case 5:
            //strRet = @"发送失败";
            corRet = UIColorFromRGB(0xfc270b);
            break;
            
        default:
            break;
    }
    
    return corRet;
}



@end
