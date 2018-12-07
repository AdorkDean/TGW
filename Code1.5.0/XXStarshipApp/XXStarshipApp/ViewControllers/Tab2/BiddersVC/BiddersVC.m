//
//  BiddersVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/5.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "BiddersVC.h"

const  int  iViewPopHeight = 400;

@interface BiddersVC ()<UITextFieldDelegate>
{
    UIImageView *imgShop;
    UILabel *labelShopName;
    UILabel *labelPrice;
    UITextField  *fidldValue;
    UILabel *labelChangeCount;
    UILabel *labelYourPice;
    
    UIScrollView *scList;
    NSArray *arrList;
    UILabel  *lableNote;
    
    UIView *background; //填出页面的背景
    UIView *viewPop;  // 弹出页面（输入竞拍价格）
    UIButton * caseBackBtn;  // 关闭按钮
    NSString *surplusCoinCount; // 个人的剩余天狗币
    
    dispatch_source_t _timer1;  // 定时器1,用于竞拍列表的计时
    UILabel  *lableTime;   //  时间lable
    UILabel *labelEndTime;
    NSString  *stringTime;  //  时间字符串
}
@end

@implementation BiddersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"竞拍详情"];

    [self layoutUI];
    
    [self getBiddersInfo];
    
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
    
}

