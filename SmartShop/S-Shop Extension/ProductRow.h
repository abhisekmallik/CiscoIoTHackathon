//
//  ProductRow.h
//  V-Teller
//
//  Created by Arun Ramakani on 11/21/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface ProductRow : NSObject


@property (weak, nonatomic) IBOutlet WKInterfaceLabel *ProductTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *ProductPrice;


@end
