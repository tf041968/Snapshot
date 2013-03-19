//
//  Alerts.m
//  FotoApp
//
//  Created by Johan Persson on 2012-07-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Alerts.h"

@implementation Alerts

//Skriver ut meddelande
-(void)createAlert: (NSString*)alert{
    
    if ([alert isEqualToString:@"NoImagePresent"]) //Om ingen bild är vald när man försöker välja filter
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No image present" message:@"You have to take a picture or use one from your camera roll before choosing filter" delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
        [alert show];
    }
    else if ([alert isEqualToString:@"NoImageToSave"]) //Om ingen bild är vald när man försöker spara
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image not saved" message:@"No image to save. Take a picture and try again" delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
        [alert show];
    }
    else if ([alert isEqualToString:@"ImageSaved"]) //När bilden sparas. 
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image saved" message:@"Your image has been saved!" delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
        [alert show];
    }
    else if ([alert isEqualToString:@"Undo"]) //Om ingen bild finns så kan man inte ångra. 
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Nothing to undo" message:@"You have to add a filter before you can undo your action." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
        [alert show];
    }

}

@end
