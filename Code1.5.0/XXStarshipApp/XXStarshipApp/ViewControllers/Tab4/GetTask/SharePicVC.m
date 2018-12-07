//
//  SharePicVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/7.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "SharePicVC.h"

@interface SharePicVC ()
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

@implementation SharePicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_strNavTitle)
     {
        _strNavTitle = @"";
     }
    [self layoutNaviBarViewWithTitle:_strNavTitle];
    
    [self layoutUI];
    
    [self getShareInfo];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight-120)];
    [self.view  addSubview:viewBG];
    if (1 == _shareType)
     {
        viewBG.image = [UIImage imageNamed:@"Task2_jieqian_share_bg"];
     }
    
    [self layoutMid];
    
    [self layoutTail];
}

-(void) layoutMid
{
    if (1 == _shareType)
     {
        viewCenter = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewBG.height - 120, SCREEN_WIDTH - 20, 110)];
        [viewBG addSubview:viewCenter];
        viewCenter.backgroundColor = UIColorFromRGBA(0x0f1d4e, 0.8);
        
        int iCenterTopY = 10;
        int iCenterLeftX = 10;
        int iCenterWidth =  viewCenter.width;
        UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(iCenterLeftX,iCenterTopY , 90, 90)];
        [viewCenter addSubview:imgHead];
        imgHead.image = [UIImage imageNamed:@"task_addfriend_myhead"];
        
        int iLabelTopY = iCenterTopY + 15;
        int iLabelLeftX = iCenterLeftX + imgHead.width + 10;
        labelYQM = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX , iLabelTopY, 200, 25)];
        [viewCenter addSubview:labelYQM];
        labelYQM.textColor = [UIColor whiteColor];
        labelYQM.font = [UIFont systemFontOfSize:13];
        labelYQM.text = @"邀请码：";
        
        iLabelTopY += labelYQM.height;
        UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX, iLabelTopY, 150, 20)];
        [viewCenter addSubview:labelT];
        labelT.textColor = [UIColor whiteColor];
        labelT.font = [UIFont systemFontOfSize:13];
        labelT.text = @"分享 / 创造价值";
        
        iLabelTopY +=  labelT.height+10;
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
            iLabelLeftX = iCenterLeftX + imgHead.width + 2.5;
            labelYQM.left = iLabelLeftX;
            labelT.left = iLabelLeftX;
            label5.left = iLabelLeftX;
            
            labelYQM.font = [UIFont systemFontOfSize:11];
            labelT.font = [UIFont systemFontOfSize:11];
            label5.font = [UIFont systemFontOfSize:10];
            label5.text = @"扫码下载天狗窝";
            label5.width = 90;
         }
        
        
        imgCode = [[UIImageView alloc] initWithFrame:CGRectMake(iCenterWidth - iCenterLeftX - 90 - 5, iCenterTopY, 90, 90)];
        [viewCenter addSubview:imgCode];
        imgCode.backgroundColor = [UIColor yellowColor];
        
     }
}

-(void) layoutTail
{
    int iviewPopShareHeight =  125;
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
    
    
    // 保存到本地图片和按钮
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith*2, iTopY, iViewWdith, 100)];
    [viewPopShare addSubview:view3];
    
    UIImageView *imag3 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    [view3 addSubview:imag3];
    imag3.image = [UIImage imageNamed:@"com_save"];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = color1;
    label3.text = @"保存到本地";
    label3.textAlignment = NSTextAlignmentCenter;
    [view3 addSubview:label3];
    
    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharSave)];
    [view3 addGestureRecognizer:singleTap3];

    // 分割线

    
    
    //scView.contentSize = CGSizeMake(0, scView.height + iviewPopShareHeight + 5);
    
    //viewPopShare.hidden = YES;
}


-(void) setUIData:(NSDictionary*) dicData
{
    NSString *strNO = [NSString stringWithFormat:@"%@", dicData[@"inviteCode"]];//  @"10501";
    NSString *strAll = [NSString stringWithFormat:@"邀请码:  %@",strNO];
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:stringRange];
    
    if (IS_IPHONE_5_OR_LESS)
     {
        strAll = [NSString stringWithFormat:@"邀请码:%@",strNO];
        [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:stringRange];
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

#pragma  mark --- action
-(void) actionWX
{
    UIImage *image = [self captureImageFromView:viewBG];
    UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
    [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:0];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            if (self.shareType == 1)
             {
                [self.navigationController popViewControllerAnimated:YES];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
    if (self.shareBlock)
     {
        self.shareBlock();
     }
    

}


-(void) actionPYQ
{
    UIImage *image = [self captureImageFromView:viewBG];
    UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
    [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:0];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            if (self.shareType == 1)
             {

                [self.navigationController popViewControllerAnimated:YES];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
    if (self.shareBlock)
     {
        self.shareBlock();
     }
}

-(void) sharSave
{
    UIImage *image = [self captureImageFromView:viewBG];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
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
    
    
    return image;
    
}

#pragma mark======保存图片到系统相册

//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        NSString *message = [NSString stringWithFormat:@"保存图片失败,失败原因：%@",error];
        [MBProgressHUD showErrorWithStatus:message toView:self.view];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"图片已成功保存到系统相册" toView:self.view];
    }
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

@end
