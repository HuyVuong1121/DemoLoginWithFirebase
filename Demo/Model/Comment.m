//
//	Comment.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Comment.h"

NSString *const kCommentEmail = @"email";
NSString *const kCommentMessage = @"message";
NSString *const kCommentUid = @"uid";

@interface Comment ()
@end
@implementation Comment




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kCommentEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kCommentEmail];
	}	
	if(![dictionary[kCommentMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kCommentMessage];
	}	
	if(![dictionary[kCommentUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kCommentUid];
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
		dictionary[kCommentEmail] = self.email;
	}
	if(self.message != nil){
		dictionary[kCommentMessage] = self.message;
	}
	if(self.uid != nil){
		dictionary[kCommentUid] = self.uid;
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
		[aCoder encodeObject:self.email forKey:kCommentEmail];
	}
	if(self.message != nil){
		[aCoder encodeObject:self.message forKey:kCommentMessage];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kCommentUid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.email = [aDecoder decodeObjectForKey:kCommentEmail];
	self.message = [aDecoder decodeObjectForKey:kCommentMessage];
	self.uid = [aDecoder decodeObjectForKey:kCommentUid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Comment *copy = [Comment new];

	copy.email = [self.email copy];
	copy.message = [self.message copy];
	copy.uid = [self.uid copy];

	return copy;
}
@end