//
//  ChaosScattering.m
//  ChaosScattering
//
//  Created by Avi on 3/2/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "ChaosScattering.h"

@implementation ChaosScattering

@synthesize trackingArea;

//- (id)initWithFrame:(NSRect)frame
//{
//    if (self)
//    {
//        NSRect rect = NSMakeRect(10, 10, 10, 10);
//        backgroundImage = [[NSImageView alloc] initWithFrame:rect];
//        [backgroundImage setImageScaling:NSImageScaleAxesIndependently];
//        [backgroundImage setImage:[NSImage imageNamed:@"Potentials"]];
//        [self addSubview:backgroundImage];
//         
//    }
//    return self;
//}

-(void)awakeFromNib
{
    
    //   [NSThread detachNewThreadSelector:@selector(animate:) toTarget:self withObject:nil]; // stat animation
    
    
    [self createTrackingArea];
    
    //------------------- Resize our window  ----------------------------------------
    
    
    // Any time our window is resized, our view, self, want to do a window resize when
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(WindowResized:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    [self WindowResized:nil];
    //------------------------------------------------------------------------------
    
    
    //Initialisations
    [self start];
    [self reset:self];
    
}

-(void)start
{
    
    
    
    
    
    //Default values for the window
    [dtText setDoubleValue:     dt = 0.1];
    [scaleText setDoubleValue:  scale = 20.0];
    [bText setDoubleValue:      b = 0];
    [velXText setDoubleValue:   velX = 0.1];
    
    //Setting Forground and the wave color
    [TrajectoryColorWell setColor: TrajectoryColor = [NSColor greenColor]];
    [backColorWell setColor: backColor = [NSColor blackColor]];
    
    
    dt = 0.1;
    scale = 20.0;
    b = 0;
    velX = 0;
    
    time = 0;
    position = 0;
    velocity = 0;
    
    
    
    /////Set chaos particle positon and velocity
    double rightBound = - [self bounds].size.width/2;
    Position ={ rightBound, b };
    Velocity = { velX, 0} ;
    // x time scale, num pixels per unit x . similar to psi... mountain peaks
    
    trajectoryLine = NO;
    
    indexStart = 0;
    
}

-(IBAction)reset:(id)sender
{
    //IN CASE USER CHANGES THE VALUES
    dt    = [dtText doubleValue];
    scale = [scaleText doubleValue];
    b     = [bText doubleValue];
    velX  = [velXText doubleValue];
    
    time = 0;
    position = 0;
    velocity = 0;
    
    //Set chaos particle positon and velocity
    double rightBound = - [self bounds].size.width/2;
    Position ={ rightBound, b };
    Velocity = { velX, 0} ;
    [self ChaoticComputation];
    
     // Default colors
    TrajectoryColor = [TrajectoryColorWell color];
    backColor = [backColorWell color];
    
    
    numDxPerPixel = 10;
    dx = 1.0 / numDxPerPixel;
    
    [self setNeedsDisplay:YES]; //invoke draw rect
}



-(void)WindowResized:(NSNotification *)notification
{
    // Click on triangle in XIB
    // 'add missing constraints' to set the distances from the interface items to the window, and other elements.
    
    // Done yesterday
    NSRect box = [self bounds];
    NSPoint newOrigin = NSMakePoint( -box.size.width/2.0 , -box.size.height/2.0);
    [self setBoundsOrigin: newOrigin];
    
    // Done for Duffing
    // Any difference?
    // Drawing a bounding rectangle and positiing the origin at the center of the rectngle
//    NSRect box = [self bounds];
//    [self translateOriginToPoint:NSMakePoint(box.size.width/2, box.size.height/2)];

    int rightScreenBound  = box.size.width/2;
    int topScreenBound = box.size.height/2;
    int leftScreenBound  = -box.size.width/2;
    int bottomScreenBound = -box.size.height/2;
    
    NSLog(@"top %d bottom %d left %d right %d", topScreenBound, bottomScreenBound, leftScreenBound, rightScreenBound);
    
    
    // TO SET MINIMUM SIZE OF WINDOW:
    // click on window
    // click on attributes
    // click on the check box 'minimum'
    
}


- (void)drawRect:(NSRect)dirtyRect
{
    

 // ----------------------------------BACKGROUND DRAWING----------------------------------
    switch (BackgroundStyle)
    {
        case 0: // Color
        {
            backColor = [backColorWell color];
            [ backColor set];
            [ NSBezierPath fillRect:dirtyRect];
        }   break;
            
        case 1: // Contor
        {
            
            
            //ATTEMPT 1 - background resizing
            static const NSImage *backImage = [ NSImage imageNamed: @"Potentials"];
            static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
            
            // change scale of contor.
            // set background the pink color
            
            [ backImage drawInRect:dirtyRect
                          fromRect:backRect
                         operation:NSCompositeCopy
                          fraction:1.0];
            
            
            //ATTEMPT 2 - placing image
            
//            NSRect box = [self bounds];
//            NSPoint center = NSMakePoint( box.size.width/2.0 , box.size.height/2.0);
//            
//            NSRect rect = NSMakeRect(-scale, -scale, 2*scale, 2*scale);
//            backgroundImage = [[NSImageView alloc] initWithFrame:rect];
//            [backgroundImage setImageScaling:NSImageScaleAxesIndependently];
//            [backgroundImage setImage:[NSImage imageNamed:@"Potentials"]];
//            [self addSubview:backgroundImage];
//            
            
            // ATTEMPT 3 - combining above two
//            static const NSImage *backImage = [ NSImage imageNamed: @"Potentials"];
//                        NSRect box = [self bounds];
//                        NSPoint center = NSMakePoint( box.size.width/2.0 , box.size.height/2.0);
//                        NSRect rect = NSMakeRect(-scale, -scale, 2*scale, 2*scale);
//                        [ backImage drawInRect:dirtyRect
//                                      fromRect:rect
//                                     operation:NSCompositeCopy
//                                      fraction:1.0];
//            
            
        }
            break;
    }
 //------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    // ----------------------------------PATH OF CHAOTIC PARTICLE----------------------------------
    TrajectoryColor = [TrajectoryColorWell color];
    [TrajectoryColor set];
    NSBezierPath *chaos_line = [NSBezierPath bezierPath];
    {
        [chaos_line setLineWidth: 3.0];
        [chaos_line moveToPoint:NSMakePoint(Position_archive[0].x*scale, Position_archive[0].y*scale)];
        for( int i = 1; i < numPoints ; i ++)
        {
            
            
            
            [chaos_line lineToPoint:NSMakePoint(Position_archive[i].x*scale, Position_archive[i].y*scale)];
            
          //  NSPoint chaosPoint = NSMakePoint(Position_archive[i].x*scale, Position_archive[i].y*scale) ;
            
          //  double x = (double) chaosPoint.x;
          //  double y = (double) chaosPoint.y;
              //  NSLog(@"Chaos Point %lf, %lf", x, y);
            
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
    //------------------------------------------------------------------------------------------------
    
    
    

    // Central Dot
    [[NSColor blueColor] set];
    static const short RADIUS = 5;
    NSRect centralSquare = NSMakeRect(-RADIUS, -RADIUS, 2*RADIUS, 2*RADIUS);
    [ [NSBezierPath bezierPathWithOvalInRect:centralSquare] fill];
    
    // Dots on the contor plots
    [[NSColor whiteColor] set];
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


////////////////////////////////////////////////////////////////
/////////////////       MOUSE STUFF       //////////////////////
////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////


-(void)mouseDown:(NSEvent *)theEvent
{
    //convert window coord to the clickPoint
    NSPoint clickPoint = [self convertPoint: [theEvent locationInWindow] fromView:nil ];
    
    static const short halfThickness = 6;
    static short width = [self bounds].size.width;
    
    
    // TRAJECTORY LINE
    
//    wont work after first
    NSRect dragTrajectoryLine = NSMakeRect(-width/2, Position.y-3, width, 2*halfThickness);
    trajectoryLine = [self mouse: clickPoint inRect:dragTrajectoryLine];

    //    NSLog(@"VALUE IS : %@", (trajectoryLine) ? @"YES" : @"NO");
    //        NSLog(@"Click Point : %d, %d", (int)clickPoint.x, (int)clickPoint.y);
    //        NSLog(@"Psi y Point : %lf", Position.y);
//
    
    /*
     for (int xPixel = 0.0 ; xPixel < ViewWidth; xPixel++ )
     {
     double xReal = (xPixel) / ( xPixels_xReal);
     yPixel[xPixel][tNow] = [self yRealAt: xReal ] * yPixels_yReal ;
     xReal = (xPixel - 1) / ( xPixels_xReal);
     yPixel[xPixel][tOld] = [self yRealAt: xReal ] * yPixels_yReal  ;
     
     //  NSLog(@"point = (%d, %lf) and x real %lf ", xPixel, yPixel[xPixel], xReal);
     }

     
     
     */
//    
//    int clickXcoord = clickPoint.x;
//    double xPix = Position_archive[clickXcoord].x * scale ;
//    double yPix = Position_archive[clickXcoord].y * scale ;
//    NSRect dragTrajectoryLine = NSMakeRect(clickXcoord, yPix - halfThickness, clickXcoord, 2*halfThickness);
//    trajectoryLine = [self mouse: clickPoint inRect:dragTrajectoryLine];
//    
//    
//    NSLog(@"Traj point %lf %lf", xPix, yPix );
//    NSLog(@"Click on line : %@", (trajectoryLine) ? @"YES" : @"NO");
//    
//    double x = clickPoint.x;
//    double y = clickPoint.y;
//    
//    
//    NSLog(@"mouse up at %lf, %lf", x, y);
//
//    
//    if (trajectoryLine == true)
//    {
//        [ [NSCursor closedHandCursor] set];
//    }
//    else //If nothing is selected
//    {
//        [ [NSCursor openHandCursor] set];
//    }
//    
    
    
    NSPoint FirstPoint = { Position_archive[0].x , Position_archive[0].y};
    
    NSLog(@"First point %lf , %lf", FirstPoint.x, FirstPoint.y);
        NSLog(@"Archive point %lf , %lf", Position_archive[0].x, Position_archive[0].y);
    
    
}

-(void)mouseUp:(NSEvent *)theEvent
{
    
//    NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//    Boolean isInside = [self mouse:mouseLoc inRect:[self bounds]];
//    

    
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


-(void)mouseDragged:(NSEvent *)theEvent
{
    // we get the coord of mouse down IN THE WINDOW OF THE APP
    NSPoint downInWindow= [theEvent locationInWindow];
    
    // we get the coord of the mose WRT the custom view in our window
    NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
    

    
    
    // Set Cross sound to be a sound
    //static NSSound *crossSound = [NSSound soundNamed: @"sound"];
    
    
    
    
    if (trajectoryLine == true)
    {
        [bText setDoubleValue: b = downInView.y / scale ];//we are setting our b to be where our mouse was 'downInView'
        
        
        
        
        [self ChaoticComputation];
        // if (currentLastPsi * lastPsi < 0) NSBeep();
        
        [ [NSCursor closedHandCursor] set];
        
        
        //   NSLog(@"B is %lf", b);
        
        
        //TALK TO DR> LINDNER!!! I SHOULD NOT NEED TO DO THIS!!
        //  [self reset:self];
        
        
        [self setNeedsDisplay:YES];
        NSLog(@"mouse drag");
    }
    else
        [ [NSCursor openHandCursor] set];
    
}




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



-(void)mouseExited:(NSEvent *)theEvent
{
    [ [ NSCursor arrowCursor] set];
    
   // NSLog(@"mouse exit");
}



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


- (void) updateTrackingAreas
{
    [self removeTrackingArea:trackingArea];
    [self createTrackingArea];
    [super updateTrackingAreas]; // Needed, according to the NSView documentation
}


////////////////////////////////////////////////////////////////
/////////////////       Radio Buttons     //////////////////////
////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////




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

// Radio button actions
- (IBAction)chageIntegrationStyle:(id)sender
{
    IntegrationStyle = [sender tag];
    [self display];
}

////////////////////////////////////////////////////////////////
/////////////////       MOUSE STUFF       //////////////////////
////////////////////////////////////////////////////////////////




-(IBAction)animate :(id)object
{
    
     NSLog(@"Animate");
    
    
        while (YES)
        {
            if (not [pauseButton state])
            {
                [self animateStep];
            }
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1/60.0] ];
        }
    
    
    
    
}

-(void)animateStep
{
     NSLog(@"Animate Step");
    
        double acceleration = -viscosity * velocity + stiffness - hardness * pow(position,3) + amplitude * cos(frequency*time);
    
    
    
        velocity+=acceleration*dt;
        position += velocity*dt;
        time += dt;
    
    
    
    
        [self setNeedsDisplay:YES];
    
}






-(void)ChaoticComputation
{
    
    switch (IntegrationStyle)
    {
            
        case 0:// EULER
        {
           // NSLog(@"IN case 0");
            NSRect box = [self bounds];
            
            int rightScreenBound  = box.size.width/2;
            int topScreenBound = box.size.height/2;
            int leftScreenBound  = -box.size.width/2;
            int bottomScreenBound = -box.size.height/2;
            
            
            
            double Dt = dt;
            int numDTperPixel = 10;
            
            
            // Repeat till we have the first point of accelteration at
            while (Position.x <= leftScreenBound)

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
            
            Position_archive[0].x = Position.x;
            Position_archive[0].y = Position.y;

            
            
            
            int num = 0;
            
            for ( num = 1; num <= numPoints; num++)
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
                
                
                // DOESNT WORK!!!!
//                
//                if (   Position.x > rightScreenBound || Position.y < bottomScreenBound|| Position.y > topScreenBound   )
//                {
//                    NSLog(@"im leaving num loop!"); break;
//                }
                
                
                
                
                Position_archive[num].x = Position.x;
                Position_archive[num].y = Position.y;
                
               // NSLog(@"x val %d, x = %lf , y = %lf", num , Position.x, Position.y);
                
                
            }
            
            
            
//            do
//            {
//   
//                    for( int countDT = 0; countDT <= numDTperPixel; countDT++)
//                    {
//                        
//                        
//                        vector acceleration2 =
//                        {
//                            -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.x * (-1 + SQR(Position.x)) * (SQR(Position.y)),
//                            -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.y * (-1 + SQR(Position.y)) * (SQR(Position.x))
//                        };
//                        
//                        Velocity.x +=  acceleration2.x * Dt;
//                        Velocity.y +=  acceleration2.y * Dt;
//                        
//                        Position.x +=  Velocity.x * Dt;
//                        Position.y +=  Velocity.y * Dt;
//                        
//                    }
//                
//                    
//                    Position_archive[num].x = Position.x;
//                    Position_archive[num].y = Position.y;
//                    
//                   // NSLog(@"x val %d, x = %lf , y = %lf", num , Position.x, Position.y);
//                    
//                num++;
//                
//            }
//            while (Position.x <= rightScreenBound && Position.y >= bottomScreenBound && Position.y <= topScreenBound  && num <= numPoints  );
            
        }break;
   
        case 1: // EULER
        {
            //////////////////// CHAOTIC SCATTERING WITH EULER
            
            for ( int num = 0; num <= numPoints; num++)
                
            {
                
                /*
                 
                 initially x velocity some value, and use normal Euler
                 
                 if the particle has entered a region of radius R then its acceleration will become
                 
                 
                 
                 */
                
                
                
                vector acceleration2 =
                {
                    -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.x * (-1 + SQR(Position.x)) * (SQR(Position.y)),
                    -2* exp (- SQR(Position.x) - SQR(Position.y) ) * Position.y * (-1 + SQR(Position.y)) * (SQR(Position.x))
                };
                
                Velocity.x +=  acceleration2.x * dt;
                Velocity.y +=  acceleration2.y * dt;
                
                Position.x +=  Velocity.x * dt;
                Position.y +=  Velocity.y * dt;
                
                
                
               //  NSLog(@"x = %lf , y = %lf", Position.x, Position.y);
            }

        }
            break;
            
    }
}





@end



