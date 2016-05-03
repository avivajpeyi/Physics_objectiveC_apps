//
//  SpringView.m
//  Spring
//
//  Created by John Lindner on 4/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import "SpringView.h"

@implementation SpringView

- (void)awakeFromNib
{
    NSRect box = [self bounds];
    NSPoint center = NSMakePoint(box.size.width/2, box.size.height/2);
    [self translateOriginToPoint:center];
    
    dt = 0.01;
    w2 = 1.0;
    algorithm = @selector(eulerCromer);

    [self reset:self];
    
    [NSThread detachNewThreadSelector:@selector(evolve:)
                             toTarget:self
                           withObject:nil];
}

- (void)algorithmChooser:(id)sender
{
    switch ([sender tag])
    {
        case 0: algorithm = @selector(eulerCromer); break;
        case 1: algorithm = @selector(RK1);         break;
    }
}

- (void)reset:(id)sender
{
    x = 40.0;
    v = 0.0;
    t = 0.0;
    
    [self display];
}

- (void)evolve:(id)object
{
    while (YES)
    {
        for(int n = 0; n < 10; n++)
        {
            [NSApp sendAction:algorithm to:self from:nil];
 //           [self performSelector:algorithm]; // ARC warning
        }
        [self setNeedsDisplay:YES];
        
        [NSThread sleepForTimeInterval:0.003];
    }
}

- (void)eulerCromer
{
    v += a(t, x, v) * dt;
    x += v * dt;
    
    t += dt;
}

- (void)RK1
{
    double dv = a(t, x, v) * dt;
    double dx = v * dt;
    
    v += dv;
    x += dx;
    
    t += dt;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    [[NSColor brownColor] set];
    NSBezierPath *circlePath = [NSBezierPath bezierPath];
    {
        static const double radius = 10.0;
        NSRect box = NSMakeRect(x - radius, v - radius, 2 * radius, 2 * radius);
        [circlePath appendBezierPathWithOvalInRect:box];
    }
    [circlePath fill];
}

@end
