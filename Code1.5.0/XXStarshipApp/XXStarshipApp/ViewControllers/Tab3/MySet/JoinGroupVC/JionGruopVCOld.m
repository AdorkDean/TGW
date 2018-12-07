//
//  JionGruopVCOld.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/6.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "JionGruopVCOld.h"

@interface JionGruopVCOld ()
{
    UIImageView *imgEWM;  // 二维码Img
    
    UIScrollView *viewTab;   // 当前tabView
    int  iTabTopY;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    int  iBtnSel;  // 1 - 加入步骤  2 - 领取狗粮
    
}
@end

@implementation JionGruopVCOld


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"加入群聊"];
    nav.backdropImg.image = [UIImage imageNamed:@"set_join_head"];
    
    barStyle =  UIStatusBarStyleDefault;
    
    [self layoutUI];
}

//-(void) layoutUI
//{
//    self.view.backgroundColor = [ResourceManager mainColor];
//
//    int iTopY =NavHeight;
//    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
//    [self.view addSubview:viewBG];
//    //viewBG.image = [UIImage imageNamed:@"set_join_bg"];
//    viewBG.userInteractionEnabled = YES;
////    [viewBG sd_setImageWithURL:[NSURL URLWithString:@"https://www.tiangouwo.com/apps/jiarWeb.png"] placeholderImage:[UIImage imageNamed:@"set_join_bg"]];
//
//
//    iTopY += 150 *ScaleSize;
//    if (IS_IPHONE_X_MORE)
//     {
//        iTopY += 20;
//     }
//    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH -30, 350)];
//    [self.view addSubview:viewYuan];
//    viewYuan.backgroundColor = [UIColor whiteColor];
//    viewYuan.cornerRadius = 10;
//
//    int iYuanWdith = viewYuan.width;
//    int iYuanTopY = 20;
//    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake((iYuanWdith-150)/2, iYuanTopY, 150, 30)];
//    [viewYuan addSubview:imgTitle];
//    imgTitle.image = [UIImage imageNamed:@"set_join_title"];
//
//    iYuanTopY += imgTitle.height +15;
//    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
//    [viewYuan addSubview:lable1];
//    lable1.font = [UIFont systemFontOfSize:14];
//    lable1.textColor = [ResourceManager color_1];
//    lable1.text = @"1. 点击保存二维码图片";
//
//    iYuanTopY += lable1.height +15;
//    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
//    [viewYuan addSubview:lable2];
//    lable2.font = [UIFont systemFontOfSize:14];
//    lable2.textColor = [ResourceManager color_1];
//    lable2.text = @"2. 打开微信长按识别添加客服微信";
//
//    iYuanTopY += lable2.height +15;
//    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
//    [viewYuan addSubview:lable3];
//    lable3.font = [UIFont systemFontOfSize:14];
//    lable3.textColor = [ResourceManager color_1];
//    lable3.text = @"3. 客服引导进入TGB官方交流群";
//
//    iYuanTopY += lable3.height +15;
//    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
//    [viewYuan addSubview:lable4];
//    lable4.font = [UIFont systemFontOfSize:14];
//    lable4.textColor = [ResourceManager color_1];
//    lable4.text = @"4. 24小时在线咨询 随时掌握TGB最新动态";
//
//    iYuanTopY += lable4.height +15;
//    imgEWM = [[UIImageView alloc] initWithFrame:CGRectMake((iYuanWdith-130)/2, iYuanTopY, 130, 130)];
//    [viewYuan addSubview:imgEWM];
//    NSString *strImgUrl = [CommonInfo getKey:K_WXQRCODEURL];
//    [imgEWM sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
//
//    iYuanTopY += imgEWM.height +5;
//    UILabel *lableTail = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
//    [viewYuan addSubview:lableTail];
//    lableTail.font = [UIFont systemFontOfSize:12];
//    lableTail.textColor = [ResourceManager color_1];
//    lableTail.text = @"- 点击保存图片 -";
//    lableTail.textAlignment = NSTextAlignmentCenter;
//
//
//    //添加手势
//    viewBG.userInteractionEnabled = YES;
//    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionCopy)];
//    gesture.numberOfTapsRequired  = 1;
//    //viewYuan.userInteractionEnabled = YES;
//    [viewBG addGestureRecognizer:gesture];
//
//}

