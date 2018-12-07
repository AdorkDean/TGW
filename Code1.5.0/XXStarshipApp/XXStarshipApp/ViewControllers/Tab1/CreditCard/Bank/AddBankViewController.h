//
//  AddBankViewController.h
//  XXJR
//
//  Created by xxjr03 on 2017/5/25.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface AddBankViewController : CommonViewController

@property(nonatomic,copy)NSDictionary *dataDic;

@property(nonatomic,assign)int iChangFlag;  // 1- 换卡操作

@end
