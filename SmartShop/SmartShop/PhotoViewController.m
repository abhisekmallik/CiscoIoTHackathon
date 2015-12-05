//
//  PhotoViewController.m
//  SmartShop
//
//  Created by Abhisek Mallik on 12/5/15.
//  Copyright © 2015 Arun Ramakani. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)choosePhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Photo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Show process button
    if (self.imgPhoto) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Process"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(processWasPressed:)];
        [self.navigationItem setRightBarButtonItem:barButton animated:YES];
        [self.imgPhoto setImage:self.selectedImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processWasPressed:(id)sender
{

    
}

- (IBAction)choosePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}
@end
