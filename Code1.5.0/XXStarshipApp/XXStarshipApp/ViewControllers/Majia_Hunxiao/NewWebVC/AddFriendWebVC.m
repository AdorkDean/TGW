//
//  AddFriendWebVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/13.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AddFriendWebVC.h"
#import "AddFriendVC.h"
#import "FristFriendVC.h"
#import "SecondFriendVC.h"
#import "ModifyYQMVC.h"

#define IOS8x ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

@interface AddFriendWebVC ()
{
    NSString *shareUrl;
    NSString *shareTitle;
    NSString *shareContent;
}

@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic ,strong)WKUserContentController * userCC;  // 为了和h5交互，所加入 (JavaScript)

@end

@implementation AddFriendWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.wkWebView.navigationDelegate = self;
    
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:self.titleStr];
    [self configUI];
    
    // 推送消息处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpWeb) name:@"UPWeb" object:nil];
}

-(void) UpWeb
{
    [self.wkWebView reload];
}

- (void)configUI {
    
    // 进度条
//    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, 1)];
//    progressView.tintColor = [ResourceManager mainColor];
//    progressView.trackTintColor = [UIColor whiteColor];
//    [self.view addSubview:progressView];
//    self.progressView = progressView;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavHeight, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    // 网页
    if (IOS8x) {
        
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)  configuration:config];
        //        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        
        self.userCC = config.userContentController;
        //此处相当于监听了JS中callFunction这个方法
        [self.userCC addScriptMessageHandler:self name:@"callFunction"];
        
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.navigationDelegate = self;
        [self.view insertSubview:wkWebView belowSubview:self.progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
        
        [self deleteWebCache];
        
//        int iTopY= SCREEN_HEIGHT - 50;
//        UIButton *btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
//        [self.view addSubview:btnQuit];
//        btnQuit.backgroundColor = [ResourceManager mainColor];
//        [btnQuit setTitle:@"获取狗粮" forState:UIControlStateNormal];
//        btnQuit.titleLabel.font = [UIFont systemFontOfSize:16];
//        btnQuit.cornerRadius = 20;
//        [btnQuit addTarget:self  action:@selector(actionGet) forControlEvents:UIControlEventTouchUpInside];
    }
}




// 计算wkWebView进度条
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
//        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//
//        if (newprogress == 1) {
//            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self.progressView setAlpha:0.0f];
//            } completion:^(BOOL finished) {
//                [self.progressView setProgress:0.0f animated:NO];
//            }];
//        }else {
//            [self.progressView setAlpha:1.0f];
//
//        }
//    }
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)deleteWebCache {

    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
    
}


// 记得取消监听
- (void)dealloc {
    if (IOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    if (self.userCC)
     {
        [self.userCC removeScriptMessageHandlerForName:@"callFunction"];
     }
}

#pragma mark - wkWebView代理
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSString *strUrl = webView.URL.absoluteString;
    
    
    //    //初始化AlertView
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test"
    //                                                    message:strUrl
    //                                                   delegate:nil
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil,nil];
    //
    //    [alert show];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 监听JavaScript
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // message.name   函数名
    // message.body   参数
    NSLog(@"message.name :%@  message.body :%@",message.name, message.body);
    
    //立即使用  传入参数 useApp
    NSString *strParmes = message.body;
    if (strParmes &&
        [strParmes isEqualToString:@"useApp"])
     {
        // 立即抢单
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(1)}];
        return;
     }
    
    
    // 去卡包  传入参数 useCard
    if (strParmes &&
        [strParmes containsString:@"useCard"])
     {
        // 去卡包
        //        CourtesyCardVC *ctl = [[CourtesyCardVC alloc] init];
        //        [self.navigationController pushViewController:ctl animated:NO];
        return;
     }
    
    // 去分享  传入参数 shareurl=
    if (strParmes &&
        [strParmes containsString:@"shareurl="])
     {
        // 去分享
        NSArray *array = [strParmes componentsSeparatedByString:@"&"];
        if ([array count] > 0)
         {
            NSString *strTemp = array[0];
            NSArray *arr2 = [strTemp componentsSeparatedByString:@"="];
            if ([arr2 count] >=2)
             {
                NSString *strGetShareUrl = arr2[1];
                //NSLog(@"strShareUrl:%@", strGetShareUrl);
                [self getShareData:strGetShareUrl];
             }
         }
        return;
        //        CourtesyCardVC *ctl = [[CourtesyCardVC alloc] init];
        //        [self.navigationController pushViewController:ctl animated:NO];
     }
    
    if (strParmes&&
        [strParmes containsString:@"shareWX"])
     {
        AddFriendVC *VC = [[AddFriendVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        return;
     }
    
    if (strParmes&&
        [strParmes containsString:@"firstFriend"])
     {
        [self actionFirst];
        return;
     }
    
    if (strParmes&&
        [strParmes containsString:@"secondFriend"])
     {
        [self actionSecond];
        return;
     }
    
    // 复制邀请吗  传入参数 shareurl=
    if (strParmes &&
        [strParmes containsString:@"copyYQM="])
     {
        NSArray *arr2 = [strParmes componentsSeparatedByString:@"="];
        if ([arr2 count] >=2)
         {
            NSString *strCopy= arr2[1];
            //                //NSLog(@"strShareUrl:%@", strGetShareUrl);
            [self actionCopy:strCopy];
         }
        return;
     }
    
    
    if (strParmes&&
        [strParmes containsString:@"modifyYQM"])
     {
        [self  actionPopModify];
        return;
     }
    
}





-(void) actionPopModify
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:20];
    
    
    //[alertView addTitle:@"实名认证"];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>提示</font>"]];
    
    NSDictionary *dicUser = [DDGAccountManager sharedManager].userInfo;
    if (dicUser)
     {
        NSString *strXH= [NSString stringWithFormat:@"是否消耗%@天狗币修改邀请码？",dicUser[@"coinValue"]];
        [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767> %@ </font>",strXH]];
        [alertView addAlertCurHeight:10];
     }
    else
     {
        NSString *strXH= [NSString stringWithFormat:@"是否消耗%@天狗币修改邀请码？",@"20"];
        [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767> %@ </font>",strXH]];
        [alertView addAlertCurHeight:10];
     }
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor2] actionBlock:^{
        ModifyYQMVC  *VC = [[ModifyYQMVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}


#pragma mark --- 网络通讯
-(void) getShareData:(NSString*)getShareUrl
{
    shareUrl = @"";
    shareTitle = @"";
    shareContent = @"";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"platform"] = @"IOS";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],getShareUrl]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 101;
    [operation start];
}

/*
 * 请求成功 ，做数据处理
 **/
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    // 处理
    
    if (101 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if(dic)
         {
            NSDictionary *dicShare = dic[@"shareInfo"];
            if (dicShare)
             {
                shareUrl = dicShare[@"url"];
                shareTitle = dicShare[@"title"];
                shareContent = dicShare[@"content"];
                
                [self freeShare];
             }
            
         }
     }
    
}

//分享
-(void)freeShare{
    
    NSString *url = shareUrl;
    NSString *title = shareTitle;
    NSString *content = shareContent;
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
}

#pragma mark  ---  acion

-(void) actionCopy:(NSString*) strCopy
{
    if (!strCopy &&
        strCopy.length <= 0)
     {
        return;
     }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = strCopy;
    [MBProgressHUD showSuccessWithStatus:@"复制邀请码成功" toView:self.view];
    
}

-(void) actionFirst
{
    FristFriendVC *VC = [[FristFriendVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void) actionSecond
{
    SecondFriendVC *VC = [[SecondFriendVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end
