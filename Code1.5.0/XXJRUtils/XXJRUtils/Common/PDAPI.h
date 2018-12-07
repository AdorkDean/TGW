//
//  PDAPI.h
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma  mark --- 小小信贷经理相关接口
// 验证码登录获取验证码
static NSString *const kDDGGetNologinKjlogAPIString = @"xxcust/smsAction/newNologin/kjLogin";


#pragma  mark --- 天狗窝相关接口
// 注册，登录相关

// 发送短信接口一（拿到SmsTokenID）
static NSString *const kDDGgetSmsToken = @"tgw/smsAction/getSmsToken/custLogin";
// 发送短信接口二（发送短信）
static NSString *const kDDGnologin = @"tgw/smsAction/nologin/custLogin";
// 注册登录
static NSString *const kDDGkjLogin = @"tgw/comm/login/kjLogin";
// 昵称及邀请码填写
static NSString *const kDDGsaveNickName = @"tgw/account/cust/saveNickName";
// 更新登录时间及ip（若为当日第一次登录则送暗物质）
static NSString *const kDDGupdateLoginInfo = @"tgw/account/cust/updateLoginInfo";
// 退出登录
static NSString *const kDDGlogOut = @"tgw/account/cust/logOut";

// 基本数据展示相关
// 基本数据展示接口（拿到后台给的天狗币）
static NSString *const kDDGqueryBaseInfo = @"tgw/account/xjBase/queryBaseInfo";
// 发送天狗币
static NSString *const kDDGgetReceiveXjCoin = @"tgw/account/xjBase/getReceiveCoin";
// 一键领取天狗币
static NSString *const kDDGgetquickReceiveCoin = @"tgw/account/xjBase/quickReceiveCoin";
// 天狗币排行榜接口
static NSString *const kDDGcoinRanking = @"tgw/xjRanking/coinRanking";
// 狗粮排行榜接口
static NSString *const kDDGabilityRanking = @"tgw/xjRanking/abilityRanking";
// 任务记录（首页滚动的文字）
static NSString *const kDDGtaskRecord =@"tgw/comm/task/taskRecord";
// 解锁记录
static NSString *const kDDGgetThawRecord =@"tgw/account/cust/getThawRecord";
// 长期狗粮记录
static NSString *const kDDGlongAbilityRecord =@"tgw/account/cust/longAbilityRecord";
// 魔法狗粮记录
static NSString *const kDDGmagicAbilityRecord =@"tgw/account/cust/magicAbilityRecord";


// 个人信息相关
// 个人信息
static NSString *const kDDGgetUserInfo = @"tgw/account/cust/getUserInfo";
// 狗粮收支记录（不做分页，只展示十条）
static NSString *const kDDGabilityRecord = @"tgw/account/cust/abilityRecord";
// 狗币收支记录（不做分页，只展示十条）
static NSString *const kDDGcoinRecord = @"tgw/account/cust/coinRecord";
// 幸运币收支记录
static NSString *const kDDGluckCoinRecord = @"tgw/account/cust/luckCoinRecord";
// 客户反馈
static NSString *const kDDGfeedBack = @"tgw/account/cust/feedBack";
// 实名验证
static NSString *const kDDGidentify = @"tgw/account/cust/task/identify";
// 上传图片
static NSString *const kDDGuploadFile = @"tgw/uploadAction/uploadFile";
// 上传头像
static NSString *const kDDGupdateUserInfo = @"tgw/account/cust/updateUserInfo";
// 获取登录记录
static NSString *const kDDGgetLoginRecord = @"tgw/account/cust/getLoginRecord";
// 修改昵称
static NSString *const kDDGupdateCustName = @"tgw/account/cust/updateCustName";
// 修改邀请码
static NSString *const kDDGupdateInviteCode = @"tgw/account/cust/updateInviteCode";
// 获取 省-市-区
static NSString *const kDDGallAreaInfo = @"tgw/account/xjArea/allAreaInfo";



// 任务模块相关
// 获取任务基本信息
static NSString *const kDDGTaskBaseInfo = @"tgw/comm/task/queryTaskBaseInfo";
// 获取任务首界面参数
static NSString *const kDDGTaskIndexInfo = @"tgw/comm/task/IndexInfo";

