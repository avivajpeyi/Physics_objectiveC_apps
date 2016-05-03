

#import "SpringView.h"

@implementation SpringView



- (void) awakeFromNib
{
   // NSLog(@"awake for Nib\n");
    
    // initialisations of values
    [self initialisations];
    
    
    myImage = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
    
    
    
    myBitMapRep = [[NSBitmapImageRep alloc]
                   initWithBitmapDataPlanes:nil
                   pixelsWide:width
                   pixelsHigh:height
                   bitsPerSample:8
                   samplesPerPixel:3  //RGB
                   hasAlpha:NO        //No Transprency
                   isPlanar:NO
                   colorSpaceName:NSDeviceRGBColorSpace
                   bytesPerRow:0
                   bitsPerPixel:0];
    
    
   
    
    
    // reset to get new user values
    [self reset:self];
    
    // get algorithm
    algorithm = @selector(eulerCromer);
    
    // start animation thread
        [NSThread detachNewThreadSelector:@selector(animate:)
                                 toTarget:self
                               withObject:nil];
    
    
    
}


-(void)initialisations
{
    stiff = 0.5;
    hard = 0.5;
    viscosity = 0.15;
    
    // dimensions of the view
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    
    
    [amplitudeText setDoubleValue:     amplitude = 0.19];
    [frequencyText setDoubleValue:     frequency = 0.833];
    [phaseText     setDoubleValue:     phase     = 0.0  ];
    [nDisplayText setIntValue:      nDisplay  = 5000 ];
    [nPeriodPerTransientText setDoubleValue:  nPeriodPerTransiet = 8];
    [scaleText setDoubleValue:         scale = 1.0];
    
    
    [amplitudeSlider setDoubleValue:     amplitude ];
    [frequencySlider setDoubleValue:     frequency ];
    [phaseSlider     setDoubleValue:     phase];
    [nDsiplaySlider setIntValue:      nDisplay];
    [nPeriodPerTransientSlider setIntValue :  nPeriodPerTransiet];
    [ScalingSlider setDoubleValue:         scale];
    

    deltaPhase = 2* M_PI / 40.0; //this will give us 40 cross sections
    period = 2 * M_PI / frequency;
    
    [NdtText setIntValue:     nDtPerPeriod = 64];
    [NdtSlider setIntValue: nDtPerPeriod];
    
    dt = period / nDtPerPeriod;
    
    // for Scaling
    double xMin = sqrt ( stiff / hard);
    mX = scale * width / (4 *xMin);
    bX  = width / 2.0;
    mY = scale * height / (2.0 * xMin);
    bY  = height / 2.0;
    
    
    // get algorithm
   // [self performSelector: algorithm];
    
}

- (void)reset:(id)sender
{
    // read users latest values from the sliders
  //  NSLog(@"algorithm %d", alg);

    //NSLog(@"reset \n");
    
    period = 2 * M_PI / frequency;
    
    
    //IN CASE USER CHANGES THE VALUES

    scale                  = [ScalingSlider doubleValue];
    amplitude              = [amplitudeSlider doubleValue];
    frequency              = [frequencySlider doubleValue];
    phase                  = [phaseSlider doubleValue];
    
    
    nDtPerPeriod                     = [NdtSlider intValue];
    nDisplay               = [nDsiplaySlider intValue];
    nPeriodPerTransiet     = [nPeriodPerTransientSlider intValue];
    
    [amplitudeText setDoubleValue:     amplitude ];
    [frequencyText setDoubleValue:     frequency ];
    [phaseText     setDoubleValue:     phase     ];
    [nDisplayText  setIntValue:      nDisplay ];
    [nPeriodPerTransientText setIntValue:  nPeriodPerTransiet ];
    [scaleText     setDoubleValue:         scale];
    [NdtText setDoubleValue:     nDtPerPeriod];

    
    period = 2 * M_PI / frequency;
    
    dt = period / nDtPerPeriod;
    
    
    
    position = 0.50;
    velocity = 0.50;
    t = 0.0;
    
    
    [self display];
}

