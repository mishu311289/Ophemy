//
//  serviceProviderOrdersOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/8/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serviceProviderOrdersOC : NSObject

   @property (assign, nonatomic) int orderId, tableId, restaurantId;
   @property (strong, nonatomic) NSString *totalBill, *dateOfOrder, *lastUpdate, *timeOfDelivery, *status;
   @property (strong, nonatomic) NSArray *orderDetails;
@end
