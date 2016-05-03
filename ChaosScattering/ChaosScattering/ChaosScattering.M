/**********************************************************************
 
              Chaos Scattering on A Complex Topography
                        Implementation File
 
 Name: Avi Vajpeyi
 Assignment: Final Project
 Title: Chaos Scattering
 Course: CS 200
 Semester: Spring 2016
 Instructor: D. Byrnes
 Date: April 14th, 2016
 
 Sources consulted: Dr. Lindner of the College of Wooster, Physics Dpt
 Program description: This program simulates the trajectory of a
                      particle through a region with four symetric
                      Gaussian Potentials
 
 Known bugs: if the time step is decreased below 0.03, then the number
             points we integrate over is not enough to complete path
 
 **********************************************************************/

#import "ChaosScattering.h"

@implementation ChaosScattering

//initiates the tracking area
@synthesize trackingArea;


// try reducing the integration at x = positive 10 n = 0; n < blah && distance < 10; n ++)


#pragma mark -
/**********************************************************************
 *                        Initialisations                             *
 **********************************************************************/

/*--------------------------------------------------------------------
 Awake From Nib:
 
 -  A function present in all objective C classes that is called
 whenever the window needs to be recreated, and the first function
 called when the program is run. This includes when the window
 is moved.
 
 Precondition : None
 Postcondition: Creates a window for the Application as displayed
 in the 'MainMenu.xib' file.
 --------------------------------------------------------------------*/
