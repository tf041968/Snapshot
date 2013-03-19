//
//  ImageCreation.m
//  FotoApp
//
//  Created by Johan Persson on 2012-06-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCreation.h"
#import "AllFilters.h"

@implementation ImageCreation


#pragma mark Scale and Crop Image
//Metod som skalar och croppar bilden. Plockad från webben. 
-(UIImage*) scaleAndCropToSize:(CGSize)newSize imageToScale:(UIImage*)img
{
    float ratio = img.size.width / img.size.height;
    
    UIGraphicsBeginImageContext(newSize);
    
    if (ratio > 1) {
        CGFloat newWidth = ratio * newSize.width;
        CGFloat newHeight = newSize.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [img drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else {
        CGFloat newWidth = newSize.width;
        CGFloat newHeight = newSize.height / ratio;
        CGFloat topMargin = (newHeight - newWidth) / 2;
        [img drawInRect:CGRectMake(0, -topMargin, newSize.width, newSize.height/ratio)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark Set Frame On Image
//Lägger en ram ovanpå bilden. 
-(UIImage*)setFrameOnImage: (UIImage*)imageToFrame
{
    UIImage *frame = [UIImage imageNamed:@"frame.png"]; //Ramen som ska appliceras. 
    CGSize size = CGSizeMake(imageToFrame.size.width, imageToFrame.size.height); //Storleken på bilden. 
    frame = [self scaleAndCropToSize:size imageToScale:frame]; //Skapar en ram i samma storlek som bilden. 
    UIGraphicsBeginImageContext(imageToFrame.size);
    [imageToFrame drawInRect:CGRectMake(0, 0, imageToFrame.size.width, imageToFrame.size.height)];//Skapar storlek på bild
    [frame drawInRect:CGRectMake(imageToFrame.size.width - frame.size.width, imageToFrame.size.height - frame.size.height, frame.size.width, frame.size.height)]; //Skapar storlek på ram. 
    UIImage *imageWithFrame = UIGraphicsGetImageFromCurrentImageContext(); //Slår ihop bilderna. 
    UIGraphicsEndImageContext();
    return imageWithFrame;
}


#pragma mark Create Previews
//Skapar en array av tumnaglar med ramar på. 
-(NSMutableArray*)createPreviews: (UIImage*)thumbNail
{
    AllFilters *allFilters = [[AllFilters alloc]init];
    thumbNail = [allFilters createBackgroundTextureOnImage:thumbNail]; //Tar inkommande bild och lägger på textur. 
    NSMutableArray *thumbNailArr = [[NSMutableArray alloc]init];
    NSMutableArray *filtersArray = [allFilters allFilters:thumbNail]; //Sparar alla filter i en arr. 
    for (int i = 0; i < filtersArray.count ; i++) //Loopar filter-arrayen.  
    {
        CIFilter *currentFilter = [filtersArray objectAtIndex:i]; //Plockar ut filter 
        CIImage *outputImage = [currentFilter outputImage]; //Lägger på filtret på en CIImage
        thumbNail = [UIImage imageWithCIImage:outputImage]; //Gör om CIImage till UIImage.
        thumbNail = [self setFrameOnImage:thumbNail]; //Lägger till ram på tumnageln
        [thumbNailArr addObject:thumbNail]; //Lägger till bild till array
    }
    return thumbNailArr; 
}



#pragma mark Add Filter
//Lägger till filter på bilderna. 
-(UIImage*)addFilter: (UIImage*)fullSizeImage filterNumber:(int)filterInt {
    AllFilters *allFilters = [[AllFilters alloc]init];
    CIFilter *chosenFilter = [[allFilters allFilters:fullSizeImage]objectAtIndex:filterInt]; //Hämtar valt filter
    CIImage *outputImage = [chosenFilter outputImage];
    fullSizeImage = [UIImage imageWithCIImage:outputImage];
    fullSizeImage = [self setFrameOnImage:fullSizeImage]; //Lägger på ram på vald bild med filter. 
    return fullSizeImage;
}

@end