// 获取分享信息
static NSString *const kDDGgetShareInfo = @"tgw/account/cust/task/getShareInfo";
// 获取用户分享邀请历史信息
static NSString *const kDDGgetInviteCount = @"tgw/account/cust/task/getInviteCount";
// 获取用户一级好友列表
static NSString *const kDDGgetInviteHistory = @"tgw/account/cust/task/getInviteHistory";
// 获取用户二级好友列表
static NSString *const kDDGgetSecondInviteHistory = @"tgw/account/cust/task/getSecondInviteHistory";
// 关注微信公众号
static NSString *const kDDGgetfollowWxPublicAccount = @"tgw/account/cust/task/followWxPublicAccount";
// 获取邀请好友信息
static NSString *const kDDGgetInviteInfo = @"tgw/html/getInviteCount";
// 提交获取意外保险
static NSString *const kDDGsendInsuranceByTask = @"tgw/account/cust/task/sendInsuranceByTask";



// 认证相关接口
// 认证照片上传
static NSString *const kDDGuploadIDCard = @"tgw/uploadAction/uploadIDCard";
// 身份证信息存储
static NSString *const kDDGmodifyInfo = @"tgw/account/cust/modifyInfo";
// 查询身份证信息
static NSString *const kDDGqueryRZInfo = @"tgw/account/cust/queryInfo";
// 身份证和人脸对比
static NSString *const kDDGfaceAuthCompare = @"tgw/account/cust/faceCompare";


// 红包相关接口
// 领取红包接口
static NSString *const kDDGreceiveReward = @"tgw/account/cust/receiveReward";

// 兑换相关接口
// 兑换列表接口
static NSString *const kDDGqueryChangeList = @"tgw/xjShopMall/queryChangeList";
//天狗币兑换接口
static NSString *const kDDGcoinChangePro = @"tgw/account/xjChange/coinChangePro";
//查询详情页 提示：兑换项目点击进去，下方展示个人兑换记录
static NSString *const kDDGqueryChangeDetail = @"tgw/account/xjChange/queryChangeDetail";
//我的兑换记录
static NSString *const kDDGqueryChangeRecord = @"tgw/account/xjChange/queryChangeRecord";
// 详情页兑换记录
static NSString *const kDDGqueryChangeDetailRec = @"tgw/account/xjChange/queryChangeDetailRec";
// 商城记录
static NSString *const kDDGqueryShopRecord = @"tgw/account/cust/queryShopRecord";

// 竞拍相关接口
// 竞拍列表接口
static NSString *const kDDGqueryAuctionList = @"tgw/xjShopMall/queryAuctionList";
//天狗币竞拍接口
static NSString *const kDDGcoinAuctionGoods = @"tgw/account/xjAuction/coinAuctionGoods";
//查询详情页 提示：竞拍项目点击进去，下方展示竞拍兑换记录
static NSString *const kDDGqueryAuctionDetail = @"tgw/account/xjAuction/queryAuctionDetail";
// 详情页竞拍记录
static NSString *const kDDGqueryAuctionRecord = @"tgw/account/xjAuction/queryAuctionRecord";
//我的竞拍—— 竞拍记录
static NSString *const kDDGqueryOwnAucRecord = @"tgw/account/xjAuction/queryOwnAucRecord";
// 我的竞拍—— 详情页面
static NSString *const kDDqueryOwnAucDetail = @"tgw/account/xjAuction/queryOwnAucDetail";
// 我的竞拍—— 立即领取
static NSString *const kDDrightOffReceive = @"tgw/account/xjAuction/rightOffReceive";
// 我的竞拍—— 修改收货地址
static NSString *const kDDmodifyOrderAddr = @"tgw/account/xjAuction/modifyOrderAddr";
// 我的竞拍—— 确认收货
static NSString *const kDDconfirmCollectGoods = @"tgw/account/xjAuction/confirmCollectGoods";
// 我的竞拍—— 换货查询
static NSString *const kDDqueryExcGoodsInfo = @"tgw/account/aucExchange/queryExcGoodsInfo";
// 我的竞拍—— 换货提交
static NSString *const kDDexchangeGoods = @"tgw/account/aucExchange/exchangeGoods";
// 我的竞拍—— 提交物流信息
static NSString *const kDDexchangeLogistics = @"tgw/account/aucExchange/exchangeLogistics";
// 查询竞拍成功记录接口
static NSString *const kDDGqueryAuctionOrder = @"tgw/account/xjAuction/queryAuctionOrder";

