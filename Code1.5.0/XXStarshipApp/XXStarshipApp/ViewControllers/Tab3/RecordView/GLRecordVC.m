//
//  GLRecordVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/12.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "GLRecordVC.h"
#import "GLTaskVC.h"

@interface GLRecordVC ()
{
    UIScrollView *scView;
    UILabel *labeGL;
    UILabel *labelCQGL;
    UILabel *labelMFGL;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    
    UIView *viewFGLeft;
    UIView *viewFGRight;
    
    UIView *viewTail;
    NSArray *arrData;
    
    
}
@end

@implementation GLRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"狗粮领取记录"];
    
    //[self layoutUI];
    
    [self getLongData];
    
}


#pragma mark ---  布局UI
-(void) layoutUI:(NSDictionary*)dic
{

    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500.f);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    
    
    UIImageView *viewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    [scView addSubview:viewHead];
    //viewHead.backgroundColor = UIColorFromRGB(0x96b3c3);
    viewHead.image = [UIImage imageNamed:@"TGB_bg"];
    viewHead.userInteractionEnabled = YES;
    
    int iTopY = 0;
    int iLeftX = 0;
    
    iTopY += 15;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [viewHead addSubview:labelTitle];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"狗粮总数";
    
    iTopY += labelTitle.height ;
    labeGL= [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 40)];
    [viewHead addSubview:labeGL];
    labeGL.textColor = [UIColor whiteColor];
    labeGL.font = [UIFont systemFontOfSize:30];
    labeGL.textAlignment = NSTextAlignmentCenter;
    labeGL.text = @"0.0";
    
    
    
    
    iTopY += labeGL.height + 10;
    labelCQGL = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH/2, 15)];
    [viewHead addSubview:labelCQGL];
    labelCQGL.textColor = [UIColor whiteColor];
    labelCQGL.font = [UIFont systemFontOfSize:12];
    labelCQGL.textAlignment = NSTextAlignmentCenter;
    labelCQGL.text = @"长期狗粮：";
    
    labelMFGL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, SCREEN_WIDTH/2, 15)];
    [viewHead addSubview:labelMFGL];
    labelMFGL.textColor = [UIColor whiteColor];
    labelMFGL.font = [UIFont systemFontOfSize:12];
    labelMFGL.textAlignment = NSTextAlignmentCenter;
    labelMFGL.text = @"魔法狗粮：";
    
    
    iTopY += labelMFGL.height + 20;
    UIButton *btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(100, iTopY, SCREEN_WIDTH - 200, 30)];
    [viewHead addSubview:btnQuit];
    btnQuit.backgroundColor = [UIColor clearColor];
    [btnQuit setTitle:@"立即获取狗粮>" forState:UIControlStateNormal];
    btnQuit.titleLabel.font = [UIFont systemFontOfSize:14];
    btnQuit.cornerRadius = 15;
    btnQuit.layer.borderColor = [UIColor whiteColor].CGColor;
    btnQuit.layer.borderWidth = 1;
    [btnQuit addTarget:self  action:@selector(actionGet) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    iTopY = viewHead.height;
    UIView *viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 150)];
    [scView addSubview:viewMid];
    viewMid.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView *viewCenter = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewHead.height - 40, SCREEN_WIDTH - 20, 130)];
    [scView addSubview:viewCenter];
    viewCenter.image = [UIImage imageNamed:@"TGB_center"];
    
    int iCenterViewWidth = viewCenter.width;
    UILabel *labCenter1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, iCenterViewWidth - 30, 20)];
    [viewCenter addSubview:labCenter1];
    labCenter1.textColor = [ResourceManager color_1];
    labCenter1.font = [UIFont systemFontOfSize:15];
    labCenter1.textAlignment = NSTextAlignmentLeft;
    labCenter1.text = @"狗粮简介";
    
    UILabel *labFG = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, iCenterViewWidth-10, 1)];
    [viewCenter addSubview:labFG];
    labFG.backgroundColor = [ResourceManager color_5];
    
    UILabel *labCenter2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 45 + 15, iCenterViewWidth - 30, 160)];
    [viewCenter addSubview:labCenter2];
    //labCenter2.backgroundColor = [UIColor lightGrayColor];
    labCenter2.textColor = [ResourceManager blackGrayColor];
    labCenter2.font = [UIFont systemFontOfSize:12];
    labCenter2.textAlignment = NSTextAlignmentLeft;
    labCenter2.numberOfLines = 0;
    NSString *strContent = @"狗粮是用户获取天狗币的影响因子，狗粮越高获得的天狗币越多。\n可以通过在天狗窝上邀请好友、实名认证、每日登录获取狗粮。由于天狗窝正在前期搭建中，未来将支持更多获取狗粮的方式。";
    strContent = dic[@"introduction"];
    
    if ([PDAPI isTestUser])
     {
        strContent =@"狗粮是用户获取天狗积分的影响因子，狗粮越高获得的天狗币越多。\n可以通过在天狗窝上邀请好友、实名认证、每日登录获取狗粮。由于天狗窝正在前期搭建中，未来将支持更多获取狗粮的方式。";;
     }

    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [labCenter2 setAttributedText:attributedString1];
    [labCenter2 sizeToFit];
    
    viewCenter.height = labCenter2.top + labCenter2.height + 20;
    viewMid.height = viewCenter.height + 10;
    
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, viewMid.height - 42, SCREEN_WIDTH/2, 31)];
    [viewMid addSubview:btnLeft];
    [btnLeft setTitle:@"长期狗粮记录" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLeft addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, viewMid.height - 42, SCREEN_WIDTH/2, 31)];
    [viewMid addSubview:btnRight];
    [btnRight setTitle:@"魔法狗粮记录" forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRight addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, viewMid.height-1, SCREEN_WIDTH, 1)];
    [viewMid addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    viewFGLeft = [[UIView alloc] initWithFrame:CGRectMake(0, viewMid.height-2, SCREEN_WIDTH/2, 1.5)];
    [viewMid addSubview:viewFGLeft];
    viewFGLeft.backgroundColor = [ResourceManager mainColor];
    
    viewFGRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, viewMid.height-2, SCREEN_WIDTH/2, 1.5)];
    [viewMid addSubview:viewFGRight];
    viewFGRight.backgroundColor = [ResourceManager mainColor];
    viewFGRight.hidden = YES;
    
    
    
    iTopY = viewHead.height + viewMid.height;
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 600)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [ResourceManager viewBackgroundColor];
    
}


