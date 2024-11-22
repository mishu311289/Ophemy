
#import <Foundation/Foundation.h>

@interface menuItemsOC : NSObject
@property (strong,nonatomic) NSString *ItemName,* Cuisine, *type, *Image,*Price;
@property (assign, nonatomic) int ItemId,Quantity,IsDeletedItem,categoryId;
@end
