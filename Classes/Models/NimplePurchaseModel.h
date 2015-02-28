//
//  NimplePurchaseModel.h
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface NimplePurchaseModel : NSObject <SKPaymentTransactionObserver>

+ (NimplePurchaseModel *)sharedPurchaseModel;

- (BOOL)isPurchased;
- (void)purchase:(NimpleBlock)successBlock errorBlock:(NimpleErrorBlock)errorBlock;

@end
