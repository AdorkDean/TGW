//
//  AddFriendVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/28.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AddFriendVC.h"

@interface AddFriendVC ()
{
    UIImageView *viewBG;
    UIImageView *viewCenter;
    
    UILabel *labelYQM;
    UIImageView *imgCode;
    
    NSString *shareDesc;
    NSString *qrCodeUrl;
    NSString *shareContent;
    NSString *shareTitle;
    NSString *shareUrl;
    
    UIView *viewPopShare;
    int  iShareSoucre;   // 1 - 分享图片,   2 - 分享链接
}
@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav=  [self layoutNaviBarViewWithTitle:@"邀请好友"];
    //nav.backdropImg.image = [UIImage imageNamed:@"task_addfriend_head"];
    
    [self layoutUI];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getShareInfo];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view  addSubview:viewBG];
    
    NSArray *arrBG = @[@"task_addfriend_bg_r1",@"task_addfriend_bg_r2",@"task_addfriend_bg_r3",@"task_addfriend_bg"];
    int iNO =  arc4random_uniform(4);
    viewBG.image = [UIImage imageNamed:arrBG[iNO]];
   
    int iTopY  = SCREEN_HEIGHT/2 - NavHeight;
    int iLeftX = 30;
    viewCenter = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 220)];
    [viewBG addSubview:viewCenter];
    //viewCenter.backgroundColor = [UIColor whiteColor];
    viewCenter.image = [UIImage imageNamed:@"task_addfriend_center"];
    viewCenter.cornerRadius = 10;
    
    [self layoutCenterView:viewCenter];
    
    iTopY += viewCenter.height + 20 + NavHeight;
    UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(60, iTopY, SCREEN_WIDTH - 120, 40)];
    [self.view addSubview:btnCopy];
    btnCopy.backgroundColor = UIColorFromRGB(0x2650c0);
    btnCopy.cornerRadius = 20;
    [btnCopy setTitle:@"复制邀请码" forState:UIControlStateNormal];
    [btnCopy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCopy.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCopy addTarget:self action:@selector(actionCopy) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnCopy.height + 10;
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH/2, 40)];
    [self.view addSubview:btnShare];
    //btnShare.backgroundColor = [ResourceManager viewBackgroundColor];
    //[btnShare setTitle:@"复制邀请码" forState:UIControlStateNormal];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShare.titleLabel.font = [UIFont systemFontOfSize:14];
    
     NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"点击分享图片"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]  range:NSMakeRange(0,[tncString length])];
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor whiteColor] range:(NSRange){0,[tncString length]}];
    [btnShare setAttributedTitle:tncString forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(actionShare) forControlEvents:UIControlEventTouchUpInside];


    
    UIButton *btnShare2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, SCREEN_WIDTH/2, 40)];
    [self.view addSubview:btnShare2];
    [btnShare2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShare2.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString* tncString2 = [[NSMutableAttributedString alloc] initWithString:@"点击分享链接"];
    [tncString2 addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString2 length]}];
    //此时如果设置字体颜色要这样
    [tncString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]  range:NSMakeRange(0,[tncString2 length])];
    //设置下划线颜色...
    [tncString2 addAttribute:NSUnderlineColorAttributeName value:[UIColor whiteColor] range:(NSRange){0,[tncString2 length]}];
    [btnShare2 setAttributedTitle:tncString2 forState:UIControlStateNormal];
    [btnShare2 addTarget:self action:@selector(actionShare2) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutTail];
}

