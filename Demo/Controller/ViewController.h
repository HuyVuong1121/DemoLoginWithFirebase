//
//  ViewController.h
//  Demo
//
//  Created by HuyVuong on 7/2/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) NSDictionary *dicPost;
@property (strong, nonatomic) NSMutableArray *likeArray;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic)  UIView * notifView;
@end

