//
//  lineView.h
//  Line
//
//  Created by Avi on 2/29/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface lineView : NSView
{
    IBOutlet id heightText; double height; //Formatted text cell
    
    Boolean draggingLine;
}


-(void)awakeFromNib;
-(void)reset:(id)sender;



-(void)mouseDown:(NSEvent *)theEvent;
-(void)mouseUp:(NSEvent *)theEvent;
-(void)mouseDragged:(NSEvent *)theEvent;


-(void)mouseEntered:(NSEvent *)theEvent;
-(void)mouseExited:(NSEvent *)theEvent;




@end
