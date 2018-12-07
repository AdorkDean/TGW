//
//  ExchangeRecordViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/25.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "ExchangeRecordViewController.h"

#import "ExchangeRecordViewCell.h"

@interface ExchangeRecordViewController ()

@end

@implementation ExchangeRecordViewController

#pragma mark === viewDidLoad
-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/ticket/change/queryRecords",[PDAPI getBaseUrlString]] parameters:@{kPage:@(self.pageIndex)} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
}

#pragma mark ---数据操作---
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super handleData:operation];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
    }
    [_tableView.mj_header endRefreshing]; // 结束刷新
    [_tableView.mj_footer endRefreshing]; // 结束刷新
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing]; // 结束刷新
    [_tableView.mj_footer endRefreshing]; // 结束刷新
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutWhiteNaviBarViewWithTitle:@"兑换记录"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ExchangeRecordViewCell" bundle:nil] forCellReuseIdentifier:@"ExchangeRecord_cell"];
    //设置分割线顶头和颜色
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
    //去掉多余cell
    _tableView.tableFooterView = [UIView new];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count?:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return  SCREEN_HEIGHT;
     }
    return 65;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    ExchangeRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeRecord_cell"];
    if (!cell) {
        cell = [[ExchangeRecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExchangeRecord_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dataDicionary = self.dataArray[indexPath.row];
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
