//
//  Second_VC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "Second_VC.h"
#import "QuestionVC.h"
#import "ChangeVC.h"
#import "BiddersVC.h"
#import "ShopRecordVC.h"
#import "MyBiddersRecrodVC.h"


@interface Second_VC ()
{
    UIScrollView  *scView;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    int  iSelTag;   //  1 - 竞拍  ，  2 - 兑换
    
    UIButton *btnExchange;  // 我的竞拍按钮
    UIButton* btnExchangeSM;
    UILabel *labelTitle;
    
    NSMutableArray *arrBtn;
    int iJPSel;    //  0 -  进行中， 1 - 未开拍, 2- 敬请期待， 3 -已经结束
    
    int iViewListTopY;
    UIView *viewList;
    NSArray  *arrData;
    NSMutableArray  *arrLableTime;   //  时间lable的数组
    NSMutableArray  *arrCurPrice;    // 当前价的数组
    NSMutableArray  *arrStringTime;  //  时间字符串的数组
    
    
    NSLock *lockStringTime;   // 时间字符串的队列锁
    
    dispatch_source_t _timer1;  // 定时器1,用于竞拍列表的计时
}
@end

@implementation Second_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor blueColor];
    
    if ([PDAPI isTestUser])
     {
        [self layoutUIForTest];
     }
    else
     {
        [self layoutUI];
     }
    
    lockStringTime = [[NSLock alloc] init];
    //[LoadView showHUDAddedTo:self.view animated:YES];
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}

-(void) viewWillAppear:(BOOL)animated
{
    //[self getBiddersListByPrice];
    if(iSelTag == 1)
     {
        [self getBiddersList];
     }
}

#pragma mark ---  布局UI
-(void) layoutUIForTest
{
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"tab1_tgmj_bg_test"];
}

-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 800);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];

    if (@available(iOS 11.0, *))
     {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        scView.height += 15;
     }
    else
     {
        scView.top -= 20;
        scView.height += 20;
     }

    
    int iImgHeight = 320;
    if (IS_IPHONE_5_OR_LESS)
     {
        iImgHeight = 300;
     }
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iImgHeight)];
    [scView addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"tab2_bg"];
    imgBG.userInteractionEnabled = YES;

    int iTopY = imgBG.height;
    int iLeftX = 15;
    int iBtnHeight = 60;
    iSelTag = 1;
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH/2, iBtnHeight)];
    [scView addSubview:btnLeft];
    [btnLeft setTitle:@"竞拍" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnLeft addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];


    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, SCREEN_WIDTH/2, iBtnHeight)];
    [scView addSubview:btnRight];
    [btnRight setTitle:@"兑换" forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnRight addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];


    iTopY += btnLeft.height;
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [scView addSubview:viewBG];
    viewBG.backgroundColor = [ResourceManager viewBackgroundColor];

    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 15, 200, 20)];
    [viewBG addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:16];
    labelTitle.text = @"限时兑换";
    
    btnExchangeSM = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX + 80, 15, 80, 20)];
    [viewBG addSubview:btnExchangeSM];
    [btnExchangeSM setTitle:@"竞拍说明" forState:UIControlStateNormal];
    [btnExchangeSM setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnExchangeSM.titleLabel.font = [UIFont systemFontOfSize:14];
    btnExchangeSM.layer.cornerRadius = 10;
    btnExchangeSM.layer.masksToBounds = YES;
    btnExchangeSM.layer.borderColor = [ResourceManager mainColor].CGColor;
    btnExchangeSM.layer.borderWidth = 1;
    [btnExchangeSM addTarget:self action:@selector(actionSM) forControlEvents:UIControlEventTouchUpInside];
    

    btnExchange = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 15, 90, 20)];
    [viewBG addSubview:btnExchange];
    [btnExchange setTitle:@"我的兑换 >" forState:UIControlStateNormal];
    [btnExchange setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    btnExchange.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnExchange addTarget:self action:@selector(actionMy) forControlEvents:UIControlEventTouchUpInside];


    [self actionLeft];
    
    

    iTopY += viewBG.height;
    UIView *viewBtnBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [scView addSubview:viewBtnBG];
    viewBtnBG.backgroundColor = [UIColor whiteColor];
    
    
    arrBtn = [[NSMutableArray alloc] init];
    NSArray *arrTitle = @[@"进行中",@"未开拍",@"期待中",@"已结束"];
    int iBtnWidht = SCREEN_WIDTH/[arrTitle count];
    int iBtnLeftX = 0;
    iBtnHeight = 40;
    UIButton *firstBtn;
    for (int i = 0; i  < [arrTitle count]; i ++)
     {
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, iBtnWidht, iBtnHeight)];
        [scView addSubview:btnTemp];
        btnTemp.tag = i;
        [btnTemp setTitle:arrTitle[i] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnTemp addTarget:self action:@selector(actionJPSel:) forControlEvents:UIControlEventTouchUpInside];
        
        iBtnLeftX += iBtnWidht;
        [arrBtn addObject:btnTemp];
        
        if (0 == i)
         {
            firstBtn = btnTemp;
         }
            
     }
    
    if (firstBtn)
     {
        [self actionJPSel:firstBtn];
     }
    

    
    
    
    iTopY += iBtnHeight;
    iViewListTopY = iTopY;
    // 长度一定要有50000， 否则数据太多了，后面的CELL不响应
    viewList = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50000)];
    [scView addSubview:viewList];
    //[self layoutListWithArray:nil atTopY:iTopY];




}

