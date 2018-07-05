//
//  PostData.m
//  Demo
//
//  Created by HuyVuong on 7/3/18.
//  Copyright © 2018 HuyVuong. All rights reserved.
//
//


#import "PostData.h"

NSString *const kPostDataEmail = @"email";
NSString *const kPostDataImage = @"image";
NSString *const kPostDataTitle = @"title";
NSString *const kPostDataUid = @"uid";

@interface PostData ()
@end
@implementation PostData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kPostDataEmail] isKindOfClass:[NSNull class]]){
        self.email = dictionary[kPostDataEmail];
    }
    if(![dictionary[kPostDataImage] isKindOfClass:[NSNull class]]){
        self.image = dictionary[kPostDataImage];
    }
    if(![dictionary[kPostDataTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kPostDataTitle];
    }
    if(![dictionary[kPostDataUid] isKindOfClass:[NSNull class]]){
        self.uid = dictionary[kPostDataUid];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.email != nil){
        dictionary[kPostDataEmail] = self.email;
    }
    if(self.image != nil){
        dictionary[kPostDataImage] = self.image;
    }
    if(self.title != nil){
        dictionary[kPostDataTitle] = self.title;
    }
    if(self.uid != nil){
        dictionary[kPostDataUid] = self.uid;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.email != nil){
        [aCoder encodeObject:self.email forKey:kPostDataEmail];
    }
    if(self.image != nil){
        [aCoder encodeObject:self.image forKey:kPostDataImage];
    }
    if(self.title != nil){
        [aCoder encodeObject:self.title forKey:kPostDataTitle];
    }
    if(self.uid != nil){
        [aCoder encodeObject:self.uid forKey:kPostDataUid];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.email = [aDecoder decodeObjectForKey:kPostDataEmail];
    self.image = [aDecoder decodeObjectForKey:kPostDataImage];
    self.title = [aDecoder decodeObjectForKey:kPostDataTitle];
    self.uid = [aDecoder decodeObjectForKey:kPostDataUid];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    PostData *copy = [PostData new];
    
    copy.email = [self.email copy];
    copy.image = [self.image copy];
    copy.title = [self.title copy];
    copy.uid = [self.uid copy];
    
    return copy;
}
@end
