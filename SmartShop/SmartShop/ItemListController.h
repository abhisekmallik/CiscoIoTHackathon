//
//  ItemListController.h
//  XpressShopping
//
//  Created by Abhisek Mallik on 12/3/15.
//  Copyright © 2015 Abhisek Mallik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScreenMode) {
    PaymentMode,
    ListMode
};

@interface ItemListController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(ScreenMode)mode;

@end
