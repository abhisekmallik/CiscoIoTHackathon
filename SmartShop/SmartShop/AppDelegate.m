//
//  AppDelegate.m
//  SmartShop
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemListController.h"
#import "RootMapViewVCViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"productlist.dat"];
    
    
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:dataPath isDirectory:&isDir]){
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        _productList = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];

    }
    
    
    _itemVC = [[ItemListController alloc] initWithNibName:@"ItemListController" bundle:nil];
    UINavigationController *navCntrl = [[UINavigationController alloc] initWithRootViewController:_itemVC];
    self.window.rootViewController = navCntrl;
    [self.window makeKeyAndVisible];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    return YES;
}


- (void)loadItemList {
    
}

- (void)loadMapView {
    
}

- (void)loadCheckout {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cisco.hack.cmx.SmartShop" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmartShop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SmartShop.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    BOOL handled = NO;
    
    // Extract the payload
    NSString *type = [userActivity activityType];
    NSDictionary *userInfo = [userActivity userInfo];
    
    // Assume the app delegate has a text field to display the activity information
    NSLog(@"User activity is of type %@, and user info %@", type, userInfo);
    
    
    
    RootMapViewVCViewController *routeMap = [[RootMapViewVCViewController alloc] initWithNibName:@"RootMapViewVCViewController" bundle:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"yourfilename.dat"];
//        
//        // Save it into file system
//        [[[userActivity userInfo] valueForKey:@"places"] writeToFile:dataPath atomically:YES];
    });
    
    
    routeMap.places  = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[[userActivity userInfo] valueForKey:@"places"]];
    
    
    [_itemVC presentViewController:routeMap animated:YES completion:^{
        
    }];

    
    handled = YES;
    return handled;
}


- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
    
    NSData *dataOnObject = (NSData*)[applicationContext valueForKey:@"product"];
    
    _productList = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:dataOnObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Generate the file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"productlist.dat"];
        
        
        NSError *error;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:dataPath isDirectory:&isDir]){
            [fileManager removeItemAtPath:dataPath error:&error];
        }
        
        
        // Save it into file system
        [dataOnObject writeToFile:dataPath atomically:YES];
        
    });
    
}

@end
