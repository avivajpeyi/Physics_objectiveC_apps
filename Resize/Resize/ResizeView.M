//
//  ResizeView.m
//  Resize
//
//  Created by Avi on 3/7/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "ResizeView.h"

@implementation ResizeView

- (void) awakeFromNib
{
    [backColorWell setColor:[NSColor yellowColor]];
    [foreColorWell setColor:[NSColor magentaColor]];

    // Any time our window is resized, our view, self, want to do a window resize when
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(WindowResized:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    [self WindowResized:nil];
    
}

-(void)WindowResized:(NSNotification *)notification
{
    // Click on triangle in XIB
    // 'add missing constraints' to set the distances from the interface items to the window, and other elements.
    
    
    NSRect box = [self bounds];
    NSPoint newOrigin = NSMakePoint( -box.size.width/2.0 , -box.size.height/2.0);
    [self setBoundsOrigin: newOrigin];


    // TO SET MINIMUM SIZE OF WINDOW:
    // click on window
    // click on attributes
    // click on the check box 'minimum'

}





- (void)update:(id)sender
{
    [self setNeedsDisplay:YES]; // invokes draw rect
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Colors the dirty rect with a color defined by back color.
    [[backColorWell color] set];
    [NSBezierPath fillRect:dirtyRect];
    
    
    [ [foreColorWell color] set];
    static const double radius = 50.0;
    static const double diameter = 2 * radius;
    // a rectange at (-r, -r) of side length diameter
    NSRect diskBox = NSMakeRect(-radius, -radius, diameter, diameter);
    // Bezier path that is inscribed in the square
    [[NSBezierPath bezierPathWithOvalInRect:diskBox] fill];
    
    
    
}

@end
