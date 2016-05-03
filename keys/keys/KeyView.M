//
//  KeyView.m
//  keys
//
//  Created by John Lindner on 4/24/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import "KeyView.h"

@implementation KeyView

- (void)awakeFromNib
{
    NSRect box = [self bounds];
    [self translateOriginToPoint:NSMakePoint(box.size.width/2, box.size.height/2)];
    
    center.x = 0.0;
    center.y = 0.0;
    
    radius = 10.0;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    
    [[NSColor yellowColor] set];
    NSRectFill(NSMakeRect(center.x - radius, center.y - radius, 2 * radius, 2 * radius));
}

- (BOOL)acceptsFirstResponder
{
    return YES;  // to get keyDown and keyUp events
}

- (void)keyDown:(NSEvent *)theEvent
{
    static const double step = 10.0;
    
    unsigned short theKeyCode = [theEvent keyCode];
//    NSLog(@"%i",theKeyCode);
    
    switch (theKeyCode)
    {
        case 2:     case 123:   center.x -= step; break;  // d or <
        case 3:     case 124:   center.x += step; break;  // f or >
        case 38:    case 125:   center.y -= step; break;  // j or v
        case 40:    case 126:   center.y += step; break;  // k or ^
    }
    
//    if ([theEvent modifierFlags] & NSNumericPadKeyMask)// arrow keys have this mask
//    {
//        NSString *characters = [theEvent charactersIgnoringModifiers];
//
//        if ( [characters length] > 0 )
//        {
//            switch ([characters characterAtIndex:0])
//            {
//                case NSLeftArrowFunctionKey:  center.x -= step; break;
//                case NSRightArrowFunctionKey: center.x += step; break;
//                case NSDownArrowFunctionKey:  center.y -= step; break;
//                case NSUpArrowFunctionKey:    center.y += step; break;
//            }
//        }
//    }
    
    [self display];
}

-(void)keyUp:(NSEvent *)theEvent
{
}

@end