//-(void) layoutUI
//{
//    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
//    [self.view addSubview:imgBG];
//    imgBG.image = [UIImage imageNamed:@"TGB_bg"];
//
//    UIButton *btnCenter = [[UIButton alloc] initWithFrame:CGRectMake(60, 70, SCREEN_WIDTH - 120, 40)];
//    [imgBG addSubview:btnCenter];
//    btnCenter.backgroundColor = [ResourceManager viewBackgroundColor];
//    btnCenter.cornerRadius = 20;
//    [btnCenter setTitle:@"致天狗窝用户" forState:UIControlStateNormal];
//    [btnCenter setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
//    btnCenter.titleLabel.font = [UIFont systemFontOfSize:19];
//
//    UIView *viewOther = [[UIView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT - 130)];
//    [self.view addSubview:viewOther];
//    viewOther.backgroundColor = [UIColor whiteColor];
//    viewOther.cornerRadius = 20;
//
//    int iTopY = 150;
//    int iLeftX = 15;
//
//    UIImageView *imgMessage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 170)];
//    [self.view addSubview:imgMessage];
//    imgMessage.image = [UIImage imageNamed:@"tab2_message"];
//
//    UILabel *labelMessage = [[UILabel alloc] initWithFrame:imgMessage.frame];
//    [self.view addSubview:labelMessage];
//    labelMessage.top += 20;
//    labelMessage.height -= (20 + 40);
//    labelMessage.left += 30;
//    labelMessage.width -= 60;
//    //labelMessage.backgroundColor = [UIColor yellowColor];
//    labelMessage.textColor = [ResourceManager color_1];
//    labelMessage.font = [UIFont systemFontOfSize:13];
//    labelMessage.numberOfLines = 0;
//    NSString *strMessage = @"庞大的时空组合体中，有一股神秘的能量，狗粮是促进天狗激发技能的唯一动力，天狗窝上智慧生命逐渐强大，外来物质逐渐增多。\n在此处即将开启各种心仪物质的兑换。";
//
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strMessage];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:8];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strMessage length])];
//    [labelMessage setAttributedText:attributedString1];
//
//    int iLableTopY = 20 + labelMessage.height ;
//    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, iLableTopY, imgMessage.width - 30, 20)];
//    [imgMessage addSubview:labelBottom];
//    //labelBottom.backgroundColor = [UIColor blueColor];
//    labelBottom.textAlignment = NSTextAlignmentRight;
//    labelBottom.textColor = [ResourceManager color_1];
//    labelBottom.font = [UIFont systemFontOfSize:13];
//    labelBottom.text = @"--天狗窝";
//
//    iTopY += imgMessage.height +15;
//
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
//    [self.view addSubview:label1];
//    label1.textColor = [ResourceManager color_1];
//    label1.font = [UIFont systemFontOfSize:16];
//    label1.text = @"限时兑换";
//
//    iTopY += label1.height + 15;
//    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 1)];
//    [self.view addSubview:viewFG];
//    viewFG.backgroundColor = [ResourceManager color_5];
//
//    iTopY += 15;
//    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 150)];
//    [self.view addSubview:btn1];
//    btn1.backgroundColor = [ResourceManager viewBackgroundColor];
//    btn1.cornerRadius = 10;
//
//    UIImageView *imgBtn1 = [[UIImageView alloc] initWithFrame:CGRectMake((btn1.width-50)/2, 30, 50, 50)];
//    [btn1 addSubview:imgBtn1];
//    imgBtn1.image = [UIImage imageNamed:@"task_yanfa"];
//
//    UILabel *labelBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, btn1.width, 20)];
//    [btn1 addSubview:labelBtn];
//    labelBtn.textColor = UIColorFromRGB(0x979797);
//    labelBtn.font = [UIFont systemFontOfSize:14];
//    labelBtn.textAlignment = NSTextAlignmentCenter;
//    labelBtn.text = @"运输途中";
//
//
//}

