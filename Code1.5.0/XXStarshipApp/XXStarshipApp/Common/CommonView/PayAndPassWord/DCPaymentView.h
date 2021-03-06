//
//  DCPaymentView.h
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentView : UIView

@property (nonatomic, copy) NSString *title, *detail;
@property (nonatomic, copy) NSString *accid;
@property (nonatomic, assign) int iAmount;
@property (nonatomic, assign) int iType;  //  0——天狗窝，  1——天狗钱包

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

// 忘记密码响应函数
@property (nonatomic,copy) Block_Void passWordBlock;

- (void)show;

- (void) dismiss;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
