//
//  OfferView.h
//  V-Teller
//
//  Created by Arun Ramakani on 11/21/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "HEREPlacesDataProvider.h"

@interface ProductListView : WKInterfaceController <WCSessionDelegate,HEREPlacesDataProviderDelegate>

@property (weak, nonatomic) IBOutlet WKInterfaceTable *productTable;

-(IBAction) loadMap:(id)sender;

@end
