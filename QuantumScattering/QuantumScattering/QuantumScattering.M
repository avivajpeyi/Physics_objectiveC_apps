/////////////////////////////////////////////////////////////////////////////////////////////////
/////
#import "QuantumScattering.h"                                                               /////
/////



/// update - set needs display method IBAction


@implementation QuantumScattering

-(void)awakeFromNib
{
    
   // NSLog(@"awake from nib");
    
    
    
    
    [self initialisations];
    //------------------- Resize our window  ----------------------------------------
    
    
    // Any time our window is resized, our view, self, want to do a window resize when
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(WindowResized:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    [self WindowResized:nil];
    //-----------------------------------------------------------------------------
    
    
    
    //    //---- Animate
        [NSThread detachNewThreadSelector:@selector(animate:)
                                 toTarget:self
                               withObject:nil]; // start animation thread
    
    
    
    // add tracking rect checks when the cursor enters/exits the custom view
    NSRect myRect = [self bounds];
    [self addTrackingRect:myRect owner:self userData:nil assumeInside:NO];
    [self addCursorRect:myRect cursor:[NSCursor openHandCursor]];
    
    
    
    
    [self reset:self];
}

- (void)initialisations
{
 //   NSLog(@"initialisations");
    dt_dx2 = 0.1;
    dx = 0.001;
    dt = dt_dx2 * dx* dx;
    
    psi2Scaling = 250.00;
    potentialScaling = 0.0015;
    
    [ScalingSlider setDoubleValue: potentialScaling = 0.0015];
    
    [psi2ScalingSlider setDoubleValue: psi2Scaling = 250.00];
    
    //    vLeft = 0.0;
    //    vCenter = 25000;
    //    vRight = 0.0;
    
    [vLeftText setDoubleValue: vLeft = 0.0];
    [vCenterText setDoubleValue: vCenter = 25000.0];
    [vRightText setDoubleValue: vRight = 0.0];
    [xLeftText setDoubleValue:xLeft  = 0.49* N_UNIVERSE * dx];         // in meters]
    [xRightText setDoubleValue:xRight = 0.51 * N_UNIVERSE * dx];        // in meters]
    
    NSLog(@"xLeft %lf, xRight %lf", xLeft/dx, xRight/dx);
    
    
    for (int i = 0; i <= xLeft/dx; i++)
    {
        potential[i] = vLeft;
    }
    for (int i = xLeft/dx+1 ; i <= xRight/dx; i++)
    {
        potential[i] = vCenter;
    }
    for (int i = xRight/dx+1 ; i <= N_UNIVERSE-1; i++)
    {
        potential[i] = vRight;
    }
    

    
    
    //    initialPosition = 0.5 * N_UNIVERSE * dx;
    //    initialEnergy = 25000;
    //    initialSigma = 0.005;
    
    [initPosText setDoubleValue: initialPosition = 0.4 * N_UNIVERSE * dx];
    [initEnergyTex setDoubleValue: initialEnergy = 25000];
    [initSigText setDoubleValue: initialSigma = 0.05];
    
    
    //  [initPosText setDoubleValue: initialPosition]
    
    [backColorWell setColor: backColor = [NSColor yellowColor]];
    [foreColorWell setColor:foreColor = [NSColor blackColor]];
    [psiColorWell setColor: psiColor = [NSColor orangeColor]];
    
    
    xLeftDragging = false;
    xRightDragging = false;
    vCenterDragging = false;
    vRightDragging = false;
    vLeftDragging = false;
    energyDragging = false;
    
    
    
    
    //[string setLineWidth:[thicknessSlider doubleValue]];
    
}

-(void)reset:(id)sender
{
 //   NSLog(@"REset");
    //IN CASE USER CHANGES THE VALUES
    initialPosition    = [initPosText doubleValue];
    initialSigma = [initSigText doubleValue];
    initialEnergy = [initEnergyTex doubleValue];
    vLeft = [vLeftText doubleValue];
    vCenter = [vCenterText doubleValue];
    vRight = [vRightText doubleValue];
    xRight = [xRightText doubleValue];
    xLeft = [xLeftText doubleValue];
    psi2Scaling = [psi2ScalingSlider doubleValue];
    backColor = [backColorWell color];
    foreColor = [foreColorWell color];
    psiColor  = [psiColorWell color];
    xLeftDragging = false;
    xRightDragging = false;
    vCenterDragging = false;
    vRightDragging = false;
    vLeftDragging = false;
    energyDragging = false;
    
    for (int i = 0; i <= xLeft/dx; i++)
    {
        potential[i] = vLeft;
    }
    for (int i = xLeft/dx+1 ; i <= xRight/dx; i++)
    {
        potential[i] = vCenter;
    }
    for (int i = xRight/dx+1 ; i <= N_UNIVERSE-1; i++)
    {
        potential[i] = vRight;
    }
    
    for (int i =0; i <N_UNIVERSE; i++)
    {

      //  NSLog(@"val %lf at %d", potential[i], i);
        
    }
    
    
    t_old = 0;
    t_now = 1;
    t_new = 2;
    
    for (int xPix = 0; xPix < N_UNIVERSE; xPix++)
    {
        psi[xPix][t_old] = [self initWavePacketAtT: -dt  andX: xPix*dx];
        psi[xPix][t_now] = [self initWavePacketAtT:   0  andX: xPix*dx];
       // psi[xPix][t_new] = [self initWavePacketAtT: +dt  andX: xPix*dx];
        
        //        NSLog(@"psi %lf , %lf\n", psi[xReal][t_old].real, psi[xReal][t_old].imaginary);
        //        NSLog(@"psi %lf , %lf\n", psi[xReal][t_now].real, psi[xReal][t_old].imaginary);
        //        NSLog(@"psi %lf , %lf\n", psi[xReal][t_new].real, psi[xReal][t_old].imaginary);
        
    }
    
    
    
    [self setNeedsDisplay:YES];
    
    
    
    
    
}

-(void)WindowResized:(NSNotification *)notification
{
    // ------------------------------------
    //   Pre:  None
    //   Post: Updates nStart, stop, etc
    //------------------------------------
    
    // Click on triangle in XIB
    // 'add missing constraints' to set the distances from the interface items to the window, and other elements.
    
    NSRect box = [self bounds];
    nSystem = box.size.width;
    
    // change the origin to a higher y position
    NSPoint newOrigin = NSMakePoint( 0 , -box.size.height/3.0);
    [self setBoundsOrigin: newOrigin];
    
    // TO SET MINIMUM SIZE OF WINDOW:
    // click on window
    // click on attributes
    // click on the check box 'minimum'
    
    nStart = (int) round ( (N_UNIVERSE - nSystem) / 2.0);
    nStop  = (int) round ( (N_UNIVERSE + nSystem) / 2.0);
    [self setNeedsDisplay:YES]; // invokes draw rect
}

- (complex)initWavePacketAtT:(double)t andX:(double)x
{
    double magnitudePsi = exp (- SQR( x - initialPosition) / (2* SQR(initialSigma)));
    
    double initialMomentum = sqrt(initialEnergy);
    
    double phi = (initialMomentum * x) - (initialEnergy * t);
    
    complex psiStart = { magnitudePsi * cos (phi), magnitudePsi * sin(phi)};
    
    return psiStart;
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSRect box = [self bounds];
    
    
  //  NSLog(@"drawing");
    // Colors the dirty rect with a color defined by back color.
    [[backColorWell color] set];
    [NSBezierPath fillRect:dirtyRect];
    
    ////////// DRAWING ENERGY
    if ([drawEnergyLine state] )
    {
        //Drawing energy
        [ [NSColor blueColor] set];
        NSBezierPath *energy_line = [NSBezierPath bezierPath];
        {
            [energy_line setLineWidth: 3.0];
            [energy_line moveToPoint:NSMakePoint ( nStart    - nStart, initialEnergy*potentialScaling)];
            [energy_line lineToPoint:NSMakePoint ( nStop  - nStart, initialEnergy*potentialScaling)];
            
        }
        [energy_line stroke];
        
    }
    
    ///////// DRAWING POTENTIAL
    [ [foreColorWell color] set];
    NSBezierPath *potential_line = [NSBezierPath bezierPath];
    
    switch (potentialDrawingStyle)
    {
        case 0:
        {// FOR Fill
            {
                //          0.....up 0.........nStart....xLeft....xRight...nStop...downNstop...00
                [potential_line setLineWidth: 3.0];
                [potential_line moveToPoint:NSMakePoint(0, -box.size.height/3.0)];
                [potential_line lineToPoint:NSMakePoint ( nStart    - nStart, vLeft*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xLeft/dx  - nStart, vLeft*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xLeft/dx  - nStart, vCenter*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xRight/dx - nStart, vCenter*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xRight/dx - nStart, vRight*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( nStop     - nStart, vRight*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( nStop     - nStart, -box.size.height/3.0)];
                [potential_line lineToPoint:NSMakePoint ( 0, -box.size.height/3.0)];
                
                
                
            }
            [potential_line fill];}
            break;
            
        case 1:
        {
            
            
            
            // FOR STROKE
            {
                
                //          0.........nStart....xLeft....xRight...nStop....N_UNIVERSE
                
                // FOR STROKE
                
                [potential_line setLineWidth: 3.0];
                [potential_line moveToPoint:NSMakePoint ( nStart    - nStart, vLeft*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xLeft/dx  - nStart, vLeft*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xLeft/dx  - nStart, vCenter*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xRight/dx - nStart, vCenter*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( xRight/dx - nStart, vRight*potentialScaling)];
                [potential_line lineToPoint:NSMakePoint ( nStop     - nStart, vRight*potentialScaling)];
                
            }
            [potential_line stroke];
            
        }
            break;
    }
    
    
    
    
    
    ////// DRAWING PSI
    
    switch (potentialDrawingStyle)
    {
        case 0: // for fill
        {
            [ [psiColorWell color] set];
            NSBezierPath *psi_line = [NSBezierPath bezierPath];
            {
                [psi_line setLineWidth: 3.0];
                
                double psiMag2 = SQR(psi[nStart][t_now].real) + SQR(psi[nStart][t_now].imaginary);
                
                
                [psi_line moveToPoint:NSMakePoint ( 0, -[self bounds].size.height/3.0)];
                
                
                [psi_line lineToPoint:NSMakePoint ( 0, psiMag2*psi2Scaling)];
                
                for ( int xPix = nStart+1; xPix < nStop; xPix++)
                {
                    double psiMag2 = SQR(psi[xPix][t_now].real) + SQR(psi[xPix][t_now].imaginary);
                    [psi_line lineToPoint:NSMakePoint ( xPix - nStart, psiMag2*psi2Scaling)];
                    
                    //NSLog(@"Psi Mag 2 = %lf ", psiMag2*psi2Scaling);
                }
                
                [psi_line lineToPoint:NSMakePoint ( nStop, -[self bounds].size.height/3.0)];
                
                [psi_line lineToPoint:NSMakePoint ( 0 , -[self bounds].size.height/3.0)];
                
                
            }
            [psi_line fill];

        }
            break;
            
        case 1: // for stroke
        {
            [ [psiColorWell color] set];
            NSBezierPath *psi_line = [NSBezierPath bezierPath];
            {
                [psi_line setLineWidth: 3.0];
                
                double psiMag2 = SQR(psi[nStart][t_now].real) + SQR(psi[nStart][t_now].imaginary);
                
                [psi_line moveToPoint:NSMakePoint ( 0, psiMag2*psi2Scaling)];
                
                for ( int xPix = nStart+1; xPix < nStop; xPix++)
                {
                    double psiMag2 = SQR(psi[xPix][t_now].real) + SQR(psi[xPix][t_now].imaginary);
                    [psi_line lineToPoint:NSMakePoint ( xPix - nStart, psiMag2*psi2Scaling)];
                    
                    //NSLog(@"Psi Mag 2 = %lf ", psiMag2*psi2Scaling);
                }
                
            }
            [psi_line stroke];

        }
            break;
    
        
    }
}


- (void)animate:(id)anObject
{
   // NSLog(@"in animate");
    while (YES)
    {
        if (not [pauseButton state])
        {
            [self animateStep];
            [self setNeedsDisplay:YES];
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:  [speedSlider doubleValue] ]];
     //   NSLog(@"speed slider %lf", [speedSlider doubleValue] );
    
    }
}

- (void)animateStep
{
  //  NSLog(@"in animate step");
    
    
    for (int xPixel = 1; xPixel < N_UNIVERSE-1; xPixel++)
    {
        int x = xPixel ;
        
        
        // chunk them into seperate stuff
        
        complex secondTerm = {
                               (psi[x-1][t_now].real       - 2*psi[x][t_now].real      + psi[x+1][t_now].real),
                               (psi[x-1][t_now].imaginary  - 2*psi[x][t_now].imaginary + psi[x+1][t_now].imaginary)
                             };
        complex thirdTerm ={
                                2*dt* potential[x] * psi[x][t_now].real,
                                2*dt* potential[x] * psi[x][t_now].imaginary
                           };
        psi[x][t_new].real = psi[x][t_old].real - ( (2*dt_dx2) * secondTerm.imaginary) + thirdTerm.imaginary;
        psi[x][t_new].imaginary = psi[x][t_old].imaginary + ( (2*dt_dx2) * secondTerm.real) - thirdTerm.real ;

    
    }
    
    
    
    
    
    /*
     Sure, you need to have an if statement in, computer psi that checks if the value of the wave at 0 or not universe is greater than a value close to zero, if it is, have it call the reset function
     
     */
    
    
    
    //Cycling the new, now and old indices
    int temp = t_old;
    t_old = t_now;
    t_now = t_new;
    t_new = temp;
    
    
    
    double start = [self Magnitude: psi[1] ];
    double end = [self Magnitude: psi[N_UNIVERSE - 1] ];

    
    //NSLog(@"start %lf", start);
    
    if ( start > 0.0001 || end > 0.0001 )
    {  //NSLog(@"reset wave");
        [self reset:self];
        
    }

    
    // [startAngleSlider setDoubleValue: fmod(startAngle += 0.02, 2 * M_PI)];

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
    
    
    
    // ENERGY LINE
    NSRect dragRectEnergy = NSMakeRect(0, initialEnergy*potentialScaling-halfThickness, width, 2*halfThickness);
    energyDragging = [self mouse: clickPoint inRect:dragRectEnergy];
    
    // POTENTIAL LEFT LINE
    NSRect dragRectLeftPotential = NSMakeRect(0, vLeft*potentialScaling - halfThickness, (xLeft/dx - nStart), 2*halfThickness);
    vLeftDragging = [self mouse: clickPoint inRect:dragRectLeftPotential];
    
    // POTENTIAL CENTER LINE
    NSRect dragRectCenterPotential = NSMakeRect(xLeft/dx - nStart, vCenter*potentialScaling-halfThickness, (xRight/dx - nStart - xLeft/dx + nStart), 2*halfThickness);
    vCenterDragging = [self mouse: clickPoint inRect:dragRectCenterPotential];
    
    // POTENTIAL RIGHT LINE
    NSRect dragRectRightPotential = NSMakeRect(xRight/dx - nStart, vRight*potentialScaling-halfThickness, (nStop - nStart) - (xRight/dx - nStart), 2*halfThickness);
    vRightDragging = [self mouse: clickPoint inRect:dragRectRightPotential];
    
    // X Left LINE
    NSRect dragXLeft = NSMakeRect(xLeft/dx  - nStart -halfThickness, vLeft*potentialScaling, 3*halfThickness, fabs(vCenter*potentialScaling - vLeft*potentialScaling));
    xLeftDragging = [self mouse: clickPoint inRect:dragXLeft];
    
    // X Right LINE
    NSRect dragXRight = NSMakeRect(xRight/dx  - nStart - halfThickness , vRight*potentialScaling, 3*halfThickness, fabs(vCenter*potentialScaling - vRight*potentialScaling));
    xRightDragging = [self mouse: clickPoint inRect:dragXRight];
    
    
    
    
    
    //
    double x = clickPoint.x;
    //NSLog(@"Click Point : %lf", x);
    //NSLog(@"xleft Point : %lf", xLeft/dx - nStart);
    
    
    
    
    if (energyDragging == true && [drawEnergyLine state])
    {
        [ [NSCursor closedHandCursor] set];
        //NSLog(@"energy");
    }
    else if (xRightDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        //NSLog(@"xR");
    }
    else if (xLeftDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
       // NSLog(@"xL");
    }
    else if (vCenterDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        //NSLog(@"vC");
    }
    else if (vRightDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        //NSLog(@"vR");
    }
    else if (vLeftDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
       // NSLog(@"vL");
    }
    else //If nothing is selected
    {
        [ [NSCursor openHandCursor] set];
    }
    
}
-(void)mouseUp:(NSEvent *)theEvent
{
    xLeftDragging = false;
    xRightDragging = false;
    vCenterDragging = false;
    vRightDragging = false;
    vLeftDragging = false;
    energyDragging = false;
    
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
    
    
    
    
    if (energyDragging== true && [drawEnergyLine state])
    {
        [ [NSCursor closedHandCursor] set];
        
        [initEnergyTex setDoubleValue: initialEnergy = downInView.y/potentialScaling];
        
        
        [self setNeedsDisplay:YES];
    }
    else if (xRightDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        [xRightText setDoubleValue: xRight = (downInView.x +nStart)*dx ];
        [self setNeedsDisplay:YES];
    }
    else if (xLeftDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        [xLeftText setDoubleValue: xLeft = (downInView.x +nStart)*dx];
        [self setNeedsDisplay:YES];
    }
    else if (vCenterDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        [vCenterText setDoubleValue: vCenter = downInView.y / potentialScaling];
        [self setNeedsDisplay:YES];
    }
    else if (vRightDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        [vRightText setDoubleValue: vRight = downInView.y / potentialScaling];
        [self setNeedsDisplay:YES];    }
    else if (vLeftDragging == true)
    {
        [ [NSCursor closedHandCursor] set];
        [vLeftText setDoubleValue: vLeft = downInView.y / potentialScaling];
        [self setNeedsDisplay:YES];    }
    else //If nothing is selected
    {
        [ [NSCursor openHandCursor] set];
    }
    
    
    
    
}
-(void)mouseEntered:(NSEvent *)theEvent
{
    
    [ [NSCursor openHandCursor] set];
    
    
    if ( (energyDragging || vCenterDragging || vLeftDragging || vRightDragging || xLeftDragging || xRightDragging ) == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
}
-(void)mouseExited:(NSEvent *)theEvent
{
    [ [ NSCursor arrowCursor] set];
}

// Radio button actions to change type of stroke
- (IBAction)chagePotentialStyle:(id)sender
{
    potentialDrawingStyle = [sender tag];
    [self display];
}


-(IBAction)update:(id)sender
{

psi2Scaling = [psi2ScalingSlider doubleValue];
   [self display]; 
}
        
        
        
-(double)Magnitude: (complex *) a
        {
            return sqrt( SQR(a->imaginary) + SQR(a->real) );
        }

@end
