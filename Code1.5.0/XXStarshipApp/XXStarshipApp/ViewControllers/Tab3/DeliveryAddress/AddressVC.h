//
//  AddressVC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressVC : CommonViewController

@property (nonatomic, assign)  BOOL  isSelAddr;  //  TRUE  领取货物时，选择收货地址

@property (nonatomic,strong) Block_Id selblock;

@end
