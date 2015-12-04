//
//  Product.m
//  SmartShop
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "Product.h"

#define nameKey                 @"name"
#define priceKey                @"price"

@implementation Product


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        self.name                          = [aDecoder decodeObjectForKey:nameKey];
        self.price                   = [aDecoder decodeObjectForKey:priceKey];
        
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.name forKey:nameKey];
    [aCoder encodeObject:self.price forKey:priceKey];
    
}


@end
