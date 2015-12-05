//
//  ViewController.m
//  CiscoRESTApi
//
//  Created by Abhisek Mallik on 12/4/15.
//  Copyright © 2015 Abhisek Mallik. All rights reserved.
//

#import "MapVC.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import "SmartShop-Swift.h"
<<<<<<< HEAD
#import "OCR.h"

=======
#import "PhotoViewController.h"
>>>>>>> origin/master

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface MapVC () <UIScrollViewDelegate, ABSteppedProgressBarDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgMap;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) UIImageView *imgLoc;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong) NSNumber *numX;
@property (strong) NSNumber *numY;
@property (strong, nonatomic) UIButton *apple;
@property (strong, nonatomic) UIButton *diaper;
@property (strong, nonatomic) UIButton *sugar;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet ABSteppedProgressBar *progress;

@end

@implementation MapVC

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}

-(void) leftTopBarButtonTouchUpInside
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(leftTopBarButtonTouchUpInside)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.title = @"Indoor Maps";
    
    _numX = [NSNumber numberWithFloat:0.0f];
    _numY = [NSNumber numberWithFloat:0.0f];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    _imgMap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"domain_0_1449152699182"]];
    CGRect rect = _imgMap.frame;
    rect.origin = CGPointZero;
    _imgMap.frame = rect;
    _imgMap.userInteractionEnabled = YES;
    
    [_scroll addSubview:_imgMap];
    [_scroll setContentSize:_imgMap.frame.size];
    _scroll.delaysContentTouches = NO;
    
    
    _scroll.delegate = self;
    
    UIImage *img = [UIImage imageNamed:@"position"];
    _imgLoc = [[UIImageView alloc] initWithImage:img];
    rect = _imgLoc.frame;
    rect.origin.x = 61.33f * (_imgMap.frame.size.width / 92.6);
    rect.origin.y = 9.63f * (_imgMap.frame.size.height / 63.3);
    _imgLoc.frame = rect;
    [_imgMap addSubview:_imgLoc];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
    _label.numberOfLines = 0;
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.window addSubview:_label];
    _progress.delegate = self;
    _progress.currentIndex = _progress.currentIndex++;
    
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(pollLocation)];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
    [inv setTarget: self];
    [inv setSelector:@selector(pollLocation)];
    
    NSTimer *t = [NSTimer timerWithTimeInterval: 10.0
                                     invocation:inv
                                        repeats:YES];
    [t fire];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];
    
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedItem:)];
    _tap.numberOfTapsRequired = 1;
    _tap.numberOfTouchesRequired = 1;
    
//    _diaper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diaper"]];
    _diaper = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diaper setBackgroundImage:[UIImage imageNamed:@"diaper"] forState:UIControlStateNormal];
    rect = _diaper.frame;
    rect.origin.x = 75.0f * (_imgMap.frame.size.width / 92.6);
    rect.origin.y = 18.0f * (_imgMap.frame.size.height / 63.3);
    rect.size = CGSizeMake(60, 60);
    _diaper.frame = rect;
    _diaper.tag = 111;
    [_diaper addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
    [_imgMap addSubview:_diaper];
    
    
    _apple = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple"]];
    [_apple setBackgroundImage:[UIImage imageNamed:@"apple"] forState:UIControlStateNormal];
    rect = _apple.frame;
    rect.origin.x = 60.0f * (_imgMap.frame.size.width / 92.6);
    rect.origin.y = 23.0f * (_imgMap.frame.size.height / 63.3);
    rect.size = CGSizeMake(60, 60);
    [_apple addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];

//    _apple.userInteractionEnabled = YES;
//    [_apple addGestureRecognizer:_tap];
    _apple.frame = rect;
    _apple.tag = 222;
    [_imgMap addSubview:_apple];
    
    
    _sugar = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sugar setBackgroundImage:[UIImage imageNamed:@"sugar"] forState:UIControlStateNormal];

    //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sugar"]];
    rect = _sugar.frame;
    rect.origin.x = 63.0f * (_imgMap.frame.size.width / 92.6);
    rect.origin.y = 40.0f * (_imgMap.frame.size.height / 63.3);
    rect.size = CGSizeMake(60, 60);
    [_sugar addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];

//    _sugar.userInteractionEnabled = YES;
//    [_sugar addGestureRecognizer:_tap];
    _sugar.frame = rect;
    _sugar.tag = 333;

    [_imgMap addSubview:_sugar];
    
    
//    [self startMotionManager];
//    NSLog(@"Mac Addr %@",[self getMacAddress]);
    
}

- (void)selectedItem:(UIButton *)button {
    NSLog(@"tag %ld",button.tag);
    
    if (button.tag == 111) {

        OCR *orc = [OCR alloc] initWithNibName:<#(nullable NSString *)#> bundle:<#(nullable NSBundle *)#>

    }
}

