//
//  WavesView.m
//  WaveOnString
//
//  Created by Avi on 2/22/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "WavesView.h"

@implementation WavesView


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSLog(@"in draw rect");
    
    // Need to include stroke / fill switch statement here
    //update the colors
    
    foreColor = [foreColorWell color];
    backColor = [backColorWell color];
    
    
    
    //filling the foreground and background colors
    [foreColor set];
    [NSBezierPath fillRect:dirtyRect];
    
    [backColor set];
    
    NSBezierPath *string = [NSBezierPath bezierPath];
    {
        [string setLineWidth:[thicknessSlider doubleValue]];
        NSPoint point = {0, yPixel[0][tNow]};
        [string moveToPoint:point];
        
        for (int xPixel = 0 ; xPixel < ViewWidth; xPixel++ )
        {
            NSPoint point = {static_cast<CGFloat>(xPixel), yPixel[xPixel][tNow]};
            [string lineToPoint:point];
        }
    }
    
    switch (style)
    {
        case 0:
            
            [string stroke];
            break;
            
        case 1:
            // Need to make the line to go to the borders
            [string lineToPoint:NSMakePoint(512, -150)];
            // Need to make the line to go to the borders
            [string lineToPoint:NSMakePoint(0, -150)];
            [string fill];
            break;
    }
    
    
    
}

- (void) awakeFromNib
{
    
    NSLog(@"in awake from nib");
    sigma = 0.03;
    init_X_Real_Position = 0.5;
    
    // int tNew, tOld, tNow; DOING THIS IN THE H FILE
    tNew = 0; tNow = 1; tOld = 2;
    
    
    //Following sets the interface defaults to the above values
    [sigmaText setDoubleValue: sigma];
    [init_X_Real_PositionText setDoubleValue: init_X_Real_Position];
    
    
    //Setting the boundaries of the window
    NSRect boundsRect = [self bounds];
    double x = 0;
    double y = boundsRect.size.height / 2;
    [self translateOriginToPoint:NSMakePoint(x, y)];
    
    //Setting Forground and the wave color
    [foreColorWell setColor: foreColor = [NSColor blackColor]];
    [backColorWell setColor: backColor = [NSColor whiteColor]];
    
    
    
    [NSThread detachNewThreadSelector:@selector(animate:)
                             toTarget:self
                           withObject:nil]; // start animation thread
    
    
    [self reset:self];
    
    
    
}

- (void) reset: (id) sender
{
    NSLog(@"in reset");
    
    
    
    sigma = [sigmaText doubleValue];
    init_X_Real_Position = [init_X_Real_PositionText doubleValue];
    
    switch (initialCondition)
    {
        case 0: // one pulse
        {
            for (int xPixel = 0.0 ; xPixel < ViewWidth; xPixel++ )
            {
                double xReal = (xPixel) / ( xPixels_xReal);
                yPixel[xPixel][tNow] = [self yRealAt: xReal ] * yPixels_yReal ;
                xReal = (xPixel - 1) / ( xPixels_xReal);
                yPixel[xPixel][tOld] = [self yRealAt: xReal ] * yPixels_yReal  ;
                
                //  NSLog(@"point = (%d, %lf) and x real %lf ", xPixel, yPixel[xPixel], xReal);
            }
            break;
        }
            
        case 1: // two pulses
        {
            for (int xPixel = 0.0 ; xPixel < ViewWidth; xPixel++ )
            {
                double xReal = xPixel / ( xPixels_xReal);
                yPixel[xPixel][tNow] = [self yRealAt: xReal ] * yPixels_yReal ;
                yPixel[xPixel][tOld] = [self yRealAt: xReal ] * yPixels_yReal ;
                
                //  NSLog(@"point = (%d, %lf) and x real %lf ", xPixel, yPixel[xPixel], xReal);
            }
            break;
        }
            
            
    }
    
    
    
    
    //x [self drawRect];
    [self display];
    
    //Fixed window
    
    
}

-(double)yRealAt: (double) xReal
{
    double ans = exp(-0.5 * pow( ( (xReal -init_X_Real_Position)/sigma), 2)) ;
    
    // NSLog(@"y Real = %lf \n", ans);
    
    return ans;
}

- (void) redraw:(id)sender
{
    
}



- (void)animate:(id)anObject
{
    NSLog(@"in animate");
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
    NSLog(@"in animate step");
    
    
    for (int xPixel = 1; xPixel <= ViewWidth-1; xPixel++)
    {
        yPixel[xPixel][tNew] = -yPixel[xPixel][tOld] + yPixel[xPixel+1][tNow] + yPixel[xPixel-1][tNow];
    }
    
    switch (boundaryCondition)
    {
        case 0://Boundary Conditions for FIXED string
        {
            
            yPixel[0][tNew] = 0;   yPixel[ViewWidth][tNew] = 0;
        }
            
            
            break;
            
        case 1://Boundary Conditions for FREE string
        {
            yPixel[0][tNew] = yPixel[1][tNew];   yPixel[ViewWidth][tNew] = yPixel[ViewWidth-1][tNew];
        }
            break;
            
        case 2://Boundary Conditions for WRAP AROUND string
        {
                                   //     i               i+1                        i-1
            //yPixel[0][tNew] = -yPixel[ViewWidth+1][tOld] + yPixel[ViewWidth+2][tNow] + yPixel[ViewWidth][tNow];
            yPixel[0][tNew] = -yPixel[ViewWidth-1][tOld] + yPixel[ViewWidth][tNow] + yPixel[ViewWidth-2][tNow];
            
            
            yPixel[ViewWidth][tNew] = -yPixel[1][tOld] + yPixel[2][tNow] + yPixel[0][tNow];
        }
            
            break;
            
        case 3://Boundary Conditions for INFINITE string
        {
            yPixel[0][tNew] = yPixel[1][tNow];   yPixel[ViewWidth][tNew] = yPixel[ViewWidth-1][tNow];
        }
            break;
            
    }
    
    
    
    
    
    //Cycling the new, now and old indices
    int temp = tOld;
    tOld = tNow;
    tNow = tNew;
    tNew = temp;
    
    
    
    // [startAngleSlider setDoubleValue: fmod(startAngle += 0.02, 2 * M_PI)];
    [self setNeedsDisplay:YES];
}

// Radio button actions to change fill/stroke
- (IBAction)chageStyle:(id)sender
{
    style = [sender tag];
    [self display];
}
// Radio button actions to change one pulse/ two pulse
- (IBAction)chageInitialCondition:(id)sender
{
    initialCondition = [sender tag];
    [self display];
}
// Radio button actions to change one pulse/ two pulse
- (IBAction)chageBoundaryCondition:(id)sender
{
    boundaryCondition = [sender tag];
    [self display];
}


- (IBAction)update:(id)sender
{
    
}




@end
