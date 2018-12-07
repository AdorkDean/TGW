//
//  TGMJ_VC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/3.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TGMJ_VC : CommonViewController

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) NSString *titleStr;

// 弹出页面形式 push or present
@property (nonatomic,assign) BOOL isPresent;

@property (strong, nonatomic) WKWebView *wkWebView;

@end
