//
//  OfferView.m
//  V-Teller
//
//  Created by Arun Ramakani on 11/21/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "ProductListView.h"
#import "ProductRow.h"
#import "Product.h"


@interface ProductListView ()

@property (nonatomic, strong) NSArray *productList;

@end

@implementation ProductListView

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    _productList = (NSArray*) context;
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [self configureTable];
    NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:_productList];
    NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataOnObject, @"product", nil];
    [[WCSession defaultSession] updateApplicationContext:productDict error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNearestShop:) name:@"NearestShop" object:nil];
}


-(IBAction) loadMap:(id)sender {
    [[HEREPlacesDataProvider sharedInstance] searchForPlaceWithString:@"lulu hypermarket"];
}

// handle success search
-(void) successWithPlaces:(NSArray*) placesList {
    
    NSLog(@" Places array : %@",placesList);
    if ([placesList count] > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:placesList];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:nil];
        
    }
    
    
}

// handle failure search
-(void) didSearchFailWithError:(NSString *) errorMessage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:nil];
    
}


-(void) loadNearestShop :(NSNotification *)notification{
    
    
    NSArray *arr = (NSArray*) notification.object;
    
    if(arr) {

        [self pushControllerWithName:@"MapController" context:arr];
        
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


-(void) configureTable {
    [_productTable setNumberOfRows:[_productList count] withRowType:@"ProductRow"];
    
    for (int i = 0; i < [_productList count]; i++) {
        ProductRow *row = [_productTable rowControllerAtIndex:i];
       
        Product *res = (Product*)_productList[i];
        [row.ProductPrice setText:res.name];
        [row.ProductTitle setText:res.price];
        
    }
}




@end



