//
//  PostViewController.m
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import "PostViewController.h"
@import FirebaseStorage;
@import Firebase;

@interface PostViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *naviButton = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(didPresNaviItemButtonClick)];
    self.navigationItem.rightBarButtonItem=naviButton;
    [naviButton release];
    self.ref = [[FIRDatabase database] reference];
    if (self.dicDataPost != nil) {
        self.titleField.text = self.dicDataPost[@"title"];
        // download image
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.dicDataPost[@"image"]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
               self.imgView.image = [UIImage imageWithData: data];
            });
            [data release];
        });
    }
    
}

//MARK: - Upload image and text to firebase
-(IBAction)didPresNaviItemButtonClick {
    [self uploadImageToFirebase];
}

-(void)writeDataText: (NSString*) url {
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if(self.dicDataPost != nil) {
        [[self.ref child:@"image"] setValue:url];
        [[self.ref child:@"title"] setValue:_titleField.text];
        
    } else {
        NSArray *like = @[
                          @{
                               @"uid": @"",
                               @"email": @"",
                               @"like": @NO,
                               }
                          ];
        NSArray *comment = @[
                             @{
                                @"uid": @"",
                                @"email": @"",
                                @"message": @"Chưa có comment nào!",
                              }
                            ];
        NSDictionary *arr = @{
                              @"uid": currentUser.uid,
                              @"email": currentUser.email,
                              @"image": url,
                              @"title": _titleField.text,
                              @"like": like,
                              @"comment":comment
                            };
        [self.ref setValue:arr];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    //   [self.ref setValue:arr forKey:@"demologin-4cbca"];
    //    [self.ref updateChildValues:[@"posts" , arr]];
}

//MARK: - upload image to firebase
-(void)uploadImageToFirebase {
    if (_imgView.image != nil)
    {
        FIRUser *currentUser = [FIRAuth auth].currentUser;
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storageRef = [storage reference];
        storageRef = [storage referenceForURL:@"gs://demologin-4cbca.appspot.com"];
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName = [NSString stringWithFormat:@"%@-%@.jpg",currentUser.uid, imageID];
        FIRStorageReference *profilePicRef = [storageRef child:imageName];
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        NSData *imageData = UIImageJPEGRepresentation(self.imgView.image, 0.8);
        [profilePicRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
         {
             if (!error)
             {
                 NSString  *profileImageURL = metadata.downloadURL.absoluteString;
                 [self writeDataText:profileImageURL];
             }
             else if (error)
             {
                 NSLog(@"Failed");
             }
         }];
    }
}

//MARK - Select image
- (IBAction)didPressChooseImage:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//MARK: - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
