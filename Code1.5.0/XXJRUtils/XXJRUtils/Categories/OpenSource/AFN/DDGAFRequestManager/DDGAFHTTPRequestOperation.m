//
//  DDGAFHTTPRequestOperation.m
//  DDGUtils
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "DDGAFHTTPRequestOperation.h"
#import "DDGJsonParseManager.h"
#import "RsaUtil.h"

// 公钥
NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGlbWrP85zsbLUaawAu5f/ozy/I+5tCFokZiZRXADkg9pJ7kNaUpy8sietKaTVPLB+DqY1QqV3jszz0st+kBmlqZvVIBy2a1Yj8HlgfAeUY2mS10LEIoIBx7kXqZ+48GagiO2eoiJHyZucxD7OpMZXlDHhnMlFYxCb9Cn9cy/CtwIDAQAB";

@implementation DDGAFHTTPRequestOperation

-(DDGAFHTTPRequestOperation *)initWithURL:(NSString *)url parameters:(id)parameters HTTPCookies:(NSArray *)cookies success:(void (^)(DDGAFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(DDGAFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *parame = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    if ([DDGSetting sharedSettings].signId && [DDGSetting sharedSettings].signId.length > 1) {
        parame[@"signId"] = [DDGSetting sharedSettings].signId;
    }
    if (!parame[kUUID] || [NSString stringWithFormat:@"%@",parame[kUUID]].length == 0 || [parame[kUUID] intValue] == 0) {
        parame[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    }
    
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"TGW_IOS_QY%@",currentVersion];
    parame[@"appVersion"] = versionStr;
    
    
    NSLog(@"加密前的URL如下：");
    DDG_urldict(url, parame);
    
    // 字段转化为jason 字符串
    NSData *data = [NSJSONSerialization dataWithJSONObject:parame
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    NSString *strJM = @"";
    if (data == nil)
     {
        strJM = @"";
     }
    else
     {
        strJM = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
     }
    
    
    // 公钥
#if DEBUG
    // 测试的KEY
    RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGlbWrP85zsbLUaawAu5f/ozy/I+5tCFokZiZRXADkg9pJ7kNaUpy8sietKaTVPLB+DqY1QqV3jszz0st+kBmlqZvVIBy2a1Yj8HlgfAeUY2mS10LEIoIBx7kXqZ+48GagiO2eoiJHyZucxD7OpMZXlDHhnMlFYxCb9Cn9cy/CtwIDAQAB";
    // 正式环境的KEY
//     RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCFErvPZlqEXkE1Nn3/1KR1xtYajnkrxY+Lm0trg5KJCd8u7npO3wwgfv9sS73w6eGPDhfRTZniIJeV/vI2cIP4IJU62ioOTtBar1UfPQb+j5dHmbgX9S0fKRDcW4SwaDi6faHLEnrrPg2jR9iOsHdx4Cm9pC/HoOzz7LW77KFS+wIDAQAB";
    
#else
    RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCFErvPZlqEXkE1Nn3/1KR1xtYajnkrxY+Lm0trg5KJCd8u7npO3wwgfv9sS73w6eGPDhfRTZniIJeV/vI2cIP4IJU62ioOTtBar1UfPQb+j5dHmbgX9S0fKRDcW4SwaDi6faHLEnrrPg2jR9iOsHdx4Cm9pC/HoOzz7LW77KFS+wIDAQAB";
#endif


    
    NSMutableDictionary *parameJM = [[NSMutableDictionary alloc] init];
    NSString *strParmeJM = [RsaUtil encrypt16String:strJM publicKey:RSAPublickKey];
    if (!strParmeJM ||
        strParmeJM.length <= 1)
     {
        NSLog(@"加密失败！！！！！！！");
        _failPassWord = 1;
     }
    // JASON字符串加密
    parameJM[@"requestParam"] = strParmeJM;
    
    parameJM[@"appVersion"] = versionStr;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:self.URL] absoluteString] parameters:parameJM error:nil];
    request.timeoutInterval = self.timeoutInterval ? self.timeoutInterval : 20.f;
//    if (cookies && cookies.count > 0) {
//        request.allHTTPHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//    }
  

    
    self = [super initWithRequest:request];
    if (!self) {
        return nil;
    }
    
    self.URL = DDG_urldict(url, parameJM);
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    self.shouldUseCredentialStorage = YES;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self setDDGCompletionBlockWithSuccess:success failure:failure];
    self.completionQueue = self.completionQueue;
    self.completionGroup = self.completionGroup;
    
    return self;
}


