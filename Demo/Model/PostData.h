//
//  PostData.h
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostData : NSObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