-(void) dataWithViewTailLeft
{
    [viewTail removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    int iCellHeight = 70;
    if (!arrData)
     {
        return;
     }
    
    for (int i = 0; i < [arrData count]; i++)
     {
        NSDictionary *dicCell = arrData[i];
        if (!dicCell)
         {
            continue;
         }
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        viewCell.backgroundColor = [UIColor whiteColor];
        [viewTail addSubview:viewCell];
        
        // 收支类型
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 15, 200, 20)];
        [viewCell addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:15];
        label1.text = dicCell[@"typeName"];
        
        
        // 狗粮
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150 , 15, 140, 20)];
        [viewCell addSubview:label2];
        label2.textColor =  [ResourceManager mainColor];
        label2.font = [UIFont systemFontOfSize:15];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = dicCell[@"abilityValue"];
        
        
        // 时间
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , 35, 200, 20)];
        [viewCell addSubview:label3];
        label3.textColor = [ResourceManager blackGrayColor];
        label3.font = [UIFont systemFontOfSize:12];
        label3.text = dicCell[@"createTime"];
        
        // 分割线
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellHeight-1, SCREEN_WIDTH-15, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += viewCell.height;
        
     }
    
    viewTail.height = iTopY;
    
    int iTotoalY = viewTail.top + viewTail.height;
    scView.contentSize = CGSizeMake(0, iTotoalY);
}

-(void) dataWithViewTailRight
{
    [viewTail removeAllSubviews];
    
    int iTopY = 0;
    int iLeftX = 15;
    int iCellHeight = 70;
    if (!arrData)
     {
        return;
     }
    
    for (int i = 0; i < [arrData count]; i++)
     {
        NSDictionary *dicCell = arrData[i];
        if (!dicCell)
         {
            continue;
         }
        
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        viewCell.backgroundColor = [UIColor whiteColor];
        [viewTail addSubview:viewCell];
        
        // 收支类型
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 15, 200, 20)];
        [viewCell addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:15];
        label1.text = dicCell[@"typeName"];
        
        
        // 狗粮
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150 , 15, 140, 20)];
        [viewCell addSubview:label2];
        label2.textColor =  [ResourceManager mainColor];
        label2.font = [UIFont systemFontOfSize:15];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = dicCell[@"abilityValue"];
        
        
        // 时间
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , 35, 200, 20)];
        [viewCell addSubview:label3];
        label3.textColor = [ResourceManager blackGrayColor];
        label3.font = [UIFont systemFontOfSize:12];
        label3.text = dicCell[@"createTime"];
        
        // 失效时间
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 180 , 35, 170, 20)];
        [viewCell addSubview:label4];
        label4.textColor = [ResourceManager blackGrayColor];
        label4.font = [UIFont systemFontOfSize:12];
        label4.textAlignment = NSTextAlignmentRight;
        label4.text = dicCell[@"recoveryTime"];
        
        // 分割线
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellHeight-1, SCREEN_WIDTH-15, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iTopY += viewCell.height;
        
     }
    
    viewTail.height = iTopY;
    
    int iTotoalY = viewTail.top + viewTail.height;
    scView.contentSize = CGSizeMake(0, iTotoalY);
}



#pragma mark ---  网络请求
-(void) getLongData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGlongAbilityRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) getLongData2
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGlongAbilityRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}

-(void) getMagicData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGmagicAbilityRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      

                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        // 初始化整个UI
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            [self layoutUI:dic];
            labeGL.text = [NSString stringWithFormat:@"%@", dic[@"allAbilityValue"]];
            
            //normalAbility 普通狗粮 totalMagicAbility 总的魔法狗粮
            labelCQGL.text = [NSString stringWithFormat:@"长期狗粮：%@", dic[@"normalAbility"]];
            labelMFGL.text = [NSString stringWithFormat:@"魔法狗粮：%@", dic[@"totalMagicAbility"]];
         }
        
        NSArray *arr = operation.jsonResult.rows;
        arrData = arr;
        [self dataWithViewTailLeft];
     }
    
    if (1001 == operation.tag)
     {
        //  魔法狗粮记录
        NSArray *arr = operation.jsonResult.rows;
        arrData = arr;
        [self dataWithViewTailRight];
     }
    
    if (1002 == operation.tag)
     {
        // 长期狗粮记录
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            arrData = arr;
            [self dataWithViewTailLeft];
         }
     }
}

#pragma  mark  ----  action
-(void) actionGet
{
//    GLTaskVC *VC = [[GLTaskVC alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
    if (self.jumpType == 100) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3)}];
}

-(void) actionLeft
{
    [btnLeft setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    viewFGLeft.hidden = NO;
    viewFGRight.hidden = YES;
    
    [self getLongData2];
}

-(void) actionRight
{
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    viewFGLeft.hidden = YES;
    viewFGRight.hidden = NO;
    [self getMagicData];
}

@end