-(void)awakeFromNib
{
    
    
    [self createTrackingArea];
    
    //------------------- Resize our window  ------------------------
    
    
    // Resize our view when window is resized
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(WindowResized:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    [self WindowResized:nil];
    //---------------------------------------------------------------
    
    
    // Create animation Thread
    [NSThread detachNewThreadSelector:@selector(animate:)
                             toTarget:self
                           withObject:nil]; // start animation thread
    
    
    
    
    // create my bit map rep
    myBitMapRep = [[NSBitmapImageRep alloc]
                   initWithBitmapDataPlanes:nil
                   pixelsWide:self.bounds.size.width
                   pixelsHigh:self.bounds.size.width
                   bitsPerSample:8
                   samplesPerPixel:3  //RGB
                   hasAlpha:NO        //No Transprency
                   isPlanar:NO
                   colorSpaceName:NSDeviceRGBColorSpace
                   bytesPerRow:0
                   bitsPerPixel:0];
    
    
    
    //Initialisations
    [self start];
    [self reset:self];
    
}


/*--------------------------------------------------------------------
 start:
 
 - Called by 'Awake from Nib', and initialises the various data
 members of the ChaoticScattering Class
 
 Precondition : None
 Postcondition: Sets the data members of the ChaoticScattering class
 to their default values.
 --------------------------------------------------------------------*/
-(void)start
{
    
    
    // Default algorithm is eulerCromer
    algorithm = @selector(eulerCromer);
    
    
    //Default values for the window
    [dtText setDoubleValue:     dt = 0.1];
     scale = 81;
    
    
    [velXText setDoubleValue:   velX = 0.1];
    [vStartText setDoubleValue:   vStart = 0.03];
    [vEndText   setDoubleValue:   vEnd   = 3.0];
    [dvText setDoubleValue:      dv = 0.01];
    [velSlider setDoubleValue: velX];
    
    [scatteringAngleText setDoubleValue:   scatteringAngle = 0.0];
    [energyText setDoubleValue:   Energy = 0.0];
    
    [bText setDoubleValue:      b = 0];
    [bStartText setDoubleValue:   bStart = -3.0];
    [bEndText   setDoubleValue:   bEnd   = 3.0];
    [dbText setDoubleValue:      db = 0.01];

    
    //Setting Forground and the wave color
    [TrajectoryColorWell setColor: TrajectoryColor = [NSColor greenColor]];
    [DotColorWell setColor: DotColor = [NSColor blackColor]];
    
    
    dt = 0.1;
    scale = 81;;
    b = 0;
    velX = 0;
    
    time = 0;
    
    radiusScattering = [self bounds].size.width/2.0;
    
    /////Set chaos particle positon and velocity
    double rightBound = 0;//- [self bounds].size.width/2.0 / scale;
    Position ={ rightBound, b };
    Velocity = { velX, 0} ;
    
    trajectoryLine = NO;
    
    indexStart = 0;
    
    N = (numPoints / 2.0) - (-rightBound);
    
    AcelType = 1;
    
}


#pragma mark -
/**********************************************************************
 *                        Updates                                     *
 **********************************************************************/


/*--------------------------------------------------------------------
 reset:
 
 - Called by 'Awake from Nib', and various locations in the program
 to reset the values of the application to the user defined values
 and to restart the aniumation process.
 
 Precondition : None
 Postcondition: Resets the values of the data memebers of the
 ChaoticScattering class to user defined values.
 --------------------------------------------------------------------*/
-(IBAction)reset:(id)sender
{
    //IN CASE USER CHANGES THE VALUES
    dt    = [dtText doubleValue];
    scale = 81;
    
    
    
    velX  = [velXText doubleValue];
    vStart  = [vStartText doubleValue];
    vEnd  = [vEndText doubleValue];
    dv     = [dvText doubleValue];
    
    b     = [bText doubleValue];
    bStart  = [bStartText doubleValue];
    bEnd  = [bEndText doubleValue];
    db     = [dbText doubleValue];
    
    
    time = 0;
      
    //Set chaos particle positon and velocity
    double rightBound = -10;//- [self bounds].size.width/2.0;
    Position ={ rightBound, b };
    Velocity = { velX, 0} ;
    [self ChaoticComputation];
    [self CalculateEnergyWithVel:Velocity andPosit:Position];
    [energyText setDoubleValue:   Energy];

    
    // Default colors
    TrajectoryColor = [TrajectoryColorWell color];
    DotColor = [DotColorWell color];
    
    
    numDxPerPixel = 10;
    dx = 1.0 / numDxPerPixel;
    radiusScattering = [self bounds].size.width/2.0;
    
    // changes the starting point of the animated particle
    switch (BackgroundStyle)
    {
        case 0: // zoom in
        {    N = 55;} break;
            
        case 1: // zoom out
        {    N = 25;} break;
            
    }

    
    [self display]; //invoke draw rect
}


/*--------------------------------------------------------------------
 drawRect:
 
 - Called when the application is first run, and whenever there need
 to be updates made for the on screen display in the view. This
 is where all the commands for draing on the screen are given.
 
 Precondition : None
 Postcondition: Draws on the Custom View in the MainMenu.xib
 --------------------------------------------------------------------*/
- (void)drawRect:(NSRect)dirtyRect
{
    
    
    // -----------------------BACKGROUND DRAWING----------------------------
    switch (BackgroundStyle)
    {
        case 0: // Zoom IN
        {
            
            scale = 81;
            
            static const NSImage *backImage = [ NSImage imageNamed: @"Potentials"];
            static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
            
            // change scale of contor.
            // set background the pink color
            
            [ backImage drawInRect:dirtyRect
                          fromRect:backRect
                         operation:NSCompositeCopy
                          fraction:1.0];
            
            
            
            
            
            //-----------------DOTS ON POTENTIALS----------------------
            {
                
                [[NSColor blueColor] set];
                static const short RADIUS = 4;
                NSRect centralSquare = NSMakeRect(-RADIUS, -RADIUS, 2*RADIUS, 2*RADIUS);
                [ [NSBezierPath bezierPathWithOvalInRect:centralSquare] fill];
                
                // Dots on the contor plots
                [[NSColor blackColor] set];
                // static const short RADIUS = 5;
                NSRect NEsquare = NSMakeRect(scale*1-RADIUS, scale*1-RADIUS, 2*RADIUS, 2*RADIUS);
                [ [NSBezierPath bezierPathWithOvalInRect:NEsquare] fill];
                NSRect NWsquare = NSMakeRect(scale*-1-RADIUS, scale*1-RADIUS, 2*RADIUS, 2*RADIUS);
                [ [NSBezierPath bezierPathWithOvalInRect:NWsquare] fill];
                NSRect SWsquare = NSMakeRect(scale*-1-RADIUS, scale*-1-RADIUS, 2*RADIUS, 2*RADIUS);
                [ [NSBezierPath bezierPathWithOvalInRect:SWsquare] fill];
                NSRect SEsquare = NSMakeRect(scale*1-RADIUS, scale*-1-RADIUS, 2*RADIUS, 2*RADIUS);
                [ [NSBezierPath bezierPathWithOvalInRect:SEsquare] fill];
            }
            //--------------------------------------------------------

          
            
            
        }   break;
            
        case 1: // zoom out
        {
            
            
            
          scale = 27.3;
            

            static const NSImage *backImage = [ NSImage imageNamed: @"Potentials-Small"];
            static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
            
           
            
            [ backImage drawInRect:dirtyRect
                          fromRect:backRect
                         operation:NSCompositeCopy
                          fraction:1.0];
            
            
            {
                
                
                
                
                //-----------------DOTS ON POTENTIALS------------------------
                {
                    
                    [[NSColor blueColor] set];
                    static const short RADIUS = 2;
                    NSRect centralSquare = NSMakeRect(-RADIUS, -RADIUS, 2*RADIUS, 2*RADIUS);
                    [ [NSBezierPath bezierPathWithOvalInRect:centralSquare] fill];
                    
                    // Dots on the contor plots
                    [[NSColor blackColor] set];
                    // static const short RADIUS = 5;
                    NSRect NEsquare = NSMakeRect(scale*1-RADIUS, scale*1-RADIUS, 2*RADIUS, 2*RADIUS);
                    [ [NSBezierPath bezierPathWithOvalInRect:NEsquare] fill];
                    NSRect NWsquare = NSMakeRect(scale*-1-RADIUS, scale*1-RADIUS, 2*RADIUS, 2*RADIUS);
                    [ [NSBezierPath bezierPathWithOvalInRect:NWsquare] fill];
                    NSRect SWsquare = NSMakeRect(scale*-1-RADIUS, scale*-1-RADIUS, 2*RADIUS, 2*RADIUS);
                    [ [NSBezierPath bezierPathWithOvalInRect:SWsquare] fill];
                    NSRect SEsquare = NSMakeRect(scale*1-RADIUS, scale*-1-RADIUS, 2*RADIUS, 2*RADIUS);
                    [ [NSBezierPath bezierPathWithOvalInRect:SEsquare] fill];
                }
                //-------------------------------------------------------

                
            }
            
            
        }
            break;
    }
    //---------------------------------------------------------
    

    
    // -------------------PATH OF CHAOTIC PARTICLE------------------
    {
        TrajectoryColor = [TrajectoryColorWell color];
        [TrajectoryColor set];
        NSBezierPath *chaos_line = [NSBezierPath bezierPath];
        {
            [chaos_line setLineWidth: 3.0];
            [chaos_line moveToPoint:NSMakePoint(Position_archive[0].x*scale, Position_archive[0].y*scale)];
            for( int i = 1; i < numPoints ; i ++)
            {
                
                [chaos_line lineToPoint:NSMakePoint(Position_archive[i].x*scale, Position_archive[i].y*scale)];
                
            }
        }
        switch (TrajectoryStyle)
        {
            case 0: // Stroke
                [chaos_line stroke];             break;
                
            case 1: // Dashed
            {
                // Set the line dash pattern.
                double array[2];
                array[0] = 2; //segment painted with stroke color
                array[1] = 1; //segment not painted with a color
                [chaos_line setLineDash:  array count:2 phase:0];
            }
                break;
        }
    }
    //---------------------------------------------------------------
    
    
    //-----------------------ANIMATED DOT----------------------
    {
        
        DotColor = [DotColorWell color];
        [DotColor set];
        [[NSColor blackColor] set];
        static const short RADIUS = 5;
        
        //double offset =(numPoints/2.0) + [self bounds].size.width/2.0;
        
        int index = fmod (N , ( (numPoints/2.0) + [self bounds].size.width/2.0) );

        NSRect centralSquare = NSMakeRect( (Position_archive[index].x*scale)-RADIUS, (Position_archive[index].y*scale)-RADIUS, 2*RADIUS, 2*RADIUS);
        [ [NSBezierPath bezierPathWithOvalInRect:centralSquare] fill];

        

    }
    //--------------------------------------------------------
    
    

    
}


/*--------------------------------------------------------------------
 WindowResized:
 
 - Called by the application automatically if the window of the app
 is resized to a different value.
 
 Precondition : Window resizing must be within the bounds specified
 by the 'MainMenu.xib' file
 Postcondition: Resizes the window arroding to a mouse drag
 --------------------------------------------------------------------*/
-(void)WindowResized:(NSNotification *)notification
{
    NSRect box = [self bounds];
    NSPoint newOrigin = NSMakePoint( -box.size.width/2.0 , -box.size.height/2.0);
    [self setBoundsOrigin: newOrigin];
}

/*--------------------------------------------------------------------
 update:
 
 - A helper function that is liked to varius items in the MainMen.xib
 and hence is called when the item is intieracted with. It then
 calls the drawRect function
 
 Precondition : None
 Postcondition: Calls the drawRect function
 --------------------------------------------------------------------*/
- (IBAction)update:(id)sender
{
    velX = [velSlider doubleValue];
    [velXText setDoubleValue: velX];
    [self reset:self];
    
    [self setNeedsDisplay:YES];
}


#pragma mark -
/**********************************************************************
 *                        Mouse tracking                              *
 **********************************************************************/

/*--------------------------------------------------------------------
 mouseDown:
 
 - sets the values of 'b' to be the coordinate where the cursor was
 placed down on the screen, if the cursor is in the 'View'
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the value of 'b' and the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseDown:(NSEvent *)theEvent
{
    [ [NSCursor closedHandCursor] set];
    
    trajectoryLine = YES;
    
    //convert window coord to the clickPoint
    NSPoint clickPoint = [self convertPoint: [theEvent locationInWindow] fromView:nil ];
    
    //we are setting our b to be where our mouse was 'downInView'
    [bText setDoubleValue: b = clickPoint.y / scale ];
    
    //reseting the trajectory
    [self reset:self];
    
}


/*--------------------------------------------------------------------
 mouseUp:
 
 - changes the shape of the mouse if the mouse is up to arrow/hand
 depending on where it is on the screen
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
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
    
    trajectoryLine = NO;
    
    
}

/*--------------------------------------------------------------------
 mouseDragged:
 
 - if the mouse is dragged, then 'b' continuously changes along with
 the coordinates of the mouse on the screen. Changes the cursor to
 a closed hand cursor.
 
 Precondition : The mouse is on the screen and down
 Postcondition: Updates the shape of the cursor and value of 'b'
 --------------------------------------------------------------------*/
-(void)mouseDragged:(NSEvent *)theEvent
{
    
    [ [NSCursor closedHandCursor] set];
    
    
    // we get the coord of mouse down IN THE WINDOW OF THE APP
    NSPoint downInWindow= [theEvent locationInWindow];
    
    // we get the coord of the mose WRT the custom view in our window
    NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
    
    
    [bText setDoubleValue: b = downInView.y / scale ];
    //we are setting our b to be where our mouse was 'downInView'
    
    
    [self reset:self];
    
}


/*--------------------------------------------------------------------
 mouseEntered:
 
 - if the mouse is moved above the view, then the cursor changes to
 hand instead of arrow, and vice versa.
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseEntered:(NSEvent *)theEvent
{
    // If mouse entered the space of the custom view
    
    
    [ [NSCursor openHandCursor] set];
    
    
    
    
    if ( trajectoryLine == true)
    {
        [ [NSCursor closedHandCursor] set];
    }
    
    //  NSLog(@"mouse enter");
}

/*--------------------------------------------------------------------
 mouseExited:
 
 - if the mouse is moved out of the view, then the cursor changes to
 arrow instead of hand, and vice versa.
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseExited:(NSEvent *)theEvent
{
    [ [ NSCursor arrowCursor] set];
    
    // NSLog(@"mouse exit");
}

/*--------------------------------------------------------------------
 createTrackingArea:
 
 - Creates the dimensions for the appliaciton to be able to track the
 position of the mouse, to be able to do other mouse function.
 Called by the 'Awake from Nib' function.
 
 Precondition : None
 Postcondition: Creates the dimensions for where the mouse is tracked
 --------------------------------------------------------------------*/
- (void) createTrackingArea
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds]))
    {
        [self mouseEntered: nil];
        
    }
    else
    {
        [self mouseExited: nil];
    }
}

