//
//  NimplePurchaseModel.m
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import "NimplePurchaseModel.h"

#define kNimpleProVersionProductIdentifier @"pro-version"

@implementation NimplePurchaseModel

+ (id)sharedPurchaseModel
{
    static id sharedPurchaseModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPurchaseModel = [[self alloc] init];
    });
    return sharedPurchaseModel;
}

#pragma mark - Purchase process

- (void)requestPurchase
{
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kNimpleProVersionProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (BOOL)isPurchased
{
    // check for purchase in queue
    return NO;
}

- (BOOL)isPurchasePending
{
    // TODO
    return NO;
}

- (void)purchase:(NimpleBlock)successBlock errorBlock:(NimpleErrorBlock)errorBlock
{
    // TODO fetch correct product from product request
    SKProduct *product = nil;
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    // TODO
    successBlock();
    errorBlock(nil);
}

- (void)purchase
{
    
}

#pragma mark - SKProductsRequestDelegate delegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
}

#pragma mark - SKPaymentTransactionObserver delegate methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateDeferred:
                NSLog(@"Transaction state -> Deferred");
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction state -> Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self purchase];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
