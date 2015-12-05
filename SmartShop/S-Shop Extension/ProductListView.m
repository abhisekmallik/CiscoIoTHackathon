//
//  OfferView.m
//  V-Teller
//
//  Created by Arun Ramakani on 11/21/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "ProductListView.h"
#import "ProductRow.h"
#import "Product.h"
#import <ApiAI/ApiAI.h>


@interface ProductListView ()

@property (nonatomic, strong) NSMutableArray                *productList;
@property (nonatomic, assign) BOOL                          activityInprogress;

@end

@implementation ProductListView

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [_pleaseWaitAnimation setImageNamed:@"frame"];
    _activityInprogress = FALSE;
    
    
    _productList = (NSMutableArray*) context;
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [self configureTable];
    
    NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:_productList];
    NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataOnObject, @"product", nil];
    [[WCSession defaultSession] updateApplicationContext:productDict error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNearestShop:) name:@"NearestShop" object:nil];
}


-(IBAction) loadMap:(id)sender {
    [self showProgress];
    [[HEREPlacesDataProvider sharedInstance] searchForPlaceWithString:@"lulu hypermarket"];
    [HEREPlacesDataProvider sharedInstance].delegate = self;
}

-(IBAction) editProduct:(id)sender {
    
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
                
                NSDictionary *paramsArray = response.result.parameters;
                
                if (paramsArray != nil && intent != nil) {
                    for(NSString *key in [paramsArray allKeys]){
                        
                        AIResponseParameter *valObj = [paramsArray valueForKey:key];
                        NSString *val               = valObj.stringValue;
                        
                        
                        if(!([val isEqualToString:@""] || val == nil) && ([key isEqualToString:@"productfruits"] || [key isEqualToString:@"productstationery"] || [key isEqualToString:@"productvegetables"]) ) {
                            Product *prod = [[Product alloc] init];
                            prod.name = val;
                            prod.section = key;
                            
                            if([key isEqualToString:@"productfruits"]) {
                                prod.price = fruitPrice;
                            } else if([key isEqualToString:@"productvegetables"]) {
                                prod.price = vegPrice;
                            } else if([key isEqualToString:@"productstationery"]) {
                                prod.price = stationaryPrice;
                            }
                            [self updateProduct:intent product:prod];
                            break;
                        }
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


-(void) updateProduct:(NSString*) intent product:(Product*) product{
    
    [self dismissProgress];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i =0; i > _productList.count; i++) {
        [indexSet addIndex:i];
       
    }

    [_productTable removeRowsAtIndexes:indexSet];
    
    if([intent isEqualToString:@"AddProduct"]){
        [_productList addObject:product];
        
    } else {
        [_productList removeObject:product];
        
    }
    
    NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:_productList];
    NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataOnObject, @"product", nil];
    [[WCSession defaultSession] updateApplicationContext:productDict error:nil];
    
    [self configureTable];
}


- (void) showError {
    
        [self dismissProgress];
        WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^(void){
            
        }];
        [self presentAlertControllerWithTitle:@"Error" message:@"We are not able to recogonize" preferredStyle:WKAlertControllerStyleAlert actions:[NSArray arrayWithObjects:act,nil]];
        
    
    
}


// handle success search
-(void) successWithPlaces:(NSArray*) placesList {
    
    NSLog(@" Places array : %@",placesList);
    if ([placesList count] > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:placesList];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:nil];
        
    }
    
    
}

// handle failure search
-(void) didSearchFailWithError:(NSString *) errorMessage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NearestShop" object:nil];
    
}


-(void) loadNearestShop :(NSNotification *)notification{
    
    
    NSArray *arr = (NSArray*) notification.object;
    
    if(arr) {
        [self dismissProgress];
        [self pushControllerWithName:@"MapController" context:arr];
        
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if(_activityInprogress) {
        [_progressGroup setHidden:FALSE];
        [_productTable setHidden:TRUE];
        [_edit setHidden:TRUE];
        [_mapButton setHidden:TRUE];
        [_pleaseWaitAnimation startAnimating];
    } else {
        [_pleaseWaitAnimation stopAnimating];
        [_progressGroup setHidden:TRUE];
        [_productTable setHidden:FALSE];
        [_edit setHidden:FALSE];
        [_mapButton setHidden:FALSE];
    }
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[NSNotificationCenter defaultCenter] removeObserver:@"NearestShop"];
}


-(void) configureTable {
    
    
    [_productTable setNumberOfRows:[_productList count] withRowType:@"ProductRow"];
    
    for (int i = 0; i < [_productList count]; i++) {
        ProductRow *row = [_productTable rowControllerAtIndex:i];
       
        Product *res = (Product*)_productList[i];
        NSString *stringPrice = [res.price stringByAppendingString:@" AED"];
        
        [row.ProductPrice setText:stringPrice];
        
        
        
        NSString *firstChar = [res.name substringToIndex:1];
        
        /* remove any diacritic mark */
        NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
        
        /* create the new string */
        NSString *result = [[folded uppercaseString] stringByAppendingString:[res.name substringFromIndex:1]];
        [row.ProductTitle setText:result];
        
    }
}



-(void) showProgress {
    
    _activityInprogress = TRUE;
    
    [_progressGroup setHidden:FALSE];
    [_productTable setHidden:TRUE];
    [_edit setHidden:TRUE];
    [_mapButton setHidden:TRUE];
    [_pleaseWaitAnimation startAnimating];
    
    
    
}


-(void) dismissProgress {
    _activityInprogress = FALSE;
    
    [_pleaseWaitAnimation stopAnimating];
    [_progressGroup setHidden:TRUE];
    [_productTable setHidden:FALSE];
    [_edit setHidden:FALSE];
    [_mapButton setHidden:FALSE];
    
}



@end



