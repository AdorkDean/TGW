//
//  SiginDayVC.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/26.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "SiginDayVC.h"
#import "YXCalendarView.h"

@interface SiginDayVC ()
{
    YXCalendarView *calendar;
    
    UILabel *labelDay;
    UILabel *labelqdgl;
    UILabel *labelqdjl;
    
}
@end

@implementation SiginDayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"每日登录"];
    
    [self layoutUI];
    
    NSString *strDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:[NSDate date]];
    [self getSiginRecrd:strDate];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    int iTopY = NavHeight;
    UIImageView *viewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 150)];
    [self.view addSubview:viewBG];
    viewBG.image = [UIImage imageNamed:@"TGB_bg"];
    
    [self layoutHeadView:viewBG];
    
    // 创建日历控件
    iTopY +=viewBG.height + 30;
    calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(20, iTopY, SCREEN_WIDTH - 40, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month]) Date:[NSDate date] Type:CalendarType_Month];
    
    __weak typeof(self) weakSelf = self;
    // 回传选择日期
    calendar.sendSelectDate = ^(NSDate *selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
    };
    calendar.sendSelectMonth = ^(NSString *strMonth) {
        NSLog(@"strMonth:%@",strMonth);
        [weakSelf getSiginRecrd:strMonth];
    };
    [self.view addSubview:calendar];
    
    // 在延迟后执行
    [self performSelector:@selector(delayFun) withObject:nil afterDelay:0.1];

    [XXJRUtils addShadowToView:calendar withOpacity:0.05 shadowRadius:10 andCornerRadius:10];

}

-(void) layoutHeadView:(UIView*)viewHead
{
    int iTopY = 30;
    int iLeftX = 15;
    UIView *viewYuan = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 80, 80)];
    [viewHead addSubview:viewYuan];
    viewYuan.backgroundColor = [UIColor whiteColor];
    viewYuan.cornerRadius = viewYuan.width/2;
    
    labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, viewYuan.width, 30)];
    [viewYuan addSubview:labelDay];
    labelDay.text = @"天";
    labelDay.font = [UIFont systemFontOfSize:14];
    labelDay.textColor = [ResourceManager mainColor];
    labelDay.textAlignment = NSTextAlignmentCenter;
    
    UILabel *labellxqd = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, viewYuan.width, 30)];
    [viewYuan addSubview:labellxqd];
    labellxqd.text = @"连续登录";
    labellxqd.font = [UIFont systemFontOfSize:12];
    labellxqd.textColor = UIColorFromRGB(0x8e8e8e);
    labellxqd.textAlignment = NSTextAlignmentCenter;
    
    iLeftX += viewYuan.width + 15;
    labelqdgl = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + 15, SCREEN_WIDTH - iLeftX - 10, 20)];
    [viewHead addSubview:labelqdgl];
    labelqdgl.text = @"已累计获得 包狗粮(签到狗粮)";
    labelqdgl.font = [UIFont systemFontOfSize:16];
    labelqdgl.textColor = [UIColor whiteColor];
    
    labelqdjl = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + 50, SCREEN_WIDTH - iLeftX - 10, 20)];
    [viewHead addSubview:labelqdjl];
    labelqdjl.text = @"连续签到7天后,每日额外奖励1包狗粮";
    labelqdjl.font = [UIFont systemFontOfSize:13];
    labelqdjl.textColor = UIColorFromRGB(0xe5f6ff);
    
    
    
    
}

-(void) delayFun
{
    // 延迟执行，可以改变日期的圆点的大小
    [calendar setType:CalendarType_Month];
}


-(void) setUIHead:(NSDictionary*) dicData
{
    if (dicData == nil )
     {
        return;
     }
    
    NSString *strNO = [NSString stringWithFormat:@"%@", dicData[@"continueDay"]];//  @"10501";
    NSString *strAll = [NSString stringWithFormat:@"%@ 天",strNO];
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:stringRange];
    //[noteString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:stringRange];
    labelDay.attributedText = noteString;
    
    
    NSString *strDay = [NSString stringWithFormat:@"%@", dicData[@"totalAbilityValue"]];//@"58";
    strAll = [NSString stringWithFormat:@"已经累计获得 %@ 包狗粮(签到狗粮)",strDay];
    noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    stringRange =  [strAll rangeOfString:strDay];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28] range:stringRange];
    
    stringRange =  [strAll rangeOfString:@"(签到狗粮)"];
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:stringRange];
    //[noteString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:stringRange];
    labelqdgl.attributedText = noteString;
    
    labelqdjl.text = dicData[@"rule"];
}

#pragma mark --- 网络通讯
// strDate  格式为 2018-06
-(void) getSiginRecrd:(NSString*) strDate
{
    //[LoadView showHUDNavAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetLoginRecord];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"recordMonth"] = strDate;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [LoadView showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}


-(void) handleData:(DDGAFHTTPRequestOperation *)operation
{
    [LoadView hideAllHUDsForView:self.view animated:YES];
    if (1000 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count] > 0)
         {
            [self setUIHead:dic];
         }
        
        NSArray *arr = operation.jsonResult.rows;
        if ([arr count] > 0)
         {
            NSMutableArray *arrayTemp = [NSMutableArray array];
            for (int i = 0; i < [arr count]; i++)
             {
                NSDictionary *dicTemp = arr[i];
                NSString *loginTime = dicTemp[@"loginTime"];
                if (loginTime.length >=6)
                 {
                    loginTime = [loginTime substringFromIndex:5];
                 }
                [arrayTemp addObject:loginTime];
             }
            // 设置日历event
            [calendar setEventToView:arrayTemp];
         }
     }
}

@end