// 信用卡相关接口
// 获取XCODE
static NSString *const kDDGGetXCode = @"tgw/account/xjBase/getXCode";
// 信用卡个人中心收入信息
static NSString *const kDDGquerySumIncome = @"tgw/account/creditFund/querySumIncome";
// 信用卡——我的推广
static NSString *const kDDGqueryApplyRecord = @"tgw/account/creditApplyRecord/queryApplyRecord";


// 银行卡相关接口
// 查询绑定的银行卡
static NSString *const kDDGBankGetInfo = @"tgw/account/cust/bank/getInfo";
// 预备绑卡（获取验证码）
static NSString *const kDDGBankPreBindCard = @"tgw/account/cust/bank/preBindCard";
// 正式绑卡
static NSString *const kDDGBankRealBindCard = @"tgw/account/cust/bank/bindCard";
// 解除绑卡
static NSString *const kDDGBankUnBindBank = @"tgw/account/cust/bank/unBindBank";
// 提现-验证(发送短信)
static NSString *const kDDGxjSmsWithdraws = @"tgw/smsAction/login/xjSmsWithdraw";
// 提现
static NSString *const kDDGxjwithdraw = @"tgw/account/creditFund/withdraw";
// 我的奖励(总信息)
static NSString *const kDDGqueryReward = @"tgw/account/creditFund/queryReward";
// 我的奖励-收入明细
static NSString *const kDDGqueryIncomeDtlList = @"tgw/account/creditFund/queryIncomeDtlList";
// 我的奖励-提现记录
static NSString *const kDDGqueryWithdrawList = @"tgw/account/creditFund/queryWithdrawList";


// 加入群聊相关接口
// 获取群聊二维码
static NSString *const kDDGbindJoinGroupInfo = @"tgw/account/cust/task/bindJoinGroupInfo";
// 加入群聊（微信群、QQ群、币用群）
static NSString *const kDDGautoJoinGroupChat = @"tgw/account/cust/task/autoJoinGroupChat";


// 公告相关接口
static NSString *const kDDGqueryNotifyInfo = @"tgw/xjCommon/queryNotifyInfo";

// 地址相关接口
// 查询收货地址
static NSString *const kDDGqueryCustAddress = @"tgw/account/addr/queryCustAddress";
// 新建收货地址
static NSString *const kDDGaddCustAddress = @"tgw/account/addr/addCustAddress";
// 编辑收货地址
static NSString *const kDDGupdateCustAddress = @"tgw/account/addr/updateCustAddress";
// 删除收货地址
static NSString *const kDDGdeleteCustAddress = @"tgw/account/addr/deleteCustAddress";


// 天狗窝钱包相关
// 绑定钱包口袋地址列表
static NSString *const kDDGbindAccList = @"tgw/account/wallet/bindAccList";
// 绑定钱包
static NSString *const kDDGbindAcc = @"tgw/account/wallet/bindAcc";
// 解绑钱包获取token
static NSString *const kDDGunBindgetSmsToken = @"tgw/smsAction/getSmsToken/unbindAcc";
// 解绑钱包短信验证码
static NSString *const kDDGSMSunBindAcc = @"tgw/smsAction/login/unbindAcc";
// 解绑钱包
static NSString *const kDDGunBindAcc = @"tgw/account/wallet/unBindAcc";
// 提现到钱包
static NSString *const kDDGaccWithdraw = @"tgw/account/wallet/accWithdraw";
// 提现记录
static NSString *const kDDGwithdrawRecord = @"tgw/account/wallet/withdrawRecord";


// 游戏充值相关
// 充值（天狗窝）
static NSString *const kDDGtgwDiceRecharge = @"tgw/account/xjBase/tgwDiceRecharge";
// （天狗钱包充值）
static NSString *const kDDGtgkdDiceRecharge = @"tgw/account/wallet/tgkdDiceRecharge";
// 获取用户天狗币余额信息
static NSString *const kDDGqueryCoinInfo = @"tgw/account/xjBase/queryCoinInfo";



#if PMHEnableSwitchURLGesture
/*!
 @brief 是否允许URL后带版本号
 */
