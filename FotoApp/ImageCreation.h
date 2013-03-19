//
//  ImageCreation.h
//  FotoApp
//
//  Created by Johan Persson on 2012-06-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCreation : NSObject
-(UIImage*) scaleAndCropToSize:(CGSize)newSize imageToScale:(UIImage*)self;
-(UIImage*)setFrameOnImage: (UIImage*)imageToFrame; 
-(NSMutableArray*)createPreviews: (UIImage*)thumbNail;
-(UIImage*)addFilter: (UIImage*)fullSizeImage filterNumber:(int)filterInt;

@end
