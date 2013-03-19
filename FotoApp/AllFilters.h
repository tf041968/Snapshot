//
//  AllFilters.h
//  FotoApp
//
//  Created by Johan Persson on 2012-06-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllFilters : NSObject

-(NSMutableArray*)allFilters: (UIImage*)image;
-(UIImage*)createBackgroundTextureOnImage: (UIImage*)imageToAddTextureTo;

@end
