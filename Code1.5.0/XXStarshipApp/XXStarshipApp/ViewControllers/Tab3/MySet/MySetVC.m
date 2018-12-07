//
//  MySetVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/22.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "MySetVC.h"
#import "FeedbackVC.h"
#import "JoinGruopVC.h"
#import "RsaUtil.h"
#import "SetNikeVC.h"
#import "ConectUsVC.h"


#define    Phone_Number   @"0755-23607473"

@interface MySetVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgHead;
    UILabel *lableMyAccout;
    UILabel *lableMyNike;
    UILabel *lableMyName;
    UILabel *lableMyCard;
    
    NSDictionary *dicUser;
    
    UIButton *btnQuit;
    BOOL isQuit;
}
@end

@implementation MySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"账号设置"];
    
    //[self actionQuit];
    [self layoutUI];
    
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserInfo];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iTopY = NavHeight;
    int iLeftX = 10;
    
    int iCellHeight = 50;
    
    
    // 头像
    UIView *viewTemp1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight+15)];
    [self.view addSubview:viewTemp1];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15+7.5, 100, 20)];
    [viewTemp1 addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"头像";
    
    imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 10, 45, 45)];
    [viewTemp1 addSubview:imgHead];
    imgHead.cornerRadius = 22.5;
    imgHead.layer.masksToBounds = YES;
    imgHead.image = [UIImage imageNamed:@"set_tou1"];
    
    UIImageView *imgRight1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 15, 15+7.5, 10, 17)];
    [viewTemp1 addSubview:imgRight1];
    imgRight1.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight+15-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp1 addSubview:labelFG1];
    labelFG1.backgroundColor = [ResourceManager color_5];
    
    //添加手势
    viewTemp1.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionHead)];
    gesture.numberOfTapsRequired  = 1;
    [viewTemp1 addGestureRecognizer:gesture];
    
    // 当前账号
    iTopY += iCellHeight + 15;
    UIView *viewTemp2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp2 addSubview:label2];
    label2.textColor = [ResourceManager color_1];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"当前账号";
    
    lableMyAccout = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 200, 15, 195, 20)];
    [viewTemp2 addSubview:lableMyAccout];
    lableMyAccout.textColor = [ResourceManager mainColor];
    lableMyAccout.font = [UIFont systemFontOfSize:14];
    lableMyAccout.text = @"1823***12321";
    lableMyAccout.textAlignment = NSTextAlignmentRight;
    
    UILabel *labelFG2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp2 addSubview:labelFG2];
    labelFG2.backgroundColor = [ResourceManager color_5];
    
    // 昵称
    iTopY += iCellHeight;
    UIView *viewTemp2_1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp2_1];
    
    UILabel *label2_1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp2_1 addSubview:label2_1];
    label2_1.textColor = [ResourceManager color_1];
    label2_1.font = [UIFont systemFontOfSize:14];
    label2_1.text = @"昵称";
    
    lableMyNike = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 215, 15, 195, 20)];
    [viewTemp2_1 addSubview:lableMyNike];
    lableMyNike.textColor = [ResourceManager mainColor];
    lableMyNike.font = [UIFont systemFontOfSize:14];
    lableMyNike.text = @"";
    lableMyNike.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imgRight21_1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 15, 15, 10, 17)];
    [viewTemp2_1 addSubview:imgRight21_1];
    imgRight21_1.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG2_1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp2_1 addSubview:labelFG2_1];
    labelFG2_1.backgroundColor = [ResourceManager color_5];
    
    
    //添加手势
    viewTemp2_1.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture2_1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionNike)];
    gesture2_1.numberOfTapsRequired  = 1;
    [viewTemp2_1 addGestureRecognizer:gesture2_1];
    
    // 姓名
    iTopY += iCellHeight;
    UIView *viewTemp3 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp3 addSubview:label3];
    label3.textColor = [ResourceManager color_1];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"姓名";
    
    lableMyName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 200, 15, 195, 20)];
    [viewTemp3 addSubview:lableMyName];
    lableMyName.textColor = [ResourceManager mainColor];
    lableMyName.font = [UIFont systemFontOfSize:14];
    lableMyName.text = @"1823***12321";
    lableMyName.textAlignment = NSTextAlignmentRight;
    
    UILabel *labelFG3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp3 addSubview:labelFG3];
    labelFG3.backgroundColor = [ResourceManager color_5];
    
    
    // 身份证号
    iTopY += iCellHeight;
    UIView *viewTemp4 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp4];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp4 addSubview:label4];
    label4.textColor = [ResourceManager color_1];
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"身份证号";
    
    lableMyCard = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 200, 15, 195, 20)];
    [viewTemp4 addSubview:lableMyCard];
    lableMyCard.textColor = [ResourceManager mainColor];
    lableMyCard.font = [UIFont systemFontOfSize:14];
    lableMyCard.text = @"1823***12321";
    lableMyCard.textAlignment = NSTextAlignmentRight;
    
    UILabel *labelFG4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp4 addSubview:labelFG4];
    labelFG4.backgroundColor = [ResourceManager color_5];
    
    // 版本号
    iTopY += iCellHeight;
    UIView *viewTemp5 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp5];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp5 addSubview:label5];
    label5.textColor = [ResourceManager color_1];
    label5.font = [UIFont systemFontOfSize:14];
    label5.text = @"版本号";
    
    UILabel *lableVersion = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 200, 15, 195, 20)];
    [viewTemp5 addSubview:lableVersion];
    lableVersion.textColor = [ResourceManager mainColor];
    lableVersion.font = [UIFont systemFontOfSize:14];
    NSString *bundleStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    lableVersion.text = bundleStr;
    lableVersion.textAlignment = NSTextAlignmentRight;
    
    UILabel *labelFG5 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp5 addSubview:labelFG5];
    labelFG5.backgroundColor = [ResourceManager color_5];
    
    // 意见反馈
    iTopY += iCellHeight;
    UIView *viewTemp6 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp6];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp6 addSubview:label6];
    label6.textColor = [ResourceManager color_1];
    label6.font = [UIFont systemFontOfSize:14];
    label6.text = @"意见反馈";
    
    UIImageView *imgRight6 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 15, 15, 10, 17)];
    [viewTemp6 addSubview:imgRight6];
    imgRight6.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG6 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp6 addSubview:labelFG6];
    labelFG6.backgroundColor = [ResourceManager color_5];
    
    //添加手势点
    viewTemp6.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionAdivse)];
    gesture6.numberOfTapsRequired  = 1;
    [viewTemp6 addGestureRecognizer:gesture6];
    
    // 加入群聊
    iTopY += iCellHeight;
    UIView *viewTemp7 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp7];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp7 addSubview:label7];
    label7.textColor = [ResourceManager color_1];
    label7.font = [UIFont systemFontOfSize:14];
    label7.text = @"加入群聊";
    
    UIImageView *imgRight7 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 15, 15, 10, 17)];
    [viewTemp7 addSubview:imgRight7];
    imgRight7.image = [UIImage imageNamed:@"arrow-2"];
    
    UILabel *labelFG7 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp7 addSubview:labelFG7];
    labelFG7.backgroundColor = [ResourceManager color_5];
    
    //添加手势
    viewTemp7.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionJoin)];
    gesture7.numberOfTapsRequired  = 1;
    [viewTemp7 addGestureRecognizer:gesture7];
    
    
    // 联系我们
    iTopY += iCellHeight;
    UIView *viewTemp8 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
    [self.view addSubview:viewTemp8];

    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, 15, 100, 20)];
    [viewTemp8 addSubview:label8];
    label8.textColor = [ResourceManager color_1];
    label8.font = [UIFont systemFontOfSize:14];
    label8.text = @"客服微信";
    
    
    UILabel *lableWX = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 215, 15, 195, 20)];
    [viewTemp8 addSubview:lableWX];
    lableWX.textColor = [ResourceManager mainColor];
    lableWX.font = [UIFont systemFontOfSize:14];
    //NSString *bundleStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
    NSString *strWX = [NSString stringWithFormat:@"%@",dicUser[@"kfWeiXin"]];
    lableWX.text = strWX;//@"tiangouwo";
    lableWX.textAlignment = NSTextAlignmentRight;

    UIImageView *imgRight8 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLeftX - 15, 15, 10, 17)];
    [viewTemp8 addSubview:imgRight8];
    imgRight8.image = [UIImage imageNamed:@"arrow-2"];


    UILabel *labelFG8 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellHeight-1, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewTemp8 addSubview:labelFG8];
    labelFG8.backgroundColor = [ResourceManager color_5];



    //添加手势
    viewTemp8.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionUS )];
    gesture8.numberOfTapsRequired  = 1;
    [viewTemp8 addGestureRecognizer:gesture8];
    
    
    iTopY+= iCellHeight + 30;
    if (IS_IPHONE_5_OR_LESS)
     {
        iTopY -= 30;
        //labelFG8.hidden = YES;
     }
    
    btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnQuit];
    btnQuit.backgroundColor = [ResourceManager mainColor];
    [btnQuit setTitle:@"退出登录" forState:UIControlStateNormal];
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:16];
    btnQuit.cornerRadius = 20;
    [btnQuit addTarget:self  action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void) setUIData:(NSDictionary*) dicUser
{
    if (dicUser == nil)
     {
        imgHead.image =  [UIImage imageNamed:@"set_tou1"];
        lableMyAccout.text = @"";
        lableMyName.text = @"";
        lableMyCard.text = @"";
        lableMyNike.text = @"";
        return;
     }
    
    [imgHead sd_setImageWithURL:[NSURL URLWithString:dicUser[@"headImg"]] placeholderImage:[UIImage imageNamed:@"set_tou2"]];
    lableMyAccout.text = dicUser[@"hideTelephone"];
    lableMyName.text = dicUser[@"realName"];
    lableMyCard.text = dicUser[@"cardNo"];
    lableMyNike.text = dicUser[@"nickName"];
}

