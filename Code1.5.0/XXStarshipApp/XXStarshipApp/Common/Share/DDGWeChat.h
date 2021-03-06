//
//  BPWeChatSDK.h
//  IWantYou
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"


////  小小金融经理
//#define APPID_WC @"wx62fd88d20b5e47ba"
//#define APPSecret_WC @"cdc95f3f8316224cda9379f7271eb836"

//  天狗窝
#define APPID_WC @"wx0def265ab79dbecb"
#define APPSecret_WC @"7e8f8192a24f5c79b7835c6b5bc175ef"

// 小小金融
//#define APPID_WC @"wx5d5d9fa306ba254a"
//#define APPSecret_WC @"c8e53826e7f8b5526397763bf8d67b7e"

@class WXPayModel;

@protocol DDGWeChatDelegate <NSObject>
@optional

-(void) weChatShareFinishedWithResult:(NSDictionary *)result; //分享结果

-(void) weChatLoginFinishedWithResult:(NSDictionary *)result; //登录结果

@end

@interface DDGWeChat : NSObject <WXApiDelegate>

@property (nonatomic,assign) id <DDGWeChatDelegate> delegate;

/**
 *  分享返回的结果/错误
 */
@property (nonatomic, strong) NSMutableDictionary *result;

@property (nonatomic,strong) Block_Void block;


+(DDGWeChat *) getSharedWeChat;


- (void)loginBlock:(Block_Void)block;
- (void)logout;


//分享
-(BOOL) share:(NSDictionary *)items shareScene:(int)scene; //0--朋友会话，1-－朋友圈

//分享webPage  0--朋友会话，1-－朋友圈  （分享纯图片）
-(BOOL) shareIMG:(NSDictionary *)items shareScene:(int)scene;

-(NSString *)wxPayWith:(WXPayModel *)wxPayModel;


@end




@interface WXPayModel : BaseModel


/*!
 @property  NSString retcode
 @brief     retcode
 */
@property (nonatomic, copy) NSString *retcode;
/*!
 @property  NSString appid
 @brief     appid
 */
@property (nonatomic, copy) NSString *retmsg;
/*!
 @property  NSString appid
 @brief     appid
 */
@property (nonatomic, copy) NSString *appid;
/*!
 @brief     noncestr
 */
@property (nonatomic, copy) NSString *noncestr;

/*!
 @brief     wx_package
 */
@property (nonatomic, copy) NSString *wx_package;

/*!
 @brief     wx_package
 */
@property (nonatomic, copy) NSString *prepayid;

/*!
 @brief     timestamp
 */
@property (nonatomic, copy) NSString *timestamp;

/*!
 @brief     sign
 */
@property (nonatomic, copy) NSString *sign;

/*!
 @brief     partner
 */
@property (nonatomic, copy) NSString *partnerId;

/*!
 @brief     partner_key
 */
@property (nonatomic, copy) NSString *partner_key;



@end
