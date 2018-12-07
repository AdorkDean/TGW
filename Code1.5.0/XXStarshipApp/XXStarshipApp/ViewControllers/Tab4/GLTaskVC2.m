//
//  GLTaskVC2.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/22.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "GLTaskVC2.h"
#import "BaseTaskVC.h"
#import "FriendTaskVC.h"
#import "BaoxianTaskVC.h"
#import "CreditCardWebVC.h"
#import "XcodeWebVC.h"
#import "GLRecordVC.h"

#import "TaskRecordViewController.h"
#import "ExchangeViewController.h"
#import "InviteCodeViewController.h"
#import "TaskZZViewController.h"
#import "QuestionVC.h"


@interface GLTaskVC2 ()
{
    UIScrollView  *scView;
    NSDictionary *dicData;
    
    UILabel *labelGLP;
    UILabel *lableLQRW;
    UILabel *lableLQDH;
    
    UIView *viewTail;

    NSString *XHTGWNum;
    
    NSArray *_JRTaskDataArr;
    CGFloat _topHeight;
    
    int identityStatus ; //实名认证
}
@end

@implementation GLTaskVC2


-(void)IndexInfoUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/comm/task/indexInfo",[PDAPI getBaseUrlString]] parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
    operation.tag = 1000;
}

-(void)referCodeUrl{
    
    //实名认证
    if(identityStatus != 1)
     {
        [LoadView showErrorWithStatus:@"请先做基础任务中的实名认证 " toView:self.view];
        return;
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/cust/queryReferCode",[PDAPI getBaseUrlString]] parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
    operation.tag = 1002;
}

-(void)receiveTaskUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/today/task/receive",[PDAPI getBaseUrlString]] parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1003;
}


#pragma mark ---数据操作---
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

    if (operation.tag == 1000) {
        if (operation.jsonResult.attr.count > 0) {
            NSDictionary *dic = operation.jsonResult.attr;
            NSString *ticketStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"xjTicketCount"]];
            NSString *strAll = [NSString stringWithFormat:@"粮票:  %@",ticketStr];
            NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
            NSRange stringRange =  [strAll rangeOfString:ticketStr];
            [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
            [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor2] range:stringRange];
            labelGLP.attributedText = noteString;
            [labelGLP sizeToFit];
            
            XHTGWNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tgwTodayTaskCostValue"]];
            lableLQRW.text = [NSString stringWithFormat:@"消耗%@天狗币领取任务",XHTGWNum];
            lableLQDH.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ticketChangeTgwMsg"]];
            
            identityStatus = [dic[@"identifyStatus"] intValue];
        }
        
        if (operation.jsonResult.rows.count > 0) {
            _JRTaskDataArr = operation.jsonResult.rows;
            [self JRTaskUI];
        }
        
    }else if (operation.tag == 1001) {
        dicData = operation.jsonResult.attr;
    }else if (operation.tag == 1002) {
        if (operation.jsonResult.attr.count > 0) {
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"消耗%@天狗币",XHTGWNum] message:@"领取今日任务" preferredStyle:UIAlertControllerStyleAlert];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[operation.jsonResult.attr objectForKey:@"hasReferCode"] intValue] == 1) {
                    //领取今日任务
                    [self receiveTaskUrl];
                }else{
                    //跳转邀请码页面
                    InviteCodeViewController *ctl = [[InviteCodeViewController alloc]init];
                    ctl.taskBlock = ^{
                        //领取今日任务
                        [self receiveTaskUrl];
                    };
                    [self.navigationController pushViewController:ctl animated:YES];
                }
            }]];
            [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
        }
        
    }else if (operation.tag == 1003) {
        //查询今日任务
        [self IndexInfoUrl];
        
    }
   
  
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self layoutUI];
    
    dicData = nil;
    [self getTaskInfo];

}

