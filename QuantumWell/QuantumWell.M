//
//  QuantumWell.m
//  QuantumWell
//
//  Created by Avi on 2/29/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "QuantumWell.h"

@implementation QuantumWell




- (void) awakeFromNib
{
    
    
    
    //We are drawing a bounding rectangle
    NSRect myRect = [self bounds];
    
    // we set energy = myRect's size's hight/2
    // This is the energy which appears on the screen
    [EnergyText setDoubleValue: energy = 0.003];
    [VLeftText setDoubleValue: VLeft = 0.004];
    [VCenterText setDoubleValue: VCenter = 0.001];
    [VRightText setDoubleValue: VRight = 0.004];
    [PsiScaleText setDoubleValue: psiScale = 50];
    [xLeftText setDoubleValue: xLeft = 150];
    [xRightText setDoubleValue: xRight = xWidth - xLeft];
    
    //Initially we are not dragging
    energyLine = NO;
    VLeftLine = NO;
    VCenterLine = NO;
    VRightLine = NO;
    PsiLine = NO;
    xLeftLine = NO;
    xRightLine = NO;
    
    
    
    // add tracking rect checks when the cursor enters/exits the custom view
    [self addTrackingRect:myRect owner:self userData:nil assumeInside:NO];
    [self addCursorRect:myRect cursor:[NSCursor openHandCursor]];
    
    
    
    //------------------INITIALISATIONS---------------//
    
    
    VLeft = 0.004;
    VCenter = 0.001;
    VRight = 0.004;
    energy = 0.003;
    
    xLeft = 150;
    xRight = xWidth - xLeft;
    
    
    
    energyScale = 100000.0; // 100 000
    psiScale = 50;
    
    
    numDxPerPixel = 10;
    dx = 1.0 / numDxPerPixel;
    dx2 = dx*dx;
    
    xStart = 0;
    
    [self reset: self];
    
    
    
}






- (IBAction)reset:(id)sender
{
    //this sets the energy of the object to the energy on the screen
    energy = [EnergyText doubleValue];
    VLeft = [VLeftText doubleValue];
    VRight = [VRightText doubleValue];
    VCenter = [VCenterText doubleValue];
    psiScale = [PsiScaleText doubleValue];
    xLeft = [xLeftText doubleValue];
    xRight = [xRightText doubleValue];
    
    [self computePsi];
    
    
      NSLog(@"In reset");
    
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    
    static const NSImage *backImage = [ NSImage imageNamed: @"background"];
    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
    
    [ backImage drawInRect:dirtyRect
                  fromRect:backRect
                 operation:NSCompositeCopy
                  fraction:1.0];

    
//    
//    [[NSColor cyanColor] set];
//    [NSBezierPath fillRect:dirtyRect];// here we fill screen, or the 'dirty rect' in orange
    
    [[NSColor whiteColor] set];
    NSBezierPath *energy_line = [NSBezierPath bezierPath];
    {//the encapsulation is comsmetic
        [energy_line setLineWidth: 3.0];
        [energy_line moveToPoint:NSMakePoint(0, energy*energyScale)];
        [energy_line lineToPoint:NSMakePoint(dirtyRect.size.width, energy*energyScale)];
    }
    
    [energy_line stroke];
    
    
    [[NSColor blackColor] set];
    NSBezierPath *potential_line = [NSBezierPath bezierPath];
    {//the encapsulation is comsmetic
        [potential_line setLineWidth: 3.0];
        [potential_line moveToPoint:NSMakePoint(0, VLeft*energyScale)];
        [potential_line lineToPoint:NSMakePoint(xLeft, VLeft*energyScale)];
        [potential_line lineToPoint:NSMakePoint(xLeft, VCenter*energyScale)];
        [potential_line lineToPoint:NSMakePoint(xRight, VCenter*energyScale)];
        [potential_line lineToPoint:NSMakePoint(xRight, VRight*energyScale)];
        [potential_line lineToPoint:NSMakePoint(dirtyRect.size.width, VRight*energyScale)];
        
    }
    
    [potential_line stroke];

    
    
    
    [[NSColor greenColor] set];
    NSBezierPath *psi_line = [NSBezierPath bezierPath];
    
    //NOTE - we are shifting phi up by E
    {//the encapsulation is comsmetic
        [psi_line setLineWidth: 3.0];
        [psi_line moveToPoint:NSMakePoint(0, psi[0]*psiScale + energy*energyScale)];
        for( int i = 1; i < xWidth ; i ++)
        {
            [psi_line lineToPoint:NSMakePoint(i, psi[i]*psiScale + energy*energyScale)];
        }
        
    }
    
    [psi_line stroke];

    
      NSLog(@"In Draw Rect");
    

}




