#import <UIKit/UIKit.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end