/*--------------------------------------------------------------------
 updatingTrackingAreas:
 
 - This updates the tracking area of the mouse if there are changes
 in the size of the window, if the window is minimized, etc.
 
 Precondition : The window's dimensions or position changes
 Postcondition: Updates the tracking dimensions for the mouse
 --------------------------------------------------------------------*/
- (void) updateTrackingAreas
{
    [self removeTrackingArea:trackingArea];
    [self createTrackingArea];
    [super updateTrackingAreas]; // Needed, according to the NSView documentation
}



#pragma mark -

/**********************************************************************
 *                        Calculations                                *
 **********************************************************************/


/*--------------------------------------------------------------------
 eulerCromer:
 
 - A numerical integration technique that updates the velocity and
 position of the particle. This is better than RK1.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
- (void)eulerCromer
{
    // updating velocity of the particle
    Velocity.x += AcelType * acceleration_X(Position.x, Position.y) * dt;
    Velocity.y +=  AcelType * acceleration_Y(Position.x, Position.y) * dt;
    
    
    // updating the position of the particle using the newly calulated velocity
    Position.x +=  Velocity.x * dt;
    Position.y +=  Velocity.y * dt;
}


/*--------------------------------------------------------------------
 RK1:
 
 - A numerical integration technique, called Runge-Kutta 1, that
 updates the velocity and position of the particle. This is
 very similar to Euler Cromer, however less accurate.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
 - (void) RK1
 {
 // worse than euler cromer since using old velocity to update position
 
 

     
     
     vector dv_ = { AcelType * acceleration_X(Position.x, Position.y) * dt , AcelType * acceleration_Y(Position.x, Position.y) * dt};
     vector dx_ = { Velocity.x * dt, Velocity.y * dt};
     
     
     Velocity.x = Velocity.x + dv_.x;
     Velocity.y = Velocity.y + dv_.y;
     
     Position.x =  Position.x + dx_.x;
     Position.y =  Position.y + dx_.y;
     
     time    += dt;
     
 
 }
 

/*--------------------------------------------------------------------
 RK2:
 
 - A numerical integration technique, called Runge-Kutta 2, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and RK1.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
- (void) RK2
{
    // better than first two
    
    
    vector v = {Velocity.x , Velocity.y};
    vector x = {Position.x , Position.y};
    
    vector  dv1 = {AcelType * acceleration_X(x.x, x.y)*dt ,  AcelType * acceleration_Y(x.x, x.y)*dt};
    vector  dx1 ={v.x*dt , v.y*dt};
    // --------------
    
    vector  dv2 =  { AcelType * acceleration_X(x.x + dx1.x, x.y + dx1.y)* dt, AcelType * acceleration_Y(x.x + dx1.x, x.y + dx1.y)* dt} ;
    vector  dx2 = { (v.x+dv1.x)* dt , (v.y+dv1.y)* dt};
    // ---------------
    
    vector  dv_ = {(dv1.x + dv2.x) /2.0 , (dv1.y + dv2.y) /2.0};
    vector  dx_ = {(dx1.x + dx2.x) /2.0 , (dx1.y + dx2.y) /2.0};
    // ---------------
    
    Velocity = {Velocity.x + dv_.x , Velocity.y + dv_.y};
    Position = {Position.x+dx_.x , Position.y+dx_.y  };
    // ---------------
    
    time +=dt;
    
    
}
/*--------------------------------------------------------------------
 RK3:
 
 - A numerical integration technique, called Runge-Kutta 3, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and the previous RK's.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
- (void) RK3
{
    // worse than euler cromer since using old velocity to update position
    
    
    vector v = {Velocity.x , Velocity.y};
    vector x = {Position.x , Position.y};
    
    vector  dv1 = {AcelType * acceleration_X(x.x, x.y)*dt ,  AcelType * acceleration_Y(x.x, x.y)*dt};
    vector  dx1 ={v.x*dt , v.y*dt};
    // --------------
    
//    double  dv2 = a( t+dt/2.0, x + dx1/2.0, v +dv1/2.0) * dt;
//    double  dx2 = (v+dv1/2.0) * dt;
    
    vector dv2 = {AcelType * acceleration_X(x.x + dx1.x/2.0, x.y + dx1.y/2.0)*dt, AcelType * acceleration_Y(x.x + dx1.x/2.0, x.y + dx1.y/2.0)*dt};
    vector dx2 = {(v.x+dv1.x/2.0)*dt, (v.y+dv1.y/2.0)*dt};
    // ---------------
    
//    double  dv3 = a( t+dt/2.0, x - dx1 + 2*dx2, v - dv1 + 2*dv2) * dt;
//    double  dx3 = (v - dv1 + 2*dv2) * dt;
    vector dv3 = {AcelType * acceleration_X(x.x - dx1.x + 2*dx2.x, x.y - dx1.y + 2*dx2.y)*dt, AcelType * acceleration_Y(x.x - dx1.x + 2*dx2.x, x.y - dx1.y + 2*dx2.y)*dt};
    vector dx3 = {(v.x - dv1.x + 2*dv2.x)*dt, (v.y - dv1.y + 2*dv2.y)*dt};
    // ---------------
    
//    double  dv = (dv1 + 4*dv2 + dv3) /6.0;
//    double  dx = (dx1 + 4*dx2 + dx3) /6.0;
    
    vector dv_ = {(dv1.x + 4*dv2.x + dv3.x)/6.0, (dv1.y + 4*dv2.y + dv3.y)/6.0};
    vector dx_ = {(dx1.x + 4*dx2.x + dx3.x)/6.0,(dx1.y + 4*dx2.y + dx3.y)/6.0};
    // ---------------
    
//    velocity += dv;
//    position += dx;
    
    Velocity = {Velocity.x + dv_.x , Velocity.y + dv_.y};
    Position = {Position.x+dx_.x , Position.y+dx_.y  };
    // ---------------
    
    time +=dt;
    
}
/*--------------------------------------------------------------------
 RK4:
 
 - A numerical integration technique, called Runge-Kutta 4, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and the previous RK's.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
- (void) RK4
{
    // better than euler cromer since using old velocity to update position


    
    vector v = {Velocity.x , Velocity.y};
    vector x = {Position.x , Position.y};
    
    vector  dv1 = {AcelType * acceleration_X(x.x, x.y)*dt ,  AcelType * acceleration_Y(x.x, x.y)*dt};
    vector  dx1 ={v.x*dt , v.y*dt};
    // --------------
    
    //    double  dv2 = a( t+dt/2.0, x + dx1/2.0, v +dv1/2.0) * dt;
    //    double  dx2 = (v+dv1/2.0) * dt;
    
    vector dv2 = {AcelType * acceleration_X(x.x + dx1.x/2.0, x.y + dx1.y/2.0)*dt, AcelType * acceleration_Y(x.x + dx1.x/2.0, x.y + dx1.y/2.0)*dt};
    vector dx2 = {(v.x+dv1.x/2.0)*dt, (v.y+dv1.y/2.0)*dt};
    // ---------------
    
    //    double  dv3 = a( t+dt/2.0, x - dx1 + 2*dx2, v - dv1 + 2*dv2) * dt;
    //    double  dx3 = (v - dv1 + 2*dv2) * dt;
    vector dv3 = {AcelType * acceleration_X( x.x + dx2.x/2.0, x.y + dx2.y/2.0 )*dt, AcelType * acceleration_Y( x.x + dx2.x/2.0, x.y + dx2.y/2.0)*dt};
    vector dx3 = {(v.x+dv2.x/2.0 )*dt, (v.y+dv2.y/2.0)*dt};
    // ---------------
    
    //    double  dv3 = a( t+dt/2.0, x - dx1 + 2*dx2, v - dv1 + 2*dv2) * dt;
    //    double  dx3 = (v - dv1 + 2*dv2) * dt;
    vector dv4 = {AcelType * acceleration_X(x.x + dx3.x, x.y + dx3.y)*dt, AcelType * acceleration_Y(x.x + dx3.x, x.y + dx3.y)*dt};
    vector dx4 = {(v.x+dv3.x)*dt, (v.y+dv3.y)*dt};
    // ---------------
    
    //    double  dv = (dv1 + 4*dv2 + dv3) /6.0;
    //    double  dx = (dx1 + 4*dx2 + dx3) /6.0;
    
    vector dv_ = {(dv1.x + 2*dv2.x + 2*dv3.x+ dv4.x)/6.0, (dv1.y + 2*dv2.y + 2*dv3.y+ dv4.y)/6.0};
    vector dx_ = {(dx1.x + 2*dx2.x + 2*dx3.x+ dx4.x)/6.0, (dx1.y + 2*dx2.y + 2*dx3.y+ dx4.y)/6.0};
    // ---------------
    
    //    velocity += dv;
    //    position += dx;
    
    Velocity = {Velocity.x + dv_.x , Velocity.y + dv_.y};
    Position = {Position.x + dx_.x , Position.y + dx_.y};

    
    
    
//    NSLog(@"%lf", x.x);
//    
//    if ( x.x != x.x )
//    {
//        NSLog(@"NAN " );
//    }
}


 
/*--------------------------------------------------------------------
 ChaoticComputation:
 
 - This function calculates the trajectory of the particle, and
 calculates the scatering angle for the given trajectory
 
 Precondition : All data memebers have been initialised
 Postcondition: Position of the particle's path has been computed,
 and the scattering angle has been calculated
 --------------------------------------------------------------------*/