-(void) layoutListWithArray:(NSArray*) arr  atTopY:(int) ilistTopY
{
    [viewList removeAllSubviews];
    
    viewList.top = ilistTopY;
    
    if (!arr ||
        [arr count] == 0 )
     {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
        imageView.image = [UIImage imageNamed:@"com_noData"];
        [viewList addSubview:imageView];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
        lable1.text = @"研发中～";
        
        
        lable1.textAlignment =  NSTextAlignmentCenter;
        lable1.font = [UIFont systemFontOfSize:16];
        lable1.textColor = [ResourceManager color_1];
        [viewList addSubview:lable1];
        
        scView.contentSize = CGSizeMake(0, 270 + ilistTopY+10);
        return;

     }
    
    int iTopY = 0;
    int iCellHeight = 170;
    int iCellTopY = 0;
    int iCellLeftX = 0;
    int iCellImgWidht = 135;
    
    if (IS_IPHONE_5_OR_LESS)
     {
        iCellImgWidht = 130;
        iCellHeight = 160;
     }
    
    if ([arr count] == 0 )
     {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
        imageView.image = [UIImage imageNamed:@"com_noData"];
        [viewList addSubview:imageView];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
        lable1.text = @"没有记录～";
        
        
        lable1.textAlignment =  NSTextAlignmentCenter;
        lable1.font = [UIFont systemFontOfSize:16];
        lable1.textColor = [ResourceManager color_1];
        [viewList addSubview:lable1];
        return;
     }
    
    for (int i = 0; i < [arr count]; i++)
     {
        NSDictionary *dic = arr[i];
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        viewCell.userInteractionEnabled = YES;
        viewCell.tag = i;
        
        
        if (1 == iSelTag)
         {
            //竞拍  添加手势
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionBidders:)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
         }
        
        if (2 == iSelTag)
         {
            //兑换  添加手势
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionChange:)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
         }
        
        
        
        iCellLeftX = 15;
        iCellTopY = 15;
        // 商品的图片
        
        UIView *imgShop = [[UIView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellImgWidht, iCellImgWidht)];
        [viewCell addSubview:imgShop];
        imgShop.backgroundColor = UIColorFromRGB(0xf4f4f4);
        imgShop.layer.cornerRadius = 15;
        imgShop.layer.masksToBounds = YES;
        
        UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, iCellImgWidht -30, iCellImgWidht-30)];
        [imgShop addSubview:imgReal];
        NSString *strImgUrl = dic[@"imgUrl"];
        if (strImgUrl)
         {
            [imgReal setImageWithURL:[NSURL URLWithString:strImgUrl]];
         }
        
        //商品的状态
        int iStatus = [dic[@"status"] intValue];
        NSString *strStatus = @"进行中";
        UIColor *colorStatus = [ResourceManager mainColor];
        if (0 == iStatus)
         {
            strStatus = @"结束";
            colorStatus = UIColorFromRGB(0xb2b2c4);
         }
        UILabel *labelShopStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, iCellImgWidht-30, iCellImgWidht, 30)];
        [imgShop addSubview:labelShopStatus];
        labelShopStatus.backgroundColor = colorStatus;
        labelShopStatus.textAlignment = NSTextAlignmentCenter;
        labelShopStatus.text = strStatus;
        labelShopStatus.font = [UIFont systemFontOfSize:12];
        labelShopStatus.textColor = [UIColor whiteColor];
        
        
        iCellLeftX += imgShop.width + 10;
        iCellTopY += 5;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:15];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = dic[@"name"];//@"幸运币";
        
        iCellTopY += labelName.height+3;
        UILabel *labelDes1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
        [viewCell addSubview:labelDes1];
        labelDes1.font = [UIFont systemFontOfSize:15];
        labelDes1.textColor = [ResourceManager color_1];
        labelDes1.text = dic[@"changeDesc"];//@"1幸运币=3TGB";
        
        iCellTopY += labelDes1.height + 10;
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
        labelPrice.text =  [NSString stringWithFormat:@"%@", dic[@"changePrice"]]; //@"1";
        
        iCellTopY += labelPrice.height + 8;
        UILabel *labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
        [viewCell addSubview:labelStauts];
        labelStauts.font = [UIFont systemFontOfSize:12];
        labelStauts.textColor = [ResourceManager mainColor];
        labelStauts.text = strStatus;
        
        
        iCellTopY += labelStauts.height;
        NSString *strcountValue = [NSString stringWithFormat:@"竞拍次数 %@", dic[@"countValue"]];
        UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
        [viewCell addSubview:labelCount];
        labelCount.font = [UIFont systemFontOfSize:12];
        labelCount.textColor = [ResourceManager color_1];
        labelCount.text = strcountValue;//@"参与次数 6";
        
        UILabel *labelStauts2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iCellTopY -5, 90, 30)];
        [viewCell addSubview:labelStauts2];
        labelStauts2.font = [UIFont systemFontOfSize:14];
        labelStauts2.textColor = [UIColor whiteColor];
        labelStauts2.backgroundColor = colorStatus;
        labelStauts2.text = strStatus;
        labelStauts2.textAlignment = NSTextAlignmentCenter;
        labelStauts2.layer.cornerRadius = labelStauts2.height/2;
        labelStauts2.layer.masksToBounds = YES;
        
        // 分割线
        iCellTopY = iCellHeight -1;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellHeight;
     }
    
    scView.contentSize = CGSizeMake(0, iTopY + ilistTopY+10);
    
    
}


