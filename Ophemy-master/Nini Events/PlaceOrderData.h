
#import <Foundation/Foundation.h>

@interface PlaceOrderData : NSObject
@property (assign, nonatomic) int ItemId, Quantity, Price;
@property (strong, nonatomic) NSString * itemName;
@end
