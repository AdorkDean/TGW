//
//  PutForwardVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/5/31.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PutForwardVC : CommonViewController

@property (nonatomic,strong) NSString *strBankName;
@property (nonatomic,strong) NSString *strHideCardCode;
@property (nonatomic,strong) NSString *strHideName;
@property (nonatomic,strong) NSString *strTelephone;
@property (nonatomic,strong) NSString *strHideTelephone;
@property (nonatomic,assign) float fAllMoney;
@property (nonatomic,assign) int  iMinWithdrawAmt;

@end
