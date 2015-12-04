//
//  InterfaceController.m
//  S-Shop Extension
//
//  Created by Arun Ramakani on 12/4/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "InterfaceController.h"
#import <ApiAI/ApiAI.h>


@interface InterfaceController()

@property (nonatomic, strong) dispatch_semaphore_t  assertionSemaphore;
@property (nonatomic, strong) NSArray               *validIntractions;
@property (nonatomic, strong) NSString              *fulfilmentRes;
@property (nonatomic, strong) NSMutableArray        *products;
@property (nonatomic, assign) BOOL                  activityInprogress;
@property (nonatomic, assign) int                   loadIndex;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    [_pleaseWaitAnimation setImageNamed:@"frame"];
    _validIntractions   = [NSArray arrayWithObjects:@"PRODUCTADD", @"PRODUCTREMOVE", nil];
    _products = [[NSMutableArray alloc] init];
    _activityInprogress = FALSE;
    _loadIndex          = -1;
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if(_activityInprogress) {
        [_progressGroup setHidden:FALSE];
        [_recordGroup setHidden:TRUE];
        [_pleaseWaitAnimation startAnimating];
    } else {
        [_pleaseWaitAnimation stopAnimating];
        [_progressGroup setHidden:TRUE];
        [_recordGroup setHidden:FALSE];
    }
    
    if(_loadIndex > -1)
        [self forwardRequest];
    
}

-(void) forwardRequest {
    
    if(_loadIndex == 0 && _loadIndex == 1){
    // Add Remove Product
        
        [self pushControllerWithName:@"MapController" context:_products];
        
    } else if(_loadIndex == 1000) {
        
        WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^(void){
        }];
        [self presentAlertControllerWithTitle:@"Error" message:@"We are not able to recogonize" preferredStyle:WKAlertControllerStyleAlert actions:[NSArray arrayWithObjects:act,nil]];
        
    }
}



-(IBAction) recordSound:(id)sender {
    
    
    NSURL *sharedContainer = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kSharedGroup];
    NSURL *fileUrl = [sharedContainer URLByAppendingPathComponent:kVoiceRecordFile];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:fileUrl.absoluteString error:&error];
    
    
    
    NSDictionary *options = @{ WKAudioRecorderControllerOptionsMaximumDurationKey:@(5.f), WKAudioRecorderControllerOptionsActionTitleKey:kRecoderSubmitTitle };
    
    
    [self presentAudioRecorderControllerWithOutputURL:fileUrl preset:WKAudioRecorderPresetWideBandSpeech options:options completion:^(BOOL didSave, NSError * _Nullable error) {
        
        if(didSave && !error) {
            
            ApiAI *apiai = [ApiAI sharedApiAI];
            
            AIVoiceFileRequest *request = [apiai voiceFileRequestWithFileURL:fileUrl];
            
            [request setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
                
                NSString *intent = response.result.metadata.intentName;
                _fulfilmentRes = response.result.fulfillment.speech;
                
                if ([intent length] && [self isValidIntraction:intent]) {
                    NSLog(@"Text : %@", intent);
                    
                    if([intent isEqualToString:@"PRODUCTADD"]) {
                        [self updateProduct:YES product:intent];
                    } else if([intent isEqualToString:@"PRODUCTREMOVE"]) {
                       [self updateProduct:NO product:intent];
                    }
                } else {
                    [self showError];
                }
                
            } failure:^(AIRequest *request, NSError *error) {
                NSLog(@"Error : %@", error.localizedDescription);
            }];
            [apiai enqueue:request];
            [self showProgress];
        }
        
    }];
    
}

-(void) updateProduct:(BOOL) isADD product:(NSString*) product{
    if(isADD){
        
    } else {
        
    }
}

-(void) showProgress {
    
    _activityInprogress = TRUE;
    _loadIndex = -1;
    _assertionSemaphore = nil;
    _assertionSemaphore = dispatch_semaphore_create(0);
    [self requestAssertionWithSmaphore];
    
    [_progressGroup setHidden:FALSE];
    [_recordGroup setHidden:TRUE];
    [_pleaseWaitAnimation startAnimating];
    
    
    
}


-(void) dismissProgress {
    _activityInprogress = FALSE;
    [self releaseAssertionSmaphore];
    
    if(kAppInForeground) {
        
        [_pleaseWaitAnimation stopAnimating];
        [_progressGroup setHidden:TRUE];
        [_recordGroup setHidden:FALSE];
        
    }
    
    
    //[[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
}


-(void) requestAssertionWithSmaphore {
    
    [[NSProcessInfo processInfo] performExpiringActivityWithReason:@"BackgroundAssertion" usingBlock:^(BOOL expired) {
        if(expired) {
            
            // No background assertion possible now, so release smaphore
            [self releaseAssertionSmaphore];
            
        } else {
            // got a background assertion so wait with Semaphore
            if(_assertionSemaphore) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (kServiceTimeOut * (double) NSEC_PER_SEC));
                dispatch_semaphore_wait(_assertionSemaphore, time);
                
            }
        }
    }];
    
}



-(void) releaseAssertionSmaphore {
    if(_assertionSemaphore)
        dispatch_semaphore_signal(_assertionSemaphore);
}

- (void) showError {
    
    [self dismissProgress];
    if(kAppInForeground) {
        WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^(void){
            
        }];
        [self presentAlertControllerWithTitle:@"Error" message:@"We are not able to recogonize" preferredStyle:WKAlertControllerStyleAlert actions:[NSArray arrayWithObjects:act,nil]];
        
    } else {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeFailure];
        _loadIndex = 1000;
    }
    
}



-(BOOL) isValidIntraction:(NSString*) resText {
    
    for (NSString *key in _validIntractions) {
        if ([resText isEqualToString:key])
            return TRUE;
    }
    
    return FALSE;
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



