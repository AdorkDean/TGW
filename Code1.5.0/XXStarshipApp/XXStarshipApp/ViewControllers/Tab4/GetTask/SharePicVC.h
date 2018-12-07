//
//  SharePicVC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/11/7.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharePicVC : CommonViewController

@property(nonatomic,strong)NSString*  strNavTitle; // 导航栏标题


@property(nonatomic,strong)Block_Void shareBlock;

@property(nonatomic,assign)NSInteger shareType;  // 1 - 分享借钱

@end

NS_ASSUME_NONNULL_END