-(void) layoutCenterView:(UIView *)viewCenter
{
    int iCenterTopY = 15;
    int iCenterLeftX = 10;
    int iCenterWidth =  viewCenter.width;
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(iCenterLeftX,iCenterTopY , 90, 90)];
    [viewCenter addSubview:imgHead];
    imgHead.image = [UIImage imageNamed:@"task_addfriend_myhead"];
    
    int iLabelLeftX = iCenterLeftX + imgHead.width + 10;
    int iLabelTopY = iCenterTopY + 15;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 15)];
    [viewCenter addSubview:label1];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:13];
    //label1.text = @"我是天狗窝 号天狗";
    
    if (IS_IPHONE_5_OR_LESS)
     {
        label1.font = [UIFont systemFontOfSize:12];
     }
    
    NSDictionary *dicUser =  [DDGAccountManager sharedManager].userInfo;
    if (dicUser)
     {
        NSString *strNO = [NSString stringWithFormat:@"%@", dicUser[@"rank"]];//  @"10501";
        NSString *strAll = [NSString stringWithFormat:@"第 %@ 号天狗",strNO];
        
        NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
        NSRange stringRange =  [strAll rangeOfString:strNO];
        [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:stringRange];
        [noteString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf4c542) range:stringRange];
        label1.attributedText = noteString;
        

     }
    
    iLabelTopY += label1.height+5;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 15)];
    [viewCenter addSubview:label2];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"开 启 区 块 链 宇 宙 旅 行";
    
    if ([PDAPI isTestUser] ||
        IS_IPHONE_5_OR_LESS)
     {
        label2.text = @"请和我一起开启宇宙旅行";
     }
    
    iLabelTopY += label2.height+5;
    labelYQM = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 30)];
    [viewCenter addSubview:labelYQM];
    labelYQM.textColor = [UIColor whiteColor];
    labelYQM.font = [UIFont systemFontOfSize:13];
    labelYQM.text = @"邀请码：";
    
    iCenterTopY += imgHead.height + 10;
    UIImageView *viewFG = [[UIImageView alloc] initWithFrame:CGRectMake(iCenterLeftX, iCenterTopY, iCenterWidth - 2*iCenterLeftX, 1)];
    [viewCenter addSubview:viewFG];
    viewFG.image = [self imageWithLineWithImageView:viewFG];
    
    iLabelLeftX =   iCenterLeftX +10;
    iLabelTopY = iCenterTopY + 15;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 20)];
    [viewCenter addSubview:label3];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = @"分享";
    
    iLabelTopY +=  label3.height;
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 20)];
    [viewCenter addSubview:label4];
    label4.textColor = [UIColor whiteColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"创 / 造 / 价 / 值";
    
    iLabelTopY +=  label4.height+10;
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 130, 15)];
    [viewCenter addSubview:label5];
    label5.textColor = [UIColor whiteColor];
    label5.font = [UIFont systemFontOfSize:12];
    label5.text = @"扫码下载天狗窝APP>";
    label5.textAlignment = NSTextAlignmentCenter;
    label5.layer.borderColor = [ResourceManager color_5].CGColor;
    label5.layer.borderWidth = 1;
    label5.layer.cornerRadius = 5;
    
    
    if (IS_IPHONE_5_OR_LESS)
     {
        label4.font = [UIFont systemFontOfSize:13];
        label5.font = [UIFont systemFontOfSize:11];
        label5.width = 115;
     }
    
    imgCode = [[UIImageView alloc] initWithFrame:CGRectMake(iCenterWidth - iCenterLeftX - 90 - 20, iCenterTopY+5, 90, 90)];
    [viewCenter addSubview:imgCode];
    //imgCode.backgroundColor = [UIColor yellowColor];
    
 
    //imgCode.image = [UIImage imageNamed:@"task_down"];
    
    
    
}

// 画虚线
-(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView{
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    int iWidht = 3;
    CGFloat lengths[] = {iWidht,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 1);
    CGContextAddLineToPoint(line, width-iWidht, 1);
    CGContextStrokePath(line);
    return  UIGraphicsGetImageFromCurrentImageContext();
}


-(void) setUIData:(NSDictionary*) dicData
{
    NSString *strNO = [NSString stringWithFormat:@"%@", dicData[@"inviteCode"]];//  @"10501";
    NSString *strAll = [NSString stringWithFormat:@"邀请码:  %@",strNO];
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:stringRange];
    
    if (IS_IPHONE_5_OR_LESS)
     {
        strAll = [NSString stringWithFormat:@"邀请码:%@",strNO];
        [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:stringRange];
     }
    [noteString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf4c542) range:stringRange];
    labelYQM.attributedText = noteString;
    
    //设置二维码
    //imgCode;
    NSString *imgUrl  =dicData[@"qrCodeUrl"];
    [imgCode sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    shareDesc = dicData[@"shareDesc"];
    shareContent = dicData[@"shareContent"];
    shareTitle = dicData[@"shareTitle"];
    shareUrl = dicData[@"shareUrl"];
    
    [self getEWMPhoto:shareUrl];
}