-(void) layoutBiddersListWithArray:(NSArray*) arr  atTopY:(int) ilistTopY
{
    [viewList removeAllSubviews];
    
    viewList.top = ilistTopY;
    
    if (!arr ||
        [arr count] == 0 )
     {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 137.f)/2, 50.f, 137.f, 160.f)];
        imageView.image = [UIImage imageNamed:@"com_noData"];
        [viewList addSubview:imageView];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+160+20, SCREEN_WIDTH, 30)];
        lable1.text = @"没有记录～";
        
        
        lable1.textAlignment =  NSTextAlignmentCenter;
        lable1.font = [UIFont systemFontOfSize:16];
        lable1.textColor = [ResourceManager color_1];
        [viewList addSubview:lable1];
        
        scView.contentSize = CGSizeMake(0, 270 + ilistTopY+10);
        return;
     }
    
    if (arrLableTime)
     {
        [arrLableTime removeAllObjects];
     }
    arrLableTime = [[NSMutableArray alloc] init];
    
    if (arrStringTime)
     {
        //[lockStringTime lock];
        
        [arrStringTime removeAllObjects];
        
        //[lockStringTime unlock];
     }
    arrStringTime = [[NSMutableArray alloc] init];
    
    if (arrCurPrice)
     {
         [arrCurPrice removeAllObjects];
     }
    arrCurPrice = [[NSMutableArray alloc] init];
    
    
    
    int iTopY = 0;
    int iCellHeight = 170;
    int iCellTopY = 0;
    int iCellLeftX = 0;
    int iCellImgWidht = 135;
    
    if (IS_IPHONE_5_OR_LESS)
     {
        iCellImgWidht = 130;
        iCellHeight = 160;
     }
    
    for (int i = 0; i < [arr count]; i++)
     {
        NSDictionary *dic = arr[i];
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        viewCell.userInteractionEnabled = YES;
        viewCell.tag = i;
        
        
        if (1 == iSelTag)
         {
            //竞拍  添加手势
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionBidders:)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
         }
        
        if (2 == iSelTag)
         {
            //兑换  添加手势
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionChange:)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
         }
        
        
        
        iCellLeftX = 15;
        iCellTopY = 15;
        // 商品的图片
        
        UIView *imgShop = [[UIView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellImgWidht, iCellImgWidht)];
        [viewCell addSubview:imgShop];
        imgShop.backgroundColor = UIColorFromRGB(0xf4f4f4);
        imgShop.layer.cornerRadius = 15;
        imgShop.layer.masksToBounds = YES;
        
        UIImageView *imgReal = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, iCellImgWidht -30, iCellImgWidht-30)];
        [imgShop addSubview:imgReal];
        NSString *strImgUrl = dic[@"imgUrl"];
        if (strImgUrl)
         {
            [imgReal setImageWithURL:[NSURL URLWithString:strImgUrl]];
         }
        
        //  竞拍状态（0进行中 1未开拍 2敬请期待 3已结束）
        int iStatus = [dic[@"auctionStatus"] intValue];
        NSString *strStatus = @"进行中";
        UIColor *colorStatus = [ResourceManager mainColor];
        if (0 == iStatus)
         {
            strStatus = @"进行中";
            colorStatus = [ResourceManager mainColor];
         }
        if (1 == iStatus)
         {
            strStatus = @"未开拍";
            colorStatus = [ResourceManager mainColor];
         }
        if (2 == iStatus)
         {
            strStatus = @"未开拍";
            colorStatus = UIColorFromRGB(0xb2b2c4);
         }
        if (3 == iStatus)
         {
            strStatus = @"已结束";
            colorStatus = UIColorFromRGB(0xb2b2c4);
         }
        
        UILabel *labelShopStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, iCellImgWidht-30, iCellImgWidht, 30)];
        [imgShop addSubview:labelShopStatus];
        labelShopStatus.backgroundColor = colorStatus;
        labelShopStatus.textAlignment = NSTextAlignmentCenter;
        labelShopStatus.text = strStatus;
        labelShopStatus.font = [UIFont systemFontOfSize:12];
        labelShopStatus.textColor = [UIColor whiteColor];
        
        
        
        iCellLeftX += imgShop.width + 10;
        iCellTopY += 5;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 30)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:15];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = dic[@"auctionName"];//@"幸运币";
        labelName.numberOfLines = 0;
        [labelName sizeToFit];
        
        
        iCellTopY += 15+3;
        UILabel *labelDes1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
