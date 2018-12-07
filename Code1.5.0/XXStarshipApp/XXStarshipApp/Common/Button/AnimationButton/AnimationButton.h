//
//  AnimationButton.h
//  BabyPigAnimation
//
//  Created by xxjr02 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonDelegateWithParameter.h"




@interface AnimationButton : UIButton

@property (nonatomic, assign) BOOL   isNotEndAnimation;  // 不显示结束动画

@property (nonatomic, assign) int   iCoinType;  // 天狗币的类型  1-天狗币 2-幸运币

/** 含参数代理 */
@property (nonatomic,weak)id<ButtonDelegateWithParameter> delegateWithParamater;


// 设置开始的动画的跳动距离
-(void) setSatrtAnimationHegit:(float) fHegint;

// 设置结束动画
-(void) setEndAnimation;


// 设置按钮的文字
-(void) setText:(NSString*) text;

// 得到按钮上的文字
-(NSString*) getLabelText;

// 设置按钮的文字大小
-(void) setTextFont:(int) iSize;




@end
