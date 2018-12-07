//
//  TaskZZViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/26.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "TaskZZViewController.h"

#import "AddFriendVC.h"
#import "ShareGameViewController.h"
#import "AnswerQuestionsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SharePicVC.h"


@interface TaskZZViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _taskId;
    
    UIButton *_shareBtn;
    UILabel *_shareLabel;
    NSString *_headImgStr;
    
    UIView *_shotsView;
    UIImageView *_shotsImgView;
}
@end

@implementation TaskZZViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/today/task/queryTaskInfo",[PDAPI getBaseUrlString]] parameters:@{@"taskId":@(_taskId)} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    
    
    [operation start];
    operation.tag = 1000;
}


-(void)finishUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/today/task/finish",[PDAPI getBaseUrlString]] parameters:@{@"todayTaskRecordId":[self.taskDic objectForKey:@"recordId"]} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                  }];
    [operation start];
}

-(void)xcodeUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/xjBase/getXCode",[PDAPI getBaseUrlString]] parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1001;
}

#pragma mark ---数据操作---
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super handleData:operation];
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            NSDictionary *dic = operation.jsonResult.rows[0];
            //  taskStatus  -1 初始状态 0-审核中 1-完成 2-审核失败
            if ([[dic objectForKey:@"auditStatus"] intValue] == 0 ||
                [[dic objectForKey:@"auditStatus"] intValue] == 2) {
                _shareBtn.hidden = YES;
                _shareLabel.hidden = YES;
                
                _headImgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"screenImg"]];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shareBtn.frame), SCREEN_WIDTH, 20)];
                [self.view addSubview:titleLabel];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [ResourceManager color_1];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.text = @"截图已上传，等待审核中！";
                
                if ([[dic objectForKey:@"auditStatus"] intValue] == 2)
                 {
                    titleLabel.text = @"审核失败！请重新上传。";
                 }
                
                int iBtnLeftX = (SCREEN_WIDTH - 120 *2 - 20)/2;
                
                UIButton *reUploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(iBtnLeftX, CGRectGetMaxY(titleLabel.frame), 120, 20)];
                [self.view addSubview:reUploadBtn];
                reUploadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [reUploadBtn setTitle:@"重新上传图片" forState:UIControlStateNormal];
                [reUploadBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
                [reUploadBtn addTarget:self action:@selector(updateImg) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(iBtnLeftX+20 + 120, CGRectGetMaxY(titleLabel.frame), 120, 20)];
                [self.view addSubview:imgBtn];
                imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [imgBtn setTitle:@"点击查看截图" forState:UIControlStateNormal];
                [imgBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
                [imgBtn addTarget:self action:@selector(lookImg) forControlEvents:UIControlEventTouchUpInside];
                
                
                
            }
            
        }
    }else if (operation.tag == 1001) {
        
        NSString *url = [NSString stringWithFormat:@"%@?xcode=%@&todayTaskRecordId=%@",[self.taskDic objectForKey:@"taskUrl"],[operation.jsonResult.attr objectForKey:@"xcode"],[self.taskDic objectForKey:@"recordId"]];
        AnswerQuestionsViewController *ctl = [[AnswerQuestionsViewController alloc]init];
        ctl.url = url;
        [self.navigationController pushViewController:ctl animated:YES];
        
    }
    
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [super handleErrorData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutWhiteNaviBarViewWithTitle:self.titleStr];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _taskId = [[self.taskDic objectForKey:@"taskId"] integerValue];
    
    if (_taskId == 24 ||
        _taskId == 25 ||
        _taskId == 27 ||
        _taskId == 30 ||
        _taskId == 31 ||
        _taskId == 32) {
        //各种分享
        [self layoutUI_1];
    }else if (_taskId == 26) {
        //浏览官网
        [self layoutUI_2];
    }else if (_taskId == 29) {
        //做题
        [self layoutUI_3];
    }
    
}