#pragma mark ---- 布局分享按钮
-(void) layoutTail
{
    int iviewPopShareHeight =  180;
    viewPopShare = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - iviewPopShareHeight, SCREEN_WIDTH, iviewPopShareHeight)];
    viewPopShare.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewPopShare];
    viewPopShare.userInteractionEnabled = YES;
    
    int iTopY = 20;
    int iLeftX = 0;
    
    
    UIColor *color1 =  UIColorFromRGB(0x4c4c4c);
    UILabel *labelTail1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    labelTail1.font = [UIFont systemFontOfSize:16];
    labelTail1.textColor = color1;
    labelTail1.text = [NSString stringWithFormat:@"分享到"];
    labelTail1.textAlignment = NSTextAlignmentCenter;
    [viewPopShare addSubview:labelTail1];
    

    
    iTopY += labelTail1.height -10;
    int iIMGWdith = 40;
    int iViewWdith = SCREEN_WIDTH/3;
    
    // 微信图片和按钮
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iViewWdith, 100)];
    [viewPopShare addSubview:view1];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    [view1 addSubview:imag1];
    imag1.image = [UIImage imageNamed:@"com_weixin"];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = color1;
    label1.text = @"微信";
    label1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label1];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionWX)];
    [view1 addGestureRecognizer:singleTap];
    
    // 朋友圈图片和按钮
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith, iTopY, iViewWdith, 100)];
    [viewPopShare addSubview:view2];
    
    UIImageView *imag2 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    [view2 addSubview:imag2];
    imag2.image = [UIImage imageNamed:@"com_pyq"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = color1;
    label2.text = @"朋友圈";
    label2.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label2];
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPYQ)];
    [view2 addGestureRecognizer:singleTap2];
    
    
//    // 保存到本地图片和按钮
//    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith*2, iTopY, iViewWdith, 100)];
//    [viewPopShare addSubview:view3];
//
//    UIImageView *imag3 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
//    [view3 addSubview:imag3];
//    imag3.image = [UIImage imageNamed:@"com_save"];
//
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
//    label3.font = [UIFont systemFontOfSize:12];
//    label3.textColor = color1;
//    label3.text = @"保存到本地";
//    label3.textAlignment = NSTextAlignmentCenter;
//    [view3 addSubview:label3];
//
//    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharSave)];
//    [view3 addGestureRecognizer:singleTap3];
    
    // 分割线
    iTopY += view1.height + 5;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0 , iTopY, SCREEN_WIDTH,1)];
    viewFG1.backgroundColor = [ResourceManager lightGrayColor];
    [viewPopShare addSubview:viewFG1];
    
    iTopY +=1;
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 40)];
    [viewPopShare addSubview:btnBack];
    [btnBack setTitle:@"取消" forState:UIControlStateNormal];
    [btnBack setTitleColor:color1 forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBack addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    
    //scView.contentSize = CGSizeMake(0, scView.height + iviewPopShareHeight + 5);
    
    viewPopShare.hidden = YES;
}


#pragma mark --- 网络通讯
-(void) getShareInfo
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetShareInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) getEWMPhoto:(NSString*) strShareUrl
{
    
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], @"tgw/xjCommon/rerfererQRCode"];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"shareUrl"] = strShareUrl;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    


    // 设置二维码
    NSString *str1 = [operation.URL absoluteString];
    if (str1)
     {
        [imgCode sd_setImageWithURL:[NSURL URLWithString:str1]];
     }
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    NSDictionary *dic = operation.jsonResult.attr;
    if (1000 == operation.tag)
     {
        
        if ([dic count] > 0)
         {
            [self setUIData:dic];
         }
     }

}