FOUNDATION_EXPORT BOOL kEnableUrlVersion;
#endif

/*!
 @brief 管理所有接口URL
 */
@interface PDAPI : NSObject

/*!
 @brief     获取base url
 @return    base url string
 */
+ (NSString *)getBaseUrlString;

+ (NSString *)getBaseImageUrlString;



/*!
 @brief     获取业务 url
 @return    Busi url string
 */
+ (NSString *)getBusiUrlString;


//是否审核中
+(BOOL)isTestUser;


/*!
 @brief     return the url string of stat
 @return    stat url string
 */
#if PMHEnableSwitchURLGesture

/*!
 @brief     设置base url和stat url
 */
+ (void)setBaseUrl:(NSString *)baseUrlString statUrl:(NSString *)statUrlString;

#endif
/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi:(NSString *)urlString;

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi2:(NSString *)urlString;

/*!
 @brief     跳转微信端路径
 @return    NSString
 */
+ (NSString *)WXSysRouteAPI;


/*!
 @brief     信用卡和星座专属
 @return    NSString
 */
+ (NSString *)WXSysRouteAPI2;



#pragma mark === Function
/*!
 @brief     图片下载API
 @return    NSString
 */
+ (NSString *)imageDownloadAPI;

/*!
 @brief     版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI;

/*!
 @brief     获取最近的放款信息
 @return    NSString
 */
+ (NSString *)getNewTreatAPI;

/*!
 @brief     获取验证码
 @return    NSString
 */
+ (NSString *)getRegSendMsghAPI;

/*!
 @brief     手机注册
 @return    NSString
 */
+ (NSString *)userGetRegisterAPI;

/*!
 @brief     手机注册获取验证码
 @return    NSString
 */
+ (NSString *)userRegisterPasswordAPI;

/*!
 @brief     用户注册协议
 @return    NSString
 */
+ (NSString *)getAgreementAPI;

/*!
 @brief     忘记密码
 @return    NSString
 */
+ (NSString *)userForgetPasswordAPI;

/*!
 @brief     忘记密码获取验证码
 @return    NSString
 */
+ (NSString *)userForgetPwdSendMsgAPI;

/*!
 @brief     登录
 @return    NSString
 */
+ (NSString *)userDoLoginAPI;

/*!
 @brief     验证码登录
 @return    NSString
 */
+ (NSString *)userVerifyLoginAPI;

/*!
 @brief     退出登录
 @return    NSString
 */
+ (NSString *)userDoLogoutAPI;

/*!
 @brief     获取引导页图片列表
 @return    NSString 获取引导页图片API
 */
+ (NSString *)getLoadingImgsAPI;

/*!
 @brief     发送反馈数据
 @return    NSString    发送反馈数据API字符串
 */
+ (NSString *)sendFeedbackAPI;

/*!
 @brief     获取版本号
 @return    NSString
 */
+ (NSString *)checkAppNewVersionAPI;

/**
 *  //// ------------------------------      ------------------------------------ /////
 */
#pragma mark === 公用
/*!
 @brief     banner 链接
 @return    NSString
 */
+ (NSString *)getBannerAPI;
/*!
 @brief     武功秘籍类型
 @return    NSString
 */
+ (NSString *)getInMiJiInfoAPI;
/*!
 @brief     武功秘籍列表
 @return    NSString
 */
+ (NSString *)getInQueryListAPI;
/*!
 @brief     武功秘籍详情
 @return    NSString
 */
+ (NSString *)getInMiJiDetailAPI;
/*!
 @brief     武功秘籍详情分享
 @return    NSString
 */
+ (NSString *)getInMiJiShareAPI;
/*!
 @brief     上传城市
 @return    NSString
 */
+ (NSString *)getSelectCityAPI;
    
 /*!
 @brief     贷款测算
 @return    NSString
 */
+ (NSString *)getInCalCLoanAmountAPI;

/*!
 @brief     信贷员列表
 @return    NSString
 */
+ (NSString *)getQueryCirclesListAPI;
/*!
 @brief     增加关注
 @return    NSString
 */
+ (NSString *)getAddJoinCirclesAPI;
/*!
 @brief     取消关注
 @return    NSString
 */
