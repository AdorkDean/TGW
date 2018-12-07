//
//  CreditCardWebVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/15.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "CreditCardWebVC.h"
#import <WebKit/WebKit.h>
#import "CreditCardInfoVC.h"

@interface CreditCardWebVC ()<WKNavigationDelegate,WKScriptMessageHandler>
{
    UITableView *_tableView;
    UIImageView *_headImgView;
    UIButton *_backHomeBtn;
    
    NSString *_shareUrl;
    NSString *_shareTitle;
    NSString *_shareContent;
    NSString *_shareImgUrl;
    
    CustomNavigationBarView* nav;
}

@property (nonatomic ,strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic ,strong)WKUserContentController *userContent;  // 为了和h5交互，所加入 (JavaScript)

@end

@implementation CreditCardWebVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"信用卡"];
    
//    if ([CommonInfo userInfo].count > 0) {
//        NSDictionary *dic = [CommonInfo userInfo];
//        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]].length > 0) {
//            NSString *headImgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]];
//            [_headImgView sd_setImageWithURL:[NSURL URLWithString:headImgStr] placeholderImage:[UIImage imageNamed:@"Tab_3-2"]];
//        }else{
//            _headImgView.image = [UIImage imageNamed:@"Tab_3-2"];
//        }
//    }else{
//        _headImgView.image = [UIImage imageNamed:@"Tab_3-2"];
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"信用卡"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nav = [self layoutWhiteNaviBarViewWithTitle:@"天狗窝"];
    
    [self layoutUI];
    [self xcodeUrl];
}


#pragma mark - 返回按钮事件
-(void)clickNavButton:(UIButton *)button{
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)layoutUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_tableView];
    //设置下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self xcodeUrl];
    }];
    
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    self.userContent = [[WKUserContentController alloc] init];
    // 将UserConttentController设置到配置文件
    self.userContent = config.userContentController;
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [self.userContent addScriptMessageHandler:self name:@"shareHandle"];
    [self.userContent addScriptMessageHandler:self name:@"postShareInfo"];
    [self.userContent addScriptMessageHandler:self name:@"personalInfo"];
    
    [self.userContent addScriptMessageHandler:self name:@"iosDialing"];
    [self.userContent addScriptMessageHandler:self name:@"backHomeBtn"];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) configuration:config];
    [_tableView setTableFooterView:_wkWebView];
    
    // 进度条
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 1.5)];
    //self.progressView.progressTintColor = [ResourceManager redColor2];
    [self.view addSubview:self.progressView];
    // 给webview添加监听
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}




// 记得取消监听
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    if (self.userContent){
        [self.userContent removeScriptMessageHandlerForName:@"shareHandle"];
        [self.userContent removeScriptMessageHandlerForName:@"postShareInfo"];
        [self.userContent removeScriptMessageHandlerForName:@"iosDialing"];
        [self.userContent removeScriptMessageHandlerForName:@"backHomeBtn"];
        [self.userContent removeScriptMessageHandlerForName:@"personalInfo"];

    }
}



//清除wkWebView缓存
- (void)clearWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}




#pragma mark ---  网络通讯
//获取xcode，成功后再加载H5
-(void)xcodeUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGGetXCode]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      if ([operation.jsonResult.attr objectForKey:@"xcode"]) {
                                                                                          NSString *xcode = [NSString stringWithFormat:@"%@",[operation.jsonResult.attr objectForKey:@"xcode"]];
                                                                                          [CommonInfo setKey:K_XCODE withValue:xcode];
                                                                                      }
                                                                                      [self clearWebCache];
                                                                                      NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@tgwproject/home?isApp=1&xcode=%@&uuid=%@&sourceType=tgwios",[PDAPI WXSysRouteAPI2],[CommonInfo getKey:K_XCODE],[DDGSetting sharedSettings].UUID_MD5]];
                                                                                      if (_homeUrl)
                                                                                       {
                                                                                           url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?isApp=1&xcode=%@&uuid=%@&sourceType=tgwios",[PDAPI WXSysRouteAPI2],_homeUrl,[CommonInfo getKey:K_XCODE],[DDGSetting sharedSettings].UUID_MD5]];
                                                                                       }
                                                                                      
                                                                                      NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                                                                      [_wkWebView loadRequest:request];
                                                                                      [_tableView.mj_header endRefreshing]; // 结束刷新
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      [_tableView.mj_header endRefreshing]; // 结束刷新
                                                                                  }];
    [operation start];
}



#pragma mark - wkWebView代理
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == _wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_wkWebView.estimatedProgress animated:YES];
        if (_wkWebView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }
    else if ([keyPath isEqualToString:@"title"])
     {
        
        nav.titleLab.text = _wkWebView.title;
        
     }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark===== 监听JavaScript WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    // message.name   函数名
    // message.body   参数
    NSLog(@"message.name :%@  message.body :%@",message.name, message.body);
    
    if ([message.name isEqualToString:@"postShareInfo"]) {
        NSDictionary *dicShare = (NSDictionary *)message.body;
        if (dicShare.count > 0) {
            _shareUrl = dicShare[@"link"];
            _shareTitle = dicShare[@"title"];
            _shareContent = dicShare[@"desc"];
            _shareImgUrl = dicShare[@"imgUrl"];
        }
    }else if ([message.name isEqualToString:@"shareHandle"]) {
        NSDictionary *dicShare = (NSDictionary *)message.body;
        if (dicShare.count > 0) {
            [self freeShare:dicShare];
        }
    }else if ([message.name isEqualToString:@"iosDialing"]) {
        NSString *tellStr=[[NSString alloc] initWithFormat:@"telprompt://%@",message.body];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tellStr]];
    }else if ([message.name isEqualToString:@"backHomeBtn"]) {
//        [_backHomeBtn removeFromSuperview];
//        _backHomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40 * ScaleSize, SCREEN_HEIGHT - TabbarHeight - 140  * ScaleSize, 30  * ScaleSize, 76  * ScaleSize)];
//        [self.view addSubview:_backHomeBtn];
//        [_backHomeBtn setImage:[UIImage imageNamed:@"Tab_1-10"] forState:UIControlStateNormal];
//        [_backHomeBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    }else if ([message.name isEqualToString:@"personalInfo"])
     {
        // 个人中心
        CreditCardInfoVC  *VC = [[CreditCardInfoVC alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
     }
    
}

//分享
-(void)freeShare:(NSDictionary *)dicShare {
    NSString *shareUrl;  NSString *shareTitle;
    NSString *shareSubTitle;  NSString *shareImgStr;
    if (dicShare.count > 0) {
        shareUrl = dicShare[@"link"];
        shareTitle = dicShare[@"title"];
        shareSubTitle = dicShare[@"desc"];
        shareImgStr = dicShare[@"imgUrl"];
    }else{
        shareUrl = _shareUrl;
        shareTitle = _shareTitle;
        shareSubTitle = _shareContent;
        shareImgStr = _shareImgUrl;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgStr]]];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
//    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":shareTitle, @"subTitle":shareSubTitle?:@"",@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeQQ,DDGShareTypeQQqzone,DDGShareTypeCopyUrl] showIn:self block:^(id result){
//        NSDictionary *dic = (NSDictionary *)result;
//        if ([[dic objectForKey:@"success"] boolValue]) {
//            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
//        }else{
//            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
//        }
//    }];
    
    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":shareTitle, @"subTitle":shareSubTitle?:@"",@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeCopyUrl] showIn:self block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
}


@end
