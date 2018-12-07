//
//  AnswerQuestionsViewController.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/28.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "AnswerQuestionsViewController.h"

#import <WebKit/WebKit.h>

@interface AnswerQuestionsViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate>

@property (nonatomic ,strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic ,strong)WKUserContentController *userContent;  // 为了和h5交互，所加入 (JavaScript)

@end

@implementation AnswerQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutWhiteNaviBarViewWithTitle:@"随机做题"];
    [self layoutUI];
}


-(void)layoutUI{
    
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    self.userContent = [[WKUserContentController alloc] init];
    // 将UserConttentController设置到配置文件
    self.userContent = config.userContentController;
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [self.userContent addScriptMessageHandler:self name:@"callFunction"];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) configuration:config];
    [self.view addSubview:_wkWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_wkWebView loadRequest:request];
    
    // 进度条
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 1)];
    self.progressView.progressTintColor = [ResourceManager redColor2];
    [self.view addSubview:self.progressView];
    // 给webview添加监听
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
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
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 记得取消监听
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (self.userContent){
        [self.userContent removeScriptMessageHandlerForName:@"callFunction"];
    }
}

//清除wkWebView缓存
- (void)clearWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}


#pragma mark - wkWebView代理
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark===== 监听JavaScript WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    // message.name   函数名
    // message.body   参数
    NSLog(@"message.name :%@  message.body :%@",message.name, message.body);
    
    if ([message.name isEqualToString:@"callFunction"]) {
        NSString *bodyStr = message.body;
        if ([bodyStr isEqualToString:@"backApp"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
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