-(void)layoutUI_1{
    
    UIView *rectangularView = [[UIView alloc]initWithFrame:CGRectMake(15, NavHeight + 30, SCREEN_WIDTH - 30, 230)];
    [self.view addSubview:rectangularView];
    rectangularView.layer.cornerRadius = 15;
    rectangularView.layer.borderWidth = 0.5;
    rectangularView.layer.borderColor = UIColorFromRGB(0x5A54FF).CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 260)/2, NavHeight + 10, 260, 40)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220, 40)];
    [view addSubview:titleLabel];
    titleLabel.backgroundColor = UIColorFromRGB(0x5A54FF);
    titleLabel.layer.cornerRadius = 40/2;
    titleLabel.clipsToBounds = YES;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@奖励%@粮票",[_taskDic objectForKey:@"taskName"],[_taskDic objectForKey:@"rewardValue"]];
    
    NSString *str = [NSString string];
    if (_taskId == 24 || _taskId == 25 || _taskId == 27 || _taskId == 30 || _taskId == 31) {
        str = @"点击'立即分享按钮，进入页面分享给好友";
    }else if (_taskId == 25) {
        str = @"点击'立即分享按钮，进入页面分享到朋友圈";
    }else if (_taskId == 27) {
        str = @"点击'立即分享按钮，进入页面分享信用卡页面";
    }else if (_taskId == 30) {
        str = @"点击'立即分享按钮，进入页面分享到微信群";
    }else if (_taskId == 31) {
        str = @"点击'立即分享按钮，进入页面分享游戏页面";
    }else if (_taskId == 32) {
        str = @"点击'立即分享按钮，进入页面分享借钱页面";
    }
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 250 * ScaleSize, 20)];
    [rectangularView addSubview:label_1];
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.textColor = [ResourceManager color_1];
    label_1.text = str;
    
    UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label_1.frame), 250 * ScaleSize, 40)];
    [rectangularView addSubview:label_2];
    label_2.numberOfLines = 2;
    label_2.textColor = [ResourceManager color_1];
    label_2.font = [UIFont systemFontOfSize:14];
    label_2.text = @"分享给好友后需进行截图，分享后返回本页面再点击上传即可";
    
    UILabel *label_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, 20, 20)];
    [rectangularView addSubview:label_3];
    label_3.textAlignment = NSTextAlignmentCenter;
    label_3.font = [UIFont systemFontOfSize:17];
    label_3.textColor = UIColorFromRGB(0x5A54FF);
    label_3.text = @"*";
    
    UILabel *label_4 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label_3.frame), 20, 20)];
    [rectangularView addSubview:label_4];
    label_4.textAlignment = NSTextAlignmentCenter;
    label_4.font = [UIFont systemFontOfSize:17];
    label_4.textColor = UIColorFromRGB(0x5A54FF);
    label_4.text = @"*";
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label_2.frame) + 15, 290 * ScaleSize, 0.5)];
    [rectangularView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Tab4-6"];
    
    UILabel *label_5 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imgView.frame) + 15, 250 * ScaleSize, 70)];
    [rectangularView addSubview:label_5];
    label_5.numberOfLines = 0;
    label_5.textColor = [ResourceManager color_6];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.text = @"每位用户每天仅有一次领取机会\n上传截图后等待审核，审核通过后可在今日任务页或提交审核起三日内在任务记录里领取奖励，超时奖励将失效";
    
    _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMaxY(rectangularView.frame) + 50, 120, 40)];
    [self.view addSubview:_shareBtn];
    _shareBtn.layer.cornerRadius = 40/2;
    _shareBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shareBtn setTitle:@"立即分享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareTouch) forControlEvents:UIControlEventTouchUpInside];
    
    _shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shareBtn.frame), SCREEN_WIDTH, 30)];
    [self.view addSubview:_shareLabel];
    _shareLabel.textAlignment = NSTextAlignmentCenter;
    _shareLabel.textColor = [ResourceManager color_6];
    _shareLabel.font = [UIFont systemFontOfSize:12];
    _shareLabel.text = @"点击按钮可直接跳转";
    
    
}

