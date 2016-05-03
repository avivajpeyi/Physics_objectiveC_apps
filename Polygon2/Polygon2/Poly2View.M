//
//  Poly2View.m
//  Polygon2
//
//  Created by John Lindner on 2/23/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import "Poly2View.h"

@implementation Poly2View

- (void)awakeFromNib
{
    NSRect boundsRect = [self bounds];
    double x = boundsRect.size.width / 2;
    double y = boundsRect.size.height / 2;
    [self translateOriginToPoint:NSMakePoint(x, y)];
    
    [NSThread detachNewThreadSelector:@selector(animate:)
                             toTarget:self
                           withObject:nil]; // start animation thread
    
    [self initialize];
}

- (void)initialize
{
    [nSidesSlider setIntValue:nSides = 5];
    [startAngleSlider setDoubleValue:startAngle = 0.0];
    
    [foreColorWell setColor: foreColor = [NSColor blackColor]];
    [backColorWell setColor: backColor = [NSColor orangeColor]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [foreColor set];
    [NSBezierPath fillRect:dirtyRect];
    
    [backColor set];
    NSBezierPath *perimeter = [NSBezierPath bezierPath];
    {
        static const double scale = 100.0;
        double deltaAngle = 2 * M_PI / nSides;
        
        double angle = - startAngle;
        double x = scale * cos(angle);
        double y = scale * sin(angle);
        [perimeter moveToPoint:NSMakePoint(x, y)];
        
        for (int n = 1; n <= nSides; n++)
        {
            double angle = - startAngle + n * deltaAngle;
            double x = scale * cos(angle);
            double y = scale * sin(angle);
            [perimeter lineToPoint:NSMakePoint(x, y)];
        }
    }
    
    switch (style)
    {
        
        case 0:
            [perimeter fill]; break;
        case 1:
            [perimeter stroke]; break;
    }

}

- (void)update:(id)sender
{
    nSides = [nSidesSlider intValue];
    
    foreColor = [foreColorWell color];
    backColor = [backColorWell color];
    
    startAngle = [startAngleSlider doubleValue];
    
    [self display]; // lock focus, drawRect, unlock focus
}

- (void)animate:(id)anObject
{
    while (YES)
    {
        if (not [pauseButton state])
        {
            [self animateStep];
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:[speedSlider doubleValue]]];
    }
}

- (void)animateStep
{
    [startAngleSlider setDoubleValue: fmod(startAngle += 0.02, 2 * M_PI)];
    [self setNeedsDisplay:YES];
}


// Radio button actions
- (IBAction)chageStyle:(id)sender
{
    style = [sender tag];
    [self display];
}

@end
