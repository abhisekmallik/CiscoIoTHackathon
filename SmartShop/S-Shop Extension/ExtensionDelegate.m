//
//  ExtensionDelegate.m
//  S-Shop Extension
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <ApiAI/ApiAI.h>
#import "CurrentLocationProvider.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"da08c64688234acbb801fc05768ec7b1";
    configuration.subscriptionKey = @"01b9957d-cf84-4c40-b1e5-db61833a038b";
    
    apiai.configuration = configuration;
    
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[CurrentLocationProvider sharedInstance] requestLocation];
    kAppInForeground = TRUE;
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
    kAppInForeground = FALSE;
}

@end
