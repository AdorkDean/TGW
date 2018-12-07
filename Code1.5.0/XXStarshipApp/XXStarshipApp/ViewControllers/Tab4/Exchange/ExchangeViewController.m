//
//  ExchangeViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/25.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "ExchangeViewController.h"

#import "ExchangeRecordViewController.h"

@interface ExchangeViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UILabel *_LPNumLabel;
    UILabel *_titleLabel;
    NSInteger _BLNum;
    NSInteger _LPNum;
    
    CGFloat _currentHeight;
    UIScrollView *_loanMesScView;
    NSInteger _loanCurrentPage;
    NSTimer *_loanScrollTimer;
    NSMutableArray *_loanMessageArr;
    
    UIView *_exchangeView;
    UIView *_alertView;
    UILabel *_exchangeNumLabel;
    UIButton *_exchangeTGWBtn;
}
@end

@implementation ExchangeViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/ticket/change/queryInfo",[PDAPI getBaseUrlString]] parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
    operation.tag = 1000;
}

#pragma mark ---数据操作---
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super handleData:operation];
    if (operation.tag == 1000) {
        if (operation.jsonResult.attr.count > 0) {
            _LPNum = [[operation.jsonResult.attr objectForKey:@"xjTicketCount"] intValue];
            _BLNum = [[operation.jsonResult.attr objectForKey:@"ticketChangeTgw"] intValue];
            _LPNumLabel.text = [NSString stringWithFormat:@"粮票：%ld",(long)_LPNum];
            _titleLabel.text = [NSString stringWithFormat:@"1张粮票可兑换%ld个天狗币",(long)_BLNum];
        }
        
        if (operation.jsonResult.rows.count > 0) {
            [_loanMessageArr addObjectsFromArray:operation.jsonResult.rows];
            [self loanMessageScViewUI];
        }
    }else if (operation.tag == 1001) {
        [MBProgressHUD showSuccessWithStatus:@"兑换成功" toView:self.view];
        [self loadData];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loanMessageArr = [NSMutableArray array];
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:@"粮票兑换"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    //导航右边按钮
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90,fRightBtnTopY,80,35)];
    [nav addSubview:rightNavBtn];
    [rightNavBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:UIColorFromRGB(0x5F57FD) forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(exchangeRecord) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self layoutUI];
    
}

-(void)exchangeRecord{
    ExchangeRecordViewController *ctl = [[ExchangeRecordViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}


-(void)layoutUI{
    
    UIImageView *bgImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 160 * ScaleSize)];
    [self.view addSubview:bgImgview];
    bgImgview.image = [UIImage imageNamed:@"Tab4-1"];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 295)/2, CGRectGetMidY(bgImgview.frame) - 39/2, 295, 39)];
    [self.view addSubview:imgview];
    imgview.image = [UIImage imageNamed:@"Tab4-2"];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imgview.bounds.size.width, imgview.bounds.size.height)];
    [imgview addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _LPNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bgImgview.frame) + 10, 150, 45)];
    [self.view addSubview:_LPNumLabel];
    _LPNumLabel.textColor = UIColorFromRGB(0x5F57FD);
    _LPNumLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 95), CGRectGetMidY(_LPNumLabel.frame) - 30/2, 80, 30)];
    [self.view addSubview:exchangeBtn];
    exchangeBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
    exchangeBtn.layer.cornerRadius = 30/2;
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_LPNumLabel.frame), SCREEN_WIDTH - 30, 0.5)];
    [self.view addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    _currentHeight = CGRectGetMaxY(viewX.frame);
    [self loanMessageScViewUI];
    
    
    UILabel *tsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loanMesScView.frame) + 25, SCREEN_WIDTH, 40)];
    [self.view addSubview:tsLabel];
    tsLabel.textAlignment = NSTextAlignmentCenter;
    tsLabel.textColor = [ResourceManager color_6];
    tsLabel.font = [UIFont systemFontOfSize:13];
    tsLabel.text = @"每天都可做今日任务获得粮票哦";
}


