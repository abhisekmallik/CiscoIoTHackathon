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
#import "AppDelegate.h"
#import "Product.h"

@interface ItemListController () <UITableViewDataSource, UITableViewDelegate>

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
    
       
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Product *prod = [delegate.productList objectAtIndex:indexPath.row];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return  [delegate.productList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Product *prod = [delegate.productList objectAtIndex:indexPath.row];
    cell.textLabel.text = prod.name;
    cell.detailTextLabel.text = prod.price;
    return cell;
}

@end
