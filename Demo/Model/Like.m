//
//	Like.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Like.h"

NSString *const kLikeEmail = @"email";
NSString *const kLikeLike = @"like";
NSString *const kLikeUid = @"uid";

@interface Like ()
@end
@implementation Like




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kLikeEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kLikeEmail];
	}	
	if(![dictionary[kLikeLike] isKindOfClass:[NSNull class]]){
		self.like = [dictionary[kLikeLike] boolValue];
	}

	if(![dictionary[kLikeUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kLikeUid];
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
		dictionary[kLikeEmail] = self.email;
	}
	dictionary[kLikeLike] = @(self.like);
	if(self.uid != nil){
		dictionary[kLikeUid] = self.uid;
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
		[aCoder encodeObject:self.email forKey:kLikeEmail];
	}
	[aCoder encodeObject:@(self.like) forKey:kLikeLike];	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kLikeUid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.email = [aDecoder decodeObjectForKey:kLikeEmail];
	self.like = [[aDecoder decodeObjectForKey:kLikeLike] boolValue];
	self.uid = [aDecoder decodeObjectForKey:kLikeUid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	Like *copy = [Like new];

	copy.email = [self.email copy];
	copy.like = self.like;
	copy.uid = [self.uid copy];

	return copy;
}
@end