+ (NSString *)getCancelJoinCirclesAPI;
/*!
 @brief     我的关注列表
 @return    NSString
 */
+ (NSString *)getMyJoinListAPI;
/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getInstitutionListAPI;

/*!
 @brief     机构产品
 @return    NSString
 */
+ (NSString *)getInstitutionProductListAPI;

/*!
 @brief     产品详情
 @return    NSString
 */
+ (NSString *)getInstitutionProductDetailAPI;

/*!
 @brief     交单
 @return    NSString
 */
+ (NSString *)getSendOrderAPI;

/*!
 @brief     交单 -- 简单交单之获取验证码
 @return    NSString
 */
+ (NSString *)getSendOrderVerifyCodeAPI;

/*!
 @brief     交单 -- 简单交单之微信分享
 @return    NSString
 */
+ (NSString *)getSendOrderWXAPI;

/*!
 @brief     交单 -- 简单交单之短信分享
 @return    NSString
 */
+ (NSString *)getSendOrderSMSAPI;

/*!
 @brief     取消订单
 @return    NSString
 */
+ (NSString *)getCanelOrderAPI;

/*!
 @brief     我的交单
 @return    NSString
 */
+ (NSString *)getMyOrderAPI;

/*!
 @brief     交单详情
 @return    NSString
 */
+ (NSString *)getOrderDetailAPI;

/*!
 @brief     读取材料
 @return    NSString
 */
+ (NSString *)getSendProductFileAPI;

/*!
 @brief     删除材料
 @return    NSString
 */
+ (NSString *)getDeleteFileAPI;

/*!
 @brief     完整交单
 @return    NSString
 */
+ (NSString *)getSendCompleteFileAPI;

/*!
 @brief     完整交单 -- 重新提交材料
 @return    NSString
 */
+ (NSString *)getReSendCompleteFileAPI;

/*!
 @brief     查号记录
 @return    NSString
 */
+ (NSString *)getSearchRecordListAPI;

/*!
 @brief     申请查号
 @return    NSString
 */
+ (NSString *)getSearchNumAPI;


/**
 *  获取金融资讯
 */
+ (NSString *)getFinanceNewsAPI;



/*!
 @brief     系统通知
 @return    NSString
 */
+ (NSString *)getNewsQueryListAPI;
/*!
 @brief     系统通知详情
 @return    NSString
 */
+ (NSString *)getNewsViewAPI;


//征信查询
/*!
 @brief     登陆注册图片验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditAPI;
/*!
 @brief     注册第一步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegAPI;
/*!
 @brief     注册第二步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegSupplementInfoAPI;
/*!
 @brief     登陆
 @return    NSString
 */
+ (NSString *)getCheckCreditLoginAPI;
/*!
 @brief     注册验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditSendRegMsgAPI;
/*!
 @brief     问题验证问题
 @return    NSString
 */
+ (NSString *)getCheckCreditIdentityDataAPI;
/*!
 @brief     提交问题
 @return    NSString
 */
+ (NSString *)getCheckCreditQuestionDataAPI;
/*!
 @brief     用户列表
 @return    NSString
 */
+ (NSString *)getCheckCreditInitDataAPI;
/*!
 @brief     用户列表信息
 @return    NSString
 */
+ (NSString *)getCheckCreditReportListDataAPI;
/*!
 @brief     核对银行验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditReportAPI;
/*!
 @brief     信息列表
 @return    NSString
 */
+ (NSString *)getCheckCreditReportDataAPI;
/*!
 @brief     贷款记录明细
 @return    NSString
 */
+ (NSString *)getCheckCreditRecordDataAPI;
/*!
 @brief     查询记录明细
 @return    NSString
 */
+ (NSString *)getCheckQueryReocrdDataAPI;


//企业查询
/*!
 @brief     企业查询结果
 @return    NSString
 */
+ (NSString *)getCheckQueryDataAPI;
/*!
 @brief     查询结果详情
 @return    NSString
 */
+ (NSString *)getCheckQueryDetailDataAPI;
//失信人查询
/*!
 @brief     失信人查询结果
 @return    NSString
 */
+ (NSString *)getChecksSXRQueryDataAPI;
/*!
 @brief     失信人查询结果详情
 @return    NSString
 */
+ (NSString *)getChecksSXRDetailDataAPI;




