//
//  PostViewController.h
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *chooseImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSDictionary *dicDataPost;

@end