//兑换
-(void)exchange{
    if (_LPNum == 0) {
        [MBProgressHUD showErrorWithStatus:@"您没有粮票，完成任务获取粮票" toView:self.view];
        return;
    }
    
    [_exchangeView removeFromSuperview];
    
    _exchangeView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_exchangeView];
    _exchangeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(hidden)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [_exchangeView addGestureRecognizer:tap];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 260 * ScaleSize)/2, (SCREEN_HEIGHT - 180 * ScaleSize)/2, 260 * ScaleSize, 180 * ScaleSize)];
    [_exchangeView addSubview:_alertView];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 10;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260 * ScaleSize, 50)];
    [_alertView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"请选择粮票兑换数量";
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), 260 * ScaleSize - 30, 0.5)];
    [_alertView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    _exchangeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((_alertView.bounds.size.width - 90)/2, CGRectGetMaxY(viewX.frame) + 30, 90, 25)];
    [_alertView addSubview:_exchangeNumLabel];
    _exchangeNumLabel.textAlignment = NSTextAlignmentCenter;
    _exchangeNumLabel.textColor = [ResourceManager color_1];
    _exchangeNumLabel.font = [UIFont systemFontOfSize:14];
    _exchangeNumLabel.text = @"1";
    
    UIButton *subtractBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_exchangeNumLabel.frame) - 25, CGRectGetMinY(_exchangeNumLabel.frame), 25, 25)];
    [_alertView addSubview:subtractBtn];
    [subtractBtn setImage:[UIImage imageNamed:@"Tab4-3"] forState:UIControlStateNormal];
    [subtractBtn addTarget:self action:@selector(subtractNum) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_exchangeNumLabel.frame), CGRectGetMinY(_exchangeNumLabel.frame), 25, 25)];
    [_alertView addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"Tab4-4"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    
    
    _exchangeTGWBtn = [[UIButton alloc]initWithFrame:CGRectMake((_alertView.bounds.size.width - 150)/2, CGRectGetMaxY(_exchangeNumLabel.frame) + 30, 150, 40)];
    [_alertView addSubview:_exchangeTGWBtn];
    _exchangeTGWBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
    _exchangeTGWBtn.layer.cornerRadius = 40/2;
    [_exchangeTGWBtn setTitle:@"兑换10天狗币" forState:UIControlStateNormal];
    [_exchangeTGWBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _exchangeTGWBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_exchangeTGWBtn addTarget:self action:@selector(exchangeTGW) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)subtractNum{
    int count = [_exchangeNumLabel.text intValue];
    if (count > 1) {
        count --;
        _exchangeNumLabel.text = [NSString stringWithFormat:@"%d",count];
        [_exchangeTGWBtn setTitle:[NSString stringWithFormat:@"兑换%ld天狗币",count * _BLNum] forState:UIControlStateNormal];
    }
}

-(void)addNum{
    int count = [_exchangeNumLabel.text intValue];
    if (count < _LPNum) {
        count ++;
        _exchangeNumLabel.text = [NSString stringWithFormat:@"%d",count];
        [_exchangeTGWBtn setTitle:[NSString stringWithFormat:@"兑换%ld天狗币",count * _BLNum] forState:UIControlStateNormal];
    }
}

-(void)exchangeTGW{
    [_exchangeView removeFromSuperview];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/ticket/change/ticketChange",[PDAPI getBaseUrlString]] parameters:@{@"changeCount":_exchangeNumLabel.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
    operation.tag = 1001;
}

-(void)hidden{
//    _addAccountView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_exchangeView removeFromSuperview];
}

#pragma mark --- UIGestureRecognizerDelegate 使子控件不响应父视图手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_alertView]) {
        return NO;
    }
    return YES;
}

-(void)loanMessageScViewUI{
    [_loanMesScView removeFromSuperview];
    
    _loanMesScView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, _currentHeight + 30, SCREEN_WIDTH - 30, 45)];
    [self.view addSubview:_loanMesScView];
    _loanMesScView.layer.cornerRadius = 45/2;
    _loanMesScView.backgroundColor = UIColorFromRGB(0xECF3FA);
    _loanMesScView.bounces = NO;
    _loanMesScView.pagingEnabled = NO;
    _loanMesScView.showsVerticalScrollIndicator = NO;
    _loanMesScView.delegate = self;
    _loanCurrentPage = 0;
    _loanMesScView.contentSize = CGSizeMake(0, 45 * _loanMessageArr.count);
    
    for (int i = 0; i< _loanMessageArr.count; i++) {
        NSDictionary *dic = _loanMessageArr[i];
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 45 * i, _loanMesScView.bounds.size.width - 40, 45)];
        [_loanMesScView addSubview:titlelabel];
        titlelabel.textColor = UIColorFromRGB(0x918FBA);
        titlelabel.font = [UIFont systemFontOfSize:14];
        titlelabel.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"nickName"],[dic objectForKey:@"remark"]];
    }
    
    [self shouldAutoShow:YES];
}

#pragma mark scrollvie停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑动时候暂停自动替换
    [_loanScrollTimer invalidate];
    _loanScrollTimer = nil;
    _loanScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    
    //得到当前页数
    float y = _loanMesScView.contentOffset.y;
    
    //往前翻
    if (y<=0) {
        if (_loanCurrentPage-1<0) {
            _loanCurrentPage = (int)_loanMessageArr.count-1;
        }else{
            _loanCurrentPage --;
        }
    }
    
    //往后翻
    if (y>=40) {
        if (_loanCurrentPage==_loanMessageArr.count-1) {
            _loanCurrentPage = 0;
        }else{
            _loanCurrentPage ++;
        }
    }
    _loanMesScView.contentOffset = CGPointMake(0, 45 *_loanCurrentPage);
    
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart)  //开启自动翻页
     {
        if (!_loanScrollTimer) {
            _loanScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
     }
    else   //关闭自动翻页
     {
        if (_loanScrollTimer.isValid) {
            [_loanScrollTimer invalidate];
            _loanScrollTimer = nil;
        }
     }
}

#pragma mark 展示下一页
-(void)autoShowNextImage{
    if (_loanCurrentPage == _loanMessageArr.count-1) {
        _loanCurrentPage = 0;
    }else{
        _loanCurrentPage ++;
    }
    _loanMesScView.contentOffset = CGPointMake(0, 45 *_loanCurrentPage);
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
