//
//  ViewController.m
//  Demo
//
//  Created by HuyVuong on 7/2/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import "ViewController.h"
#import "HomeCell.h"
#import "HomeTextImageCell.h"
#import "CommentCell.h"
#import "PostViewController.h"
#import "LoginViewController.h"
@import Firebase;
#import "AppDelegate.h"


@interface ViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) BOOL newMessagesOnTop;
@property (nonatomic) NSInteger count;

@end

@implementation ViewController
@synthesize newMessagesOnTop;
@synthesize count;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self tableViewRegisterNibCell];
    self.ref = [[FIRDatabase database] reference];
}

-(void)tableViewRegisterNibCell {
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil]
             forCellReuseIdentifier:@"HomeCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HomeTextImageCell" bundle:nil]
             forCellReuseIdentifier:@"HomeTextImageCell"];
    [self.homeTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil]
             forCellReuseIdentifier:@"CommentCell"];
    [self.homeTableView setSeparatorColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    if (savedValue == nil) {
        // present to LoginViewController
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:myViewController animated:NO completion:nil];
        
    } else {
        [self loadData];
    }
    
}
//MARK: - query data
-(void)loadData {
    count = 0;
    newMessagesOnTop = NO;
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (!snapshot.exists) {
            self.dicPost = nil;
            [self.likeArray removeAllObjects];
            [self.commentArray removeAllObjects];
            [self.homeTableView reloadData];
            return;
        }
        
        NSDictionary *dic = snapshot.value;
        self.dicPost = dic;
        NSLog(@"Info : %@",dic);
        
        NSMutableArray *like = dic[@"like"];
        self.likeArray = like;
        //  NSLog(@"Like : %@",like);
        
        NSMutableArray *comment = dic[@"comment"];
        self.commentArray = comment;
        // NSLog(@"Comment : %@",comment);
        if(count == self.commentArray.count) {
            newMessagesOnTop = YES;
        }
        
        [self.homeTableView reloadData];
        
    }];
    
    
    [[self.ref child:@"comment"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot)  {
        // Add the chat message to the array.
        NSDictionary *newComment = snapshot.value;
        NSLog(@"new commnet : %@", newComment);
        if(newMessagesOnTop) {
             FIRUser *currentUser = [FIRAuth auth].currentUser;
             NSString *currentUid = currentUser.uid;
             NSString *uidPost = self.dicPost[@"uid"];
            if (![currentUid isEqualToString:uidPost]) {
                return ;
            }
            
            NSString *uidComment = newComment[@"uid"];
            if ([uidComment isEqualToString:@""]) {
                return;
            }
            if (![currentUid isEqualToString:uidComment]) {
                NSLog(@"Show message");
                NSString *message = newComment[@"message"];
                NSString *email = newComment[@"email"];
                [self customBannerViewNotification:message email:email];
            }
        }
        
        count ++;
        if(count == self.commentArray.count) {
            newMessagesOnTop = YES;
        }
        
    }];
    
}

//MARK - custom banner view
- (void)customBannerViewNotification: (NSString*)message email:(NSString*)email {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //Define notifView as UIView in the header file
    [_notifView removeFromSuperview]; //If already existing
    
    _notifView = [[UIView alloc] initWithFrame:CGRectMake(0, -70,appDelegate.window.frame.size.width, 80)];
    [_notifView setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,25,20,20)];
    imageView.image = [UIImage imageNamed:@"images.png"];
    UILabel *emailabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, appDelegate.window.frame.size.width - 100 , 25)];
    emailabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    emailabel.text = email;
    
    [emailabel setTextColor:[UIColor whiteColor]];
    [emailabel setNumberOfLines:1];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, emailabel.frame.size.height + 5, appDelegate.window.frame.size.width - 100 , 30)];
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    messageLabel.text = message;
    
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setNumberOfLines:0];
    
    [_notifView setAlpha:0.5];
    
    //The Icon
    [_notifView addSubview:imageView];
    
    //The Text
    [_notifView addSubview:emailabel];
    [_notifView addSubview:messageLabel];
    
    //The View
    [appDelegate.window addSubview:_notifView];
    
    UITapGestureRecognizer *tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dismissNotifFromScreen)];
    tapToDismissNotif.numberOfTapsRequired = 1;
    tapToDismissNotif.numberOfTouchesRequired = 1;
    
    [_notifView addGestureRecognizer:tapToDismissNotif];
    
    
    [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [_notifView setFrame:CGRectMake(0, 0, appDelegate.window.frame.size.width, 60)];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    //Remove from top view after 5 seconds
    [self performSelector:@selector(dismissNotifFromScreen) withObject:nil afterDelay:5.0];
    
    
    return;
    
    
}

//If the user touches the view or to remove from view after 5 seconds
- (void)dismissNotifFromScreen{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [_notifView setFrame:CGRectMake(0, -70, appDelegate.window.frame.size.width, 60)];
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
}