-(void)viewWillAppear:(BOOL)animated{
    // 设置状态栏字体颜色为白色
    barStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    [self IndexInfoUrl];
    
    [self getTaskInfo];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:scView];
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    scView.userInteractionEnabled = YES;
    
    
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    int iTopY = 0;
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 218 * ScaleSize)];
    [scView addSubview:imgTop];
    imgTop.image = [UIImage imageNamed:@"Task2_head_bg"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NavHeight - 35, SCREEN_WIDTH, 35)];
    [scView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"狗粮任务";
    
    iTopY = NavHeight + 35 * ScaleSize;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [scView addSubview:lableTitle];
    lableTitle.textColor = [UIColor whiteColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:46];
    lableTitle.text = @"狗粮";
    
    iTopY += lableTitle.height + 15;
    int iGLBtnLeftX = 80;
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(iGLBtnLeftX, iTopY, SCREEN_WIDTH - 2*iGLBtnLeftX, 30)];
    [scView addSubview:btnGL];
    btnGL.layer.borderColor = [UIColor whiteColor].CGColor;
    btnGL.layer.borderWidth = 0.5;
    btnGL.cornerRadius = 15;
    [btnGL setTitle:@"促进天狗技能的神秘能量" forState:UIControlStateNormal];
    [btnGL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGL.titleLabel.font = [UIFont systemFontOfSize:14];
    
    iTopY += btnGL.height + 15;
    UIButton  *btnGLJL = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [scView addSubview:btnGLJL];
    [btnGLJL setTitle:@"狗粮记录 >" forState:UIControlStateNormal];
    [btnGLJL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGLJL.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGLJL addTarget:self action:@selector(GLJLTouch) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY = 0;
    iTopY = imgTop.height + 15;
    int iLeftX = 15;
    UILabel  *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scView addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:17];
    labelTitle.text = @"独家任务";
    
    iTopY += labelTitle.height + 10;
    int iBtnLineCount = 5;
    int iBtnWidth = SCREEN_WIDTH/iBtnLineCount;
    int iBtnLeftX = 0;
    int iBtnTopY = iTopY;
    
    NSArray *imgArr = @[@"Task2_jichu",@"Task2_friend",@"Task2_card",@"Task2_baoxian",@"Task2_yx",@"Task2_book"];
    NSArray *nameArr = @[@"基础",@"交友",@"办卡",@"保险",@"游戏",@"小说"];
    
    int iBtnCount = (int )[imgArr count];
    for (int i = 0; i < iBtnCount; i++)
     {
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWidth, 80)];
        [scView addSubview:btnTemp];
        //btnTemp.backgroundColor = [UIColor yellowColor];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionTask:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView  *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth - 35)/2, 10, 35, 35)];
        [btnTemp addSubview:imgTemp];
        imgTemp.image = [UIImage imageNamed:imgArr[i]];
        
        UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, iBtnWidth, 15)];
        [btnTemp addSubview:labelTemp];
        labelTemp.textColor = [ResourceManager color_1];
        labelTemp.font = [UIFont systemFontOfSize:14];
        labelTemp.textAlignment = NSTextAlignmentCenter;
        labelTemp.text = nameArr[i];
        
        int iTemp = i+1;
        if (iTemp %  iBtnLineCount == 0)
         {
            iBtnLeftX = 0;
            iBtnTopY += 80;
            iTopY += 80;
         }
        else
         {
            iBtnLeftX += iBtnWidth;
         }
        
     }
    
    iTopY += 80  + 15;
    UILabel  *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scView addSubview:labelTitle2];
    labelTitle2.textColor = [ResourceManager color_1];
    labelTitle2.font = [UIFont systemFontOfSize:17];
    labelTitle2.text = @"今日任务";
    
    iTopY += labelTitle2.height + 15;
    UIView *imgMessage = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 150)];
    [scView addSubview:imgMessage];
    imgMessage.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    imgMessage.layer.borderWidth = 1;
    imgMessage.layer.cornerRadius = 5;
    imgMessage.layer.masksToBounds = YES;
    
    
    UILabel *labelMessage = [[UILabel alloc] initWithFrame:imgMessage.frame];
    [scView addSubview:labelMessage];
    labelMessage.top += 10;
    labelMessage.height -= (20 + 40);
    labelMessage.left += 20;
    labelMessage.width -= 40;
    //labelMessage.backgroundColor = [UIColor yellowColor];
    labelMessage.textColor = [ResourceManager color_1];
    labelMessage.font = [UIFont systemFontOfSize:13];
    labelMessage.numberOfLines = 0;
    NSString *strMessage = @"在全体天狗窝用户的共同努力下，天狗窝迅速崛起，吸引了许多组织进驻并给天狗窝用户空投的大量物资，天狗窝用户可领取任务赢取丰富奖励。";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strMessage];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strMessage length])];
    [labelMessage setAttributedText:attributedString1];
    
    int iLableTopY = 20 + labelMessage.height ;
    UIButton *btnGZSM = [[UIButton alloc] initWithFrame:CGRectMake(20, iLableTopY, 70, 18)];
    [imgMessage addSubview:btnGZSM];
    [btnGZSM setTitle:@"任务说明" forState:UIControlStateNormal];
    [btnGZSM setTitleColor:[ResourceManager mainColor2] forState:UIControlStateNormal];
    btnGZSM.titleLabel.font = [UIFont systemFontOfSize:13];
    btnGZSM.borderColor = [ResourceManager mainColor2];
    btnGZSM.borderWidth = 1;
    btnGZSM.cornerRadius = 5;
    [btnGZSM addTarget:self action:@selector(actionRWSM) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, iLableTopY, imgMessage.width - 20, 20)];
    [imgMessage addSubview:labelBottom];
    //labelBottom.backgroundColor = [UIColor blueColor];
    labelBottom.textAlignment = NSTextAlignmentRight;
    labelBottom.textColor = [ResourceManager color_1];
    labelBottom.font = [UIFont systemFontOfSize:13];
    labelBottom.text = @"--天狗窝";
    
    iTopY += imgMessage.height + 20;
    UIView  *viewGL = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 60)];
    [scView addSubview:viewGL];
    viewGL.backgroundColor = UIColorFromRGB(0xecf3fb);
    viewGL.layer.cornerRadius = 5;
    viewGL.layer.masksToBounds = YES;
    
    NSString *strLP = @"100";
    labelGLP = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    [viewGL addSubview:labelGLP];
    labelGLP.textColor = [ResourceManager color_1];
    labelGLP.font = [UIFont systemFontOfSize:14];
    
    NSString *strNO = strLP;//  @"10501";
    NSString *strAll = [NSString stringWithFormat:@"粮票:  %@",strNO];
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor2] range:stringRange];
    labelGLP.attributedText = noteString;
    [labelGLP sizeToFit];
    
    iLeftX = 15 + labelGLP.width + 10;
    UIButton *btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 20, 20, 20)];
    [viewGL addSubview:btnRecord];
    //btnRecord.backgroundColor = [UIColor yellowColor];
    [btnRecord setBackgroundImage:[UIImage imageNamed:@"Task2_right"] forState:UIControlStateNormal];
    [btnRecord addTarget:self action:@selector(actionReord) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX = SCREEN_WIDTH - 2*15   - 15  -  90;
    UIButton *btnDH= [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 15, 90, 30)];
    [viewGL addSubview:btnDH];
    btnDH.backgroundColor = [ResourceManager mainColor2];
    btnDH.cornerRadius = 30/2;
    [btnDH setTitle:@"兑换" forState:UIControlStateNormal];
    [btnDH setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDH.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnDH addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += viewGL.height + 20;
    
    viewTail = [[UIView alloc] init];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    iTopY = 0;
    lableLQRW = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewTail addSubview:lableLQRW];
    lableLQRW.textColor = [ResourceManager color_1];
    lableLQRW.font = [UIFont systemFontOfSize:15];
    lableLQRW.textAlignment = NSTextAlignmentCenter;
    lableLQRW.text = [NSString stringWithFormat:@"消耗%@天狗币领取任务",@"30"];
    
    iTopY += lableLQRW.height + 20;
    UIButton *btnLQRW = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, iTopY, 130, 40)];
    [viewTail addSubview:btnLQRW];
    btnLQRW.backgroundColor = [ResourceManager mainColor2];
    btnLQRW.cornerRadius = btnLQRW.height/2;
    [btnLQRW setTitle:@"领取任务" forState:UIControlStateNormal];
    [btnLQRW setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLQRW.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLQRW addTarget:self action:@selector(referCodeUrl) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += btnLQRW.height + 20;
    lableLQDH = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewTail addSubview:lableLQDH];
    lableLQDH.textColor = [ResourceManager lightGrayColor];
    lableLQDH.font = [UIFont systemFontOfSize:13];
    lableLQDH.textAlignment = NSTextAlignmentCenter;
    lableLQDH.text = [NSString stringWithFormat:@"1张粮票可兑换%@天狗币",@"10"];
    
    
    
    
    _topHeight = CGRectGetMaxY(viewGL.frame) + 20;
    viewTail.frame = CGRectMake(0, _topHeight, SCREEN_WIDTH, CGRectGetMaxY(lableLQDH.frame));
    scView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewTail.frame) + 50);
}