//        [viewCell addSubview:labelDes1];
//        labelDes1.font = [UIFont systemFontOfSize:15];
//        labelDes1.textColor = [ResourceManager color_1];
//        labelDes1.text = dic[@"changeDesc"];//@"1幸运币=3TGB";
        
        iCellTopY += labelDes1.height + 10;
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
        labelPrice.text =  [NSString stringWithFormat:@"%@", dic[@"currentPrice"]]; //@"1";
        
        
        //  竞拍状态（0进行中 1未开拍 2敬请期待 3已结束）
        if ( 0 == iStatus ||
            1 == iStatus)
         {
            NSString *countDownTime = dic[@"countDownTime"];
            if (countDownTime)
             {
                labelShopStatus.text = [NSString stringWithFormat:@"剩余时间%@",countDownTime];
                if (1 == iStatus)
                 {
                    labelShopStatus.text = [NSString stringWithFormat:@"距离开拍时间%@",countDownTime];
                    labelShopStatus.font = [UIFont systemFontOfSize:11];
                 }
                
                [arrStringTime addObject:countDownTime];
                
                // 商品状态，加入时间数组
                [arrLableTime addObject:labelShopStatus];
                
                [arrCurPrice addObject:labelPrice];
             }
         }
        
        iCellTopY += labelPrice.height + 8;
        UILabel *labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 15)];
        [viewCell addSubview:labelStauts];
        labelStauts.font = [UIFont systemFontOfSize:12];
        labelStauts.textColor = [ResourceManager mainColor];
        labelStauts.text = strStatus;
        
        
        iCellTopY += labelStauts.height;
        NSString *strcountValue = [NSString stringWithFormat:@"竞拍次数 %@", dic[@"auctionCount"]];
        UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX, 20)];
        [viewCell addSubview:labelCount];
        labelCount.font = [UIFont systemFontOfSize:12];
        labelCount.textColor = [ResourceManager color_1];
        labelCount.text = strcountValue;//@"参与次数 6";
        
        UILabel *labelStauts2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iCellTopY -5, 90, 30)];
        [viewCell addSubview:labelStauts2];
        labelStauts2.font = [UIFont systemFontOfSize:14];
        labelStauts2.textColor = [UIColor whiteColor];
        labelStauts2.backgroundColor = colorStatus;
        labelStauts2.text = strStatus;
        labelStauts2.textAlignment = NSTextAlignmentCenter;
        labelStauts2.layer.cornerRadius = labelStauts2.height/2;
        labelStauts2.layer.masksToBounds = YES;
        
        // 分割线
        iCellTopY = iCellHeight -1;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellTopY, SCREEN_WIDTH - 30, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += iCellHeight;
     }
    
    scView.contentSize = CGSizeMake(0, iTopY + ilistTopY+10);
    
    if (arr &&
        [arr count] > 0)
     {
        [self creatTime];
     }
    

}


