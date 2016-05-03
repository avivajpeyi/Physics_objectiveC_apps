//
//  lineView.m
//  Line
//
//  Created by Avi on 2/29/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "lineView.h"

@implementation lineView


- (void) awakeFromNib
{
    //We are drawing a bounding rectangle
    NSRect myRect = [self bounds];
    
    // we set height = myRect's size's hight/2
    // This is the height which appears on the screen
    [heightText setDoubleValue: height = myRect.size.height/2];
    
    
    //Initially we are not dragging
    draggingLine = NO;
    
    
    
    // add tracking rect checks when the cursor enters/exits the custom view
    [self addTrackingRect:myRect owner:self userData:nil assumeInside:NO];
    [self addCursorRect:myRect cursor:[NSCursor openHandCursor]]; //de
    
    
    [self reset: self];
    
    
    
}
- (IBAction)reset:(id)sender
{
    //this sets the height of the object to the height on the screen
    height = [heightText doubleValue];
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    
    
    static const NSImage *backImage = [ NSImage imageNamed: @"backgroundImage.jpg"];
    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
    
    [ backImage drawInRect:dirtyRect
                  fromRect:backRect
                 operation:NSCompositeCopy
                  fraction:1.0];
    
    // [ backImage drawInRect:dirtyRect]; doesnt work
    
    
//    
//    [[NSColor cyanColor] set];
//    [NSBezierPath fillRect:dirtyRect];// here we fill screen, or the 'dirty rect' in orange

    
    
    [[NSColor whiteColor] set];
    NSBezierPath *line = [NSBezierPath bezierPath];
    {//the encapsulation is comsmetic
        [line setLineWidth: 3.0];
        [line moveToPoint:NSMakePoint(0, height)];
        [line lineToPoint:NSMakePoint(dirtyRect.size.width, height)];
    }
    
    [line stroke];
    
    
    
    
    // Drawing code here.
}



#pragma mark -
////////////////////////////////////////////////////////////////


-(void)mouseDown:(NSEvent *)theEvent
{
    //need to check if the user has clicked on the line
    
    
    //convert window coord to the clickPoint
    NSPoint clickPoint = [self convertPoint: [theEvent locationInWindow] fromView:nil ];
    
    
    // static lets the thickness be set in a presestiant manner. It lets the halfThickness be defined after being defined onece, even after the activation record for the function is deleted.
    static const short halfThickness = 4;
    static short width = [self bounds].size.width;
    
    NSRect dragRect = NSMakeRect(0, height-halfThickness, width, 2*halfThickness);
    // 0 to down half thickness, go length of width, then go up the thickness. This defines the entire area of the line
    
    draggingLine = [self mouse: clickPoint inRect:dragRect];
    
    
    if (draggingLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    
    
}
-(void)mouseUp:(NSEvent *)theEvent
{
    draggingLine = NO;
    
    
    // frame returns rectangle of the custom view, in the windows referenece
    if ( [self mouse: [theEvent locationInWindow] inRect:[self frame]])
    {
        [[NSCursor openHandCursor] set];
    }
    else // mouse up, oustside custom view
    {
        [ [NSCursor arrowCursor] set];
    }
    
    
    
}
-(void)mouseDragged:(NSEvent *)theEvent
{
    // we get the coord of mouse down IN THE WINDOW OF THE APP
    NSPoint downInWindow= [theEvent locationInWindow];
    
    // we get the coord of the mose WRT the custom view in our window
    NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
    
    
    if (draggingLine == TRUE)
    {
        //NAME SOUND SOMETHING LIKE CrossingSound
        static NSSound *crossSound = [NSSound soundNamed: @"Submarine"];
        if ( height * downInView.y < 0) // beeps when the cursor moves past zero
        {
            [crossSound play];//NSBeep();
        }
        
        
        
        
        [heightText setDoubleValue: height = downInView.y];//we are setting our height text to be where our mose was 'downInView'
        
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }
    
    
    
    
    
    
}




-(void)mouseEntered:(NSEvent *)theEvent
{
    if (draggingLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else // not dragging
    {
        [ [NSCursor openHandCursor] set];
    }
}
-(void)mouseExited:(NSEvent *)theEvent
{
    [ [ NSCursor arrowCursor] set];
}











@end
