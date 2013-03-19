//
//  ViewController.m
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AllFilters.h"
#import "FiltersViewController.h"
#import "ImageCreation.h"
#import "alerts.h"

@interface ViewController (){

    UIImage *finalImage;
    UIImagePickerController *imagePicker;
    AllFilters *allFilters;
    ImageCreation *imgCreation;
    CGSize fullSize; 
    CGSize thumbSize;
}

@end

@implementation ViewController
@synthesize backgroundImageView;
@synthesize cameraButton;
@synthesize imageFromCameraOrRoll;
@synthesize loadingCircle;
@synthesize chosenImageView;
@synthesize filterInt;
@synthesize undoButtonOutlet;
@synthesize bottomView;
@synthesize tapToStartOutlet;
@synthesize blackBoxView;
@synthesize imageWithPaperBackground;


#pragma mark Load methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializer];
    [self isFirstRun];   
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

//Initialiserar och allokerar en massa. 
-(void)initializer{
    allFilters = [[AllFilters alloc]init];
    imgCreation = [[ImageCreation alloc]init];
    imagePicker = [[UIImagePickerController alloc] init];
    [loadingCircle stopAnimating];
    fullSize = CGSizeMake(1800,1800); //Stor bilds dimensioner. 
    thumbSize = CGSizeMake(400,400); //Tumnagels dimesioner
}

-(void)isFirstRun{
    //Om det inte ngn bild är tagen eller importerad. 
    if (imageFromCameraOrRoll == Nil)     
    {
        filterInt = -1; 
        NSString *tapImage = [[NSBundle mainBundle] pathForResource:@"tapToOpenCamera" ofType:@"png"];
        UIImage *tapView = [[UIImage alloc]initWithContentsOfFile:tapImage];
        [self.tapToStartOutlet setImage:tapView];
        self.bottomView.hidden = YES;
        self.blackBoxView.hidden = YES;
    }
    //Om bild finns
    else 
    {
        NSString *tapImage = [[NSBundle mainBundle] pathForResource:@"SaveImage" ofType:@"png"];
        UIImage *filterView = [[UIImage alloc]initWithContentsOfFile:tapImage];
        [self.bottomView setImage:filterView];
        self.tapToStartOutlet.hidden = YES;
        imageWithPaperBackground = [allFilters createBackgroundTextureOnImage:imageFromCameraOrRoll]; //Lägger till bakgrundstextur
        imageWithPaperBackground = [imgCreation addFilter:imageWithPaperBackground filterNumber:filterInt]; //Lägger till valt filter. 
        [self.chosenImageView setImage:imageWithPaperBackground]; //Lägger till filter på bilden
    }
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [self setCameraButton:nil];
    [self setLoadingCircle:nil];
    [self setChosenImageView:nil];
    [self setUndoButtonOutlet:nil];
    [self setTapToStartOutlet:nil];
    [self setBottomView:nil];
    [self setBlackBoxView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark Image Capture Methods
//Om enheten har en kamera så startas den annars så öppnas bildrullen istället. 
-(void) takePicture:(id) sender 
{   //Om kamera finns på enheten. 
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    //Om kamera inte finns
    else 
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

//När bild är skapad/hämtad
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{   picker = nil;
    imageFromCameraOrRoll = [info objectForKey:UIImagePickerControllerOriginalImage]; //Hämtar bilden. 
    imageFromCameraOrRoll = [imgCreation scaleAndCropToSize:fullSize imageToScale:imageFromCameraOrRoll]; //Skalar om bilden
    imageWithPaperBackground = nil;
    [self.chosenImageView setImage:imageFromCameraOrRoll]; //Ritar ut bild på skärm.
    self.tapToStartOutlet.hidden = YES; //Döljer imageview med Tap to start
    NSString *chooseFilterBG = [[NSBundle mainBundle] pathForResource:@"ChooseFilter" ofType:@"png"]; //Bild med meddelande
    UIImage *chooseFilterView = [[UIImage alloc]initWithContentsOfFile:chooseFilterBG]; //Bild med meddelande
    self.bottomView.hidden = NO;
    self.blackBoxView.hidden = NO;
    [self.bottomView setImage:chooseFilterView];
    [self dismissModalViewControllerAnimated:YES];
}

//Öppnar bildrullen
- (IBAction)openPhotoButton:(id)sender {
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentModalViewController:imagePicker animated:YES];
}

//Kameraknapp. Startar kameran. 
- (IBAction)cameraButton:(id)sender {
    [self takePicture:sender];
}


#pragma mark Save Image
//Sparar vald bild. 
- (IBAction)saveImageButton:(id)sender {
    //Om det inte finns någon bild att spara. 
    if (imageFromCameraOrRoll == nil) 
    {
        Alerts *alerts = [[Alerts alloc]init];
        [alerts createAlert:@"NoImageToSave"];
    }
    else 
    {   //Kollar vilken bild som visas och sparar sedan den visade bilden. 
        if (chosenImageView.image == imageFromCameraOrRoll) 
        {
            UIImageWriteToSavedPhotosAlbum(imageFromCameraOrRoll,nil,nil,nil);
        }
        else 
        {
            UIImageWriteToSavedPhotosAlbum(imageWithPaperBackground,nil,nil,nil);
        }
        Alerts *alerts = [[Alerts alloc]init];
        [alerts createAlert:@"ImageSaved"];
    }
}

#pragma mark Reset Image
//Tar bort valt filter och återställer bilden till normaltillstånd. 
- (IBAction)resetImageButton:(id)sender {
    
    if (imageWithPaperBackground == nil) //Om det inte finns någon bild med filter
    {
        Alerts *alerts = [[Alerts alloc]init];
        [alerts createAlert:@"Undo"]; //Felmeddelande
    }
    else 
    {   //Om knappen har texten UNDO
        if ([undoButtonOutlet.title isEqualToString:@"Undo"]) 
        {   
            [loadingCircle startAnimating];
            [undoButtonOutlet setTitle:@"Redo"]; //Ändrar text
            [self.chosenImageView setImage:imageFromCameraOrRoll]; //Visa bild. 
            [loadingCircle stopAnimating];
        }
        else 
        {
            [loadingCircle startAnimating];
            [self.chosenImageView setImage:imageWithPaperBackground];
            [undoButtonOutlet setTitle:@"Undo"];
            [loadingCircle stopAnimating];
        }
    }
}

#pragma mark Choose Filter
//Knapp som kör byter vy. 
- (IBAction)chooseFilterButton:(id)sender {
    if (imageFromCameraOrRoll == Nil) //Om det inte visas ngn bild. 
    {
        Alerts *alerts = [[Alerts alloc]init];
        [alerts createAlert:@"NoImagePresent"];
    }
    else 
    { [loadingCircle startAnimating];
        //Måste tydligen köra delay för att activity indicatorn ska böra snurra. 
        [self performSelector: @selector(pushImageAfterDelay:) 
                   withObject: sender 
                   afterDelay: 0];
    }
}

#pragma mark Segue Methods
//Pushar vy
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Om seguen stämmer så pushas ny vy med bild att lägga filter på.  
    if ([segue.identifier isEqualToString:@"pushImage"]) {
        FiltersViewController *fVC = [segue destinationViewController];
        [fVC setImageFromCameraOrRoll:imageFromCameraOrRoll];
    }
}

-(void)pushImageAfterDelay: (id)sender{

[self performSegueWithIdentifier:@"pushImage" sender:sender]; 
    [loadingCircle stopAnimating];

}

@end
