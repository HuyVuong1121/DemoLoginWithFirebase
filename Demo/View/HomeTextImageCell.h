//
//  HomeTextImageCell.h
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTextImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *timePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlePostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgPostImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *countLikeLabel;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;
@property (retain, nonatomic) IBOutlet UIButton *optionButton;



@end
