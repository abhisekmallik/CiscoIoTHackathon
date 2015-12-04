//
//  Product.h
//  SmartShop
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject <NSCoding>

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *price;
@property (nonatomic, strong) NSString     *section;

@end
