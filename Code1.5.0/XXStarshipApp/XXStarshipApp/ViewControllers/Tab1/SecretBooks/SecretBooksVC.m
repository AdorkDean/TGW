//
//  SecretBooksVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/29.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "SecretBooksVC.h"
#include "GLTaskVC.h"

@interface SecretBooksVC ()
{
    UIScrollView *scView;
}
@end

@implementation SecretBooksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"天狗秘籍"];

    [self layoutUI];
}

-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50)];
    [self.view addSubview:scView];
   scView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NavHeight);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight )];
    [scView  addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"tab1_tgmj_bg"];
    if ([PDAPI isTestUser])
     {
        viewBG.image = [UIImage imageNamed:@"tab1_tgmj_bg_test"];
     }
    
    int iTopY= SCREEN_HEIGHT - 50;
    
    UIButton *btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(30, iTopY, SCREEN_WIDTH - 60, 45)];
    [self.view addSubview:btnQuit];
    btnQuit.backgroundColor = [ResourceManager mainColor];
    [btnQuit setTitle:@"获取狗粮" forState:UIControlStateNormal];
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:16];
    btnQuit.cornerRadius = 20;
    [btnQuit addTarget:self  action:@selector(actionGet) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) actionGet
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
     }
    GLTaskVC  *VC = [[GLTaskVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}



@end