-(void)ChaoticComputation
{
    
    
    //double Dt = dt;
    int numDTperPixel = 10;
    
    
    Position_archive[0].x = Position.x;
    Position_archive[0].y = Position.y;
    
    

    
    double radius = sqrt(SQR(Position.x) + SQR(Position.y));
    
    // store the x and y position after numerical integration
    for (int num = 1; num <= numPoints; num++)
    {
        
        
        
        for( int countDT = 0; countDT <= numDTperPixel; countDT++)
        {
            
                    [self performSelector:algorithm];
            

        }
        

        
        Position_archive[num].x = Position.x;
        Position_archive[num].y = Position.y;
        [self CalculateEnergyWithVel:Velocity andPosit:Position];
        
    }
    
    // calclate and store scattering angle
    {
        double x1 = Position_archive[numPoints-2].x;
        double y1 = Position_archive[numPoints-2].y;
        
        double x2 = Position_archive[numPoints-1].x;
        double y2 = Position_archive[numPoints-1].y;

        
        //  arctangent (opposite / adjacent )
        scatteringAngle = ( atan( (y1 - y2) / (x1 - x2) )) * (180.0 / M_PI);
        [scatteringAngleText setDoubleValue:   scatteringAngle];
        
                [energyText setDoubleValue:   Energy];
    }
    
}




