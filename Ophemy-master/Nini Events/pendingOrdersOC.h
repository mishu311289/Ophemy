
#import <Foundation/Foundation.h>

@interface pendingOrdersOC : NSObject

@property (strong, nonatomic) NSString *DateTimeOfOrder,*LastUpdate,*Status,*TimeOfDelivery,*TotalBill,*OrderId,*RestaurantId,*TableId,*lastUpdatedTime,*tableType,*note,*TableName;
@property (strong, nonatomic) NSArray *pendingOrderDetails;
@property (strong, nonatomic) NSString *comments,*isCompleted,*requestid;
@property (strong, nonatomic) NSDictionary *requestData;
@end
