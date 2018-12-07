//
//  BatretInfoVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/20.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "BatretInfoVC.h"

@interface BatretInfoVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CustomNavigationBarView  *nav;
    
    UIView *viewSQHH;  // 申请换货view
    UITextField *fieldHHYY;
    NSDictionary *dicHH;
    
    UIImageView *img1;       //  图片1
    NSString    *strImgUrl1;
    UIImageView *img2;       //  图片2
    NSString    *strImgUrl2;
    UIImageView *img3;       //  图片3
    NSString    *strImgUrl3;
    int iSelImg;
    
    UIView *viewHHXQ;  // 换货详情view
    UILabel *labelWLDH;
    
    
    UIView *viewTXWL;  // 填写换货物流view
    UITextField *field1;
    UITextField *field2;
    
}
@end

@implementation BatretInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nav = [self layoutNaviBarViewWithTitle:@"申请换货"];

    
    [self getBatretDetail];

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

#pragma mark ---  网络通讯
-(void) getBatretDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 我的竞拍—— 换货查询
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDqueryExcGoodsInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    parmas[@"ownId"] = _dicData[@"ownId"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

- (void) comitSQHH
{
    if (!strImgUrl1 ||
        strImgUrl1.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"必须上传图片" toView:self.view];
        return;
     }
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDexchangeGoods];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ownId"] = dicHH[@"ownId"];
    params[@"orderId"] = dicHH[@"orderId"];
    params[@"auctionId"] = dicHH[@"auctionId"];
    params[@"exchangeId"] = dicHH[@"exchangeId"];
    if (strImgUrl1) {
        params[@"imgUrl1"] = strImgUrl1;
    }
    if (strImgUrl2) {
        params[@"imgUrl2"] = strImgUrl2;
    }
    if (strImgUrl3) {
        params[@"imgUrl3"] = strImgUrl3;
    }
    if (fieldHHYY.text.length > 0)
     {
        params[@"excGoodsExplain"] = fieldHHYY.text;
     }
    
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


- (void) comitTJWL
{

    if (!field1.text ||
        field1.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请填写物流公司" toView:self.view];
        return;
     }
    if (!field2.text ||
        field2.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请填写物流单号" toView:self.view];
        return;
     }
    
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDexchangeLogistics];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ownId"] = dicHH[@"ownId"];
    params[@"orderId"] = dicHH[@"orderId"];
    params[@"auctionId"] = dicHH[@"auctionId"];
    params[@"exchangeId"] = dicHH[@"exchangeId"];
    params[@"logisticsName"] = field1.text;
    params[@"expressNo"] = field2.text;
    
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

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    if (1000 == operation.tag)
     {
        dicHH = operation.jsonResult.attr;
        
        [self layoutUI:dicHH];
     }
    
    if (1001 == operation.tag)
     {
        //[MBProgressHUD showSuccessWithStatus:@"申请换货提交成功"   toView:self.view];
        //NSDictionary *dic = operation.jsonResult.attr;
        
        [self getBatretDetail];
        
     }
}

#pragma mark ---  布局UI
-(void) layoutUI:(NSDictionary*) dicAttr
{

    
    //换货状态（0未审核 1待审核 2已审核  3商品已寄回 4商品已发货 5换货成功 6 申请拒绝  7换货失败
    int iStatus = [dicAttr[@"status"] intValue];
    if (0 == iStatus)
     {
        nav.titleLab.text = @"申请换货";
        [self layoutSQHH:dicAttr];
     }
    else if (1 == iStatus)
     {
        nav.titleLab.text = @"换货详情";
        [self layoutHHXQ:dicAttr];
     }
    else if (2 == iStatus)
     {
        nav.titleLab.text = @"填写换货物流";
        [self layoutTJWL];
     }
    else
     {
        nav.titleLab.text = @"换货详情";
        [self layoutHHXQ:dicAttr];
     }
}

