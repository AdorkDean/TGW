//
//  ChangeVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/5.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "ChangeVC.h"

@interface ChangeVC ()
{
    UIImageView *imgShop;
    UILabel *labelShopName;
    UILabel *labelPrice;
    UITextField  *fidldValue;
    UILabel *labelChangeCount;
    
    UIScrollView *scList;
    NSArray *arrList;
    UILabel  *lableNote;
}
@end

@implementation ChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"兑换详情"];
    
    [self layoutUI];
    
    [self getChangInfo];

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
    NSString *strImgUrl = _dicData[@"imgUrl"];
    if (strImgUrl)
     {
        [imgShop setImageWithURL:[NSURL URLWithString:strImgUrl]];
     }
    
    iTopY += imgShop.height + 20;
    iLeftX = 0;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 30)];
    [self.view addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.backgroundColor = [ResourceManager mainColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = @"    兑换进行中";
    
    // 项目名
    int iLabelBetween = 20;
    if (IS_IPHONE_5_OR_LESS)
     {
        iLabelBetween = 10;
     }
    iTopY += labelTitle.height + iLabelBetween;
    iLeftX = 15;
    labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX, 20)];
    [self.view addSubview:labelShopName];
    labelShopName.textColor = [ResourceManager color_1];
    labelShopName.font = [UIFont systemFontOfSize:15];
    labelShopName.text = [NSString stringWithFormat:@"%@【%@】",_dicData[@"name"], _dicData[@"changeDesc"]];
    
    // 价格
    iTopY += labelShopName.height +iLabelBetween;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 20)];
    [self.view addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.text = @"价格:";
    
    labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 40, iTopY-5, 200, 25)];
    [self.view addSubview:labelPrice];
    labelPrice.textColor = [ResourceManager mainColor];
    labelPrice.font = [UIFont systemFontOfSize:30];
    labelPrice.text = [NSString stringWithFormat:@"%@", _dicData[@"changePrice"]];
    
    // 兑换数量
    iTopY += label1.height +iLabelBetween;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 80, 20)];
    [self.view addSubview:label2];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"兑换数量:";
    
    
    fidldValue = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX + 80, iTopY-5, 100, 30)];
    [self.view addSubview:fidldValue];
    fidldValue.backgroundColor = [UIColor whiteColor];
    fidldValue.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    fidldValue.layer.borderWidth = 0.3;
    fidldValue.layer.cornerRadius = 5;
    fidldValue.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示)
    fidldValue.leftViewMode = UITextFieldViewModeAlways;
    fidldValue.font = [UIFont systemFontOfSize:14];
    fidldValue.placeholder = @"请输入兑换值";
    fidldValue.text = @"1";
    fidldValue.keyboardType = UIKeyboardTypeDecimalPad;
    
    // 兑换次数
    iTopY += label1.height +iLabelBetween;
    labelChangeCount = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:labelChangeCount];
    labelChangeCount.textColor = [ResourceManager lightGrayColor];
    labelChangeCount.font = [UIFont systemFontOfSize:13];
    labelChangeCount.text = [NSString stringWithFormat:@"兑换次数 %@", _dicData[@"countValue"]];
    
    iTopY += labelChangeCount.height +10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    iTopY += viewFG.height + 10;
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [self.view addSubview:labelTitle2];
    labelTitle2.font = [UIFont systemFontOfSize:15];
    labelTitle2.textColor = [ResourceManager color_1];
    labelTitle2.text = @"兑换记录";
    
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
    lableNote.text = @"    您共参与兑换0次";
    
    UIView  *viewLableFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH*2/3, 1)];
    [self.view addSubview:viewLableFG];
    viewLableFG.backgroundColor = [ResourceManager color_5];
    
    UIButton *btnChange = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, iTopY, SCREEN_WIDTH/3, iBtnHeight)];
    [self.view addSubview:btnChange];
    btnChange.backgroundColor = [ResourceManager mainColor];
    [btnChange setTitle:@"兑换" forState:UIControlStateNormal];
    btnChange.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnChange addTarget:self action:@selector(actionChange) forControlEvents:UIControlEventTouchUpInside];
    
    
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
        strTemp = [NSString stringWithFormat:@"%@", dic[@"totalCost"]];
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

#pragma mark ---  网络通讯
-(void) getChangInfo
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryChangeDetail];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"changeId"] = _dicData[@"changeId"];
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
    
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryChangeDetailRec];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"changeId"] = _dicData[@"changeId"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void) getChange
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGcoinChangePro];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"changeId"] = _dicData[@"changeId"];
    parmas[@"changNum"] = fidldValue.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      //[self handleData:operation];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"兑换成功" toView:self.view];
                                                                                      
                                                                                      
                                                                                      [self performSelector:@selector(getChangInfo) withObject:nil afterDelay:0.5];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        NSDictionary *attr = operation.jsonResult.attr;
        if (attr)
         {
            lableNote.text =  [NSString stringWithFormat:@"   您共参与兑换%@次" ,attr[@"changeCount"]];
            
            NSString *strImgUrl = attr[@"detailImgUrl"];
            if (strImgUrl)
             {
                [imgShop setImageWithURL:[NSURL URLWithString:strImgUrl]];
             }
            
            labelChangeCount.text = [NSString stringWithFormat:@"兑换次数 %@", attr[@"countValue"]];
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
-(void) actionChange
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
    
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:10];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    //[alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>竞拍说明</font>"]];
    
    
    NSString *strNote = [NSString stringWithFormat:@"是否兑换 %@%@？",fidldValue.text,_dicData[@"name"]];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#676767>%@</font>",strNote]];
    [alertView addAlertCurHeight:10];
    
    alertView.isBtnCenter = TRUE;
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self getChange];
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
    
}

-(void) actionSM
{

}


@end