#pragma mark --- action
- (void) actionQuit
{
    if (isQuit  ||
        ![[DDGAccountManager sharedManager] isLoggedIn])
     {
        [self logoutToWeb];
        return;
     }
    
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"确认退出"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"退出", nil];
    
    [sheet showInView:self.view];
    sheet.tag = 1;
}

-(void) actionHead
{

    [self.view endEditing:YES];
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
    sheet.tag = 2;
    
}

-(void) actionAdivse
{
    FeedbackVC *VC = [[FeedbackVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionJoin
{
    JoinGruopVC *VC = [[JoinGruopVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionNike
{
    SetNikeVC *VC = [[SetNikeVC alloc] init];
    if (dicUser)
     {
        VC.strNikeName = dicUser[@"nickName"];
     }
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionUS
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"tiangouwo";
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信" toView:self.view];
        return;
     }
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"复制微信号成功" message:@"去微信，添加客服" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
    }];
    
    
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //ConectUsVC  *VC = [[ConectUsVC alloc] init];
    //[self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
     {
        if (buttonIndex == 0) //退出
         {
            [self logoutToWeb];
            
         }
        else
         {
            
         }
     }
    else if (actionSheet.tag == 2)
     {
        if (buttonIndex == 0) //拍摄
         {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                           UIImagePickerControllerSourceTypeCamera];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //pickerController.allowsEditing = YES;
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
         } else if (buttonIndex == 1) //从相册中获取照片
          {
             if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
              {
                 return;
              }
             
             UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
             pickerController.delegate = self;
             pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
             pickerController.allowsEditing = YES;
             if (iOS7) {
                 pickerController.navigationBar.barTintColor = [ResourceManager redColor2];
             }else{
                 pickerController.navigationBar.tintColor = [ResourceManager redColor2];
             }
             
             [self.navigationController presentViewController:pickerController animated:YES completion:nil];
          }
     }
}

#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//#define dataSize 1024.0f
//#define imageSize CGSizeMake(600.0f, 600.0f)
//    //先把原图保存到图片库
//    //if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//
//    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        //UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
//
//    //获取用户选取的图片并转换成NSData
//    //UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    //缩小图片的size
//    UIImage *image = [self imageByRedraw:originalImage];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
//    if (imageData){
//        self.imageData = imageData;
//        // 上传
//        [self upLoadImageData];
//        [picker dismissViewControllerAnimated:YES completion:nil];
//    }
//}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    
    UIImage *image = nil;
    //先把原图保存到图片库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
     {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
        // 相机获取
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
     }
    else
     {
        // 相册获取
        //获取用户选取的图片并转换成NSData
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
     }
    
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    return;
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

#pragma mark --- 网络通讯
-(void) getUserInfo
{
    [self setUIData:nil];
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetUserInfo];
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

- (void) logoutToWeb
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGlogOut];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      // 退出登录
                                                                                      [LoadView showSuccessWithStatus:@"退出登录成功" toView:self.view];
                                                                                      [[DDGAccountManager sharedManager] deleteUserData];
                                                                                      [self setUIData:nil];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

//-(void)upLoadImageData{
//    [LoadView showHUDNavAddedTo:self.view animated:YES];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"fileType"] = @"dogHead";
//    params[@"signId"] = [DDGSetting sharedSettings].signId;
//    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSString *versionStr = [NSString stringWithFormat:@"xxStarshipIOS%@",currentVersion];
//    params[@"appVersion"] = versionStr;
//
//    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
//    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kDDGuploadFile];
//    [requestManager POST:strUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//
//
//        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
//
//            NSString *headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
//            [self upLoadImgHead:headImgStr];
//        }
//        else{
//            [LoadView showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
//        }
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        [LoadView hideHUDForView:self.view animated:NO];
//        [LoadView showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
//        self.imageData = nil;
//    }];
//}

-(void)upLoadImageData{
    [LoadView showHUDNavAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"dogHead";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"TgwTpIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    
//    NSURL *parmeURL =   DDG_urldict(@"", params);
//    NSString *strJM = [parmeURL absoluteString];
//    if (strJM &&
//        strJM.length > 1)
//     {
//        strJM =  [strJM substringFromIndex:1];
//        // URL 解码
//        strJM =  [strJM stringByRemovingPercentEncoding];
//     }
//    NSMutableDictionary *parameJM = [[NSMutableDictionary alloc] init];
//    parameJM[@"requestParam"] = [RsaUtil encrypt16String:strJM publicKey:RSAPublickKey];
//
//
//    parameJM[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kDDGuploadFile];
    [requestManager POST:strUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            
            NSString *headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
            [self upLoadImgHead:headImgStr];
        }
        else{
            [LoadView showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [LoadView hideHUDForView:self.view animated:NO];
        [LoadView showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}


-(void) upLoadImgHead:(NSString*)strHead
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGupdateUserInfo];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"headImg"] = strHead;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [LoadView hideAllHUDsForView:self.view animated:YES];
                                                                                      
                                                                                      [self getUserInfo];
                                                                                      
                                                                                    
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    //operation.tag = 1001;
    [operation start];
}

-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1000 == operation.tag)
     {
        // 获取个人信息
        dicUser = operation.jsonResult.attr;
        if ([dicUser count] > 0)
         {
            [self setUIData:dicUser];
         }
     }
    else if (1001 == operation.tag)
     {
        // 退出登录
        [LoadView showSuccessWithStatus:@"退出登录成功" toView:self.view];
        [[DDGAccountManager sharedManager] deleteUserData];
        [self setUIData:nil];
        
        isQuit = TRUE;
        [btnQuit setTitle:@"登录" forState:UIControlStateNormal];
     }
}


@end