/*--------------------------------------------------------------------
 VelocitiesSaveData:
 
 - Iterates 'initial velocity' from a starting velocity to a
 stopping velocity, and calculates the value for the scattering angle
 at each value of 'initial velocity' for transits.
 
 Precondition : The button to save velocities data has been triggerd
 Postcondition: Creates a file with the values of 'vel' and the
 scattering angles.
 --------------------------------------------------------------------*/
-(IBAction)VelocitiesSaveData:(id)sender
{
 
    int originalV = velX;
    
    
    velX = vStart;
    
    __block double x1, x2, y1,y2;
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"VelocitiesAngleData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK)
        {
            
            
            [savePanel close]; // close save panel while data is being aquired
            
            
            const char *cFileName = [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
            FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
            {
                fprintf(dataFileP, "Vel \t thetaV \n");
                
                
                
                
                
                // this will calculate scattering angles for a hundred values,
                // print and then calculate another set of values,
                // until the scattering parameter becomes 2
                
                do // iterate from v = 0.03 to b = 3
                {
                    
                    
                    // calculate praticle's trajectory
                    
                    double Dt = dt;
                    int numDTperPixel = 10;
                    
                    
                    
                    
                    Velocity = { velX, 0} ;
                    Position = { -[self bounds].size.width/2.0, b };
                    
                    x1 = Position.x;
                    y1 = Position.y;
                    
                    x2= 0;
                    y2 = 0;
                    
                    //calculating the position etc for 'numPoints'
                    for (int num = 1; num <= numPoints; num++)
                    {
                        for( int countDT = 0; countDT <= numDTperPixel; countDT++)
                        {
                            
                            [NSApp sendAction: algorithm to:self from:nil];
                            
                        }
                        
                        
                        x2 = x1; //get previous values of x
                        y2 = y1; //get previous values of y
                        
                        x1 = Position.x;
                        y1 = Position.y;
                        
                        
                    } //numPoints number of postions have been stored
                    
                    
                    
                    
                    // since the particle has exited the area we calculate scattering angle
                    
                    
                    // calclate and store scattering angle
                    
                    //  arctangent (opposite / adjacent )
                    double scatteringAngleX = ( atan( (y1 - y2) / (x1 - x2) )) * (180.0 / M_PI);
                    
                    
                    // storing the scattering angle
                    fprintf(dataFileP, "%lf \t %lf \n", velX, scatteringAngleX);
                    
                    
                    
                    // reset the data and simulation and update the scattering parameter
                    
                    velX += dv;
                    
                    Velocity = { velX, 0} ;
                    Position = { -[self bounds].size.width/2.0, b };
                    
                    
                    //now the particles scatterd angle is stored and b hase been incremented
                    
                }
                while (velX < vEnd);
                
                
                
                
                
            }
            fclose(dataFileP);
        }
        
        velX = originalV;
        
        
        NSBeep(); //alert user for completion of data recording
        
    }];
    

}

