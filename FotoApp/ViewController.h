//
//  ViewController.h
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIImage *imageFromCameraOrRoll;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingCircle;
@property (weak, nonatomic) IBOutlet UIImageView *chosenImageView;

@property (nonatomic) int filterInt;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButtonOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *tapToStartOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *blackBoxView;


@property (strong, nonatomic) UIImage *imageWithPaperBackground;

@end
