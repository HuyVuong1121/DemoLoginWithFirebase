//
//  HomeTextImageCell.m
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import "HomeTextImageCell.h"

@implementation HomeTextImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_chatButton release];
    [_optionButton release];
    [super dealloc];
}
- (IBAction)optionButton:(id)sender {
}
@end