-(DDGAFHTTPRequestOperation *)initWithURL:(NSString *)url noJiaMiparameters:(id)parameters HTTPCookies:(NSArray *)cookies success:(void (^)(DDGAFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(DDGAFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *parame = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    if ([DDGSetting sharedSettings].signId && [DDGSetting sharedSettings].signId.length > 1) {
        parame[@"signId"] = [DDGSetting sharedSettings].signId;
    }
    if (!parame[kUUID] || [NSString stringWithFormat:@"%@",parame[kUUID]].length == 0 || [parame[kUUID] intValue] == 0) {
        parame[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    }
    
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"TGW_IOS_QY%@",currentVersion];
    parame[@"appVersion"] = versionStr;
    
    
    NSLog(@"非加密的URL如下：");
    DDG_urldict(url, parame);
    
   
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:self.URL] absoluteString] parameters:parame error:nil];
    request.timeoutInterval = self.timeoutInterval ? self.timeoutInterval : 20.f;
    //    if (cookies && cookies.count > 0) {
    //        request.allHTTPHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //    }
    
    
    
    self = [super initWithRequest:request];
    if (!self) {
        return nil;
    }
    
    self.URL = DDG_urldict(url, parame);
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    self.shouldUseCredentialStorage = YES;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self setDDGCompletionBlockWithSuccess:success failure:failure];
    self.completionQueue = self.completionQueue;
    self.completionGroup = self.completionGroup;
    
    return self;
}

#pragma mark === 私有方法

// 删除NSArray中的NSNull
- (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class]) {
            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class]) {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class]) {
            [marr addObject:value];
        }
    }
    return marr;
}

// Dictionary中的NSNull转换成@“”
- (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys) {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class]) {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典
        else if ([value isKindOfClass:NSArray.class]) {
            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class]) {
            mdic[strKey] = dic[strKey];
        }
        // NSNull类型的数据转换成@“”保存进字典
        else if ([value isKindOfClass:NSNull.class]) {
            mdic[strKey] = @"";
        }
    }
    return mdic;
}



#pragma mark - AFHTTPRequestOperation

- (void)setDDGCompletionBlockWithSuccess:(void (^)(DDGAFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(DDGAFHTTPRequestOperation *operation, NSError *error))failure
{
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    self.completionBlock = ^{
        if (self.completionGroup) {
            dispatch_group_enter(self.completionGroup);
        }
        
        dispatch_async(http_request_operation_processing_queue(), ^{
            
            if (self.error) {
                if (failure) {
                    dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                
                id responseObject = self.responseString;
                
                if (responseObject == nil)
                {
                    self.errorDDG = [DDGError errorWithCode:self.error.code errorMessage:@"返回结果为空"];
                    dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                        failure(self, self.errorDDG);
                    });
                    return;
                }
                
                // 数据处理与解析
                JsonResult *jsonResult = [[self class] jsonResultWithRequest:self];
                NSLog(@"url is %@ \n [self.response allHeaderFields] = \n %@",self.request.URL,[self.response allHeaderFields]);
                NSDictionary *headDic = (NSDictionary *)[self.response allHeaderFields];
                NSString *signId = [NSString stringWithFormat:@"%@",[headDic objectForKey:@"signId"]];
                
                if ([signId containsString:@"noWx"])
                 {
                    NSLog(@"noWx  url is %@ \n ",self.request.URL);
                 }
                
                // 在某种情况下，会加密参数失败， 这时后台会返回 sinID = no encryptParams. 此时不能存储
                if ([headDic objectForKey:@"signId"] &&
                    signId.length > 0 &&
                    ![signId isEqualToString:@"no encryptParams"] &&
                    _failPassWord != 1 ) {
                    [[DDGSetting sharedSettings] setSignId:signId];
                }
                if (jsonResult.success){
                    NSLog(@"requestFinished -- ParseJSONData success");
                    if (jsonResult.rows || jsonResult.attr)
                        [self parseJsonData:jsonResult];
                    if (success) {
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            
                            success(self, responseObject);
                        });
                        
//                        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                        NSArray *cookies = [storage cookiesForURL:DDG_url([PDAPI getBaseUrlString])];
//                        [DDGAccountManager sharedManager].sessionCookiesArray = [NSMutableArray arrayWithArray:cookies];
                    }
                    
                    return;
                }else{
                    
                    self.errorDDG = [DDGError errorWithCode:DDGUnknownErrorType errorMessage:jsonResult.message];
                    self.jsonResult = jsonResult;
                    //token过期通知  signId过期通知 重新登录
                    if ([jsonResult.errorCode intValue] == 99) {
                        
                        
                        NSLog(@"99  self.request.URL: %@",self.request.URL);
                        
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            
                            if (failure) {
                                failure(self, self.errorDDG);
                            }                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:DDGUserTokenOutOfDataNotification object:nil];
                        });
                    }else{
                        dispatch_group_async(self.completionGroup ?: http_request_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                            
                            if (failure) {
                                failure(self, self.errorDDG);
                            }
                        });
                    }
                }
                
                return;
            }
            
            if (self.completionGroup) {
                dispatch_group_leave(self.completionGroup);
            }
        });
    };
