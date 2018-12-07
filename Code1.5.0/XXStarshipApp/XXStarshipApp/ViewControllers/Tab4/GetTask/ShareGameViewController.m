//
//  ShareGameViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/28.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "ShareGameViewController.h"

@interface ShareGameViewController ()


@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImgViewLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImgViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImgViewLayoutTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewLayoutHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WXShareViewLayoutWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PYQShareViewLayoutWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *XZShareViewLayoutWidth;


@end

@implementation ShareGameViewController

-(void) loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetShareInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    [operation start];
}


-(void)shareGameUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/xjBase/shareGameInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD showSuccessWithStatus:@"分享成功，游戏次数加1" toView:self.view];
                                                                                      [self performBlock:^{
                                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                                      } afterDelay:1.5];                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void) handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.jsonResult.attr.count > 0){
        NSDictionary *dic = operation.jsonResult.attr;
        //设置二维码
        //imgCode;
        NSString *imgUrl = [dic objectForKey:@"qrCodeUrl"];
        [self.QRCodeImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutWhiteNaviBarViewWithTitle:@"分享游戏"];
    
    self.view.backgroundColor = UIColorFromRGB(0x807E80);
    
    [self layoutUI];
}


-(void)layoutUI{
    self.bgViewLayoutWidth.constant = 223 * ScaleSize;
    self.bgViewLayoutHeight.constant = 366 * ScaleSize;
    self.bgViewLayoutTop.constant = 60 * ScaleSize;
    self.QRCodeImgViewLayoutTop.constant = 125 * ScaleSize;
    self.QRCodeImgViewLayoutWidth.constant = self.QRCodeImgViewLayoutHeight.constant = 90 * ScaleSize;
    
    self.shareViewLayoutHeight.constant = 110 * ScaleSize;
    self.WXShareViewLayoutWidth.constant = self.PYQShareViewLayoutWidth.constant = self.XZShareViewLayoutWidth.constant = SCREEN_WIDTH/3;    
    
}

- (IBAction)funtchTouch:(UIButton *)sender {
    switch (sender.tag) {
        case 101:{
            [self shareWXHY];
        }break;
        case 102:{
            [self shareWXPYQ];
        }break;
        case 103:{
            UIImage *image = [self captureImageFromView:self.shareView];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }break;
        default:
            break;
    }
    
}

-(void)shareWXHY{
    
    UIImage *image = [self captureImageFromView:self.shareView];
    UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
    [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:0];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            //[MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            //游戏页面进入分享后加一次机会
            if (self.shareType == 100)
             {
                [self shareGameUrl];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
 
    
    //每日任务今日分享
    if (self.shareType == 1) {
        self.shareBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.shareType == 100) {
        //游戏页面进入分享后加一次机会
        //[self shareGameUrl];
    }
}

-(void)shareWXPYQ{
    UIImage *image = [self captureImageFromView:self.shareView];
    UIImage * imageXXJR = [UIImage imageNamed:@"tab3_head1"];
    [[DDGWeChat getSharedWeChat] shareIMG:@{@"image":UIImageJPEGRepresentation(image,1.0), @"imageXXJR":UIImageJPEGRepresentation(imageXXJR,0.3)} shareScene:1];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            //[MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            //游戏页面进入分享后加一次机会
            if (self.shareType == 100)
             {
                [self shareGameUrl];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
    //每日任务今日分享
    if (self.shareType == 1) {
        self.shareBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.shareType == 100) {
        //游戏页面进入分享后加一次机会
        //[self shareGameUrl];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
