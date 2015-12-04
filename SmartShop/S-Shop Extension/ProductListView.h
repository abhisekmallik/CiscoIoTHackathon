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


@property (nonatomic, weak) IBOutlet WKInterfaceImage *pleaseWaitAnimation;

@property (nonatomic, weak) IBOutlet WKInterfaceGroup *progressGroup;

@property (nonatomic, weak) IBOutlet WKInterfaceButton *edit;

@property (nonatomic, weak) IBOutlet WKInterfaceButton *mapButton;



-(IBAction) loadMap:(id)sender;
-(IBAction) editProduct:(id)sender;

@end
