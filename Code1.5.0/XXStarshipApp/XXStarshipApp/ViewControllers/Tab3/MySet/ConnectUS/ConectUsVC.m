//
//  ConectUsVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/9/5.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "ConectUsVC.h"

@interface ConectUsVC ()

@end

@implementation ConectUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"联系我们"];
    
    [self layoutUI];
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    
    int iTopY = NavHeight + 25;
    int iLeftX = 15;
    int iWidth = SCREEN_WIDTH - 2*iLeftX;
    UIView  *viewWX = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iWidth, 100)];
    [self.view addSubview:viewWX];
    viewWX.backgroundColor = [UIColor whiteColor];
    viewWX.cornerRadius = 10;
    
    //UII
    
    

}





@end