-(void)layoutUI_2{
    
    UIView *rectangularView = [[UIView alloc]initWithFrame:CGRectMake(15, NavHeight + 30, SCREEN_WIDTH - 30, 180)];
    [self.view addSubview:rectangularView];
    rectangularView.layer.cornerRadius = 15;
    rectangularView.layer.borderWidth = 0.5;
    rectangularView.layer.borderColor = UIColorFromRGB(0x5A54FF).CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 260)/2, NavHeight + 10, 260, 40)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220, 40)];
    [view addSubview:titleLabel];
    titleLabel.backgroundColor = UIColorFromRGB(0x5A54FF);
    titleLabel.layer.cornerRadius = 40/2;
    titleLabel.clipsToBounds = YES;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@奖励%@粮票",[_taskDic objectForKey:@"taskName"],[_taskDic objectForKey:@"rewardValue"]];
    
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 250 * ScaleSize, 40)];
    [rectangularView addSubview:label_1];
    label_1.numberOfLines = 2;
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.textColor = [ResourceManager color_1];
    label_1.text = @"点击‘立即浏览’按钮，进入天狗窝官网浏览了解天狗窝";
    
   
    
    UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, 20, 20)];
    [rectangularView addSubview:label_2];
    label_2.textAlignment = NSTextAlignmentCenter;
    label_2.font = [UIFont systemFontOfSize:17];
    label_2.textColor = UIColorFromRGB(0x5A54FF);
    label_2.text = @"*";
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label_1.frame) + 15, 290 * ScaleSize, 0.5)];
    [rectangularView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Tab4-6"];
    
    UILabel *label_5 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imgView.frame) + 15, 250 * ScaleSize, 40)];
    [rectangularView addSubview:label_5];
    label_5.numberOfLines = 0;
    label_5.textColor = [ResourceManager color_6];
    label_5.font = [UIFont systemFontOfSize:12];
    label_5.text = @"每位用户每天仅有一次领取机会\n点击按钮进入官网浏览即可获得奖励";
    
    _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMaxY(rectangularView.frame) + 50, 120, 40)];
    [self.view addSubview:_shareBtn];
    _shareBtn.layer.cornerRadius = 40/2;
    _shareBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shareBtn setTitle:@"立即浏览" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(browse) forControlEvents:UIControlEventTouchUpInside];
    
    _shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shareBtn.frame), SCREEN_WIDTH, 30)];
    [self.view addSubview:_shareLabel];
    _shareLabel.textAlignment = NSTextAlignmentCenter;
    _shareLabel.textColor = [ResourceManager color_6];
    _shareLabel.font = [UIFont systemFontOfSize:12];
    _shareLabel.text = @"点击按钮可直接跳转";
    
    
}

-(void)layoutUI_3{
    
    UIView *rectangularView = [[UIView alloc]initWithFrame:CGRectMake(15, NavHeight + 30, SCREEN_WIDTH - 30, 180)];
    [self.view addSubview:rectangularView];
    rectangularView.layer.cornerRadius = 15;
    rectangularView.layer.borderWidth = 0.5;
    rectangularView.layer.borderColor = UIColorFromRGB(0x5A54FF).CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 260)/2, NavHeight + 10, 260, 40)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220, 40)];
    [view addSubview:titleLabel];
    titleLabel.backgroundColor = UIColorFromRGB(0x5A54FF);
    titleLabel.layer.cornerRadius = 40/2;
    titleLabel.clipsToBounds = YES;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@奖励%@粮票",[_taskDic objectForKey:@"taskName"],[_taskDic objectForKey:@"rewardValue"]];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 260 * ScaleSize, 120)];
    [rectangularView addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x5A54FF);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@" *  答题内容和区块链技术相关\n *  每位用户每天仅有一次领取机会\n *  此次任务随机做一题，答对题目后可获取粮票奖励\n *  答错题将有8秒审题时间，仔细阅读题目后可继续作答"];
    
    NSRange range1 = [[str string] rangeOfString:@"答题内容和区块链技术相关"];
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_1] range:range1];
    NSRange range2 = [[str string] rangeOfString:@"每位用户每天仅有一次领取机会"];
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_1] range:range2];
    NSRange range3 = [[str string] rangeOfString:@"此次任务随机做一题，答对题目后可获取粮票奖励"];
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_1] range:range3];
    NSRange range4 = [[str string] rangeOfString:@"答错题将有8秒审题时间，仔细阅读题目后可继续作答"];
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_1] range:range4];
    
    label.attributedText = str;
    [label sizeToFit];
    
    
    _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMaxY(rectangularView.frame) + 50, 120, 40)];
    [self.view addSubview:_shareBtn];
    _shareBtn.layer.cornerRadius = 40/2;
    _shareBtn.backgroundColor = UIColorFromRGB(0x5A54FF);
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shareBtn setTitle:@"开始答题" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(answerQuestions) forControlEvents:UIControlEventTouchUpInside];
    
}





