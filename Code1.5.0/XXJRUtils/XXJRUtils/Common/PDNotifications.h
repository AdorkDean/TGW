//
//  PDNotifications.h
//  PMH.Common
//
//  Created by well xeon on 9/10/12.
//  Copyright (c) 2012 Paidui, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark -
#pragma mark ==== Notifications ====
#pragma mark -


/**
 *  推送通知
 */
/*!
 @brief 通知
 */
FOUNDATION_EXPORT NSString *const DDGPushNotification;

/*!
 @brief 登陆成功通知
 */
FOUNDATION_EXPORT NSString *const DDGAccountEngineDidLoginNotification;

/*!
 @brief 退出登陆成功通知
 */
FOUNDATION_EXPORT NSString *const DDGAccountEngineDidLogoutNotification;

/*!
 @brief token过期通知 signid过期通知
 */
FOUNDATION_EXPORT NSString *const DDGUserTokenOutOfDataNotification;


/*!
 @brief 实名认证刷新通知
 */
FOUNDATION_EXPORT  NSString *const DDGAccounSMRZNotification;


/*!
 @brief  WEB刷新通知
 */
FOUNDATION_EXPORT  NSString *const DDGWebRefshNotification;

/*!
 @brief 设置通知
 */
FOUNDATION_EXPORT NSString *const DDGPushNotificationSetting;

/*!
 @brief userInfo需要更新通知
 */
FOUNDATION_EXPORT NSString *const DDGNotificationAccountNeedRefresh;



/*!
 @brief 完善银行卡信息成功
 */
FOUNDATION_EXPORT NSString *const DDGImproveBankCardInforSuccessNotification;

/*!
 @brief 账号类型切换的通知
 */
FOUNDATION_EXPORT NSString *const DDGSwitchAccountTypeNotification;

/*!
 @brief 首页跳转到其它tab的通知
 */
FOUNDATION_EXPORT NSString *const DDGSwitchTabNotification;


/*!
 @brief 免费抢单切换状态通知
 */
FOUNDATION_EXPORT NSString *const FreeGrabSwitchNotification;


/*!
 @brief 抢单成功通知
 */
FOUNDATION_EXPORT NSString *const GrabSuccessNotification;

/*!
 @brief 推广抢单成功通知
 */
FOUNDATION_EXPORT NSString *const TGGrabSuccessNotification;


/*!
 @brief
 */
FOUNDATION_EXPORT NSString *const LocationGPSNotOnNotification;

/*!
 @brief
 */
FOUNDATION_EXPORT NSString *const LocationCityDidChangeNotification;

/*!
 @brief 标签变化通知
 */
FOUNDATION_EXPORT NSString *const DDGMarksChangedNotification;

/*!
 @brief 新增查号通知
 */
FOUNDATION_EXPORT NSString *const DDGSearchNumNotification;

/*!
 @brief APP进入前台的通知
 */
FOUNDATION_EXPORT NSString *const DDGEnterForeground;