-(void) viewWillDisappear:(BOOL)animated
{


    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        dispatch_source_cancel(_timer1);
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
     }
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    int iTopY = NavHeight;
    int iLeftX = 0;
    
    
    int iImgShopWidth = 150;
    if (IS_IPHONE_5_OR_LESS)
     {
        iImgShopWidth = 120;
     }
    iTopY += 20;
    iLeftX =  (SCREEN_WIDTH - iImgShopWidth)/2;
    UIView *viewHeadBG = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,  2*20 + iImgShopWidth )];
    [self.view addSubview:viewHeadBG];
    viewHeadBG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    imgShop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iImgShopWidth, iImgShopWidth)];
    [self.view addSubview:imgShop];
    NSString *strImgUrl = _dicData[@"detailImgUrl"];
    if (strImgUrl)
     {
        [imgShop setImageWithURL:[NSURL URLWithString:strImgUrl]];
     }
    
    iTopY += imgShop.height + 20;
    iLeftX = 0;
    lableTime = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 30)];
    [self.view addSubview:lableTime];
    lableTime.font = [UIFont systemFontOfSize:14];
    lableTime.backgroundColor = [ResourceManager mainColor];
    lableTime.textColor = [UIColor whiteColor];
    NSString *strTime = [NSString stringWithFormat:@"    剩余时间%@", _dicData[@"countDownTime"]];
    lableTime.text = strTime;
    

    if (_isEnd)
     {
        lableTime.text = @"      已结束";
     }
    
    
    // 项目名
    int iLabelBetween = 20;
    if (IS_IPHONE_5_OR_LESS)
     {
        iLabelBetween = 10;
     }
    iTopY += lableTime.height + iLabelBetween;
    iLeftX = 15;
    labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX, 20)];
    [self.view addSubview:labelShopName];
    labelShopName.textColor = [ResourceManager color_1];
    labelShopName.font = [UIFont systemFontOfSize:16];
    labelShopName.text = [NSString stringWithFormat:@"%@",_dicData[@"auctionName"]];
    
    // 截止竞拍时间
    iTopY += lableTime.height + 5;
    labelEndTime = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 250, 20)];
    [self.view addSubview:labelEndTime];
    labelEndTime.textColor = [ResourceManager mainColor];
    labelEndTime.font = [UIFont systemFontOfSize:13];
    //labelEndTime.text =  [NSString stringWithFormat:@"截止竞拍时间为：%@", _dicData[@"endTime"]];// @"截止竞拍时间为：";
    
    
    // 价格
    iTopY += labelShopName.height +iLabelBetween;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.text = @"当前价：";
    
    labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 60, iTopY-5, 200, 25)];
    [self.view addSubview:labelPrice];
    labelPrice.textColor = [ResourceManager mainColor];
    labelPrice.font = [UIFont systemFontOfSize:30];
    labelPrice.text = [NSString stringWithFormat:@"%@", _dicData[@"currentPrice"]];
    
    
    // 参与次数
    iTopY += label1.height +iLabelBetween;
    labelChangeCount = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:labelChangeCount];
    labelChangeCount.textColor = [ResourceManager lightGrayColor];
    labelChangeCount.font = [UIFont systemFontOfSize:13];
    labelChangeCount.text = [NSString stringWithFormat:@"竞拍次数 %@", _dicData[@"auctionCount"]];
    
    // 您的出价
    labelYourPice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 20)];
    [self.view addSubview:labelYourPice];
    labelYourPice.textColor = [ResourceManager color_1];
    labelYourPice.font = [UIFont systemFontOfSize:13];
    labelYourPice.text = @"";//[NSString stringWithFormat:@"参与次数 %@", _dicData[@"auctionCount"]];
    int iPrice = [_dicData[@"ownOfferPrice"] intValue];
    if (iPrice > 0)
     {
        labelYourPice.text = [NSString stringWithFormat:@"您的出价 %@", _dicData[@"ownOfferPrice"]];
        
        labelChangeCount.left = iLeftX + 150;
     }
    
    iTopY += labelChangeCount.height +10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    iTopY += viewFG.height + 10;
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:labelTitle2];
    labelTitle2.font = [UIFont systemFontOfSize:15];
    labelTitle2.textColor = [ResourceManager color_1];
    labelTitle2.text = @"竞拍记录";
    
    iTopY += labelTitle2.height + 10;
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
    [self.view addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    iTopY += 1;
    int iBtnHeight = 45;
    if (IS_IPHONE_5_OR_LESS)
     {
        iBtnHeight = 40;
     }
    int iListHeight = SCREEN_HEIGHT - iTopY - iBtnHeight;
    scList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iListHeight)];
    [self.view addSubview:scList];
    scList.contentSize = CGSizeMake(0, iListHeight);
    scList.pagingEnabled = NO;
    scList.bounces = NO;
    scList.showsVerticalScrollIndicator = FALSE;
    scList.showsHorizontalScrollIndicator = FALSE;
    scList.backgroundColor = [UIColor whiteColor];
    [self getRecord];
    
    
    iTopY = SCREEN_HEIGHT - iBtnHeight;
    lableNote = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH*2/3, iBtnHeight)];
    [self.view addSubview:lableNote];
    lableNote.backgroundColor = [UIColor whiteColor];
    lableNote.font = [UIFont systemFontOfSize:14];
    lableNote.textColor = [ResourceManager color_1];
    lableNote.text = @"    您共参与竞拍0次";
    
    UIView  *viewLableFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH*2/3, 1)];
    [self.view addSubview:viewLableFG];
    viewLableFG.backgroundColor = [ResourceManager color_5];
    
    UIButton *btnChange = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, iTopY, SCREEN_WIDTH/3, iBtnHeight)];
    [self.view addSubview:btnChange];
    btnChange.backgroundColor = [ResourceManager mainColor];
    [btnChange setTitle:@"竞拍" forState:UIControlStateNormal];
    btnChange.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnChange addTarget:self action:@selector(actionBidders) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isEnd)
     {
        btnChange.userInteractionEnabled = NO;
        btnChange.backgroundColor = [ResourceManager lightGrayColor];
        
        //label2.text =  [NSString stringWithFormat:@"截止竞拍时间为："];
     }
    
    
}