/*--------------------------------------------------------------------
 FractalAngleSaveData:
 
 - Iterates 'b' from a starting positition to a stopping position,
 and calculates the value for the scattering angle at each
 value of 'b' during the transit.
 
 Precondition : The button to save fractal data has been triggerd
 Postcondition: Creates a file with the values of 'b' and the
 scattering angles.
 --------------------------------------------------------------------*/
- (IBAction)FractalAngleSaveData:(id)sender
{
    
    
    
    int originalB = b;
    

    __block double B = bStart;
    b = bStart;
    
    __block double x1, x2, y1, y2;
    
    
    
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"FractalAngleData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK)
        {
            
            
            [savePanel close]; // close save panel while data is being aquired
            
            
            const char *cFileName = [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
            FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
            {
                fprintf(dataFileP, "b \t theta \n");
                
                
                
                
                
                // this will calculate scattering angles for a hundred values,
                // print and then calculate another set of values,
                // until the scattering parameter becomes 2
                
                do // iterate from b = -2 to b = 2
                {
                    

                    // calculate praticle's trajectory

                    double Dt = dt;
                    int numDTperPixel = 10;
                        
                    
                    Velocity = { velX, 0} ;
                    Position = { -[self bounds].size.width/2.0, b };
                    
                    x1 = Position.x;
                    y1 = Position.y;
                    
                    x2= 0;
                    y2 = 0;

                    
//                    [self CalculateEnergyWithVel:Velocity andPosit:Position];
//                    EnergyArchive[0] = Energy;
    
                        //calculating the position etc for 'numPoints'
                        for (int num = 1; num <= numPoints; num++)
                        {
                            for( int countDT = 0; countDT <= numDTperPixel; countDT++)
                            {
                                
                                //[NSApp sendAction: algorithm to:self from:nil];
                                
                                Velocity.x +=  AcelType * acceleration_X(Position.x, Position.y) * Dt;
                                Velocity.y +=  AcelType * acceleration_Y(Position.x, Position.y) * Dt;
                                
                                Position.x +=  Velocity.x * Dt;
                                Position.y +=  Velocity.y * Dt;
                                
                                
                                                           }
                            
                            
                            x2 = x1; //get previous values of x
                            y2 = y1; //get previous values of y
                            
                            x1 = Position.x;
                            y1 = Position.y;
                            
                        } //numPoints number of postions have been stored
                        
                    
                    
                    
                    // since the particle has exited the area we calculate scattering angle
                    
                    
                    // calclate and store scattering angle
                    
                            //  arctangent (opposite / adjacent )
                            double scatteringAngleX = ( atan( (y1 - y2) / (x1 - x2) )) * (180.0 / M_PI);

                        
                        // storing the scattering angle
                        fprintf(dataFileP, "%lf \t %lf \n", b, scatteringAngleX);
                
                    
                    
                    // reset the data and simulation and update the scattering parameter

                    
                    
                    
                    B += db;
                    b = B;
                    
                    
                    Velocity = { velX, 0} ;
                    Position = { -[self bounds].size.width/2.0, b };
                    
                    
                    
                    
                    //now the particles scatterd angle is stored and b hase been incremented
                    
                    
                }
                while (b < bEnd);
                
                
                
                
                
            }
            fclose(dataFileP);
        }
        
        b = originalB;
        
        
        NSBeep(); //alert user for completion of data recording
        
    }];
    
    
}