#pragma mark --- 布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [ResourceManager mainColor];
    
    int iTopY =NavHeight;
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [self.view addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"set_join_bg"];
    viewBG.userInteractionEnabled = YES;
    //    [viewBG sd_setImageWithURL:[NSURL URLWithString:@"https://www.tiangouwo.com/apps/jiarWeb.png"] placeholderImage:[UIImage imageNamed:@"set_join_bg"]];
    
    
    //TODO:uiview 左边按钮 ，单边圆角或者单边框
    iTopY += 20;
    int iBtnWdith = 100;
    int iBtnLeft = (SCREEN_WIDTH - 2*iBtnWdith)/2;
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY, iBtnWdith, 30)];
    [self.view addSubview:btnLeft];
    btnLeft.backgroundColor = [UIColor clearColor];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left1"] forState:UIControlStateNormal];
    [btnLeft setTitle:@"加入步骤" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLeft addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //TODO:uiview 右边按钮，单边圆角或者单边框
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft + iBtnWdith, iTopY, iBtnWdith, 30)];
    [self.view addSubview:btnRight];
    btnRight.backgroundColor = [UIColor clearColor];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right2"] forState:UIControlStateNormal];
    [btnRight setTitle:@"领取狗粮" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnRight addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    iTopY += btnLeft.height + 20;
    iTabTopY = iTopY;
    viewTab = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTabTopY, SCREEN_WIDTH, SCREEN_HEIGHT - iTopY)];
    [self.view addSubview:viewTab];
    viewTab.backgroundColor = [UIColor clearColor];
    viewTab.contentSize = CGSizeMake(0, 300);
    viewTab.pagingEnabled = NO;
    viewTab.bounces = NO;
    viewTab.showsVerticalScrollIndicator = FALSE;
    viewTab.showsHorizontalScrollIndicator = FALSE;
    
    [self layoutTab1];
    
    
    
    
}