//MARK: - Like button
-(void)didPressLikeButtonClick:(UIButton*)sender
{
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUid = currentUser.uid;
    __block BOOL checkUserLike = NO;
    for (int i = 0; i < self.likeArray.count; i++) {
        NSString *uid =  self.likeArray[i][@"uid"];
        if ([currentUid isEqualToString:uid]) {
            checkUserLike = YES;
        }
    }
    if(checkUserLike) {
        [[self.ref child:@"like"] removeValue];
    } else {
        NSDictionary *arr= @{
                             @"uid" : currentUser.uid,
                             @"email": currentUser.email,
                             @"like": @YES
                             };
        NSDictionary *childUpdates = @{[@"/like/" stringByAppendingString:@"0"]: arr};
        [self.ref updateChildValues:childUpdates];
    }
    
}

//MARK: - Add commnet
-(void)didPressCommentButtonClick:(UIButton*)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Comment"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter text";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        [self updateCommentToDataBase:namefield.text];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// add comment to firebase
- (void)updateCommentToDataBase: (NSString*)text {
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    __block NSString *countCommnet = @"0";
    __block BOOL updateComment = YES;
    
    [[self.ref child:@"comment"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)  {
        // Add the chat message to the array.
        if (updateComment) {
            NSMutableArray *comment = snapshot.value;
            NSString *uid = comment[0][@"uid"];
            if ([uid isEqualToString:@""]) {
                countCommnet = @"0";
            } else {
                countCommnet = [NSString stringWithFormat:@"%lu",(unsigned long)comment.count];
            }
            
            
            NSDictionary *arr= @{
                                 @"uid" : currentUser.uid,
                                 @"email": currentUser.email,
                                 @"message": text
                                 };
            NSDictionary *childUpdates = @{[@"/comment/" stringByAppendingString:countCommnet]: arr};
            [self.ref updateChildValues:childUpdates];
            // [[self.ref child:@"comment"] setValue:arr];
            updateComment = NO;
        }
    }];
    
}

//MARK: - button option edit or delete Post
-(void)didPressOptionButtonClick:(UIButton*)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Option"
                                                                              message: @"Select button edit or delete post"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editPostClick];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deletePostClik];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)editPostClick {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostViewController *postVC = [storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    postVC.dicDataPost = self.dicPost;
    [self.navigationController pushViewController:postVC animated:YES];
}

-(void)deletePostClik{
     [self.ref removeValue];
}



//MARK: - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dicPost != nil) {
        return 3;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    switch (section) {
        case 0: return 1;
        case 1: return 1;
        case 2:
            return self.commentArray == nil ? 0 : self.commentArray.count;
        default:
            return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    // Configure the cell...
    if (indexPath.section == 0) {
        HomeCell *dequecell = [_homeTableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        cell = dequecell;
    } else if (indexPath.section == 1) {
        HomeTextImageCell *dequecell = [_homeTableView dequeueReusableCellWithIdentifier:@"HomeTextImageCell"];
        if (self.dicPost != nil) {
            dequecell.emailUserLabel.text = self.dicPost[@"email"];
            dequecell.titlePostLabel.text = self.dicPost[@"title"];
            
            // download image
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.dicPost[@"image"]]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // WARNING: is the cell still using the same data by this point??
                    dequecell.imgPostImageView.image = [UIImage imageWithData: data];
                });
                [data release];
            });
        }
        // like button
        [dequecell.likeButton addTarget:self action:@selector(didPressLikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // comment buton
        [dequecell.chatButton addTarget:self action:@selector(didPressCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [dequecell.optionButton addTarget:self action:@selector(didPressOptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //  dequecell.countLikeLabel.text = self.dicLike == nil ? @"+0" : [NSString stringWithFormat: @"+%lu", (unsigned long)self.dicLike.count];
        dequecell.countLikeLabel.text = @"";
        
        // set value like button
        if([self getUserCurrentLike:self.likeArray]) {
            UIImage *btnImage = [UIImage imageNamed:@"like_red.png"];
            [dequecell.likeButton setImage:btnImage forState:UIControlStateNormal];
        } else {
            UIImage *btnImage = [UIImage imageNamed:@"like_w.png"];
            [dequecell.likeButton setImage:btnImage forState:UIControlStateNormal];
        }
        
        cell = dequecell;
    } else {
        CommentCell *dequecell = [_homeTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (self.commentArray != nil) {
            NSDictionary *cm = self.commentArray[indexPath.row];
            dequecell.emailUserLabel.text = cm[@"email"];
            dequecell.commentLabel.text = cm[@"message"];
            NSString *uid = cm[@"email"];
            if([uid isEqualToString:@""]) {
                dequecell.avatarImageView.hidden = YES;
            } else {
                dequecell.avatarImageView.hidden = NO;
            }
        }
        cell = dequecell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL)getUserCurrentLike:(NSMutableArray*)array{
    BOOL check = false;
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSString *currentUid = currentUser.uid;
    for (int i = 0; i < array.count; i++) {
        NSString *uid =  array[i][@"uid"];
        if ([currentUid isEqualToString:uid]) {
            return true;
        }
    }
    return check;
}

//MARK : - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // present to PostViewController
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PostViewController *postVC = [storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
        [self.navigationController pushViewController:postVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
