//
//  BatretInfoVC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/20.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatretInfoVC : CommonViewController

@property (nonatomic,strong) NSDictionary *dicData;

@property (nonatomic,strong) Block_Id  changeBlock;

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@end