-(void) layoutList:(NSArray*) arr
{
    [scList removeAllSubviews];
    int iTopY = 0;
    int iLeftX = 10;
    int iCellHeight = 45;
    for (int i = 0;  i < [arrList count]; i++)
     {
        NSDictionary *dic = arrList[i];
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [scList addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelNo = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 100, iCellHeight)];
        [viewCell addSubview:labelNo];
        NSString *strTemp = dic[@"nickName"];
        labelNo.textColor = [ResourceManager mainColor];
        labelNo.font = [UIFont systemFontOfSize:14];
        labelNo.text = strTemp;
        
        int iMidWidht = 95;
        if (IS_IPHONE_5_OR_LESS)
         {
            iMidWidht = 45;
         }
        UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 100 +10, 0, iMidWidht, iCellHeight)];
        [viewCell addSubview:labelCount];
        strTemp = [NSString stringWithFormat:@"%@", dic[@"offerPrice"]];
        labelCount.textColor = [ResourceManager mainColor];
        labelCount.font = [UIFont systemFontOfSize:14];
        labelCount.text = strTemp;
        
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 0, 150, iCellHeight)];
        [viewCell addSubview:labelTime];
        strTemp =   [NSString stringWithFormat:@"%@", dic[@"createTime"]];
        labelTime.textColor = [ResourceManager mainColor];
        labelTime.font = [UIFont systemFontOfSize:14];
        labelTime.text = strTemp;
        
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellHeight;
     }
    
    scList.contentSize = CGSizeMake(0, iTopY+iCellHeight);
    
}

