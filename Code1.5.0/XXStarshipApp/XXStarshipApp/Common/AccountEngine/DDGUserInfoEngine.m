//
//  JMKAccountEngine.h
//  DDGAPP
//
//  Created by Cary on 15/3/3.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "DDGUserInfoEngine.h"
#import "DDGJsonParseManager.h"

#import "WXLoginViewController.h"
#import "WXLoginViewController_2.h"

static DDGUserInfoEngine *singleton;

@interface DDGUserInfoEngine ()

@end

@implementation DDGUserInfoEngine : NSObject


+ (DDGUserInfoEngine *)engine
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        singleton = [[DDGUserInfoEngine alloc] init];
        singleton.iISXDJL = 0;
    });
    return singleton;
}

-(id)copy{
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self)
	{
        
    }
    return self;
}
#pragma mark -
#pragma mark ==== Property methods ====
#pragma mark -

- (void)finishUserInfoWithFinish:(void (^)(void))block{
    [self finishUserInfoWithFinish:block cancel:nil];
}

- (void)finishUserInfoWithFinish:(void (^)(void))block cancel:(void(^)(void))cancelBlock{
    if ([[DDGAccountManager sharedManager] isLoggedIn] && _isLogging) return;
    
    self.loginFinishBlock = block;
    self.loginCancelBlock = cancelBlock;
    
    [self manualLogin];
}

/*!
 @brief     手动输入登录
 */
- (void)manualLogin
{
//    [[DDGAccountManager sharedManager] deleteUserData];
//    _isLogging = YES;
//    self.loginViewController = [[LoginViewController alloc] init];
//	UINavigationController *navigationController =
//    [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
////    navigationController.navigationBar.translucent = NO;
//    [navigationController setNavigationBarHidden:NO];       // 使导航条有效
//    [navigationController.navigationBar setHidden:YES];
//    navigationController.navigationBar.barTintColor = [ResourceManager navgationBackGroundColor];
//	navigationController.view.backgroundColor = [ResourceManager viewBackgroundColor];
//    
////    [navigationController setModalPresentationStyle:UIModalPresentationCustom];
////    [navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self.parentViewController presentViewController:navigationController animated:YES completion:nil];
   
    
    
    [[DDGAccountManager sharedManager] deleteUserData];
    _isLogging = YES;
    //self.loginViewController = [[WXLoginViewController alloc] init];
    self.loginViewController = [[WXLoginViewController_2 alloc] init];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    //    navigationController.navigationBar.translucent = NO;
    [navigationController setNavigationBarHidden:NO];       // 使导航条有效
    [navigationController.navigationBar setHidden:YES];
    navigationController.navigationBar.barTintColor = [ResourceManager navgationBackGroundColor];
    navigationController.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    //    [navigationController setModalPresentationStyle:UIModalPresentationCustom];
    //    [navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.parentViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)finishDoBlock
{
	if (self.loginFinishBlock)
	{
		self.loginFinishBlock();

        self.loginFinishBlock = nil;
	}
	self.loginCancelBlock = nil;
}

- (void)cancelDoBlock
{
	if (self.loginCancelBlock)
	{
		self.loginCancelBlock();
		self.loginCancelBlock = nil;
	}
	self.loginFinishBlock = nil;
}

- (void)dismissFinishUserInfoController:(Block_Void)block{
    
    
    _isLogging = NO;
    //跳转首页
	[self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
		_loginViewController = nil;
        if (block) {
            block();
        }
	}];
    
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccountEngineDidLoginNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}

@end
