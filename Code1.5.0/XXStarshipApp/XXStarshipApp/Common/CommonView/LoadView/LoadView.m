//
//  LoadView.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/6/15.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "LoadView.h"

#import "UIImage+GIF.h"

@implementation LoadView
{
    UIView *parentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    LoadView *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:animated];
    return  hud;//MB_AUTORELEASE(hud);
}

+ (MB_INSTANCETYPE)showHUDNavAddedTo:(UIView *)view animated:(BOOL)animated {
    LoadView *hud = [[self alloc] initWithView:view];
    hud.top = NavHeight;
    hud.height -= NavHeight;
    [view addSubview:hud];
    [hud show:animated];
    return  hud;//MB_AUTORELEASE(hud);
}


+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    LoadView *hud = [self HUDForView:view];
    if (hud != nil) {
        
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
    NSArray *huds = [LoadView allHUDsForView:view];
    for (LoadView *hud in huds) {
        
        [hud removeFromSuperview];
    }
    return [huds count];
}



+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view
{
    [LoadView hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = string;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    [hud hide:YES afterDelay:2.0];
    return hud;
}

+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view
{
    [LoadView hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = string;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    [hud hide:YES afterDelay:2.0];
    return hud;
}


+ (MB_INSTANCETYPE)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LoadView *)subview;
        }
    }
    return nil;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"loadView params View must not be nil.");
    parentView = view;
    return [self initWithFrame:view.bounds];
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {

    self.backgroundColor = [UIColor whiteColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"load" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    
    int iTopY = NavHeight+100;
//    // GIF加入白色背景
//    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(50, iTopY-30, SCREEN_WIDTH - 100, 160)];
//    [self addSubview:viewBG];
//    viewBG.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,iTopY,100,100)];
    [self addSubview:gifImageView];
    gifImageView.image = image;
    
    iTopY += gifImageView.height;
    _labelText = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY+20, SCREEN_WIDTH - 20, 20)];
    [self addSubview:_labelText];
    _labelText.font = [UIFont systemFontOfSize:14];
    _labelText.textColor = [ResourceManager color_1];
    _labelText.textAlignment = NSTextAlignmentCenter;
    _labelText.text = @"分享创造价值";
    
}


- (void)hide:(BOOL)animated {
    [self removeFromSuperview];
}



+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

@end
