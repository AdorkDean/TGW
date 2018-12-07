//
//  TGBRecordVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "TGBRecordVC.h"
#import "LoadView.h"
#import "QuestionVC.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "WithdrawTGW_VC.h"

@interface TGBRecordVC ()
{
    UIScrollView  *scView;
    
    UIImageView *viewHead;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    int  iBtnSel;  // 1 - 天狗币  2 - 幸运币
    
    UIButton *btnTX;
    UIButton *btnTXGZ;
    
    UILabel *labelTitle;
    UILabel *labelTGB;
    UILabel *labCenter1;
    UILabel *labCenter2;
    
    UIView *viewTail;
    NSArray *arrData;
}
@end

@implementation TGBRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *strTitle = @"我的资产";

    [self layoutNaviBarViewWithTitle:strTitle];
    
    [self layoutUI];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccounSMRZNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
    
    [self loadData];
}

//    //TODO:uiview 左边按钮 ，单边圆角或者单边框
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btnLeft.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(btnLeft.frame.size.height/2,btnLeft.frame.size.height/2)];//圆角大小
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = btnLeft.bounds;
//    maskLayer.path = maskPath.CGPath;
//    btnLeft.layer.mask = maskLayer;

#pragma mark ---  布局UI
-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500.f);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];




    viewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235)];
    [scView addSubview:viewHead];
    //viewHead.backgroundColor = UIColorFromRGB(0x96b3c3);
    viewHead.image = [UIImage imageNamed:@"TGB_bg"];
    viewHead.userInteractionEnabled = YES;

    int iTopY = 0;
    int iLeftX = 0;

    iTopY += 15;
    int iBtnWdith = 100;
    int iBtnLeft = (SCREEN_WIDTH - 2*iBtnWdith)/2;
    
    //TODO:uiview 左边按钮 ，单边圆角或者单边框
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY, iBtnWdith, 30)];
    [viewHead addSubview:btnLeft];
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left1"] forState:UIControlStateNormal];
    [btnLeft setTitle:@"天狗币" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLeft addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //TODO:uiview 右边按钮，单边圆角或者单边框
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft + iBtnWdith, iTopY, iBtnWdith, 30)];
    [viewHead addSubview:btnRight];
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right2"] forState:UIControlStateNormal];
    [btnRight setTitle:@"幸运币" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRight addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];

    
    iTopY += btnLeft.height + 25;
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [viewHead addSubview:labelTitle];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"天狗币总数";

    iTopY += labelTitle.height + 10;
    labelTGB = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 40)];
    [viewHead addSubview:labelTGB];
    labelTGB.textColor = [UIColor whiteColor];
    labelTGB.font = [UIFont systemFontOfSize:30];
    labelTGB.textAlignment = NSTextAlignmentCenter;
    labelTGB.text = @"0.00";
    
    
    iTopY += labelTGB.height + 15;
    iBtnLeft = 100;
    iBtnWdith = (SCREEN_WIDTH - 200);
    btnTX = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY-2.5, iBtnWdith, 25)];
    [viewHead addSubview:btnTX];
    btnTX.cornerRadius = btnTX.height/2;
    btnTX.layer.borderColor = [UIColor whiteColor].CGColor;
    btnTX.layer.borderWidth = 1;
    [btnTX setTitle:@"提  现" forState:UIControlStateNormal];
    btnTX.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnTX addTarget:self action:@selector(actionTXTGW) forControlEvents:UIControlEventTouchUpInside];
    
    iBtnLeft = SCREEN_WIDTH - 100;
    btnTXGZ = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY, 100, 20)];
    [viewHead addSubview:btnTXGZ];
    btnTXGZ.cornerRadius = btnTXGZ.height/2;
    [btnTXGZ setImage:[UIImage imageNamed:@"TGB_txgz"] forState:UIControlStateNormal];
    [btnTXGZ setTitle:@" 规则" forState:UIControlStateNormal];
    btnTXGZ.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnTXGZ addTarget:self action:@selector(actionTXGZ) forControlEvents:UIControlEventTouchUpInside];
    


    iTopY = viewHead.height;
    UIView *viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 150)];
    [scView addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];



    UIImageView *viewCenter = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewHead.height - 40, SCREEN_WIDTH - 20, 130)];
    [scView addSubview:viewCenter];
    viewCenter.image = [UIImage imageNamed:@"TGB_center"];

    int iCenterViewWidth = viewCenter.width;
    labCenter1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, iCenterViewWidth - 30, 20)];
    [viewCenter addSubview:labCenter1];
    labCenter1.textColor = [ResourceManager color_1];
    labCenter1.font = [UIFont systemFontOfSize:15];
    labCenter1.textAlignment = NSTextAlignmentLeft;
    labCenter1.text = @"天狗币简介";

    UILabel *labFG = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, iCenterViewWidth-10, 1)];
    [viewCenter addSubview:labFG];
    labFG.backgroundColor = [ResourceManager color_5];

    labCenter2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 45 + 15, iCenterViewWidth - 30, 60)];
    [viewCenter addSubview:labCenter2];
    //labCenter2.backgroundColor = [UIColor lightGrayColor];
    labCenter2.textColor = [ResourceManager blackGrayColor];
    labCenter2.font = [UIFont systemFontOfSize:12];
    labCenter2.textAlignment = NSTextAlignmentLeft;
    labCenter2.numberOfLines = 0;
    NSString *strContent = @"天狗币是天狗窝依托于区块链技术生产的，每日定量奖励予勤劳的天狗窝用户。帮助用户更好的了解区块链，近距离接触，参与区块链的网络创建。";