#pragma mark -
////////////////////////////////////////////////////////////////


-(void)mouseDown:(NSEvent *)theEvent
{
    
    //convert window coord to the clickPoint
    NSPoint clickPoint = [self convertPoint: [theEvent locationInWindow] fromView:nil ];
    
    
    // static lets the thickness be set in a presestiant manner. It lets the halfThickness be defined after being defined onece, even after the activation record for the function is deleted.
    static const short halfThickness = 6;
    static short width = [self bounds].size.width;
    
    
    // ENERGY LINE
    NSRect dragRectEnergy = NSMakeRect(0, energy*energyScale-halfThickness, width, 2*halfThickness);
    energyLine = [self mouse: clickPoint inRect:dragRectEnergy];
    
    // POTENTIAL LEFT LINE
    NSRect dragRectLeftPotential = NSMakeRect(0, VLeft*energyScale-halfThickness, xLeft, 2*halfThickness);
    VLeftLine = [self mouse: clickPoint inRect:dragRectLeftPotential];
    
    // POTENTIAL CENTER LINE
    NSRect dragRectCenterPotential = NSMakeRect(xLeft, VCenter*energyScale-halfThickness, xRight, 2*halfThickness);
    VCenterLine = [self mouse: clickPoint inRect:dragRectCenterPotential];
    
    // POTENTIAL RIGHT LINE
    NSRect dragRectRightPotential = NSMakeRect(xRight, VRight*energyScale-halfThickness, width - xRight, 2*halfThickness);
    VRightLine = [self mouse: clickPoint inRect:dragRectRightPotential];
    
    // PSI LINE
    int clickXCoord = clickPoint.x;
    double psiY =psiScale*psi[clickXCoord] +energy*energyScale;
    NSRect dragPsi = NSMakeRect(clickXCoord, psiY-halfThickness, clickXCoord, 2*halfThickness);
    PsiLine = [self mouse: clickPoint inRect:dragPsi];
    
    // X Left LINE
    NSRect dragXLeft = NSMakeRect(xLeft-1, VCenter*energyScale, 2*halfThickness, VLeft*energyScale);
    xLeftLine = [self mouse: clickPoint inRect:dragXLeft];

    // X Right LINE
    NSRect dragXRight = NSMakeRect(xRight-1, VCenter*energyScale, 2*halfThickness, VRight*energyScale);
    xRightLine = [self mouse: clickPoint inRect:dragXRight];

    
    

    
//    
//    NSLog(@"Click Point : %lf", clickYCoord);
//    NSLog(@"Psi y Point : %lf", psiY);
   

    
    
    if (PsiLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (energyLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (VLeftLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (VCenterLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (VRightLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (xLeftLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    else if (xRightLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }

    else //If nothing is selected
    {
        [ [NSCursor openHandCursor] set];
    }
    
}


-(void)mouseUp:(NSEvent *)theEvent
{
    // frame returns rectangle of the custom view, in the windows referenece
    if ( [self mouse: [theEvent locationInWindow] inRect:[self frame]])
    {
        [[NSCursor openHandCursor] set];
    }
    else // mouse up, oustside custom view
    {
        [ [NSCursor arrowCursor] set];
    }
    
    energyLine = NO;
    VLeftLine = NO;
    VCenterLine = NO;
    VRightLine = NO;
    PsiLine = NO;
    xLeftLine = NO;
    xRightLine = NO;
    
    
    
    
    
}



-(void)mouseDragged:(NSEvent *)theEvent
{
    // we get the coord of mouse down IN THE WINDOW OF THE APP
    NSPoint downInWindow= [theEvent locationInWindow];
    
    // we get the coord of the mose WRT the custom view in our window
    NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
    
    

    // Set Cross sound to be a sound
    static NSSound *crossSound = [NSSound soundNamed: @"sound"];


    double currentLastPsi = lastPsi;
    
    //psi[int(inWindow.x)]
    
  //  psiPixels = psiScale * ps[n] + energy * energy scale;
    
    
    if (PsiLine == true)
    {
        int xCoordInWindow = downInView.x;
        [PsiScaleText setDoubleValue: psiScale = (downInView.y - energy*energyScale)/ psi[xCoordInWindow]];//we are setting our height text to be where our mose was 'downInView'
        
    //    [PsiScaleText setDoubleValue: psiScale = psi];//we are setting our height text to be where our mose was 'downInView'

        
        // [Psi]
        
        [self computePsi];
        // if (currentLastPsi * lastPsi < 0) NSBeep();
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }

    else if (energyLine == TRUE)
    {
        
        
        [EnergyText setDoubleValue: energy = downInView.y / energyScale];//we are setting our height text to be where our mose was 'downInView'
        
        
        [self computePsi];
        
      //  if (currentLastPsi * lastPsi < 0) [crossSound play];;
        
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }
    else if (VLeftLine == true)
    {
        [VLeftText setDoubleValue: VLeft = downInView.y / energyScale];//we are setting our height text to be where our mose was 'downInView'
        
        [self computePsi];
     //   if (currentLastPsi * lastPsi < 0) NSBeep();
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }
    else if (VCenterLine == true)
    {
        [VCenterText setDoubleValue: VCenter = downInView.y / energyScale];//we are setting our height text to be where our mose was 'downInView'
        
        [self computePsi];
     //   if (currentLastPsi * lastPsi < 0) NSBeep();
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }
    else if (VRightLine == true)
    {
        [VRightText setDoubleValue: VRight = downInView.y / energyScale];//we are setting our height text to be where our mose was 'downInView'
        
        [self computePsi];
     //   if (currentLastPsi * lastPsi < 0) NSBeep();
        
        [ [NSCursor closedHandCursor] set];
        
        [self setNeedsDisplay:YES];
    }
    else if (xLeftLine == true)
    {
        [xLeftText setDoubleValue: xLeft = downInView.x ];   [self computePsi];
        [ [NSCursor closedHandCursor] set];
        [self setNeedsDisplay:YES];
    }
    else if (xRightLine == true)
    {
        [xRightText setDoubleValue: xRight = downInView.x ];   [self computePsi];
        [ [NSCursor closedHandCursor] set];
        [self setNeedsDisplay:YES];
    }
    
    if (currentLastPsi * lastPsi < 0)   [crossSound play];

  NSLog(@"In dragging");

    
}



-(void)mouseEntered:(NSEvent *)theEvent
{
    
    NSLog(@"enter");
    
    [ [NSCursor openHandCursor] set];

    
    if ( (energyLine || VCenterLine || VLeftLine || VRightLine || PsiLine || xLeftLine || xRightLine) == true)
    {
        [ [NSCursor closedHandCursor] set];
    }

    
}

-(void)mouseExited:(NSEvent *)theEvent
{
    
    NSLog(@"exit");
        [ [ NSCursor arrowCursor] set];
}




#pragma mark -
////////////////////////////////////////////////////////////////



-(void)computePsi
{
    
    double psi_ , psi_dx, psi_2dx;
    
    psi_ = 0; psi_dx = 0; psi_2dx = 0;
    
    double kappa = 0;
    
    double alpha = 0;
    
    double norm = 0;
    

    
    if ( energy < VLeft) // then solution is -alph sqr psi
    {
        
        kappa = sqrt  ( VLeft - energy );
        
        norm = exp (kappa * xLeft);
        
        psi_2dx = exp ( kappa * ( -2 * dx) ) / norm;
        
        psi_dx  = exp ( kappa * (  -dx )) / norm;
        
        psi_ = exp(0) / norm;

        
        
    }
    else if ( energy > VLeft) // then solution is kappa sqr psi
    {
        alpha = sqrt ( energy - VLeft );
        
        
        psi_2dx = cos ( alpha * ( 2 * -dx) ) ;
        
        psi_dx  = cos ( alpha * (  -dx )) ;
        
        psi_ = cos (0);
    }
    
    double x = xStart;
    
    
    
    
    
    for ( int num = 0; num <= xWidth ; num ++)
    {
        
        for ( int countDx = 0 ; countDx < numDxPerPixel; countDx++)
        {
            psi_ =  2* psi_dx - psi_2dx - dx2 *  (energy - V(x-dx))  * psi_dx;
            
            psi_2dx = psi_dx;
            psi_dx = psi_;
            
            
            x += dx;
            
            
            
        }
        

        
        psi[num] = psi_;
        
    }
    
    lastPsi = psi[xWidth];
}





@end