-(void)shareTouch{
    
    if (_shareBtn.selected) {
        //上传截图
        [self updateImg];
    }else{
        //分享好友
        if (_taskId != 27 &&
            _taskId != 31 &&
            _taskId != 32) {
            AddFriendVC *ctl = [[AddFriendVC alloc] init];
            ctl.shareType = 1;
            ctl.shareBlock = ^{
                _shareBtn.selected = YES;
                _shareLabel.hidden = YES;
                [_shareBtn setTitle:@"上传截图" forState:UIControlStateNormal];
            };
            [self.navigationController pushViewController:ctl animated:YES];
        }else {
            if (_taskId == 27) {
                [self share];
                
            }else if (_taskId == 31) {
                // 分享游戏
                ShareGameViewController *ctl = [[ShareGameViewController alloc]init];
                ctl.shareType = 1;
                ctl.shareBlock = ^{
                    _shareBtn.selected = YES;
                    _shareLabel.hidden = YES;
                    [_shareBtn setTitle:@"上传截图" forState:UIControlStateNormal];
                };
                [self.navigationController pushViewController:ctl animated:YES];
            }
            else if (_taskId == 32) {
                // 分享借钱
                SharePicVC *ctl = [[SharePicVC alloc]init];
                ctl.strNavTitle = @"分享借钱";
                ctl.shareType = 1;
                ctl.shareBlock = ^{
                    _shareBtn.selected = YES;
                    _shareLabel.hidden = YES;
                    [_shareBtn setTitle:@"上传截图" forState:UIControlStateNormal];
                };
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }
    }
}


//浏览官网
-(void)browse{
    [self finishUrl];
    
    NSString *url = [NSString stringWithFormat:@"%@",[self.taskDic objectForKey:@"taskUrl"]];
    CCWebViewController *ctl = [[CCWebViewController alloc]init];
    ctl.isBackType = YES;
    ctl.homeUrl = [NSURL URLWithString:url];
    ctl.titleStr = @"浏览官网";
    [self.navigationController pushViewController:ctl animated:YES];
    
}

//随机做题
-(void)answerQuestions{
    
    [self xcodeUrl];
    
}


//分享
-(void)share{
    NSString *url = [NSString stringWithFormat:@"%@?referCode=%@",[_taskDic objectForKey:@"taskUrl"],[[DDGAccountManager sharedManager].userInfo objectForKey:@"inviteCode"]];
    NSString *title = @"天狗窝";
    
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;

    NSString *strWX = [NSString stringWithFormat:@"%@",dicUser[@"nickName"]];
    NSString *content = [NSString stringWithFormat:@"我是%@，邀请您通过天狗窝APP注册办卡领取28元现金及280包狗粮",strWX];
    UIImage *image = [ResourceManager logo];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":title, @"subTitle":content?:@"",@"image":UIImageJPEGRepresentation(image,1.0),@"url": url} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeCopyUrl] showIn:self block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
    _shareBtn.selected = YES;
    _shareLabel.hidden = YES;
    [_shareBtn setTitle:@"上传截图" forState:UIControlStateNormal];
}


#pragma mark======== 上传截图
-(void)updateImg{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){ return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init]; pickerController.delegate = self;
    //pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; pickerController.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        if (iOS7) {
            pickerController.navigationBar.barTintColor = [ResourceManager redColor2];
        }else if(iOS11){
            pickerController.navigationBar.tintColor = [ResourceManager redColor2]; //去除⽑毛玻璃效果，解决照⽚片被导航条遮挡问题 pickerController.navigationBar.translucent = NO; pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            pickerController.navigationBar.tintColor = [ResourceManager redColor2];
        } }
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate
/**
* 解决取消按钮点击不不灵敏敏问题
*/
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){ return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            // iOS 11之后，图⽚片编辑界⾯面最上层会出现⼀一个宽度<42的view，会遮盖住左下⽅方的cancel按钮，使cancel按钮很难被 点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42){ [viewController.view sendSubviewToBack:obj]; *stop = YES;
            } }];
    }
    
}

#pragma mark -
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
    //先把原图保存到图片库
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//     {
//        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
//     }
    //获取用户选取的图片并转换成NSData
    //UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    __block  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    
    
   // 获取图片的时间信息
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 NSDate* date = [asset valueForProperty:ALAssetPropertyDate];
                 NSLog(@"date：%@",date);
                 
                 // 比较时间，是否是当天的照片
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 
                 // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                 //[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                 [formatter setDateFormat:@"YYYY-MM-dd"];
                 
                 //现在时间,你可以输出来看下是什么格式
                 NSDate *datenow = [NSDate date];
                 //----------将nsdate按formatter格式转成nsstring
                 NSString *currentTimeString = [formatter stringFromDate:datenow];
                 
                 NSString *compareTimeString = [formatter stringFromDate:date];
                 
                 NSLog(@"currentTimeString:%@, compareTimeString :%@",currentTimeString,compareTimeString);
                 
                 // 日期相等，可以上传
                 if ([currentTimeString isEqualToString:compareTimeString])
                  {
                     //缩小图片的size
                     image = [self imageByRedraw:image];
                     NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
                     if (imageData){
                         self.imageData = imageData;
                         // 上传
                         [self upLoadImgData];
                         
                         [picker dismissViewControllerAnimated:YES completion:nil];
                     }
                  }
                 else if (!date)
                  {
                     //缩小图片的size
                     image = [self imageByRedraw:image];
                     NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
                     if (imageData){
                         self.imageData = imageData;
                         // 上传
                         [self upLoadImgData];
                         
                         [picker dismissViewControllerAnimated:YES completion:nil];
                     }
                  }
                     
                 // 否则报错
                 else
                  {
                     
                     [picker dismissViewControllerAnimated:YES completion:nil];
                     
                     [MBProgressHUD showErrorWithStatus:@"照片必须是当天的，才可上传" toView:self.view];
                  }
                 
                 NSLog(@"currentTimeString =  %@",currentTimeString);
                 
             }
            failureBlock:^(NSError *error) {
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                
                [MBProgressHUD showErrorWithStatus:@"请开放相机权限" toView:self.view];
            }];
    
   
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