//    if ([PDAPI isTestUser])
//     {
//        labelTitle.text = @"天狗积分总数";
//        labCenter1.text = @"天狗积分简介";
//        strContent = @"天狗积分是天狗窝依托于大数据技术生产的，每日定量奖励予勤劳的天狗窝用户。帮助用户更好的了解大数据，近距离接触，参与大数据的网络创建。";
//     }

    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [labCenter2 setAttributedText:attributedString1];
    [labCenter2 sizeToFit];

    viewCenter.height = labCenter2.top + labCenter2.height + 20;
    viewMid.height = viewCenter.height - 40 + 50;

    UILabel *labelRecrod = [[UILabel alloc] initWithFrame:CGRectMake(15, viewMid.height - 32, 100, 20)];
    [viewMid addSubview:labelRecrod];
    labelRecrod.textColor = [ResourceManager color_1];
    labelRecrod.font = [UIFont systemFontOfSize:14];
    labelRecrod.textAlignment = NSTextAlignmentLeft;
    labelRecrod.text = @"收支记录";

    iTopY = viewHead.height + viewMid.height;
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 600)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [ResourceManager viewBackgroundColor];

}




-(void) dataWithViewTail
{
    [viewTail removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    for (int i = 0; i < [arrData count]; i++)
     {
        NSDictionary *dicTemp = arrData[i];
        
        NSString* strDate = dicTemp[@"date"];
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 50)];
        [viewTail addSubview:labelDate];
        labelDate.textColor = [ResourceManager blackGrayColor];
        labelDate.font = [UIFont systemFontOfSize:14];
        labelDate.text = strDate;
        
        iTopY += labelDate.height;
        
        NSArray *arrCell = dicTemp[@"row"];
        if (!arrCell)
         {
            continue;
         }
        
        for (int i = 0; i < [arrCell count]; i++)
         {
            NSDictionary *dicCell = arrCell[i];
            if (!dicCell)
             {
                continue;
             }
            
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
            viewCell.backgroundColor = [UIColor whiteColor];
            [viewTail addSubview:viewCell];
            
            // 时间
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 50, 50)];
            [viewCell addSubview:label1];
            label1.textColor = [ResourceManager blackGrayColor];
            label1.font = [UIFont systemFontOfSize:14];
            label1.text = dicCell[@"createTime"];
            
            // 分割线
            UILabel *labFG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 50 + 4.5 , 0, 1, 50)];
            [viewCell addSubview:labFG];
            labFG.backgroundColor = UIColorFromRGB(0xe5e5e5);//[ResourceManager color_5];
            
            // 小圆圈
            UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + 50, 20, 10, 10)];
            [viewCell addSubview:viewYuan];
            viewYuan.backgroundColor =  UIColorFromRGB(0xe5e5e5);
            viewYuan.layer.cornerRadius = 5;
            viewYuan.layer.masksToBounds = YES;
            
            // 收支类型
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 50 + 20 , 0, 200, 50)];
            [viewCell addSubview:label2];
            label2.textColor = [ResourceManager blackGrayColor];
            label2.font = [UIFont systemFontOfSize:14];
            label2.text = dicCell[@"typeName"];
            
            // 天狗币
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 , 0, 100, 50)];
            [viewCell addSubview:label3];
            label3.textColor = [ResourceManager mainColor2];
            label3.font = [UIFont systemFontOfSize:14];
            label3.text = dicCell[@"coinValue"];
            
            if (2 == iBtnSel)
             {
                label3.text = dicCell[@"luckValue"];
                
             }
            
            
            iTopY += viewCell.height;
         }
        
        
     }
    
    viewTail.height = iTopY;
    
    int iTotoalY = viewTail.top + viewTail.height;
    scView.contentSize = CGSizeMake(0, iTotoalY);
    
}



