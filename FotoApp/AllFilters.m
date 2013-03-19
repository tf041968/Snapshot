//
//  AllFilters.m
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllFilters.h"
#import "ImageCreation.h"

@implementation AllFilters{

    NSMutableArray *filters;

}

//Array som håller alla filter. 
-(NSMutableArray*)allFilters: (UIImage*)image{

    CIImage *filterPreviewImage = [[CIImage alloc] initWithImage:image]; 

    //FILTER 1 - SEPIA
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,filterPreviewImage,
                         @"inputIntensity",[NSNumber numberWithFloat:1.0],nil];

    //FILTER 2 - COLOR MONOCHROME
    CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,filterPreviewImage,
                             @"inputColor",[CIColor colorWithString:@"Red"],
                             @"inputIntensity",[NSNumber numberWithFloat:0.5], nil];
    //FILTER 3 - VIBRANCE
    CIFilter *vibrance = [CIFilter filterWithName:@"CIVibrance" keysAndValues:kCIInputImageKey,filterPreviewImage,
                             @"inputAmount",[NSNumber numberWithFloat:0.8], nil];

    //FILTER 4 - COLOR CONTROL
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,filterPreviewImage,
                                 @"inputSaturation",[NSNumber numberWithFloat:1.0],
                                 @"inputContrast",[NSNumber numberWithFloat:2.2],
                                @"inputBrightness",[NSNumber numberWithFloat:0.5], nil];
    
    
    //FILTER 5 - INVERT
    CIFilter *invert = [CIFilter filterWithName:@"CIColorInvert" keysAndValues:kCIInputImageKey,filterPreviewImage,
                         nil];
    
    //FILTER 6 - FALSE COLOR
    CIFilter *falseColor = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:kCIInputImageKey,filterPreviewImage,
                         @"inputColor0",[CIColor colorWithRed:0.75 green:0.63 blue:0.46],
                         @"inputColor1",[CIColor colorWithRed:0.70 green:0.70 blue:0.88]
                                         , nil];

    
    //FILTER 7 - EXPOSURE ADJUST
    CIFilter *exposureAdjust = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey,filterPreviewImage,
                           @"inputEV",[NSNumber numberWithFloat:2.0],
                                                      nil];
 
    //FILTER 8 - HIGHLIGHT & SHADOW ADJUST
    CIFilter *highlightShadowAdjust = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey,filterPreviewImage,
                                @"inputHighlightAmount",[NSNumber numberWithFloat:0.2],
                                       @"inputShadowAmount",[NSNumber numberWithFloat:0.5],
                                       nil];
    
        
filters = [[NSMutableArray alloc] init];
    [filters addObject:sepia];
    [filters addObject:colorMonochrome];
    [filters addObject:vibrance];
    [filters addObject:colorControls];
    [filters addObject:invert];
    [filters addObject:falseColor];
    [filters addObject:exposureAdjust];
    [filters addObject:highlightShadowAdjust];
    return filters;
}

//Skapar textur och lägger på den på bild. 
-(UIImage*)createBackgroundTextureOnImage: (UIImage*)imageToAddTextureTo
{
    ImageCreation *imgCreation = [[ImageCreation alloc]init];
    CIImage *imageToAddTextureToCI = [[CIImage alloc] initWithImage:imageToAddTextureTo]; //CIImage av UIImage
    NSString *texture = [[NSBundle mainBundle] pathForResource:@"Combo3" ofType:@"jpg"]; //Texturbild
    UIImage *textureUI = [[UIImage alloc]initWithContentsOfFile:texture]; //Texture som UIImage
    CGSize size = CGSizeMake(imageToAddTextureTo.size.width, imageToAddTextureTo.size.height); //Storlek på textur
    textureUI = [imgCreation scaleAndCropToSize:size imageToScale:textureUI]; //Skalar texturen till rätt format
    CIImage *textureCI = [[CIImage alloc]initWithImage:textureUI]; //Textur som CIImage
    CIFilter *CIColorDodgeBlendMode = [CIFilter filterWithName:@"CIColorDodgeBlendMode" keysAndValues:kCIInputImageKey,textureCI,kCIInputBackgroundImageKey, imageToAddTextureToCI, nil]; //Filter 
    CIImage *outputImage = [CIColorDodgeBlendMode outputImage]; //Filter output
    imageToAddTextureTo = [UIImage imageWithCIImage:outputImage]; //Bild med textur som UIImage
    imageToAddTextureTo = [imgCreation setFrameOnImage:imageToAddTextureTo]; //Skapa ram på bilden. 
    
    return imageToAddTextureTo;
}

@end