- (void)CalculateEnergyWithVel : (vector) V andPosit: (vector) X
{
    // 2D Do prodct

    //{V}(x,y) = x^2 y^2 \ e^ {-x^2-y^2}.
    double potential = (X.x*X.x) * (X.y*X.y) * exp(-(X.x*X.x)- (X.y*X.y));
    double velMagnitude_2 = (V.x * V.x) + (V.y * V.y); //mag squared 
    
    // for valley check 
    
    Energy =  (0.5 *  velMagnitude_2) + potential;

}


- (IBAction)EnergyData:(id)sender
{
    
    
    
    
    
    
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"myEenrgyData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK)
        {
            [savePanel close];
            
            
            
            //double Dt = dt;
            int numDTperPixel = 10;
            
            
            Position_archive[0].x = Position.x;
            Position_archive[0].y = Position.y;
            
            
            const char *cFileName = [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
            FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
            {
                fprintf(dataFileP, "Energy \t x \t y");
                
                
                // store the x and y position after numerical integration
                for (int num = 1; num <= numPoints; num++)
                {
                    
                    for( int countDT = 0; countDT <= numDTperPixel; countDT++)
                    {
                        [self performSelector:algorithm];
                    }
                    
                    
                    [self CalculateEnergyWithVel:Velocity andPosit:Position];
                    
                    
                    fprintf(dataFileP, "%lf \t %lf \t %lf\n", Energy, Position.x, Position.y);
                    
                    
                }
                
                
                
                
            }
            fclose(dataFileP);
            
            
            NSBeep(); //alert user for completion of data recording
            
        }
    }];
    
}



////////////////////////////////////////////////////////////////
/////////////////       EXTRA FEATURES     //////////////////////
////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////



// repeating the animation thread
-(IBAction)animate:(id)object
{
    while (YES)
    {
        if (not [pauseButton state])
        {
            N++;
            [self setNeedsDisplay:YES];
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow: 1.0/ [speedSlider doubleValue]] ];//
    }
}




// Saving images of the scattering
-(void) saveImage:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"ChaoticScat.png"];
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


// Radio button actions
- (IBAction)chageTrajectoryStyle:(id)sender
{
    TrajectoryStyle = [sender tag];
    [self display];
}


// Radio button actions
- (IBAction)chageBackgroundStyle:(id)sender
{
    BackgroundStyle = [sender tag];
    [self display];
}

// Radio button for potential style
- (IBAction)chagePotentialStyle:(id)sender
{
    
    switch ([sender tag])
    {
        case 0: AcelType =  1;         break;
        case 1: AcelType = -1;         break;
    }
    [self reset:self];
}