#pragma mark ---  布局申请换货
-(void) layoutSQHH:(NSDictionary *) dicAttr
{
    int iViewHeight = SCREEN_HEIGHT - NavHeight;
    viewTXWL = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, iViewHeight)];
    [self.view addSubview:viewTXWL];
    viewTXWL.backgroundColor = [UIColor whiteColor];
    
    UIScrollView  *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iViewHeight - 60)];
    [viewTXWL addSubview:scView];
    scView.contentSize = scView.contentSize = CGSizeMake(0, 500);
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = dicAttr;
    int iTopY = 15;
    int iLeftX = 15;
    int iImgWidht = 130;

    UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX,iTopY , iImgWidht, iImgWidht)];
    [scView addSubview:imgReal];
    imgReal.layer.cornerRadius = 10;
    imgReal.layer.masksToBounds = YES;
    NSString *strImgUrl = dic[@"detailImgUrl"];
    if (strImgUrl)
     {
        [imgReal setImageWithURL:[NSURL URLWithString:strImgUrl]];
     }
    
    
    iLeftX += imgReal.width + 10;
    iTopY += 5;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX , 30)];
    [scView addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:16];
    labelName.textColor = [ResourceManager color_1];
    labelName.text = dic[@"auctionName"];//@"幸运币";
    labelName.numberOfLines = 0;
    [labelName sizeToFit];
    
    // 分割线1
    iTopY += imgReal.height + 15;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [scView addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 换货原因
    iTopY += viewFG1.height + 20;
    iLeftX = 15;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scView addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [ResourceManager color_1];
    lable1.text = @"换货说明";
    
    fieldHHYY = [[UITextField alloc] initWithFrame:CGRectMake(110, iTopY, SCREEN_WIDTH - 120, 20)];
    [scView addSubview:fieldHHYY];
    fieldHHYY.font = [UIFont systemFontOfSize:14];
    fieldHHYY.textColor = [ResourceManager color_1];
    fieldHHYY.placeholder = @"请选填";
    if (dic[@"excGoodsExplain"])
     {
        fieldHHYY.text = dic[@"excGoodsExplain"];
     }
    
    // 分割线2
    iTopY += lable1.height + 20;
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [scView addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 换货人  换货地址
    iTopY += viewFG1.height + 15;
    iLeftX = 15;
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [scView addSubview:lable2];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = [ResourceManager color_1];
    lable2.text =  [NSString stringWithFormat:@"收货人          %@", dic[@"realname"]];  //@"换货原因";
    
    UILabel *lable2_V = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, iTopY, 190, 20)];
    [scView addSubview:lable2_V];
    lable2_V.font = [UIFont systemFontOfSize:14];
    lable2_V.textColor = [ResourceManager color_1];
    lable2_V.textAlignment = NSTextAlignmentRight;
    lable2_V.text = dic[@"telephone"];
    
    iTopY += lable2.height + 10;
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 70, 20)];
    [scView addSubview:lable3];
    lable3.font = [UIFont systemFontOfSize:14];
    lable3.textColor = [ResourceManager color_1];
    lable3.text =  @"收货地址";
    
    iLeftX += lable3.width + 10;
    UILabel *lable3_V = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 50)];
    [scView addSubview:lable3_V];
    lable3_V.font = [UIFont systemFontOfSize:14];
    lable3_V.textColor = [ResourceManager color_1];
    lable3_V.numberOfLines = 0;
    lable3_V.text = dic[@"receivingAddress"];
    [lable3_V sizeToFit];
    
    
    // 分割线3
    iTopY += lable3_V.height + 20;
    UIView *viewFG3 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [scView addSubview:viewFG3];
    viewFG3.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    // 上传凭证 和图片
    iTopY += viewFG3.height + 15;
    iLeftX = 15;
    UILabel *labelSCPZ = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, 100, 20)];
    [scView addSubview:labelSCPZ];
    labelSCPZ.font = [UIFont systemFontOfSize:14];
    labelSCPZ.textColor = [ResourceManager color_1];
    labelSCPZ.text = @"上传凭证";
    
    iTopY += labelSCPZ.height +20;
    int iImgWdith = (SCREEN_WIDTH - 4*iLeftX ) /3;
    int iImgLeft = iLeftX;
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    img1.tag = 1;
    [img1 setImage:[UIImage imageNamed:@"bid_sctp"]];
    img1.userInteractionEnabled = YES;
    [scView addSubview:img1];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img1 addGestureRecognizer:imgGesture];
    
    iImgLeft += iImgWdith + iLeftX;
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img2 setImage:[UIImage imageNamed:@"bid_sctp"]];
    img2.tag = 2;
    img2.userInteractionEnabled = YES;
    img2.hidden = YES;
    [scView addSubview:img2];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img2 addGestureRecognizer:imgGesture2];
    
    iImgLeft += iImgWdith + iLeftX;
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img3 setImage:[UIImage imageNamed:@"bid_sctp"]];
    img3.tag = 3;
    img3.userInteractionEnabled = YES;
    img3.hidden = YES;
    [scView addSubview:img3];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img3 addGestureRecognizer:imgGesture3];
    
    strImgUrl1 = nil;
    strImgUrl2 = nil;
    strImgUrl3 = nil;
    
    strImgUrl1 = dic[@"imgUrl1"];
    if (strImgUrl1 &&
        strImgUrl1.length > 0)
     {
        [img1 sd_setImageWithURL:[NSURL URLWithString:strImgUrl1] placeholderImage:[UIImage imageNamed:@"bid_sctp"]];
        img2.hidden = NO;
     }
    
    strImgUrl2 = dic[@"imgUrl2"];
    if (strImgUrl2 &&
        strImgUrl2.length > 0)
     {
        [img2 sd_setImageWithURL:[NSURL URLWithString:strImgUrl2] placeholderImage:[UIImage imageNamed:@"bid_sctp"]];
        img3.hidden = NO;
     }
    
    strImgUrl3 = dic[@"imgUrl3"];
    if (strImgUrl3 &&
        strImgUrl3.length > 0)
     {
        [img3 sd_setImageWithURL:[NSURL URLWithString:strImgUrl3] placeholderImage:[UIImage imageNamed:@"bid_sctp"]];
        img3.hidden = NO;
     }
    
    iTopY += img1.height + 15;
    iLeftX = 15;
    UILabel *labelGHSM = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 50)];
    [scView addSubview:labelGHSM];
    labelGHSM.font = [UIFont systemFontOfSize:14];
    labelGHSM.textColor = [ResourceManager lightGrayColor];
    labelGHSM.text = dic[@"excGoodsDesc"];
    [labelGHSM sizeToFit];
    
    // 调整scView 的滚动范围
    iTopY += labelGHSM.height + 10;
    scView.contentSize = scView.contentSize = CGSizeMake(0, iTopY);
    
    iTopY = viewTXWL.height - 50;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [viewTXWL addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"提交" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    btnOK.cornerRadius = btnOK.height/2;
    [btnOK addTarget:self action:@selector(comitSQHH) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark ---  布局换货详情
-(void) layoutHHXQ:(NSDictionary *) dicAttr
{
    int iViewHeight = SCREEN_HEIGHT - NavHeight;
    viewHHXQ = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, iViewHeight)];
    [self.view addSubview:viewHHXQ];
    viewHHXQ.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [viewHHXQ addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 30;
    int iImgWidht = 50;
    int iImgLeft = (SCREEN_WIDTH - iImgWidht)/2;
    UIImageView  *imgOK = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWidht, iImgWidht)];
    [viewHHXQ addSubview:imgOK];
    imgOK.image = [UIImage imageNamed:@"com_gou_sel"];
    
    iTopY += imgOK.height + 10;
    UILabel  *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 25)];
    [viewHHXQ addSubview:labelInfo];
    labelInfo.textColor = [ResourceManager mainColor];
    labelInfo.font = [UIFont systemFontOfSize:16];
    labelInfo.textAlignment = NSTextAlignmentCenter;
    NSString *strInfo = @"等待客服处理换货申请";
    //换货状态（0未审核 1待审核 2已审核  3商品已寄回 4商品已发货 5换货成功 6 申请拒绝  7换货失败
    int iStatus = [dicAttr[@"status"] intValue];
    if (3 == iStatus)
     {
        strInfo = @"等待商家收货";
     }
    else if (4 == iStatus)
     {
        strInfo = @"商品已发货";
     }
    else if (5 == iStatus)
     {
        strInfo = @"换货成功";
     }
    else if (6 == iStatus)
     {
        strInfo = @"换货被拒绝";
     }
    labelInfo.text = strInfo;
    

    iTopY = viewHead.height + 15;
    UIView *viewOther = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1500)];
    [viewHHXQ addSubview:viewOther];
    viewOther.backgroundColor = [UIColor whiteColor];
    
    // 非审核状态
    if (1 != iStatus)
     {
        viewOther.hidden = YES;
        
        NSString *expressNo = dicHH[@"expressNo"];
        // 物流信息
        if (expressNo &&
            expressNo.length > 0)
         {
            viewOther.hidden = NO;
            viewOther.height = 80;
            
            int iTempLeftX = 15;
            int iTempTopY = 15;
            UIImageView *imgWL = [[UIImageView alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 46, 46)];
            [viewOther addSubview:imgWL];
            imgWL.image =[UIImage imageNamed:@"bid_wl"];
            
            iTempLeftX = 15 + imgWL.width + 10;
            iTempTopY +=5;
            UILabel *labe11 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 50, 15)];
            [viewOther addSubview:labe11];
            labe11.font = [UIFont systemFontOfSize:14];
            labe11.textColor = [ResourceManager lightGrayColor];
            labe11.text = @"物流公司:";
            [labe11 sizeToFit];
            
            UILabel *label1V = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX + labe11.width + 5, iTempTopY, 100, 15)];
            [viewOther addSubview:label1V];
            label1V.font = [UIFont systemFontOfSize:14];
            label1V.textColor = [ResourceManager color_1];
            label1V.text = dicHH[@"logisticsName"];//@"中通快递";
            
            iTempTopY += labe11.height + 5;
            UILabel *labe12 = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, 50, 15)];
            [viewOther addSubview:labe12];
            labe12.font = [UIFont systemFontOfSize:14];
            labe12.textColor = [ResourceManager lightGrayColor];
            labe12.text = @"物流单号:";
            [labe12 sizeToFit];
            
            iTempLeftX = 15 + imgWL.width + 10 + labe12.width + 5;
            labelWLDH = [[UILabel alloc] initWithFrame:CGRectMake(iTempLeftX, iTempTopY, SCREEN_WIDTH - iTempLeftX - 90, 15)];
            [viewOther addSubview:labelWLDH];
            labelWLDH.font = [UIFont systemFontOfSize:14];
            labelWLDH.textColor = [ResourceManager color_1];
            labelWLDH.text = expressNo;//@"12234124324123";
                                       //label2V.backgroundColor = [UIColor yellowColor];
            
            UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, iTempTopY-7, 70, 25)];
            [viewOther addSubview:btnCopy];
            btnCopy.borderWidth = 1;
            btnCopy.borderColor = [ResourceManager color_5];
            btnCopy.cornerRadius = btnCopy.height/2;
            [btnCopy setTitle:@"复制" forState:UIControlStateNormal];
            [btnCopy setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
            btnCopy.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnCopy addTarget:self action:@selector(actionCopy) forControlEvents:UIControlEventTouchUpInside];
            
            iTopY += viewOther.height + 10;
         }

        return;
     }
    
    int iOtherTopY = 15;
    int iOtherLeftX = 15;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iOtherLeftX, iOtherTopY, SCREEN_WIDTH - 2*iOtherLeftX, 50)];
    [viewOther addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.numberOfLines = 0;
    label1.text = @"*  若商家同意：换货申请达成，请你及时退货";
    [label1 sizeToFit];
    
    iOtherTopY += label1.height + 10;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iOtherLeftX, iOtherTopY, SCREEN_WIDTH - 2*iOtherLeftX, 50)];
    [viewOther addSubview:label2];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.numberOfLines = 0;
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
    NSString *strWX = [NSString stringWithFormat:@"*  若商家拒绝：换货申请将关闭，您可以联系客服协商处理,客服微信:  %@",dicUser[@"kfWeiXin"]];
    label2.text = strWX;
    [label2 sizeToFit];
    
    iTopY += label2.height + 100;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 35)];
    [viewHHXQ addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"修改申请" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    btnOK.cornerRadius = btnOK.height/2;
    [btnOK addTarget:self action:@selector(actionChange) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark ---  布局审核通过UI （提交物流信息）
-(void) layoutTJWL
{
    
    int iViewTXWLHeight = SCREEN_HEIGHT - NavHeight;
    viewTXWL = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, iViewTXWLHeight)];
    [self.view addSubview:viewTXWL];
    viewTXWL.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTopY =  25;
    int iLeftX = 15;
    int iViewWdith = SCREEN_WIDTH - 2*iLeftX;
    int iViewHeight = 60;
    

    
    // 物流公司view
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, iViewHeight)];
    [viewTXWL addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    view1.cornerRadius = 5;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, iViewHeight)];
    [view1 addSubview:label1];
    label1.textColor = [ResourceManager lightGrayColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"物流公司";
    
    field1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, iViewWdith-110, iViewHeight)];
    [view1 addSubview:field1];
    field1.placeholder = @"请输入物流公司";
    field1.textColor = [ResourceManager color_1];
    field1.font = [UIFont systemFontOfSize:15];
    
    //快递单号View
    iTopY += view1.height + 15;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, iViewHeight)];
    [viewTXWL addSubview:view2];
    view2.backgroundColor = [UIColor whiteColor];
    view2.cornerRadius = 5;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, iViewHeight)];
    [view2 addSubview:label2];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"快递单号";
    
    field2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, iViewWdith-110, iViewHeight)];
    [view2 addSubview:field2];
    field2.placeholder = @"请输入快递单号";
    field2.textColor = [ResourceManager color_1];
    field2.font = [UIFont systemFontOfSize:15];
    
    iTopY += view2.height + 15;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
    [viewTXWL addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"提交" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    btnOK.cornerRadius = btnOK.height/2;
    [btnOK addTarget:self action:@selector(comitTJWL) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark  ---   action
-(void) imgBtn:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    int iTag = (int)[singleTap view].tag;
    iSelImg = iTag;
    NSLog(@"iTag:%d",iTag);
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
     {
        return;
     }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.allowsEditing = YES;
    
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

-(void) actionChange
{
    [self layoutSQHH:dicHH];
}

-(void) actionCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = labelWLDH.text;
    [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:self.view];
}


#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //    //先把原图保存到图片库
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //     {
    //        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    //     }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *
 *  @param image
 *
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
     {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
     }else{
         CGFloat ratio = image.size.width / image.size.height;
         CGSize size = CGSizeZero;
         
         if (image.size.width > imageSize.width)
          {
             size.width = imageSize.width;
             size.height = size.width / ratio;
          }
         else if (image.size.height > imageSize.height)
          {
             size.height = imageSize.height;
             size.width = size.height * ratio;
          }
         else
          {
             size.width = image.size.width;
             size.height = image.size.height;
          }
         //这里的size是最终获取到的图片的大小
         UIGraphicsBeginImageContext(imageSize);
         CGRect rect = CGRectZero;
         rect.size = imageSize;
         //先填充整个图片区域的颜色为黑色
         CGContextRef ctx = UIGraphicsGetCurrentContext();
         CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
         CGContextFillRect(ctx, rect);
         rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
         rect.size = size;
         //画图
         [image drawInRect:rect];
         image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
     }
    return image;
}

-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"xjExchangeImg";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xdjlIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        //把图片添加到视图框内
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            //[self handleData];
            //_headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
            
            if (iSelImg == 1)
             {
                img1.image=[UIImage imageWithData:self.imageData];
                strImgUrl1 = [(NSDictionary *)json objectForKey:@"fileId"];
                img2.hidden = NO;
                
             }
            else if (iSelImg == 2)
             {
                img2.image=[UIImage imageWithData:self.imageData];
                strImgUrl2 = [(NSDictionary *)json objectForKey:@"fileId"];
                img3.hidden = NO;
             }
            else if (iSelImg == 3)
             {
                img3.image=[UIImage imageWithData:self.imageData];
                strImgUrl3 = [(NSDictionary *)json objectForKey:@"fileId"];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}


@end