-(void) layoutPop
{
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    
    // 创建背景框
    viewPop = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - iViewPopHeight,  SCREEN_WIDTH , iViewPopHeight  ) ];
    viewPop.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:viewPop];
    
    
    // 关闭按钮
    caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, SCREEN_HEIGHT - iViewPopHeight-51,30, 51)];
    [bgView addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = YES;
    [caseBackBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    

    int iCellLeftX = 15;
    int iCellTopY = 20;
    int iCellImgWidht = 130;
    // 商品的图片
    
    UIView *imgShop = [[UIView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellImgWidht, iCellImgWidht)];
    [viewPop addSubview:imgShop];
    imgShop.backgroundColor = UIColorFromRGB(0xf4f4f4);
    imgShop.layer.cornerRadius = 15;
    imgShop.layer.masksToBounds = YES;
    
    UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iCellImgWidht, iCellImgWidht)];
    [imgShop addSubview:imgReal];
    NSString *strImgUrl = _dicData[@"detailImgUrl"];
    if (strImgUrl)
     {
        [imgReal setImageWithURL:[NSURL URLWithString:strImgUrl]];
     }
    

    
    // 名称
    iCellLeftX += imgShop.width + 10;
    iCellTopY += 5;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 30)];
    [viewPop addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = _dicData[@"auctionName"];//@"幸运币";
    labelName.numberOfLines = 0;
    [labelName sizeToFit];
    
    
    // 当前描述
    iCellTopY += 30 + 10;
    UILabel *labelDes2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
    [viewPop addSubview:labelDes2];
    labelDes2.font = [UIFont systemFontOfSize:12];
    labelDes2.textColor = [ResourceManager lightGrayColor];
    labelDes2.text =  _dicData[@"priceDesc"]; //@"当前价(幸运币)";
    
    // 当前价
    iCellTopY += labelDes2.height + 8;
    UILabel *labelPriceT = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
    [viewPop addSubview:labelPriceT];
    labelPriceT.font = [UIFont systemFontOfSize:18];
    labelPriceT.textColor = [ResourceManager mainColor];
    labelPriceT.text =   labelPrice.text;//[NSString stringWithFormat:@"%@", _dicData[@"currentPrice"]]; //@"1";
    
    // 状态
    iCellTopY += labelPrice.height + 8;
    UILabel *labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
    [viewPop addSubview:labelStauts];
    labelStauts.font = [UIFont systemFontOfSize:12];
    labelStauts.textColor = [ResourceManager mainColor];
    labelStauts.text = @"进行中";
    
    // 参与次数
    iCellTopY += labelStauts.height;
    NSString *strcountValue = [NSString stringWithFormat:@"参与次数 %@", _dicData[@"auctionCount"]];
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
    [viewPop addSubview:labelCount];
    labelCount.font = [UIFont systemFontOfSize:12];
    labelCount.textColor = [ResourceManager lightGrayColor];
    labelCount.text = strcountValue;//@"参与次数 6";
    
    iCellTopY += labelCount.height +20;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
    [viewPop addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    iCellTopY += 15;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iCellTopY, SCREEN_WIDTH, 20)];
    [viewPop addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = [NSString stringWithFormat:@"请输入竞拍价格(最多加%@TGW)", _dicData[@"risesRange"]];
    
    
    iCellTopY += labelTitle.height + 15;
    fidldValue = [[UITextField alloc] initWithFrame:CGRectMake(80, iCellTopY, SCREEN_WIDTH - 160, 46)];
    [viewPop addSubview:fidldValue];
    fidldValue.backgroundColor = [UIColor whiteColor];
    fidldValue.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    fidldValue.layer.borderWidth = 0.3;
    fidldValue.layer.cornerRadius = 5;
    fidldValue.textAlignment =  NSTextAlignmentCenter;
    fidldValue.font = [UIFont systemFontOfSize:18];
    fidldValue.textColor = [ResourceManager mainColor];
    fidldValue.placeholder = @"请输入";
    fidldValue.keyboardType = UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    fidldValue.tag = 1000;
    fidldValue.delegate = self;
    
    iCellTopY += fidldValue.height + 15;
    UILabel *labelSYTWG = [[UILabel alloc] initWithFrame:CGRectMake(0, iCellTopY, SCREEN_WIDTH, 20)];
    [viewPop addSubview:labelSYTWG];
    labelSYTWG.font = [UIFont systemFontOfSize:13];
    labelSYTWG.textColor = [ResourceManager lightGrayColor];
    labelSYTWG.textAlignment = NSTextAlignmentCenter;
    labelSYTWG.text = [NSString stringWithFormat:@"剩余TGW: %@", surplusCoinCount];
    
    iCellTopY += labelSYTWG.height + 25;
    UIButton * btnOK = [[UIButton alloc] initWithFrame:CGRectMake(30, iCellTopY, SCREEN_WIDTH - 60, 45)];
    [viewPop addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    btnOK.cornerRadius = 45/2;
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    

}

-(void)closeView{
    [background removeFromSuperview];
}


#pragma mark ---  定时器
-(void) creatTime
{
    //static long long  llTimeCount = 0;
    

    if (_isEnd)
     {
        return;
     }
    
    if (_timer1)
     {
        // 关闭定时器
//        dispatch_source_cancel(_timer1);
//        _timer1 = nil;
        
        return;
     }
    
    //设置时间间隔
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer1, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // block 会立马执行一遍，后面隔一定时间间隔再执行一次
    dispatch_source_set_event_handler(_timer1, ^{
        // 定时器事件回调
        //        llTimeCount++;
        //        NSLog(@"定时器%lld次运行" ,llTimeCount);
        [self setStringTime];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中实现需要的功能 （UI操作）
            NSString *strTime = [NSString stringWithFormat:@"    剩余时间%@", stringTime];
            lableTime.text = strTime;
      
        
        });
        
    });
    
    dispatch_resume(_timer1);
    
    
}

-(void) setStringTime
{
    
    
    NSString *strTemp = stringTime;
    NSArray *array = [strTemp componentsSeparatedByString:@":"]; //字符串按照:分隔成数组
    if ([array count] >= 3)
     {
        int iSecond = [array[2] intValue];
        int iMinute = [array[1] intValue];
        int iHour = [array[0] intValue];
        
        int iTotalSecond  = iHour*3600 + iMinute*60 + iSecond;
        iTotalSecond -=1;
        if (iTotalSecond > 0)
         {
            NSString *str_hour = [NSString stringWithFormat:@"%02d",iTotalSecond/3600];
            NSString *str_minute = [NSString stringWithFormat:@"%02d",(iTotalSecond%3600)/60];
            NSString *str_second = [NSString stringWithFormat:@"%02d",iTotalSecond%60];
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            //替换指定下标的元素
            stringTime = format_time;
            
            if (iTotalSecond %5 == 0)
             {
                [self getBiddersInfoOnSecond];
             }
         }
        else
         {
            // 倒计时到最后一秒
            if (_timer1)
             {
                // 关闭定时器
                dispatch_source_cancel(_timer1);
                _timer1 = nil;
             }
            
         }
        
     }
        
    
}