-(void) layoutTab1
{
    [viewTab removeAllSubviews];
    
    int iTopY = 10;
    //    UIImageView *imgTitle2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210)/2, iTopY, 210, 110)];
    //    [viewTab addSubview:imgTitle2];
    //    imgTitle2.image = [UIImage imageNamed:@"set_join_title2"];
    
    
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
    [viewTab addSubview:lableTitle];
    lableTitle.textColor = [UIColor whiteColor];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.font = [UIFont systemFontOfSize:46];
    lableTitle.text = @"加入群聊";
    
    iTopY += lableTitle.height + 15;
    int iBtnLeftX = 80;
    UIButton *btnGL = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, SCREEN_WIDTH - 2*iBtnLeftX, 30)];
    [viewTab addSubview:btnGL];
    btnGL.layer.borderColor = [UIColor whiteColor].CGColor;
    btnGL.layer.borderWidth = 0.5;
    btnGL.cornerRadius = 15;
    [btnGL setTitle:@"随时掌握天狗币动态" forState:UIControlStateNormal];
    [btnGL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGL.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    iTopY += btnGL.height + 30;
    
    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH -30, 350)];
    [viewTab addSubview:viewYuan];
    viewYuan.backgroundColor = [UIColor whiteColor];
    viewYuan.cornerRadius = 10;
    
    int iYuanWdith = viewYuan.width;
    int iYuanTopY = 30;
    UIImageView *imgTitle = [[UIImageView alloc] initWithFrame:CGRectMake((iYuanWdith-150)/2, iYuanTopY, 150, 30)];
    [viewYuan addSubview:imgTitle];
    imgTitle.image = [UIImage imageNamed:@"set_join_title"];
    
    iYuanTopY += imgTitle.height +25;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [ResourceManager color_1];
    lable1.text = @"1. 复制群链接: https://0.plus/tiangouwo";
    
    iYuanTopY += lable1.height +25;
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable2];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = [ResourceManager color_1];
    lable2.text = @"2. 在网页中打开，下载BiYong APP";
    
    iYuanTopY += lable2.height +25;
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 15)];
    [viewYuan addSubview:lable3];
    lable3.font = [UIFont systemFontOfSize:14];
    lable3.textColor = [ResourceManager color_1];
    lable3.text = @"3. 根据提示买入天狗窝群聊";
    
    iYuanTopY += lable3.height + 35;
    // 调整公告框的大小
    viewYuan.height = iYuanTopY;
    
    
    
    iTopY +=viewYuan.height + 20;
    UILabel *lableTail = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, iYuanWdith - 30, 30)];
    [viewTab addSubview:lableTail];
    lableTail.font = [UIFont systemFontOfSize:15];
    lableTail.textColor = [UIColor whiteColor];
    
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
    NSString *strWX = [NSString stringWithFormat:@"* 如有疑问请添加客服微信号:  %@",dicUser[@"kfWeiXin"]];
    
    lableTail.text = strWX;
    lableTail.numberOfLines = 0;
    [lableTail sizeToFit];
    //lableTail.textAlignment = NSTextAlignmentCenter;
    
    iTopY +=lableTail.height + 50;
    UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [viewTab addSubview:btnCopy];
    [btnCopy setTitle:@"复制群链接" forState:UIControlStateNormal];
    [btnCopy setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnCopy.backgroundColor = [ResourceManager viewBackgroundColor];
    btnCopy.cornerRadius = 45/2;
    [btnCopy addTarget:self action:@selector(actionCopy) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += btnCopy.height + 20;
    viewTab.contentSize = CGSizeMake(0, iTopY);
    
    //添加手势
    //    viewTab.userInteractionEnabled = YES;
    //    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionCopy)];
    //    gesture.numberOfTapsRequired  = 1;
    //    //viewYuan.userInteractionEnabled = YES;
    //    [viewTab addGestureRecognizer:gesture];
}

-(void) layoutTab2
{
    [viewTab removeAllSubviews];
    
    int iTopY = 20;
    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH -30, 350)];
    [viewTab addSubview:viewYuan];
    viewYuan.backgroundColor = [UIColor whiteColor];
    viewYuan.cornerRadius = 10;
    
    int iYuanWdith = viewYuan.width;
    int iYuanTopY = 30;
    
    //iYuanTopY += imgTitle.height +25;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 50)];
    [viewYuan addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [ResourceManager color_1];
    lable1.text = @"1. 加入群聊后，输入本人邀请吗(如示例，格式必须保持一致)";
    lable1.numberOfLines = 0;
    [lable1 sizeToFit];
    
    iYuanTopY += lable1.height +5;
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, iYuanTopY, iYuanWdith - 30, 50)];
    [viewYuan addSubview:lable2];
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textColor = [ResourceManager color_1];
    lable2.text = @"2. 截图上传，客服在24小时之内审核成功后自动发放狗粮到账户";
    lable2.numberOfLines = 0;
    [lable2 sizeToFit];
    
    iYuanTopY += lable2.height + 20;
    viewYuan.height = iYuanTopY;
}


#pragma mark --- action
-(void) actionCopy
{
    
    //UIImageWriteToSavedPhotosAlbum(imgEWM.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"https://0.plus/tiangouwo";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"复制群链接成功" message:@"去网页中打开，掌握天狗币动态" preferredStyle:UIAlertControllerStyleAlert];
    
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


-(void) actionLeft
{
    
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left1"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right2"] forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self layoutTab1];
}

-(void) actionRight
{
    [btnRight setBackgroundImage:[UIImage imageNamed:@"com_btn_right1"] forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"com_btn_left2"] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self layoutTab2];
}

@end
