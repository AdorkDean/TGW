//
//  JoinGruopVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/29.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "JoinGruopVC.h"

@interface JoinGruopVC ()
{
    UIScrollView *scView;
    
    UITextField *fieldCode;
    UIImageView *imgEWM;  // 二维码Img

}


@end

@implementation JoinGruopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithUIAndTitle:@"加入群聊"];
    nav.backdropImg.image = [UIImage imageNamed:@"set_join_head"];
    
    barStyle =  UIStatusBarStyleDefault;
    
    [self layoutUI];
    
    [self getEWM];
}


#pragma mark --- 布局UI
-(void) layoutUI
{
    
    int iTopY =NavHeight;
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NavHeight);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];

    iTopY =0;
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [scView addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"set_join_bg"];
    viewBG.userInteractionEnabled = YES;



    iTopY += 10 *ScaleSize;
    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH -30, 350)];
    [scView addSubview:viewYuan];
    viewYuan.backgroundColor = [UIColor whiteColor];
    viewYuan.cornerRadius = 10;

    
    int iYuanTopY = 30;
    int iYuanWdith = viewYuan.width;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iYuanTopY, iYuanWdith, 20)];
    [viewYuan addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    //joinType  //0-微信群 1-QQ群 2-币用群
    NSString *strTemp = @"请输入微信群邀请码";
    if (1 == _joinType)
     {
        strTemp = @"请输入QQ群邀请码";
     }
    else if (2 == _joinType)
     {
        strTemp = @"请输入币用群邀请码";
     }
    labelTitle.text = strTemp;//@"请输入微信群邀请码";
    
    iYuanTopY += labelTitle.height + 30;
    fieldCode = [[UITextField alloc] initWithFrame:CGRectMake(0, iYuanTopY, iYuanWdith, 20)];
    [viewYuan addSubview:fieldCode];
    fieldCode.font = [UIFont systemFontOfSize:16];
    fieldCode.textColor = [ResourceManager color_1];
    fieldCode.placeholder = @"请输入邀请码";
    fieldCode.textAlignment = NSTextAlignmentCenter;
    //fieldCode.delegate = self;
    
    iYuanTopY +=fieldCode.height+5;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(20, iYuanTopY, iYuanWdith - 40, 1)];
    [viewYuan addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    viewFG1.userInteractionEnabled = YES;
    
    
    iYuanTopY += 30;
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(20, iYuanTopY, iYuanWdith - 40, 45)];
    [viewYuan addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager mainColor];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    btnOK.cornerRadius = 45/2;
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    iYuanTopY += btnOK.height + 50;
    UIImageView * lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, iYuanTopY, iYuanWdith- 70, 1)];
    [viewYuan addSubview:lineView1];
    lineView1.image = [self imageWithLineWithImageView:lineView1];
    
    UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, iYuanTopY - 20, 20, 40)];
    [viewYuan addSubview:imgLeft];
    imgLeft.image = [UIImage imageNamed:@"set_join_yuan_left"];
    
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iYuanWdith- 20, iYuanTopY - 20, 20, 40)];
    [viewYuan addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"set_join_yuan_right"];



    //iYuanTopY += lable4.height +15;
    iYuanTopY += 30;
    imgEWM = [[UIImageView alloc] initWithFrame:CGRectMake((iYuanWdith-200)/2, iYuanTopY, 200, 200)];
    [viewYuan addSubview:imgEWM];
    imgEWM.backgroundColor = [ResourceManager viewBackgroundColor];
    
    imgEWM.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionCopy)];
    gesture.numberOfTapsRequired  = 1;
    [imgEWM addGestureRecognizer:gesture];
    
    
    iYuanTopY += imgEWM.height +15;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = UIColorFromRGB(0x929292);
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"点击保存二维码图片";
    
    iYuanTopY += lable1.height+5;
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable2];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = UIColorFromRGB(0x929292);
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = @"扫描加入微信群";
    
    //joinType  //0-微信群 1-QQ群 2-币用群
    strTemp = @"扫描加入微信群";
    if (1 == _joinType)
     {
        strTemp = @"扫描加入QQ群";
     }
    else if (2 == _joinType)
     {
        strTemp = @"扫描加入币用群";
     }
    lable2.text = strTemp;//@"扫描加入微信群";
    
    iYuanTopY += lable2.height+5;
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable3];
    lable3.font = [UIFont systemFontOfSize:14];
    lable3.textColor = UIColorFromRGB(0x929292);
    lable3.textAlignment = NSTextAlignmentCenter;
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
    NSString *strWX = [NSString stringWithFormat:@"客服微信：%@",dicUser[@"kfWeiXin"]];
    lable3.text = strWX;

    iYuanTopY += 40;
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable4];
    lable4.font = [UIFont systemFontOfSize:15];
    lable4.textColor = [ResourceManager color_1];
    lable4.text = @"获取邀请码途径";
    lable4.textAlignment = NSTextAlignmentCenter;
    
    iYuanTopY += lable4.height + 5;
    UILabel *lableTail = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lableTail];
    lableTail.font = [UIFont systemFontOfSize:13];
    lableTail.textColor = [ResourceManager color_1];
    
    //joinType  //0-微信群 1-QQ群 2-币用群
    strTemp = @"加入微信群 —— 通过群公告获得";
    if (1 == _joinType)
     {
        strTemp = @"加入QQ群 —— 通过群公告获得";
     }
    else if (2 == _joinType)
     {
        strTemp = @"加入币用群 —— 通过群公告获得";
     }
    
    lableTail.text = strTemp;//@"加入微信群 —— 通过群公告获得";
    lableTail.textAlignment = NSTextAlignmentCenter;
    
    
    // 调整viewYuan 的高度
    iYuanTopY += lableTail.height + 30;
    viewYuan.height = iYuanTopY;
    
    
    iTopY +=viewYuan.height +30;
    if (iTopY > viewBG.height)
     {
        viewBG.height = iTopY;
        scView.contentSize = CGSizeMake(0, iTopY);
     }
    
    



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





#pragma mark --- action
-(void) actionOK
{
    if (fieldCode.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入邀请码" toView:self.view];
        return;
     }
    
    [self commitCode];
    
}

-(void) actionCopy
{
    if (imgEWM.image)
     {
        UIImageWriteToSavedPhotosAlbum(imgEWM.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccessWithStatus:@"保存失败" toView:self.view];
    } else {
        [MBProgressHUD showSuccessWithStatus:@"成功保存到相册" toView:self.view];
    }
}

#pragma mark --- 网络通讯
-(void) getEWM
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGbindJoinGroupInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"joinType"] = [NSString stringWithFormat:@"%d", _joinType];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void) commitCode
{
    [LoadView showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGautoJoinGroupChat];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"joinType"] = [NSString stringWithFormat:@"%d", _joinType];
    parmas[@"activeCode"] = fieldCode.text ;
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [LoadView showSuccessWithStatus:@"领取狗粮成功" toView:self.view];
                                                                                      
                                                                                      // 在延迟后执行
                                                                                      [self performSelector:@selector(delayFun) withObject:nil afterDelay:1];
                                                                                      
                                                                                  }                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}




-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        NSDictionary *dicData = operation.jsonResult.attr;
//        if ([dicData count] > 0)
//         {
//            [self layoutUI];
//            [self setUIHead:dicData];
//         }
        NSString *strImgUrl = dicData[@"qunQrCodeUrl"];
        if (strImgUrl &&
            strImgUrl.length > 0)
         {
            [imgEWM sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
         }
        
     }
}


-(void) delayFun
{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
