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

#import "MapVC.h"

@interface ItemListController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnApplePay;
- (IBAction)applePaymentAction:(id)sender;

- (IBAction)continueAction:(id)sender;
@property (assign, nonatomic) ScreenMode mode;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) UITapGestureRecognizer *gesture;
@end

@implementation ItemListController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(ScreenMode)mode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mode = mode;
    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.5 animations:^{
        _imgView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat price = 0.0f;
    for (Product *p in delegate.productList) {
        price += [p.price floatValue];
    }
    _lblTotal.text = [NSString stringWithFormat:@"Total : AED %0.2f",price];
    
    
    if (_mode == PaymentMode) {
        _btnContinue.hidden = YES;
//        _imgView.alpha = 0;
    } else {
        _btnApplePay.hidden = YES;
    }
    
    self.title = @"Wish List";
    
    
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    _gesture.numberOfTapsRequired = 1;
    
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ApplePayment"]];
    _imgView.userInteractionEnabled = YES;
    CGRect frame = _imgView.frame;
    frame.origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height +_imgView.frame.size.height);
    [_imgView addGestureRecognizer:_gesture];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"AED %0.2f",[prod.price floatValue]];
    return cell;
}

- (IBAction)applePaymentAction:(id)sender {
//    [UIView animateWithDuration:0.5 animations:^{
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // animation duration in seconds
    _imgView.alpha = 1.0;

    [UIView commitAnimations];
}

- (IBAction)continueAction:(id)sender {
    MapVC *map = [[MapVC alloc] initWithNibName:@"MapVC" bundle:nil];
    [self.navigationController pushViewController:map animated:YES];
}
@end