// Radio button for numerical integration
- (IBAction)chageIntegrationStyle:(id)sender
{
    
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


// old version of saving data
-(IBAction)FractalAngleDataOld:(id)sender
{
    
    
    NSString *content = @"b\tTheta";
    
    [self writeToLogFile:content];
    
    
    int numDataPoints = 100;
    scatteringAngle_archive = new double [numDataPoints];
    b_archive = new double [numDataPoints];
    
    double db = 1.0 / numDataPoints;
    __block double B = -2;
    b = B;
    
    // this will calculate scattering angles for a hundred values,
    //print and then calculate another set of values,
    //until the scattering parameter becomes 2
    do
    {
        // iterates for 100 values of b and stores data for 100 pts
        for (int i = 0; i < 100; i++)
        {
            
            // calculate scattering angle
            
            double radius_part = 0;
            while (radius_part/2.0 < radiusScattering/2.0) // while particle is still in system
            {
                
                double Dt = dt;
                int numDTperPixel = 10;
                
                
                int num = 0;
                
                
                //calculating the position etc for 'numPoints'
                for ( num = 0; num <= numPoints; num++)
                {
                    for( int countDT = 0; countDT <= numDTperPixel; countDT++)
                    {
                        vector acceleration2 =
                        {
                            -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.x * (-1 + SQR(Position.x)) * (SQR(Position.y)),
                            -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.y * (-1 + SQR(Position.y)) * (SQR(Position.x))
                        };
                        
                        Velocity.x +=  acceleration2.x * Dt;
                        Velocity.y +=  acceleration2.y * Dt;
                        
                        Position.x +=  Velocity.x * Dt;
                        Position.y +=  Velocity.y * Dt;
                    }
                    
                    
                    Position_archive[num].x = Position.x;
                    Position_archive[num].y = Position.y;
                    
                    if (num > 0 && num < numPoints)
                    {
                        Scattering_points[0] = { Position_archive[num-1].x , Position_archive[num-1].y};
                        Scattering_points[1] = { Position_archive[num].x , Position_archive[num].y};
                    }
                } //numPoints number of postions have been stored
                
                // update radius part to check if we should exit the loop or not
                radius_part = sqrt(  SQR(Position.x) + SQR(Position.y) );
              //  NSLog(@"rPart : %lf", radius_part);
            }
            
            // since the particle has exited the area we calculate scattering angle
            // calclate and store scattering angle
            {
                
                double x1 = Scattering_points[0].x;
                double y1 = Scattering_points[0].y;
                
                double x2 = Scattering_points[1].x;
                double y2 = Scattering_points[1].y;
                
                //  arctangent (opposite / adjacent )
                scatteringAngle = ( atan( (y1 - y2) / (x1 - x2) )) * (180.0 / M_PI);
                
                
                // storing the scattering angle
                scatteringAngle_archive[i] = scatteringAngle;
                b_archive[i] = b;
            }
            
            
            // reset the data and simulation and update the scattering parameter
            [self reset:self];
            B += db;
            b = B;
            Position = { -[self bounds].size.width/2.0, b };
            
            
            
        }
        //now the particles scatterd angle is stored and b hase been incremented
        
        
        // the first 100 values are now printed
        for (int i = 0; i < 100; i++)
        {
            NSLog(@"b: %lf, theta: %lf", b_archive[i], scatteringAngle_archive[i]);
            NSString *results = [NSString stringWithFormat:@"%lf\t%lf", b_archive[i],scatteringAngle_archive[i] ];
            
            [self writeToLogFile:results];
        }
        
    }
    while (b < 2);
    
}


// helper to old version of saving data
-(void) writeToLogFile:(NSString*)content
{
    content = [NSString stringWithFormat:@"%@\n",content];
    
    //get the documents directory:
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"scatteringAngleData.txt"];
    
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
    }
}

// old version of animation
-(IBAction)animateOrig :(id)object
{
    
    while (YES)
    {
        
       // NSLog(@"Animate");
        
        
        
        if (not [pauseButton state] )
        {
            [self animateStepOrig];
            
            NSLog(@"inside if");
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow: [speedSlider doubleValue]] ];//
        
        
        NSLog(@"outside if %lf,", [speedSlider doubleValue]);
        
    }
    
    
    
    
}

// old version of animation
-(void)animateStepOrig
{
    NSLog(@"Animate Step");
    
    double Dt = dt;
    int numDTperPixel = 10;
    
    
    int num = 0;
    
    for ( num = 0; num <= numPoints; num++)
    {
        
        
        
        for( int countDT = 0; countDT <= numDTperPixel; countDT++)
        {
            
            vector acceleration2 =
            {
                -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.x * (-1 + SQR(Position.x)) * (SQR(Position.y)),
                -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.y * (-1 + SQR(Position.y)) * (SQR(Position.x))
            };
            
            Velocity.x +=  acceleration2.x * Dt;
            Velocity.y +=  acceleration2.y * Dt;
            
            Position.x +=  Velocity.x * Dt;
            Position.y +=  Velocity.y * Dt;
            
        }
        
        
        Position_archive[num].x = Position.x;
        Position_archive[num].y = Position.y;
        
        if (num > 0 && num < numPoints)
        {
            Scattering_points[0] = { Position_archive[num-1].x , Position_archive[num-1].y};
            Scattering_points[1] = { Position_archive[num].x , Position_archive[num].y};
        }
        
        
    }
    
  //  NSLog(@"x = %lf , y = %lf", Position.x, Position.y);
    
    
    
    
    
    double radius_part = sqrt(  SQR(Position.x) + SQR(Position.y) );
    //NSLog(@"\nrad part =%lf  \nrad scat = %lf", radius_part/2.0, (radiusScattering/2.0));
    
    if ( radius_part/2.0 >= radiusScattering/2.0  )
    {
        {
            double x1 = Scattering_points[0].x;
            double y1 = Scattering_points[0].y;
            
            double x2 = Scattering_points[1].x;
            double y2 = Scattering_points[1].y;
            
            // 180 - arctangent (opposite / adjacent )
            scatteringAngle = ( atan( (y1 - y2) / (x1 - x2) )) * (180.0 / M_PI);
            [scatteringAngleText setDoubleValue:   scatteringAngle];
            
            
        }
        
        [self reset:self];
    }
    
    
    
    [self setNeedsDisplay:YES];
    
    
}




@end



