//
//  KeyView.h
//  keys
//
//  Created by John Lindner on 4/24/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KeyView : NSView
{
    NSPoint center;
    double radius;
}

-(void)awakeFromNib;
-(void)drawRect:(NSRect)dirtyRect;

-(BOOL)acceptsFirstResponder;
-(void)keyDown:(NSEvent *)theEvent;
-(void)keyUp:(NSEvent *)theEvent;

@end
