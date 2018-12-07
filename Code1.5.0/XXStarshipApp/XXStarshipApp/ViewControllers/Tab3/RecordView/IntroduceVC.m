//
//  IntroduceVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/7/2.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "IntroduceVC.h"

@interface IntroduceVC ()
{
    UIScrollView *scView;
}
@end

@implementation IntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"天狗窝介绍"];
    //nav.backdropImg.image = [UIImage imageNamed:@"set_join_head"];
    
    [self layoutUI];
}

-(void) layoutUI
{
    int iTopY =NavHeight;
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 700  * ScaleSize);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    

    
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700  * ScaleSize )];
    [scView  addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"tab3_tgw_js_bj"];
}



@end