#pragma mark ---   action
-(void) actionTask:(UIButton*) sender
{
    if (!dicData)
     {
        [self getTaskInfo];
        return;
     }
    if (![[DDGAccountManager sharedManager] isLoggedIn]){
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    int  iTag = (int)sender.tag;
    if (0 == iTag)
     {
        // 基础任务
        BaseTaskVC *VC = [[BaseTaskVC alloc] init];
        VC.dicData = dicData;
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (1 == iTag)
     {
        //交友
        FriendTaskVC *VC = [[FriendTaskVC alloc] init];
        VC.dicData = dicData;
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (2 == iTag)
     {

        // 认证
        if(identityStatus != 1)
         {
            [LoadView showErrorWithStatus:@"请先通过实名认证 " toView:self.view];
            return;
         }

        // 信用卡
        CreditCardWebVC *VC = [[CreditCardWebVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        

     }
    else if (3 == iTag)
     {
        // 保险
        BaoxianTaskVC *VC = [[BaoxianTaskVC alloc] init];
        VC.dicData = dicData;
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (4 == iTag)
     {
        // 游戏
        XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
        vc.homeUrl = @"tgwproject/games";
        vc.titleStr = @"游戏";
        vc.jumpType = @"game";
        [self.navigationController pushViewController:vc animated:YES];
     }
    else if (5 == iTag)
     {

        // 读书
        QuestionVC  *vc = [[QuestionVC alloc] init];
        NSString *url = [NSString stringWithFormat:@"https://book.mediaway.cn/bookweb/App/book/h5/index.html?lid=969&pid=146#/home/quality"];
        vc.homeUrl = [NSURL URLWithString:url];
        vc.titleStr = @"读书";
        [self.navigationController pushViewController:vc animated:YES];
            
        
     }
}

//狗粮记录
-(void)GLJLTouch{
    GLRecordVC  *vc = [[GLRecordVC alloc] init];
    vc.jumpType = 100;
    [self.navigationController pushViewController:vc animated:YES];
}

//任务说明
-(void)actionRWSM{
    NSString *url = [NSString stringWithFormat:@"%@tgwproject/taskrules",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"任务规则"];
    
}

//任务记录
-(void)actionReord{
    TaskRecordViewController *ctl = [[TaskRecordViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

//兑换
-(void)exchange{
    ExchangeViewController *ctl = [[ExchangeViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}



#pragma mark --- 网络通讯
-(void) getTaskInfo
{
    if (!dicData)
     {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGTaskBaseInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}



#pragma mark 今日任务页面布局
-(void)JRTaskUI{
    if (_JRTaskDataArr.count == 0) {
        return;
    }
    [viewTail removeAllSubviews];
    
    NSInteger count = 0;

    if (_JRTaskDataArr.count == 1)
     {
        count = 1;
     }
    else {
        if (_JRTaskDataArr.count/2 == 0) {
            count = _JRTaskDataArr.count/2;
        }else{
            count = _JRTaskDataArr.count/2 + 1;
        }
        
    }

    
    CGFloat width = (SCREEN_WIDTH - 15 * 3)/2;
    CGFloat height = 125 * ScaleSize;
    for (int j = 0; j < count; j++) {
        for (int i = 0; i < 2; i++) {
            if (j * 2 + i < _JRTaskDataArr.count) {
                NSDictionary *dic = _JRTaskDataArr[j * 2 + i];
                UIView *taskView = [[UIView alloc]initWithFrame:CGRectMake(15 + (width + 15) * i, (height + 15) * j, width, height)];
                [viewTail addSubview:taskView];
                taskView.backgroundColor = UIColorFromRGB(0xECF3FB);
                taskView.layer.cornerRadius = 8;
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((taskView.bounds.size.width - 40)/2, 15 * ScaleSize, 40, 40)];
                [taskView addSubview:imgView];
                [imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"taskImg"]]];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 10, taskView.bounds.size.width, 30)];
                [taskView addSubview:titleLabel];
                titleLabel.textColor = [ResourceManager color_1];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskName"]];
                
                
                UIButton *taskBtn = [[UIButton alloc]initWithFrame:CGRectMake((taskView.bounds.size.width - 85)/2, CGRectGetMaxY(titleLabel.frame) + 10, 85, 25)];
                [taskView addSubview:taskBtn];
                [taskBtn setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"taskDesc"]] forState:UIControlStateNormal];
                taskBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                taskBtn.tag = 100 + j * 2 + i;
                int taskStatus = [[dic objectForKey:@"taskStatus"] intValue];
                // taskStatus  -1 初始状态 0-审核中 1-完成 2-审核失败
                if (1 == taskStatus) {
                    taskBtn.selected = YES;
                    [taskBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [taskBtn setImage:[UIImage imageNamed:@"Tab4-5"] forState:UIControlStateNormal];
                    [taskBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
                }else if (-1 == taskStatus ) {
                    taskBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
                    [taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    taskBtn.layer.cornerRadius = 3;
                }else if (0 == taskStatus ){
                    taskBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
                    [taskBtn setTitle:@"审核中" forState:UIControlStateNormal];
                    [taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    taskBtn.layer.cornerRadius = 3;
                    
                }else if (2 == taskStatus ){
                    taskBtn.backgroundColor = UIColorFromRGB(0xf32527);
                    [taskBtn setTitle:@"重新上传" forState:UIControlStateNormal];
                    [taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    taskBtn.layer.cornerRadius = 3;
                    
                }else{
                    taskBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
                    [taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    taskBtn.layer.cornerRadius = 3;
                }
                [taskBtn addTarget:self action:@selector(taskTouch:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                viewTail.frame = CGRectMake(0, _topHeight, SCREEN_WIDTH, CGRectGetMaxY(taskView.frame));
            }
        }
    }
    
    
    scView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewTail.frame) + 50);
    
}


-(void)taskTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    
    if (![[DDGAccountManager sharedManager] isLoggedIn]){
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    NSDictionary *dic = _JRTaskDataArr[sender.tag - 100];
    NSLog(@"------------%@",dic);
    
    TaskZZViewController *ctl = [[TaskZZViewController alloc]init];
    ctl.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskName"]];
    ctl.taskDic = dic;
    [self.navigationController pushViewController:ctl animated:YES];
   
}

















-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}



@end
