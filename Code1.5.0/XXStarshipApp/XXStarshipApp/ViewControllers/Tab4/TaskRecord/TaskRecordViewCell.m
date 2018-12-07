//
//  TaskRecordViewCell.m
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/25.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import "TaskRecordViewCell.h"

@interface TaskRecordViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *resultlabel;


@end


@implementation TaskRecordViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titlelabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"taskName"]];
    self.timelabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
    self.resultlabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"taskDesc"]];
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