#pragma mark ---  定时器
-(void) creatTime
{
    //static long long  llTimeCount = 0;
    
    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
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
            for (int i = 0; i < [arrStringTime count]; i ++)
             {
                UILabel *labelTemp = arrLableTime[i];
                NSString *strTemp = arrStringTime[i];
                if (labelTemp)
                 {
                    int iStrLength = (int)labelTemp.text.length;
                    if (iStrLength <= 12)
                     {
                        labelTemp.text = [NSString stringWithFormat:@"剩余时间%@", strTemp];
                     }
                    else
                     {
                        labelTemp.text = [NSString stringWithFormat:@"距离开拍时间%@", strTemp];
                     }
                 }
             }
        });
        
    });
    
    dispatch_resume(_timer1);
    
    
}

-(void) setStringTime
{
    for (int i = 0; i < [arrStringTime count]; i ++)
     {
        NSString *strTemp = arrStringTime[i];
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
                //替换指定下标的元素,防止崩溃
                if ([arrStringTime count] >= i+1 )
                 {
                    [arrStringTime replaceObjectAtIndex:i withObject:format_time];
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
                
                // 重新请求列表
                [self getBiddersList];
             }

         }
        
     }
}


#pragma mark ----  action
-(void) actionLeft
{
    iSelTag = 1;
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    
    labelTitle.text = @"限时竞拍";
    [btnExchange setTitle:@"我的竞拍 >"    forState:UIControlStateNormal];
    btnExchangeSM.hidden = NO;
    
     [self getBiddersList];
    
    int iCount = (int)[arrBtn count];
    for (int i = 0; i< iCount; i++)
     {
        UIButton *btnTemp = arrBtn[i];
        btnTemp.hidden = NO;
     }
}

