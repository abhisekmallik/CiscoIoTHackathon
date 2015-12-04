//
//  AppDelegate.h
//  SmartShop
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class ItemListController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ItemListController *itemVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

