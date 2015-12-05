//
//  OCR.h
//  SmartShop
//
//  Created by Arun Ramakani on 12/5/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>



@interface OCR : UIViewController <G8TesseractDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageToRecognize;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)openCamera:(id)sender;
- (IBAction)recognizeSampleImage:(id)sender;

@end