#pragma mark ---  网络请求
-(void) loadData
{
    [LoadView showHUDNavAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],   kDDGcoinRecord];
    //strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],   kDDGluckCoinRecord];
    
    if (2 == iBtnSel)
     {
        strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGluckCoinRecord];
     }
    
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                                                                                                            [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    
    if (2 == iBtnSel)
     {
        operation.tag = 1001;
     }
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    
    [LoadView hideHUDForView:self.view animated:YES];
    
    if (1000 == operation.tag)
     {
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            arrData = arr;
            [self dataWithViewTail];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            //float  fTemp =  [dic[@"allCoinValue"] floatValue];
            labelTGB.text = [NSString stringWithFormat:@"%@", dic[@"allCoinValue"]];
         }
            
     }
    
    if (1001 == operation.tag)
     {
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            arrData = arr;
            [self dataWithViewTail];
         }
        else
         {
            [viewTail removeAllSubviews];
         }
        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            labelTGB.text = [NSString stringWithFormat:@"%@", dic[@"allLuckCoinValue"]];
         }
        
     }
}

-(void) delayMethod
{
    [LoadView hideHUDForView:self.view animated:YES];
}

#pragma  mark --- action
-(void) actionLeft
{
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left1"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right2"] forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnTX.hidden = NO;
    btnTXGZ.hidden = NO;
    
    labelTitle.text = @"天狗币总数";
    labCenter1.text = @"天狗币简介";
    NSString *strContent = @"天狗币是天狗窝依托于区块链技术生产的，每日定量奖励予勤劳的天狗窝用户。帮助用户更好的了解区块链，近距离接触，参与区块链的网络创建。";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [labCenter2 setAttributedText:attributedString1];
    
    iBtnSel = 1;
    [self loadData];

}

-(void) actionRight
{
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right1"] forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left2"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnTX.hidden = YES;
    btnTXGZ.hidden = YES;
    
    labelTitle.text = @"幸运币总数";
    labCenter1.text = @"幸运币简介";
    NSString *strContent = @"幸运币是天狗窝依托于区块链技术产生的，它不同于天狗币，是更稀缺的数字货币，因此价值更高，用予奖励天狗用户。幸运币未来会有更大的应用场景。";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [labCenter2 setAttributedText:attributedString1];
 

    iBtnSel = 2;
    [self loadData];
}


-(void) actionTXTGW
{
//    [MBProgressHUD showErrorWithStatus:@"天狗币提现将在下一个版本开放" toView:self.view];
//    return;
    
    int identityStatus = 0;
    NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
    if ([dic count] > 0)
     {
        identityStatus = [dic[@"identityStatus"] intValue];
     }
    
    // 认证
    if(identityStatus != 1)
     {
        [self actionPopSMRZ];
        return;
     }
    
    WithdrawTGW_VC  *VC = [[WithdrawTGW_VC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}


-(void) actionPopSMRZ
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>提示</font>"]];
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>需要先进行实名认证，才能提现!</font>"]];
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"立即实名" color:[ResourceManager mainColor] actionBlock:^{
        
        
        int identityStatus = 0;
        NSDictionary *dic =   [DDGAccountManager sharedManager].userInfo;
        if ([dic count] > 0)
         {
            identityStatus = [dic[@"identityStatus"] intValue];
         }
        
        // 认证
        if(identityStatus == 1)
         {
            [LoadView showSuccessWithStatus:@"您已经通过认证 " toView:self.view];
            return;
         }
        
        if (identityStatus == 0 ||
            identityStatus == 1 ||
            identityStatus == 2) {
            ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
            [self.navigationController pushViewController: ctl animated:YES];
        }else{
            ApproveViewController *ctl = [[ApproveViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

-(void) actionTXGZ
{
    // 平台公告
    QuestionVC  *vc = [[QuestionVC alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/RuleCash",[PDAPI WXSysRouteAPI2]];
    vc.homeUrl = [NSURL URLWithString:url];
    vc.titleStr = @"提现规则";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  --- 网络通讯

@end
