//
//  FiltersViewController.m
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FiltersViewController.h"
#import "ViewController.h"
#import "AllFilters.h"
#import "ImageCreation.h"

@interface FiltersViewController (){

    AllFilters *all;
    ImageCreation *imgCreation;
}

@end

@implementation FiltersViewController
@synthesize thumbNail;
@synthesize imageFromCameraOrRoll;
@synthesize buttonCollection;
@synthesize scrollView;
@synthesize filterInt;
@synthesize loadingCircle;


#pragma mark Load Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES]; //Aktiverar scroll
    [scrollView setContentSize:CGSizeMake(320, 660)]; //Skapar scrollstorlek
    all = [[AllFilters alloc]init];
    [self createPreviews];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{

[self.navigationController setToolbarHidden:YES animated:YES];

}

- (void)viewDidUnload
{
    [self setButtonCollection:nil];
    [self setScrollView:nil];
    [self setLoadingCircle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Create Preview Images
//Skapar tumnaglar med de olika filtren applicerade. 
-(void)createPreviews{
    imgCreation = [[ImageCreation alloc]init];
    CGSize thumbSize = CGSizeMake(400,400); //Tumnagels dimesioner
    thumbNail = [imgCreation scaleAndCropToSize:thumbSize imageToScale:imageFromCameraOrRoll]; //Skalar tumnagel
    NSMutableArray *thumbNailArray = [imgCreation createPreviews:thumbNail]; //Skapar arr  med alla filter
    
    //För varje filter som finns.
    //Sätter bakgrundsbild på knapp till filtret i arrayens position. 
    //Sätter knapptag till samma värde som filterposition. 
    for (int i = 0; i < thumbNailArray.count; i++) 
    {
        [[buttonCollection objectAtIndex:i]setBackgroundImage:[thumbNailArray objectAtIndex:i] forState:UIControlStateNormal];
        [[buttonCollection objectAtIndex:i]setTag:i];
    }
}


#pragma mark Segue Methods
//Pushar till ny vy. 
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ViewController *VC = [segue destinationViewController];
    filterInt = [sender tag]; //Int som ger det valda filtrets position i filterarrayen.   
    [VC setImageFromCameraOrRoll:imageFromCameraOrRoll]; //Skickar tillbaka originalbilden. 
    [VC setFilterInt:filterInt]; //Skickar tillbaka filterInten. 
}

//Körs när man klickar på någon av tumnagelknapparna. 
- (IBAction)sendImageToVC:(UIButton *)sender {

    [loadingCircle startAnimating];
    [self performSelector: @selector(pushImageAfterDelay:) 
               withObject: sender 
               afterDelay: 0];  
}

-(void)pushImageAfterDelay: (id)sender{
    
    [self performSegueWithIdentifier:@"pushImageBack" sender:sender];
    [loadingCircle stopAnimating];
}
@end
