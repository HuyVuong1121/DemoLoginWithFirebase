//
//  CommentCell.h
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