#pragma mark --- action
-(void) actionCopy
{
    if (!shareDesc &&
        shareDesc.length <= 0)
     {
        return;
     }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = shareDesc;
    
    if ([PDAPI isTestUser])
     {
        pasteboard.string = @"请和我一起开启宇宙旅行";
     }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"复制邀请码成功" message:@"将邀请码发送给你给好友，获取狗粮" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
    }];

    
    [alertController addAction:okAction];
    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Cancel Action");
//    }];
//    [alertController addAction:cancelAction];
    
     [self presentViewController:alertController animated:YES completion:nil];

}



-(void) actionShare
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:self.view];
        return;
     }
    
    iShareSoucre = 1;
    viewPopShare.hidden = NO;

}

-(void) actionShare2
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:self.view];
        return;
     }
    
    iShareSoucre = 2;
    viewPopShare.hidden = NO;
    
}

-(void) actionCancel
{
    viewPopShare.hidden = YES;
}

-(void) actionWX
{
    if (1 == iShareSoucre)
     {
        UIImage * image = [self captureImageFromView:viewBG];
        UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
        [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:0];
        
        [[DDGShareManager  shareManager] setBlock:^(id obj) {
            
            NSDictionary *dic = (NSDictionary *)obj;
            if ([[dic objectForKey:@"success"] boolValue]) {
                [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            }else{
                [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
            }
        }];
     }
    else if (2 == iShareSoucre)
     {
        UIImage * image =  [UIImage imageNamed:@"set_tou2"];
        [[DDGShareManager shareManager] weChatShare:@{@"title":shareTitle, @"subTitle":shareContent,@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} shareScene:0 block:^(id result){
            NSDictionary *dic = (NSDictionary *)result;
            if ([[dic objectForKey:@"success"] boolValue]) {
               
                //[MBProgressHUD showErrorWithStatus:@"支付取消" toView:self.view];
            }else{
               
            }
        }];;
     }

    //每日任务今日分享
    if (self.shareType == 1) {
        self.shareBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
-(void) actionPYQ
{
    if (1 == iShareSoucre)
     {
        UIImage * image = [self captureImageFromView:viewBG];
        UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
        [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:1];
        
        [[DDGShareManager  shareManager] setBlock:^(id obj) {
            
            NSDictionary *dic = (NSDictionary *)obj;
            if ([[dic objectForKey:@"success"] boolValue]) {
                [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            }else{
                [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
            }
        }];
     }
    else if (2 == iShareSoucre)
     {
        UIImage * image =  [UIImage imageNamed:@"set_tou2"];
        NSString *strPYQTitle = [NSString stringWithFormat:@"天狗窝下载地址:%@", shareUrl];
        [[DDGShareManager shareManager] weChatShare:@{@"title":strPYQTitle, @"subTitle":shareContent,@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} shareScene:1 block:^(id result){
            NSDictionary *dic = (NSDictionary *)result;
            if ([[dic objectForKey:@"success"] boolValue]) {
                
                //[MBProgressHUD showErrorWithStatus:@"支付取消" toView:self.view];
            }else{
                
            }
        }];;
     }

    //每日任务今日分享
    if (self.shareType == 1) {
        self.shareBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//截图功能

-(UIImage *)captureImageFromView:(UIView *)view{
    
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    
    [[UIColor clearColor] setFill];
    
    
    [[UIBezierPath bezierPathWithRect:view.bounds] fill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    //    textfieldYJ.hidden = NO;
    //    labelT3_A.hidden = NO;
    //    labelT3_B.hidden = NO;
    //
    //    labelSB.hidden = YES;
    //    labelShowYJ.hidden = YES;
    //    imgTail.hidden = YES;
    
    return image;
    
}



@end
