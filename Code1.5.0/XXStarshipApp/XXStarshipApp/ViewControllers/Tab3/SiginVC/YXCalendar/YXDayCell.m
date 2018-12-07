//
//  YXDayCell.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXDayCell.h"

@interface YXDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayL;     //日期
@property (weak, nonatomic) IBOutlet UIView *pointV;    //点

@end

@implementation YXDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //_dayL.layer.cornerRadius = dayCellH / 2;
    _dayL.height = 30;
    _dayL.width = 30;
    _dayL.layer.cornerRadius = 30 / 2;
    _pointV.layer.cornerRadius = 1.5;
    
}

//MARK: - setmethod

- (void)setCellDate:(NSDate *)cellDate {

    _dayL.height = 30;
    _dayL.width = 30;
    _dayL.layer.cornerRadius = 30 / 2;
    
    _cellDate = cellDate;
    if (_type == CalendarType_Week) {
        [self showDateFunction];
    } else {
        if ([[YXDateHelpObject manager] checkSameMonth:_cellDate AnotherMonth:_currentDate]) {
            [self showDateFunction];
        } else {
            [self showSpaceFunction];
        }
    }
    
}

//MARK: - otherMethod

- (void)showSpaceFunction {
    
    self.userInteractionEnabled = NO;
    _dayL.text = @"";
    _dayL.backgroundColor = [UIColor clearColor];
    _dayL.layer.borderWidth = 0;
    _dayL.layer.borderColor = [UIColor clearColor].CGColor;
    _pointV.hidden = YES;
}

- (void)showDateFunction {

    self.userInteractionEnabled = YES;
    
    _dayL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:_cellDate];
    if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
        _dayL.layer.borderWidth = 0.5;
        _dayL.layer.borderColor = [ResourceManager mainColor].CGColor;//[UIColor blueColor].CGColor;
    } else {
        _dayL.layer.borderWidth = 0;
        _dayL.layer.borderColor = [UIColor clearColor].CGColor;
    }
    if (_selectDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:_selectDate]) {
            _dayL.backgroundColor =  [ResourceManager mainColor];//[UIColor blueColor];
            _dayL.textColor = [UIColor whiteColor];
            _pointV.backgroundColor =  [UIColor whiteColor];
        } else {
            _dayL.backgroundColor = [UIColor clearColor];
            _dayL.textColor =  [ResourceManager color_1];//[UIColor orangeColor];
            _pointV.backgroundColor = [UIColor orangeColor];
        }
        
    }
    NSString *currentDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"MM-dd" Date:_cellDate];
    _pointV.hidden = YES;
    if (_eventArray.count) {
        for (NSString *strDate in _eventArray) {
            if ([strDate isEqualToString:currentDate]) {
                //_pointV.hidden = NO;
                
                _dayL.layer.borderWidth = 0.5;
                _dayL.layer.borderColor = [ResourceManager mainColor].CGColor;
            }
        }
    }
    
}

@end
