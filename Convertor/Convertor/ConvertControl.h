//
//  ConvertControl.h
//  Convertor
//
//  Created by Avi Vajpeyi on 2/15/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConvertControl : NSController
{
    //The circle in the gutter is for linking this variable to something in the interface
    IBOutlet id miText; //Data goes here
    IBOutlet id kmText;
    
    IBOutlet id minText;
    IBOutlet id secText;
    
}



- (IBAction)convert:(id)sender; // methods go here



@end
