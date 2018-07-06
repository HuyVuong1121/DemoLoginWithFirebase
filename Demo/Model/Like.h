#import <UIKit/UIKit.h>

@interface Like : NSObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) BOOL like;
@property (nonatomic, strong) NSString * uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end