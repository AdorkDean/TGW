//
//  ShopRecordVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "ShopRecordVC.h"

@interface ShopRecordVC ()

@end

@implementation ShopRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"商城记录"];
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
    return 60;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"cell";
    UITableViewCell * cell = nil;
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-10 - 80, 20)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text =  dic[@"proName"];
        label1.textColor = [ResourceManager navgationTitleColor];
        [cell addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 10, 200 , 20)];
        label2.font = [UIFont systemFontOfSize:15];
        label2.text = [NSString stringWithFormat:@"%@" , dic[@"changeCount"]];
        label2.textColor = [ResourceManager mainColor];//[ResourceManager navgationTitleColor];
        label2.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label2];
        
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-10 - 80, 20)];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = [UIColor grayColor];
        label3.text =  dic[@"createTime"];
        [cell addSubview:label3];
    }
    
    
    
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
    lable1.text = @"没有兑换记录～";
    
    
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
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDGqueryShopRecord];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    //params[@"status"] = @(1);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      [self endRefresh];
                                                                                  }];
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
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

/*
 *  结束刷新
 */
-(void)endRefresh{
    _isLoading = NO;
    [_tableView.mj_header endRefreshing]; // 结束刷新
    [_tableView.mj_footer endRefreshing]; // 结束刷新
}






@end