-(void) actionRight
{
    iSelTag = 2;
    [btnRight setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    
    labelTitle.text = @"限时兑换";
    [btnExchange setTitle:@"我的兑换 >"    forState:UIControlStateNormal];
    btnExchangeSM.hidden = YES;
    
    
    int iCount = (int)[arrBtn count];
    for (int i = 0; i< iCount; i++)
     {
        UIButton *btnTemp = arrBtn[i];
        btnTemp.hidden = YES;
     }
    
    [self getChangeList];
}

-(void) actionSM
{

    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@pages/bidders.html",[PDAPI WXSysRouteAPI]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"竞拍说明";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) actionMy
{
    if (1 == iSelTag)
     {
        //  我的竞拍
        MyBiddersRecrodVC   *VC = [[MyBiddersRecrodVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    else
     {
        //  我的兑换
        ShopRecordVC   *VC = [[ShopRecordVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
}

-(void) actionChange:(UITapGestureRecognizer*) sender
{
    //用tag传值判断
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    int  index = (int)view.tag;
    NSLog(@"点击了第%d张图片",index);
    
    if (index < [arrData count])
     {
        NSDictionary *dicData = arrData[index];
        ChangeVC  *VC = [[ChangeVC alloc] init];
        VC.dicData = dicData;
        [self.navigationController pushViewController:VC animated:YES];
     }
}

-(void) actionBidders:(UITapGestureRecognizer*) sender
{
    //用tag传值判断
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    int  index = (int)view.tag;
    NSLog(@"点击了第%d张图片",index);
    
    if (index < [arrData count])
     {
        NSDictionary *dicData = arrData[index];
       
        //竞拍状态（0进行中 1未开拍 2敬请期待 3已结束）
        int auctionStatus = [dicData[@"auctionStatus"] intValue];
        if (auctionStatus == 0 ||
            auctionStatus == 3)
         {
            BiddersVC  *VC = [[BiddersVC alloc] init];
            VC.dicData = dicData;
            if (3 == auctionStatus)
             {
                VC.isEnd = YES;
             }
            [self.navigationController pushViewController:VC animated:YES];
         }
        

     }
    
}

-(void) actionJPSel:(UIButton*) sender
{
    int iCount = (int)[arrBtn count];
    for (int i = 0; i < iCount; i++)
     {
        UIButton *btnTemp = arrBtn[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
     }
    
    [sender setTitleColor:[ResourceManager mainColor2] forState:UIControlStateNormal];
    int iTag = (int) sender.tag;
    //  0 -  进行中， 1 - 未开拍, 2- 敬请期待， 3 -已经结束
    iJPSel = iTag;
    
    [self getBiddersList];
    
}

#pragma mark ---  网络通讯
-(void) getChangeList
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryChangeList];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[kPage] = @(1);
    parmas[kPageSize] = @(200);
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

-(void) getBiddersList
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionList];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[kPage] = @(1);
    parmas[kPageSize] = @(200);
    parmas[@"auctionStatus"] = @(iJPSel);
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

// 当前价格更新时， 需要刷新列表
-(void) getBiddersListByPrice
{
    if(iSelTag != 1)
     {
        return;
     }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGqueryAuctionList];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[kPage] = @(1);
    parmas[kPageSize] = @(200);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView  showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}




-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        arrData = operation.jsonResult.rows;
        [self layoutListWithArray:arrData atTopY:iViewListTopY-40];
 
     }
    else  if (1001 == operation.tag)
     {
        arrData = operation.jsonResult.rows;
        [self layoutBiddersListWithArray:arrData atTopY:iViewListTopY];

     }
    else if (1002 == operation.tag)
     {
        // 当前价格更新时， 更新列表中的当前价
        NSArray  *arrTemp = operation.jsonResult.rows;
        int iPriceCount = (int)[arrCurPrice count];
        if ([arrTemp count] > 0 &&
            [arrTemp count] >= iPriceCount)
         {
            
            for (int i = 0; i < iPriceCount; i++)
             {
                UILabel *labelTemp = arrCurPrice[i];
                NSDictionary *dic = arrTemp[i];
                labelTemp.text = dic[@"currentPrice"];
             }
            
         }
     }
}



@end