/*!
 @brief     直贷头像
 @return    NSString
 */
+ (NSString *)getLoanListHeadImgAPI;

/*!
 @brief     抢单
 @return    NSString
 */
+ (NSString *)getLoanLightingAPI;

/*!
 @brief     抢单－甩单
 @return    NSString
 */
+ (NSString *)getLoanLighting2API;


#pragma mark === Tab_2  客户
/*!
 @brief     客户列表
 @return    NSString
 */
+ (NSString *)getContactListAPI;

/*!
 @brief     删除客户
 @return    NSString
 */
+ (NSString *)getDeleteContactAPI;

/*!
 @brief     添加客户
 @return    NSString
 */
+ (NSString *)getAddContactAPI;

/*!
 @brief     修改客户信息
 @return    NSString
 */
+ (NSString *)getUpdateContactListAPI;

/*!
 @brief     修改客户标签初始数据
 @return    NSString
 */
+ (NSString *)getContactMarksDtlAPI;

/*!
 @brief     修改客户标签
 @return    NSString
 */
+ (NSString *)getUpdateContactMarksAPI;

/*!
 @brief     客户标星处理
 @return    NSString
 */
+ (NSString *)getUpdateContactStarAPI;


/*!
 @brief     查寻标签
 @return    NSString
 */
+ (NSString *)getMarksListAPI;

/*!
 @brief     标签下的客户
 @return    NSString
 */
+ (NSString *)getMarksContactListAPI;

/*!
 @brief     添加标签
 @return    NSString
 */
+ (NSString *)getAddMarksAPI;

/*!
 @brief     修改标签
 @return    NSString
 */
+ (NSString *)getUpdateMarksAPI;

/*!
 @brief     删除标签
 @return    NSString
 */
+ (NSString *)getDeleteMarksAPI;



#pragma mark === Tab_3  微店
/*!
 @brief     微店首页
 @return    NSString
 */
+ (NSString *)userGetWDShopIndexInfoAPI;

/*!
 @brief     申请列表
 @return    NSString
 */
+ (NSString *)userGetWDShopApplyListInfoAPI;
/*!
 @brief     申请产品详情
 @return    NSString
 */
+ (NSString *)userGetApplyDetailInfoAPI;
/*!
 @brief     申请展示
 @return    NSString
 */
+ (NSString *)userGetWDShowInfoAPI;
/*!
 @brief    创建微店的初始化信息
 @return    NSString
 */
+ (NSString *)userGetWDShopWdInfoInitInfoAPI;
/*!
 @brief     修改微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopEditInfoAPI;
/*!
 @brief     查询微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopQueryInfoAPI;

/*!
 @brief     微店统计
 @return    NSString
 */
+ (NSString *)userGetWdApplyStatisticAPI;

/*!
 @brief     微店排行
 @return    NSString
 */
+ (NSString *)userGetwdShopRankInfoAPI;
/*!
 @brief     微店产品选项
 @return    NSString
 */
+ (NSString *)userGetProductInitDataInfoAPI;
/*!
 @brief     微店产品增加/修改
 @return    NSString
 */
+ (NSString *)userGetWdProductInfoAPI;
/*!
 @brief      微店产品增加第二步
 @return    NSString
 */
+ (NSString *)userGetWdProductDtlInfoAPI;
/*!
 @brief     微店产品列表
 @return    NSString
 */
+ (NSString *)userGetwdproductListInfoAPI;
/*!
 @brief     微店产品删除
 @return    NSString
 */
+ (NSString *)userGetwddelWdProductInfoAPI;
/*!
 @brief     微店产品信息
 @return    NSString
 */
+ (NSString *)userGetwdWdPordInfoAPI;
/*!
 @brief     微店产品信息第二步
 @return    NSString
 */
+ (NSString *)userGetWdProRuleInfoAPI;
/*!
 @brief     微店名片信息
 @return    NSString
 */
+ (NSString *)userGetwdCardInfoAPI;
/*!
 @brief     微店名片新增或修改
 @return    NSString
 */
+ (NSString *)userGetwdeditCardInfoAPI;

/*!
 @brief     成功案例列表
 @return    NSString
 */
+ (NSString *)userGetCustCaseListInfoAPI;
/*!
 @brief     添加成功案例
 @return    NSString
 */