- (void)drawRect:(NSRect)dirtyRect
{
    unsigned char *myBitmapData = [myBitMapRep bitmapData];
    
    
    //NSLog(@"drawRect\n");
    
    // Color Background of the view-----------------------
    
    for ( int x = 0; x < width; x++) // We're going through every 'x' pixel,
    {
        for (int y = 0; y < height; y++) // we're going through every 'y' pixel
        {
            int index = 3* ( width* y + x);
            
            myBitmapData [index]       = 0;
            myBitmapData [index + 1]   = 0;
            myBitmapData [index + 2]   = 0;
            
            // vary one of these for gradient
        }
    }
    //-----------------------
    
    
    
    CGFloat red, green, blue, alpha;
    // in place of yellow color, you could get a  user to put a color in
    [[NSColor greenColor] getRed: &red green: &green blue: &blue alpha: & alpha];
    
    
    
    // delete transient data nPeriodPerTransiet
    
    for (int i = 0; i < nPeriodPerTransiet; i ++ )
    {
        for ( int b = 0; b < nDtPerPeriod; b++)
        {
            
            [self performSelector: algorithm];
            //[self eulerCromer];
        }
        
    }
    
    
    
    // iterate through the number of point ypou want to display
    for ( int a = 0; a < nDisplay; a++)
    {
        
        int xScaled = scale*mX * position + bX;
        int yScaled = mY * velocity +  bY;
        int index     = 3 * (yScaled * width + xScaled);
        
        if (   ( ( 0 <= xScaled ) and (xScaled < width) )  and ((0 <= yScaled) and (yScaled < height)) )
        {
            
            //put index here?
            
            // bitmap stuff
            myBitmapData [index]       = red     * UCHAR_MAX;
            myBitmapData [index + 1]   = green   * UCHAR_MAX;
            myBitmapData [index + 2]   = blue    * UCHAR_MAX;
            
        }
        
        
        for ( int b = 0; b < nDtPerPeriod; b++)
        {
            // integrate for one period, and get new x and v here
            //[NSApp sendAction: algorithm to:self from:nil];
            
            
            [self performSelector: algorithm];
            //[self eulerCromer];
        }
    }
    
    //  NSLog(@"***Finished drawing the section**\n");
    
    
    
    [ myImage addRepresentation:myBitMapRep];
    
    [ myImage drawAtPoint:NSMakePoint(0, 0)
                 fromRect:NSMakeRect(0, 0, width, height)
                operation:NSCompositeCopy
                 fraction:1.0];
    
    [myImage removeRepresentation:myBitMapRep];
    [myImage recache]; // free memory for improved performance
    
    
}



- (void)animate:(id)object
{
    //NSLog(@"animate\n");
    
    while (YES)
    {
        
        
        if (not [pauseButton state])
        {

            
            // this makes sure phase is always between 0 and 2 M_PI
            if ( (phase += deltaPhase) > (2*M_PI))
                phase = 0.0;
   
            phase += deltaPhase;
            
            
            [phaseSlider setDoubleValue: phase];
            [phaseText   setDoubleValue: phase];

            [self setNeedsDisplay:YES];
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0/[speedSlider doubleValue]]];
    }
}



#pragma mark -
////////////////////////////////////////////////////////////////

- (void)eulerCromer
{
    double dv = a( t, position, velocity) *dt;


velocity += dv;
    
   double dx = velocity * dt;
    
    position += dx;
    t    += dt;
    
   // NSLog(@"\t %lf \t %lf \t %lf", t, position, velocity);

    
}

- (void) RK1
{
    // worse than euler cromer since using old velocity to update position
    
    
    double dv = a(t, position, velocity) * dt;
    double dx = velocity * dt;
    
    velocity += dv;
    position += dx;
    t    += dt;
    
   // NSLog(@"\t %lf \t %lf \t %lf", t, position, velocity);
    
}

