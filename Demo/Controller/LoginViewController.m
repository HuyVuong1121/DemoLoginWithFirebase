
//
//  LoginViewController.m
//  Demo
//
//  Created by HuyVuong on 7/2/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
@import Firebase;

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//MARK: Login with email
- (IBAction)didPressLogin:(id)sender {
    
//MARK: -account test
//    _emailField.text = @"admin@gmail.com";
//    _passwordField.text = @"12345678";
    
//    _emailField.text = @"hey@gmail.com";
//    _passwordField.text = @"123456";
    
    [[FIRAuth auth] signInWithEmail:_emailField.text password:_passwordField.text completion:^(FIRUser *user, NSError *error) {
        
        if (user) {
            NSString *uid = user.uid; // Unique ID, which you can use to identify the user on the client side
            NSString *email = user.email;
            NSLog(@"Uid: %@",uid);
            NSLog(@"email: %@", email);
            // NSString *photoURL = user.photoURL; [user getTokenWithCompletion:^(NSString *token, NSError *error) {
            NSString *valueToSave = user.uid;
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // Dismiss loginViewController
            [self dismissViewControllerAnimated:YES completion:NULL];

        } 
    }];
    
}

//MARK: dismiss keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
