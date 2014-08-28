//
//  RecipeProducts.m
//  BPDown
//
//  Created by ml2-1 on 11/14/13.
//  Copyright (c) 2013 TheTiger. All rights reserved.
//

#import "RecipeProducts.h"

#define ShowTransactionAlert(TITLE, MESSAGE,DELEGATE) [[[UIAlertView alloc] initWithTitle:TITLE message:MESSAGE delegate:DELEGATE cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]


@interface RecipeProducts () <SKProductsRequestDelegate ,SKPaymentTransactionObserver>
{
    RequestProductsCompletionHandler _completionHandler;
    SKProductsRequest *_productsRequest;
}

-(void)addProductToPurchasedList:(NSString *)productIdentifier;

@end

@implementation RecipeProducts
@synthesize delegate = _delegate;
@synthesize products = _products;

static RecipeProducts *productsHalper = nil;
static NSSet *productIdentifiers = nil;
static NSMutableArray *purchsaedProducts = nil;

+(RecipeProducts *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productsHalper = [[RecipeProducts alloc] init];
    });
    
    return productsHalper;
}

-(void)initialize
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    productIdentifiers = [NSSet setWithObjects:Product_Identifier, nil];
    
    purchsaedProducts = [[NSMutableArray alloc] init];
    // Check for previously purchased products
    for (NSString *productId in productIdentifiers) {
        BOOL purchsed = [[NSUserDefaults standardUserDefaults] boolForKey:productId];
        if (purchsed) {
            [purchsaedProducts addObject:productId];
        }
    }

}

-(void)addProductToPurchasedList:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (purchsaedProducts == nil)
    {
        purchsaedProducts = [[NSMutableArray alloc] init];
    }
    
    [purchsaedProducts addObject:productIdentifier];
}

-(BOOL)productIsAlreadyPurchased:(NSString *)productIdentifier
{
    return [purchsaedProducts containsObject:productIdentifier];
}

-(void)buyProduct:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Request For Products
-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    self.products = response.products;

    _completionHandler (YES, self.products);
    _completionHandler = nil;
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler (NO, nil);
    _completionHandler = nil;
}

#pragma mark - Payment Methods
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self purchaseTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                [self purchasingTransaction:transaction];
                break;

            default:
                break;
        }
    }
}

-(void)purchaseTransaction:(SKPaymentTransaction *)transaction
{
    [self addProductToPurchasedList:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    if ([self.delegate respondsToSelector:@selector(didFinishWithTransaction:)]) {

        [self.delegate didFinishWithTransaction:transaction];
    }
    
    ShowTransactionAlert(@"", @"You have purchased paid version successfully.\nThank you for purchasing!",nil);
}

-(void)purchasingTransaction:(SKPaymentTransaction *)transaction
{
    
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code == SKErrorPaymentCancelled) {
        NSLog(@"Transaction Cancelled");
        ShowTransactionAlert(@"", @"Transaction cancelled!",nil);
        if ([self.delegate respondsToSelector:@selector(didFailWithError:transaction:)]) {
            [self.delegate didFailWithError:nil transaction:transaction];
        }
    }
    else {
        NSLog(@"Transaction Error: %@", [transaction.error localizedDescription]);
        NSString *message = [NSString stringWithFormat:@"%@",[transaction.error localizedDescription]];
        ShowTransactionAlert(@"", message,nil);
        if ([self.delegate respondsToSelector:@selector(didFailWithError:transaction:)]) {
            [self.delegate didFailWithError:transaction.error transaction:transaction];
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - Restore
-(void)restoreLastTrasanction
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"%@",[error localizedDescription]];
    ShowTransactionAlert(@"", message,self.controller);
    if ([self.delegate respondsToSelector:@selector(restoringFailedWithError:)]) {
        [self.delegate restoringFailedWithError:error];
    }

}


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    if ([queue.transactions count] == 0)
    {
        ShowTransactionAlert(@"Restore:", @"There is no product purchased by you.",self.controller);
    }
    else
    {
        
        NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            NSString *productID = transaction.payment.productIdentifier;
            [purchasedItemIDs addObject:productID];
            // here put an if/then statement to write files based on previously purchased items
            // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
            
            [self addProductToPurchasedList:Product_Identifier];
        }
        
        ShowTransactionAlert(@"Restore:", @"Product Restored Successfully!",self.controller);
    }
    
    
    if ([self.delegate respondsToSelector:@selector(restoringFinish)]) {
        [self.delegate restoringFinish];
    }
    
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self addProductToPurchasedList:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)cancelRequest
{
    [_productsRequest cancel];
}

@end
