//
//  DCPaymentView.m
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import "DCPaymentView.h"

#import "GLTextField.h"
#import "UIView+category.h"

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width

#define ALERT_HEIGHT   [UIScreen mainScreen].bounds.size.height/2



//密码位数
static NSInteger const kDotsNumber = 6;
//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface DCPaymentView ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *pwdTextField;


//密码输入文本框
@property (nonatomic,strong) GLTextField *passwordField;
//用来装密码圆点的数组
@property (nonatomic,strong) NSMutableArray *passwordDotsArray;
//默认密码
@property (nonatomic,strong,readonly) NSString *password;


@end

@implementation DCPaymentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    
    }
    return self;
}

- (void)drawView {
    if (!_paymentAlert) {
        //_paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT, [UIScreen mainScreen].bounds.size.width, ALERT_HEIGHT)];
        float  fPayAlertH = [UIScreen mainScreen].bounds.size.height/2;
//        if (IS_IPHONE_5_OR_LESS)
//         {
//            fPayAlertH = [UIScreen mainScreen].bounds.size.height/2-80;
//         }
//        if (IS_IPHONE_6)
//         {
//            fPayAlertH = [UIScreen mainScreen].bounds.size.height/2-30;
//         }

        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(0, fPayAlertH, [UIScreen mainScreen].bounds.size.width, ALERT_HEIGHT)];
        //_paymentAlert.layer.cornerRadius = 5.f;
        //_paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self addSubview:_paymentAlert];
        
        int iTopY = 0;
        // 加入个白底
        UIView *viewTitleBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, ALERT_HEIGHT)];
        viewTitleBack.backgroundColor = [UIColor whiteColor];
        [_paymentAlert addSubview:viewTitleBack];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = _title;
        [_paymentAlert addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_closeBtn];
        
        
        // 加入天狗币展示
        iTopY += TITLE_HEIGHT;
        UIView *viewHeadBG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 72)];
        [_paymentAlert addSubview:viewHeadBG];
        viewHeadBG.backgroundColor = UIColorFromRGB(0xf3f3ff);
        
        UIImageView *imgTGB = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30)/2, 10, 30, 30)];
        [viewHeadBG addSubview:imgTGB];
        imgTGB.image = [UIImage imageNamed:@"gr_money"];
        
        UILabel *labelTGB1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 20)];
        [viewHeadBG addSubview:labelTGB1];
        labelTGB1.font = [UIFont systemFontOfSize:18];
        labelTGB1.textColor = [ResourceManager mainColor];
        labelTGB1.textAlignment = NSTextAlignmentCenter;
        labelTGB1.text = [NSString stringWithFormat:@"%d",_iAmount];
        
        // 充值金额
        iTopY += viewHeadBG.height;
        int iCellHeight = 50;
        int iCellLeftX = 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, 100, iCellHeight)];
        [_paymentAlert addSubview:label1];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [ResourceManager color_1];
        label1.text = @"充值金额";
        
        iCellLeftX += 100 +10;
        UILabel *labe1Vaule = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, SCREEN_WIDTH -iCellLeftX - 15, iCellHeight)];
        [_paymentAlert addSubview:labe1Vaule];
        labe1Vaule.font = [UIFont systemFontOfSize:14];
        labe1Vaule.textColor = [ResourceManager color_1];
        labe1Vaule.textAlignment = NSTextAlignmentRight;
        labe1Vaule.text = [NSString stringWithFormat:@"%d",_iAmount];
    
        UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY+ iCellHeight -1, SCREEN_WIDTH - 20, 1)];
        [_paymentAlert addSubview:viewFG1];
        viewFG1.backgroundColor = [ResourceManager color_5];
        
        // 充值方式
        iTopY += iCellHeight;
        iCellLeftX = 10;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, 100, iCellHeight)];
        [_paymentAlert addSubview:label2];
        label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = [ResourceManager color_1];
        label2.text = @"充值方式";
        
        iCellLeftX += 100 +10;
        UILabel *labe2Vaule = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, SCREEN_WIDTH -iCellLeftX - 15, iCellHeight)];
        [_paymentAlert addSubview:labe2Vaule];
        labe2Vaule.font = [UIFont systemFontOfSize:14];
        labe2Vaule.textColor = [ResourceManager color_1];
        labe2Vaule.textAlignment = NSTextAlignmentRight;
        labe2Vaule.text = @"天狗窝";
        
        UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY+ iCellHeight -1, SCREEN_WIDTH - 20, 1)];
        [_paymentAlert addSubview:viewFG2];
        viewFG2.backgroundColor = [ResourceManager color_5];
        
        if (_iType == 1)
         {
            // 钱包地址
            iTopY += iCellHeight;
            iCellLeftX = 10;
            
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, 100, iCellHeight)];
            [_paymentAlert addSubview:label3];
            label3.font = [UIFont systemFontOfSize:14];
            label3.textColor = [ResourceManager color_1];
            label3.text = @"钱包地址";
            
            iCellLeftX += 100 +10;
            UILabel *labe3Vaule = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iTopY, SCREEN_WIDTH -iCellLeftX - 15, iCellHeight)];
            [_paymentAlert addSubview:labe3Vaule];
            labe3Vaule.font = [UIFont systemFontOfSize:14];
            labe3Vaule.textColor = [ResourceManager color_1];
            labe3Vaule.textAlignment = NSTextAlignmentRight;
            labe3Vaule.text = _accid;
            
            UIView *viewFG3 = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY+ iCellHeight -1, SCREEN_WIDTH - 20, 1)];
            [_paymentAlert addSubview:viewFG3];
            viewFG3.backgroundColor = [ResourceManager color_5];
         }
        
        // 加入“立即支付”按钮
        float  fButtonY = ALERT_HEIGHT - 60;
        UIButton  *btOK  = [[UIButton alloc] initWithFrame:CGRectMake(15, fButtonY, SCREEN_WIDTH-30, 46)];
        btOK.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [btOK setTitle:@"立即支付" forState:UIControlStateNormal];
        //[btOK setTitleColor:[ResourceManager color_8] forState:UIControlStateNormal];
        btOK.backgroundColor = [ResourceManager mainColor];
        btOK.layer.cornerRadius = btOK.height/2;
        [btOK addTarget:self action:@selector(actionLJZF) forControlEvents:UIControlEventTouchUpInside];
        [_paymentAlert addSubview:btOK];

    }
    
}

