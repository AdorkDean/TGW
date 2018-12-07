//
//  WithdrawTGW_VC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/5.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "CommonViewController.h"
#import "MJRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawTGW_VC : MJRefreshViewController

@property (nonatomic,assign) BOOL  isSelAddr;   // 选择天狗口袋地址  （充值时）

@property (nonatomic,copy) Block_String selAddrBlock;

@end

NS_ASSUME_NONNULL_END
