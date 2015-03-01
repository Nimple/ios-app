//
//  NimplePurchaseModel.m
//  nimple-iOS
//
//  Created by Ben John on 28/02/15.
//  Copyright (c) 2015 nimple. All rights reserved.
//

#import "NimplePurchaseModel.h"

#define kNimpleProVersionProductIdentifier @"nimple.ios.pro"

@interface NimplePurchaseModel()

@property NSUserDefaults *defaults;

@end

@implementation NimplePurchaseModel

#pragma mark - Initialization

+ (id)sharedPurchaseModel
{
    static id sharedPurchaseModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPurchaseModel = [[self alloc] init];
    });
    return sharedPurchaseModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
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

- (void)purchased
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNimpleProVersionProductIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNimplePurchasedNotification object:self];
}

- (BOOL)isPurchased
{
    return [self.defaults boolForKey:kNimpleProVersionProductIdentifier];
}

- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate delegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response.products.count > 0) {
        NSLog(@"products are available");
        [self purchase:response.products[0]];
    } else {
        NSLog(@"nopey, %@, %@", request, response);
    }
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
                NSLog(@"Transaction state -> Purchased");
                [self purchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                [self purchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"failed");
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [self purchased];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
