//
//  FirstView.h
//  FrstView
//
//  Created by Avi Vajpeyi on 2/15/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FirstView : NSView
{
    
    IBOutlet id colourWell;
    IBOutlet id titleText;
    
    
}


-(IBAction)updateTitle:(id)sender;
-(IBAction)updateColor:(id)sender;



-(void)awakeFromNib;
-(void)initialise;



@end
