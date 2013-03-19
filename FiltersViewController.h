//
//  FiltersViewController.h
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FiltersViewController : UIViewController


@property (strong, nonatomic) UIImage *thumbNail;
@property (strong, nonatomic) UIImage *imageFromCameraOrRoll;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int filterInt;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingCircle;

@end
