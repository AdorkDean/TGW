//
//  VerificatioPhoneVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/6/1.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificatioPhoneVC : CommonViewController

@property(nonatomic, copy) Block_Id okBlock;

@property (nonatomic,strong) NSString *strTelephone;
@property (nonatomic,strong) NSString *strHideTelephone;
@property (nonatomic,assign) float   amount;

@end