- (void) RK2
{
    // better than first two
    
    
    double v = velocity;
    double x = position;
    
    double  dv1 = a(t,x,v) * dt;
    double  dx1 = v*dt;
    // --------------
    
    double  dv2 = a( t+dt, x + dx1, v +dv1) * dt;
    double  dx2 = (v+dv1) * dt;
    // ---------------
    
    double  dv = (dv1 + dv2) /2.0;
    double  dx = (dx1 + dx2) /2.0;
    // ---------------
    
    velocity += dv;
    position += dx;
    // ---------------
    
    t +=dt;
    
    
}

- (void) RK3
{
    // worse than euler cromer since using old velocity to update position
    
    
    double v = velocity;
    double x = position;
    
    double  dv1 = a(t,x,v) * dt;
    double  dx1 = v*dt;
    // --------------
    
    double  dv2 = a( t+dt/2.0, x + dx1/2.0, v +dv1/2.0) * dt;
    double  dx2 = (v+dv1/2.0) * dt;
    // ---------------
    
    double  dv3 = a( t+dt/2.0, x - dx1 + 2*dx2, v - dv1 + 2*dv2) * dt;
    double  dx3 = (v - dv1 + 2*dv2) * dt;
    // ---------------
    
    double  dv = (dv1 + 4*dv2 + dv3) /6.0;
    double  dx = (dx1 + 4*dx2 + dx3) /6.0;
    // ---------------
    
    velocity += dv;
    position += dx;
    // ---------------
    
    t +=dt;
    
    
    
}

- (void) RK4
{
    // worse than euler cromer since using old velocity to update position
    
    double v = velocity;
    double x = position;
    
    double  dv1 = a(t,x,v) * dt;
    double  dx1 = v*dt;
    // --------------
    
    double  dv2 = a( t+dt/2.0, x + dx1/2.0, v +dv1/2.0) * dt;
    double  dx2 = (v+dv1/2.0) * dt;
    // ---------------
    
    double  dv3 = a( t+dt/2.0, x + dx2/2.0, v +dv2/2.0) * dt;
    double  dx3 = (v+dv2/2.0) * dt;
    // ---------------
    
    double  dv4 = a( t+dt, x + dx3, v +dv3) * dt;
    double  dx4 = (v+dv3) * dt;
    // --------------
    
    double  dv = (dv1 + 2*dv2 + 2*dv3 + dv4) / 6.0;
    double  dx = (dx1 + 2*dx2 + 2*dx3 + dx4) / 6.0;
    // ---------------
    
    velocity += dv;
    position += dx;
    // ---------------
    
    t +=dt;
}


- (IBAction) update:(id)sender;
{
    
    
    [self reset:self];
    
}

- (void)algorithmChooser:(id)sender
{
    switch ([sender tag])
    {
        case 0: alg= 0; break;
        case 1: alg=1;         break;
        case 2: alg=2;         break;
        case 3: alg=3;         break;
        case 4: alg=4;         break;
    }

    
    
    switch ([sender tag])
    {
        case 0: algorithm = @selector(eulerCromer); break;
        case 1: algorithm = @selector(RK1);         break;
        case 2: algorithm = @selector(RK2);         break;
        case 3: algorithm = @selector(RK3);         break;
        case 4: algorithm = @selector(RK4);         break;
    }
    
    [self reset:self];
}





/*
 
 integer sliders with slaved text fields to control the transient, integration time step, number of points. Add floating point sliders with slaved text fields to control the drawing scale, and the amplitude and frequency of the forcing. Add a circular slider to control the phase of the forcing and a linear slider to control the speed of the animation. Add a custom application icon and about box and create a standalone app.
 
 */



-(IBAction)saveImage:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"Ising.png"];
    [savePanel beginSheetModalForWindow:[self window] // the window we want to save - since we want to save bit map view, we return self's window
                      completionHandler:^(NSInteger result)
     {
         if (result == NSModalResponseOK)
         {
             NSDictionary *imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
             NSData *data = [myBitMapRep representationUsingType:NSPNGFileType properties:imageProperties];
             [data writeToFile:[[savePanel URL] path] atomically:NO];
         }
     }];
}


-(IBAction)OrigValuesReset:(id)sender
{
    [self initialisations];
    [self reset:self];
}

@end