+ (NSString *)userGetEditCustCaseInfoAPI;
/*!
 @brief     查询成功案例
 @return    NSString
 */
+ (NSString *)userGetCustCaseInfoAPI;
/*!
 @brief     删除成功案例
 @return    NSString
 */
+ (NSString *)userGetDelCustCaseInfoAPI;

/*!
 @brief     所有城市列表
 @return    NSString
 */
+ (NSString *)userGetWDShopCityInfoAPI;
/*!
 @brief    微店模板
 @return    NSString
 */
+ (NSString *)userGetWdShopTemplateListInfoAPI;
/*!
 @brief    微店模板修改
 @return    NSString
 */
+ (NSString *)userGetEditWdShopInfoAPI;
/*!
 @brief     分享微店Html5
 @return    NSString
 */
+ (NSString *)userGetShareWdWedInfoAPI;
#pragma mark === Tab_4  我的
/*!
 @brief     用户信息 不需要登录 -- （用户名、头像、真实姓名、身份证、邮箱、手机号码、登陆密码、交易密码、IM账号）
 @return    NSString
 */
+ (NSString *)getUserInfoAPI;

/*!
 @brief     切换身份
 @return    NSString
 */
+ (NSString *)userGetUserUserTypeInfoAPI;
/*!
 @brief     信贷经理入驻条件
 @return    NSString
 */
+ (NSString *)userGetQueryCheckJoinInfoAPI;

/*!
 @brief     修改个人信息
 @return    NSString
 */
+ (NSString *)userGetModifyInfoAPI;

/*!
 @brief     头像
 @return    NSString
 */
+ (NSString *)getUserHeadImageAPI;

/*!
 @brief     个人认证
 @return    NSString
 */
+ (NSString *)getpersonalAuthAPI;
/*!
 @brief     查询认证信息
 @return    NSString
 */
+ (NSString *)getQueryProfessionListAPI;
/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getqueryCompanyListAPI;
/*!
 @brief     添加公司
 @return    NSString
 */
+ (NSString *)getAddCompanyAPI;

/*!
 @brief     借款人单独身份认证
 @return    NSString
 */
+ (NSString *)getValidateNameAPI;
/*!
 @brief     查询借款人单独身份认证信息
 @return    NSString
 */
+ (NSString *)getQueryIdentifyAPI;

/*!
 @brief     服务区域
 @return    NSString
 */
+ (NSString *)getAllAreaInfoAPI;
/*!
 @brief     提交工作地点
 @return    NSString
 */
+ (NSString *)getModifyLocaInfoAPI;
/*!
 @brief     第一次添加邮箱
 @return    NSString
 */
+ (NSString *)userGetUserEmailInfoAPI;

/*!
 @brief     修改邮箱
 @return    NSString
 */
+ (NSString *)userGetUserAmendEmailInfoAPI;

/*!
 @brief     修改邮箱获取验证码
 @return    NSString
 */
+ (NSString *)userForgetEmailSendMsgAPI;

/*!
 @brief     修改密码，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserModifyLoginPwdInfoAPI;
/*!
 @brief     公司简介，关于小小金融
 @return    NSString
 */
+ (NSString *)userGetUserXxjrInfoAPI;

/*!
 @brief     设置交易密码
 @return    NSString
 */
+ (NSString *)setPayPassword;

/*!
 @brief     修改交易密码
 @return    NSString
 */
+ (NSString *)userEditPayPwdAPI;

/*!
 @brief     更换手机
 @return    NSString
 */
+ (NSString *)userGetUserNewTelInfoAPI;

/*!
 @brief     更换手机获取原手机号验证码
 @return    NSString
 */
+ (NSString *)userGetUserChangeTelSendAPI;

/*!
 @brief     验证原手机获取的验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelInfoAPI;

/*!
 @brief     更换手机获取新手机验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelNewSendAPI;

/*!
 @brief     意见反馈，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserFeedBackInfoAPI;


/*!
 @brief     我的业绩总信息
 @return    NSString
 */
+ (NSString *)userGetUserSummaryInfoAPI;

/*!
 @brief     绑定微信
 @return    NSString
 */
+ (NSString *)userGetUserBindingWXAPI;

/*!
 @brief     提现明细
 @return    NSString
 */
