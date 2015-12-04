//
//  ItemListController.m
//  XpressShopping
//
//  Created by Abhisek Mallik on 12/3/15.
//  Copyright © 2015 Abhisek Mallik. All rights reserved.
//

#import "ItemListController.h"
#import "SmartShop-Swift.h"
#import "RootMapViewVCViewController.h"

@interface ItemListController ()

@end

@implementation ItemListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) restoreUserActivityState:(NSUserActivity *)activity {
    
    RootMapViewVCViewController *routeMap = [[RootMapViewVCViewController alloc] initWithNibName:@"RootMapViewVCViewController" bundle:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"yourfilename.dat"];
        
        // Save it into file system
        [[[activity userInfo] valueForKey:@"places"] writeToFile:dataPath atomically:YES];
    });
    
    
    routeMap.places  = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[[activity userInfo] valueForKey:@"places"]];
    
    
    [self presentViewController:routeMap animated:YES completion:^{
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