-(void)upLoadImgData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"xjShareImg";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"TGW_IOS_QY%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@tgw/uploadAction/uploadFile",[PDAPI getBaseUrlString]] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        //把图片添加到视图框内
        //        _headImgView.image=[UIImage imageWithData:self.imageData];
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            _headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
            [self handleData];
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}

-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    [self uploadHeadImgUrl];
}
//图片提交到数据库
-(void)uploadHeadImgUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"screenImg"] = _headImgStr;
    params[@"taskId"] = @(_taskId);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@tgw/account/today/task/saveShareImg",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                      [self alertView];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void)alertView {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"截图上传成功" message:@"等待人工审核中" preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _shareBtn.hidden = YES;
        _shareLabel.hidden = YES;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_shareBtn.frame), SCREEN_WIDTH, 20)];
        [self.view addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [ResourceManager color_1];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"截图已上传，等待审核中！";
        
        
//        UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMaxY(titleLabel.frame), 120, 20)];
//        [self.view addSubview:imgBtn];
//        imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [imgBtn setTitle:@"点击查看截图" forState:UIControlStateNormal];
//        [imgBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
//        [imgBtn addTarget:self action:@selector(lookImg) forControlEvents:UIControlEventTouchUpInside];
        
        
//        UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMaxY(titleLabel.frame), 120, 20)];
//        [self.view addSubview:imgBtn];
//        imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [imgBtn setTitle:@"点击查看截图" forState:UIControlStateNormal];
//        [imgBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
//        [imgBtn addTarget:self action:@selector(lookImg) forControlEvents:UIControlEventTouchUpInside];
        
        
        int iBtnLeftX = (SCREEN_WIDTH - 120 *2 - 20)/2;
        
        UIButton *reUploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(iBtnLeftX, CGRectGetMaxY(titleLabel.frame), 120, 20)];
        [self.view addSubview:reUploadBtn];
        reUploadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [reUploadBtn setTitle:@"重新上传图片" forState:UIControlStateNormal];
        [reUploadBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
        [reUploadBtn addTarget:self action:@selector(updateImg) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(iBtnLeftX+20 + 120, CGRectGetMaxY(titleLabel.frame), 120, 20)];
        [self.view addSubview:imgBtn];
        imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [imgBtn setTitle:@"点击查看截图" forState:UIControlStateNormal];
        [imgBtn setTitleColor:UIColorFromRGB(0x5A54FF) forState:UIControlStateNormal];
        [imgBtn addTarget:self action:@selector(lookImg) forControlEvents:UIControlEventTouchUpInside];
    }]];
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}


//查看图片
-(void)lookImg{
    [_shotsView removeFromSuperview];
    
    _shotsView  = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_shotsView];
    _shotsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _shotsImgView = [[UIImageView alloc]init];
    [_shotsView addSubview:_shotsImgView];
    
    UIButton *hiddenBtn = [[UIButton alloc]init];
    [_shotsView addSubview:hiddenBtn];
    [hiddenBtn setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    [hiddenBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    
    [_shotsImgView sd_setImageWithURL:[NSURL URLWithString:_headImgStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat height = image.size.height/image.size.width * 260 * ScaleSize;
        _shotsImgView.frame = CGRectMake((SCREEN_WIDTH - 260 * ScaleSize)/2, (SCREEN_HEIGHT - height)/2, 260 * ScaleSize,height);
        
        hiddenBtn.frame = CGRectMake(CGRectGetMaxX(_shotsImgView.frame) - 31 * ScaleSize, CGRectGetMinY(_shotsImgView.frame) - 48 * ScaleSize, 31 * ScaleSize, 50.5 * ScaleSize);
    }];
    
}

-(void)hidden{
    if (_shotsView) {
        [_shotsView removeFromSuperview];
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