#pragma mark ----- 立即支付
-(void) actionLJZF
{

    
    if (_completeHandle) {
        _completeHandle(@"");
    }
    

}


#pragma mark == private method
- (void)addDotsViews
{
    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.passwordField.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.passwordField.frame);
    
    for (int i = 0; i < kDotsNumber; i ++)
     {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 1, password_height)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [self.passwordField addSubview:line];
        
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        dotView.layer.cornerRadius = kDotWith_height/2;
        dotView.hidden = YES;
        [self.passwordField addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
     }
}


- (void)cleanPassword
{
    _passwordField.text = @"";
    
    [self setDotsViewHidden];
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in _passwordDotsArray)
     {
        [view setHidden:YES];
     }
}



- (void)show {
    
    [self drawView];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _paymentAlert.alpha = 0;

    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [self removeFromSuperview];
}




#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
     {
        return YES;
     }
    
    if (_passwordField.text.length >= kDotsNumber)
     {
        return NO;
     }
    
    return YES;
}

#pragma mark - 
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

#pragma mark == event response
- (void)passwordFieldDidChange:(UITextField *)field
{
    [self setDotsViewHidden];
    
    for (int i = 0; i < _passwordField.text.length; i ++)
     {
        if (_passwordDotsArray.count > i )
         {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
         }
     }
    
    
    if (_passwordField.text.length == 6)
     {
        NSString *password = _passwordField.text;
        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        
//        //  转圈等待加入
//        [MBProgressHUD showHUDAddedTo:keyWindow animated:NO];
//        
//        // 转圈等待消失
//        [MBProgressHUD hideHUDForView:keyWindow animated:NO];
        

        
       
        if (_completeHandle) {
                _completeHandle(password);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
        NSLog(@"complete");
        
     }
}


#pragma mark == 懒加载
- (GLTextField *)passwordField
{
    if (nil == _passwordField)
     {
        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake((kScreenWidth - 44 * 6)/2.0, TITLE_HEIGHT + 10, 44 * 6, 44)];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor whiteColor];
        //将密码的文字颜色和光标颜色设置为透明色
        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        //_passwordField.keyboardType = UIKeyboardTypeDecimalPad;
        _passwordField.secureTextEntry = YES;
        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     }
    return _passwordField;
}

- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
     {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
     }
    return _passwordDotsArray;
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
