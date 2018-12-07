//
//  LoadView.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/15.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadView : UIView

// 全屏(view)动画加载
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

// 在导航条位置(view的导航条)以下加载动画
+ (MB_INSTANCETYPE)showHUDNavAddedTo:(UIView *)view animated:(BOOL)animated;



+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view;

+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view;



// 加载时，显示的文字lable (修改后，可显示文字)
@property (nonatomic,strong) UILabel *labelText;

@end
