
#import <Foundation/Foundation.h>

@interface menuOC : NSObject
@property (strong,nonatomic) NSString *categoryName,* type, *imageUrl;
@property (assign, nonatomic) int categoryID,isDeleted;
@property (strong, nonatomic) NSArray *itemsList;
@end
