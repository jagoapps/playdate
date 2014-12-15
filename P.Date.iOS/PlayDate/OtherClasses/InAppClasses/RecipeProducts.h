//
//  RecipeProducts.h
//  BPDown
//
//  Created by ml2-1 on 11/14/13.
//  Copyright (c) 2013 TheTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// #define Product_Identifier @"com.partho.recipes"
#define Product_Identifier @"com.jagoapps.playdate.exchangechilds"

@protocol RecipeProductsDelegate <NSObject>
@optional
-(void)didFinishWithTransaction:(SKPaymentTransaction *)transaction;
-(void)didFailWithError:(NSError *)error transaction:(SKPaymentTransaction *)transaction;
-(void)restoringFinish;
-(void)restoringFailedWithError:(NSError *)error;

@end

@interface RecipeProducts : NSObject

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@property (strong, nonatomic) id <RecipeProductsDelegate> delegate;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) id controller;

+(RecipeProducts *)sharedInstance;
-(void)initialize;

-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
-(BOOL)productIsAlreadyPurchased:(NSString *)productIdentifier;

-(void)buyProduct:(SKProduct *)product;
-(void)restoreLastTrasanction;
-(void)cancelRequest;


@end
