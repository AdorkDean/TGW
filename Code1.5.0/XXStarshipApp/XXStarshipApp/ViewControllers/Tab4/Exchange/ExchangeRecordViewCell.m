//
//  ExchangeRecordViewCell.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/25.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "ExchangeRecordViewCell.h"


@interface ExchangeRecordViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end


@implementation ExchangeRecordViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"remark"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
    self.resultLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"changeCountText"]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