+ (NSString *)userGetUserQueryWithdrawInfoAPI;

/*!
 @brief     剩余佣金提现处理
 @return    NSString
 */
+ (NSString *)userGetUserAddWithdrawInfoAPI;

/*!
 @brief     剩余佣金提现处理获取验证码
 @return    NSString
 */
+ (NSString *)getRegWithdrawSendMsghAPI;

/*!
 @brief     已返佣金
 @return    NSString
 */
+ (NSString *)userGetUserQueryMyListInfoAPI;

/*!
 @brief     可提现的银行
 @return    NSString
 */
+ (NSString *)userGetUserBankAllListInfoAPI;

/*!
 @brief     获取银行卡信息
 @return    NSString
 */
+ (NSString *)userGetUserCardListInfoAPI;

/*!
 @brief     添加银行卡
 @return    NSString
 */
+ (NSString *)userGetUserAddCardInfoAPI;
/*!
 @brief     我要收徒
 @return    NSString
 */
+ (NSString *)userGetUsershoutuInfoAPI;
/*!
 @brief     收徒赚佣金分享
 @return    NSString
 */
+ (NSString *)userGetUsershoutuShareInfoAPI;
/*!
 @brief     我的学徒
 @return    NSString
 */
+ (NSString *)userGetUserApprenticeListInfoAPI;
/*!
 @brief     为什么要收徒
 @return    NSString
 */
+ (NSString *)userGetUserReasonInfoAPI;
/*!
 @brief     如何收取更多徒弟
 @return    NSString
 */
+ (NSString *)userGetUserStrategyInfoAPI;
/*!
 @brief     我的会员
 @return    NSString
 */
+ (NSString *)userGetUserCustGradeInfoAPI;
/*!
 @brief     我的抢单
 @return    NSString
 */
+ (NSString *)userGetUserCustGrabListInfoAPI;
/*!
 @brief     小安时代推荐列表
 @return    NSString
 */
+ (NSString *)userGetRefererListInfoAPI;
/*!
 @brief    摇一摇礼品记录
 @return    NSString
 */
+ (NSString *)userGetDrawLotteryListInfoAPI;











#pragma mark 公用接口

/*!
 @brief     用户基本信息 需要登录 -- 个人信息（用户ID、昵称、性别、生日、省份、城市、详细地址、个人说明、 ）
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI;


/*!
 @brief   资讯类型
 @return    NSString
 */
+ (NSString *)userZixunQueryTypeAPI;

/*!
 @brief   资讯列表
 @return    NSString
 */
+ (NSString *)userZixunQueryListAPI;

/*!
 @brief     资讯详情
 @return    NSString
 */
+ (NSString *)userGetCardNewsDetailInfoAPI;
/*!
 @brief     资讯详情分享
 @return    NSString
 */
+ (NSString *)userGetCardNewsShareInfoAPI;
/*!
 @brief     资讯分享成功修改积分
 @return    NSString
 */
+ (NSString *)userGetRewardShareInfoAPI;


/*!
 @brief  设置-更改绑定手机号
 @return    NSString
 */
+ (NSString *)userForceBindingWXAPI;

/*!
 @brief  设置-查询当前绑定微信
 @return    NSString
 */
+ (NSString *)userInfoBindingWXWXAPI;

/*!
 @brief   设置-修改密码
 @return    NSString
 */
+ (NSString *)userChangeLoginPwdAPI;

/*!
 @brief     上传材料
 @return    NSString
 */
+ (NSString *)getSendFileAPI;




#pragma mark 登陆及验证码

/*!
 @brief    验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI;

/*!
 @brief   密码登陆
 @return    NSString
 */
+ (NSString *)userPassWordLoginInfoAPI;

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI;

/*!
 @brief   微信登陆绑定手机号
 @return    NSString
 */
+ (NSString *)userWxLoginBindInfoAPI;

/*!
 @brief   设置密码
 @return    NSString
 */
+ (NSString *)userSetLoginPwdInfoAPI;

/*!
 @brief     验证码登录获取验证码
 @return    NSString
 */
+ (NSString *)userNologinKjloginAPI;

/*!
 @brief     信贷经理列表申请按钮填写资料发送验证码
 @return    NSString
 */
+ (NSString *)userNologinWdApplyAPI;














@end