#pragma clang diagnostic pop
}


/*!
 @brief     解析请求返回的data数据，一般用于处理返回的图片数据
 @param     data 请求返回的数据
 */
- (void)parseData:(NSData *)data{
    
}

/*!
 @brief    解析JSON数据中的data数据,该方法为abstract类型， 继承类需要重载此方法来实现数据的解析
 */
- (void)parseJsonData:(JsonResult *)jsonResult{
    
    

    
    if ([jsonResult.rows isKindOfClass:[NSArray class]] || [jsonResult.attr isKindOfClass:[NSDictionary class]])
    {

        self.jsonResult = jsonResult;
       
       DDGVerboseLog(@"url is %@",self.request.URL);
       
       if ([jsonResult.rows isKindOfClass:[NSArray class]]) {
           DDGVerboseLog(@"rows result have NULL is %@",self.jsonResult.rows);
           
           
       }
       if ([jsonResult.attr isKindOfClass:[NSDictionary class]]) {
           DDGVerboseLog(@"attr result have NULL is %@",self.jsonResult.attr);
       }
       
       // 去除字典和数组中所有的null
       self.jsonResult.rows = [self removeNullFromArray:self.jsonResult.rows];
       self.jsonResult.attr = [self removeNullFromDictionary:self.jsonResult.attr];
    }else{
        // message 根据返回数据格式来解析并传递，此处未做处理
        self.errorDDG = [DDGError errorWithCode:DDGUndefinedError errorMessage:@"未知错误"];
    }
    
//    DDGVerboseLog(@"url is %@",self.request.URL);
//    
//    if ([jsonResult.rows isKindOfClass:[NSArray class]]) {
//        DDGVerboseLog(@"rows result is %@",self.jsonResult.rows);
//        
//        
//    }
//    if ([jsonResult.attr isKindOfClass:[NSDictionary class]]) {
//        DDGVerboseLog(@"attr result is %@",self.jsonResult.attr);
//    }
    
}

/*!
 @brief     将业务http返回的数据转换为json实体
 @param     request 业务操作的请求
 @return    JsonResult的实例
 */
+ (JsonResult *)jsonResultWithRequest:(DDGAFHTTPRequestOperation *)operation{
    DDGASSERT(operation.responseData != nil);
    if (!operation.responseData) return nil;
    
    NSDictionary *jsonDictionary = [DDGJsonParseManager parseJsonObjectWithRequest:operation];
    
    return [JsonResult instanceWithDict:jsonDictionary];
}

/*!
 @brief     将传入的参数，数据转为nsnull。字符串和数字直接转为null， 字典将obj转为null，数组将元素（字典外）转为null。
 该方法用于测试各种数据异常的情况， 可以在单独的接口处调用。基类修改将对所有数据起作用，如下：
 */
#if !IsAppstoreVersion
- (id)change2NSNull:(id)data
{
    
    if ([data isKindOfClass:[NSString class]] ||
        [data isKindOfClass:[NSNumber class]])
        return [NSNull null];
    else if ([data isKindOfClass:[NSArray class]])
    {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:data];
        for (NSUInteger idx = 0,j=mArray.count; idx<j; idx++)
            mArray[idx] = [self change2NSNull:mArray[idx]];
        
        return mArray;
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *mDictionary = [NSMutableDictionary dictionaryWithDictionary:data];
        for (id key in mDictionary.allKeys)
            mDictionary[key] = [self change2NSNull:mDictionary[key]];
        
        return mDictionary;
    }
    
    
    return [NSNull null];
}
#endif

@end