- (void)pollLocation {
//    NSString *strUrl = [NSString stringWithFormat:@"http://10.10.20.11/api/contextaware/v1/location/clients/%@",[self getMacAddress]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.10.20.11/api/contextaware/v1/location/clients/48:74:6e:ad:53:ae"]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Basic bGVhcm5pbmc6bGVhcm5pbmc=" forHTTPHeaderField:@"Authorization"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
                    if (!error) {
                        NSError *err = nil;
                        id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                        if ([responseDict isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = (NSDictionary *)responseDict;
                            NSDictionary* dimension = [dict valueForKeyPath:@"WirelessClientLocation.MapCoordinate"];
                            @synchronized(_numX) {
                                _numX = [dimension objectForKey:@"x"];
                            }
                            
                            @synchronized(_numY) {
                                _numY = [dimension objectForKey:@"y"];
                            }
                            NSLog(@"x: %@ | y: %@",_numX, _numY);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CGRect rect = _imgLoc.frame;
                                rect.origin.x = [_numX floatValue] * (_imgMap.frame.size.width / 92.6);
                                rect.origin.y = [_numY floatValue] * (_imgMap.frame.size.height / 63.3);
                                _imgLoc.frame = rect;
                                
                                _label.text = [NSString stringWithFormat:@"x: %f\ny: %f",[_numX floatValue], [_numY floatValue]];
                                [_label sizeToFit];
                            });
                            
                        }
                        NSLog(@"response \n%@",responseDict);
                    }

                    
    }] resume];
}

- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    _motionManager.deviceMotionUpdateInterval = 1;//1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                           withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                               //CMAttitude *attitude = motion.attitude;
                                               //NSLog(@"rotation rate = [%f, %f, %f]", attitude.pitch, attitude.roll, attitude.yaw);
                                               [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                               
                                           }];
        //[motionManager startDeviceMotionUpdates];
        
        
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
    
    
    
    
//    if ([_motionManager isAccelerometerAvailable]) {
//        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
//                                             withHandler:^(CMAccelerometerData * _Nullable accelerometerData,
//                                                           NSError * _Nullable error) {
//            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:accelerometerData waitUntilDone:YES];
//        }];
//    } else {
//        NSLog(@"No device motion on device.");
//        [self setMotionManager:nil];
//    }
}

- (void)handleDeviceMotion:(CMDeviceMotion*)motion {
//    CMAttitude *attitude = motion.attitude;
    
//    float accelerationThreshold = 0.2; // or whatever is appropriate - play around with different values
    CMAcceleration userAcceleration =  motion.userAcceleration;
    CMAcceleration gravity = motion.gravity;
    __block double x = userAcceleration.x + gravity.x;
    __block double y = userAcceleration.y + gravity.y;
    
    @synchronized(_numX) {
        _numX = [NSNumber numberWithFloat:(x + [_numX floatValue])];
    }
    
    @synchronized(_numY) {
        _numY = [NSNumber numberWithFloat:(y + [_numY floatValue])];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGRect rect = _imgLoc.frame;
//        rect.origin.x = x * (_imgMap.frame.size.width / 92.6);
//        rect.origin.y = y * (_imgMap.frame.size.height / 63.3);
//        _imgLoc.frame = rect;
//        
//        _label.text = [NSString stringWithFormat:@"x: %f\ny: %f",x, y];
//        [_label sizeToFit];
        
        
        CGRect rect = _imgLoc.frame;
        rect.origin.x = [_numX floatValue] * (_imgMap.frame.size.width / 92.6);
        rect.origin.y = [_numY floatValue] * (_imgMap.frame.size.height / 63.3);
        _imgLoc.frame = rect;
        
        _label.text = [NSString stringWithFormat:@"x: %f\ny: %f",[_numX floatValue], [_numY floatValue]];
        [_label sizeToFit];

    });
    
//    float rotationRateThreshold = 7.0;
//    CMRotationRate rotationRate = motion.rotationRate;
//
//    if ((rotationRate.x) > rotationRateThreshold) {
//        if (fabs(userAcceleration.x) > accelerationThreshold || fabs(userAcceleration.y) > accelerationThreshold || fabs(userAcceleration.z) > accelerationThreshold) {
//            
//            NSLog(@"rotation rate = [Pitch: %f, Roll: %f, Yaw: %f]", attitude.pitch, attitude.roll, attitude.yaw);
//            NSLog(@"motion.rotationRate = %f", rotationRate.x);
//            
//            [self showMenuAnimated:YES];
//        }
//    }
//    
//    else if ((-rotationRate.x) > rotationRateThreshold) {
//        if (fabs(userAcceleration.x) > accelerationThreshold || fabs(userAcceleration.y) > accelerationThreshold || fabs(userAcceleration.z) > accelerationThreshold) {
//            
//            NSLog(@"rotation rate = [Pitch: %f, Roll: %f, Yaw: %f]", attitude.pitch, attitude.roll, attitude.yaw);
//            NSLog(@"motion.rotationRate = %f", rotationRate.x);
//            
//            [self dismissMenuAnimated:YES];
//        }
//    }
}


- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