#pragma mark ---  网络通讯
-(void) getBiddersInfo
{
    
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionDetail];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"auctionId"] =  [NSString stringWithFormat:@"%@", _dicData[@"auctionId"]];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) getBiddersInfoOnSecond
{
    
    //[LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionDetail];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"auctionId"] =  [NSString stringWithFormat:@"%@", _dicData[@"auctionId"]];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void) getRecord
{

    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"auctionId"] = [NSString stringWithFormat:@"%@", _dicData[@"auctionId"]];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void) getBidders
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGcoinAuctionGoods];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"auctionId"] = _dicData[@"auctionId"];
    parmas[@"offerPrice"] = fidldValue.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self closeView];
                                                                                      
                                                                                      [MBProgressHUD showSuccessWithStatus:@"您已经参与竞拍，竞拍成功后会通知您。" toView:self.view];
                                                                                      
                                                                                      
                                                                                      [self performSelector:@selector(getBiddersInfo) withObject:nil afterDelay:0.5];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            lableNote.text =  [NSString stringWithFormat:@"   您共参与竞拍%@次" ,dic[@"ownAuctionCount"]];
            surplusCoinCount = dic[@"surplusCoinCount"];
            
            NSString *strImgUrl = dic[@"detailImgUrl"];
            if (strImgUrl)
             {
                [imgShop setImageWithURL:[NSURL URLWithString:strImgUrl]];
             }
            
            labelChangeCount.text = [NSString stringWithFormat:@"竞拍次数 %@", dic[@"auctionCount"]];
            
            labelPrice.text = [NSString stringWithFormat:@"%@", dic[@"currentPrice"]];
            
            
            int iPrice = [dic[@"ownOfferPrice"] intValue];
            if (iPrice > 0)
             {
                labelYourPice.text = [NSString stringWithFormat:@"您的出价 %@", dic[@"ownOfferPrice"]];
                
                labelChangeCount.left = 15 + 150;
             }
            
            // 剩余时间
            stringTime =  dic[@"countDownTime"];
            
            
            if (stringTime &&
                stringTime.length == 8)
             {
                [self creatTime];
             }
            
            labelEndTime.text =  [NSString stringWithFormat:@"截止竞拍时间为：%@", dic[@"endTime"]];// @"截止竞拍时间为：";
         }
        
        [self getRecord];
        
     }
    else if (1001 == operation.tag)
     {
        arrList = operation.jsonResult.rows;
        if ([arrList count] > 0)
         {
            
            [self layoutList:arrList];
         }
        else
         {
            [scList removeAllSubviews];
         }
     }
    
    
}

#pragma mark ---   action
-(void) actionBidders
{
    [self layoutPop];
}

-(void) actionOK
{
    
    if (fidldValue.text.length <= 0)
     {
        [LoadView showErrorWithStatus:@"请输入兑换值" toView:self.view];
        return;
     }
    
    float  fTemp =  [fidldValue.text floatValue];
    if (fTemp <= 0.00001)
     {
        [LoadView showErrorWithStatus:@"请输入大于0.00001的值" toView:self.view];
        return;
     }
    
    [self.view endEditing:YES];
    
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    // 降低高度
    [alertView subAlertCurHeight:10];
    alertView.textAlignment = RTTextAlignmentCenter;
    NSString *strNote = [NSString stringWithFormat:@"是否用 %@TGW 参与竞拍？",fidldValue.text];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#676767>%@</font>",strNote]];
    [alertView addAlertCurHeight:10];
    alertView.isBtnCenter = TRUE;
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self getBidders];
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
}

#pragma mark == UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[scView setContentOffset:CGPointMake(0,200) animated:YES];
    
    viewPop.top = 100;
    caseBackBtn.top = 100-51;
    
    return  YES;
}




@end
