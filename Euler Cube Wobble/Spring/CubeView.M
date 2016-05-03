//
//  SpringView.m
//  Spring
//
//  Created by John Lindner on 4/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import "CubeView.h"

@implementation CubeView


-(void)awakeFromNib
{
    //  NSLog(@"\n awake From nib");
    
    //translate origin to the center
    NSRect boundsRect = [self bounds];
    double x = boundsRect.size.width / 2;
    double y = boundsRect.size.height / 2;
    [self translateOriginToPoint:NSMakePoint(x, y)];
    
    
    dt = 0.0001;

    

    [RadXSlider setDoubleValue:   radius[X] = 4.0];
    [RadYSlider setDoubleValue:   radius[Y] = 9.0];
    [RadZSlider setDoubleValue:   radius[Z] = 1.0];

    
    
    //omega0[X] = 0; omega0[Y] =  0.0; omega0[Z] = 1;

    
    
    [OmegXText setDoubleValue:   omega0[X] = 1];
    [OmegYText setDoubleValue:   omega0[Y]=  0.05];
    [OmegZText   setDoubleValue:   omega0[Z]= 0];
    [OmegXSlider setDoubleValue:   omega0[X]];
    [OmegYSlider setDoubleValue:   omega0[Y]];
    [OmegZSlider   setDoubleValue:   omega0[Z]];
    
    eye= 20; magnify = 15;
    [eyeSlider   setDoubleValue:   eye= 20];
    [magnifySlider   setDoubleValue:   magnify = 15];
    
    
    // invoke reset
    [self resetWobble:self ];
    
    // detach, evolve, thread (start the animation thread)
    // start animation thread
    [NSThread detachNewThreadSelector:@selector(evolve:)
                             toTarget:self
                           withObject:nil];
    
    //
    
    backGroundNumber = 0 ;
    
}


-(IBAction)resetWobble: (id) sender
{
   // NSLog(@"\n reset wobble");
    // read new omega0
    
    // reset inertia, momentum, cuboid and rotation


    // intially had reset omega first.
    [self resetOmega];
    [self resetInertia];
    [self resetMomentum];
    [self resetCuboids];
    [self resetRotation];
    

    [self display];
}

-(void) resetOmega

{
    
    //        NSLog(@"\n reset omega");
    // set omega[] = omega0[]
    
    for (int i = 0; i < DIM; i ++)
    {
        omega[i] = omega0[i];
    }
    
}

-(void)resetMomentum
{
    
    //       NSLog(@"\n reset momentum");
    // L = I * w
    
    angularMomentum[X] = inertia[X] * omega0[X];
    angularMomentum[Y] = inertia[Y] * omega0[Y];
    angularMomentum[Z] = inertia[Z] * omega0[Z];
    
}

-(void)resetInertia
{
    
    //   NSLog(@"\n reset inertia and inverse inertia");
    
    /* MASS CALCULATION
     
     double mass = 8 * density * radius[X] * radius[Y] * radius[Z]
     = ro 8 Rx Ry Rz
     = ro (2Rx) (2Ry) (2Rz)
     
     */
    
    //double density = 1.0 / 8.0;
    
    double mass = 8 *   density * radius[X] * radius[Y] * radius[Z];
    
    
    
    /*
     Note:
     
     Io-1  = 1/Ix     0       0
     0     1/Iy     0
     0     0        1/Iz
     
     
     I    =  same except Ix instead of 1/Ix
     
     
     Ix = m(Ry^2 + Rz^2)/3
     Iy = m(Rx^2 + Rz^2)/3
     Iz = m(Rx^2 + Ry^2)/3
     
     
     */
    
    inertia[X] = mass * (SQR(radius[Y]) + SQR(radius[Z]))/3.0;
    inertia[Y] = mass * (SQR(radius[X]) + SQR(radius[Z]))/3.0;
    inertia[Z] = mass * (SQR(radius[X]) + SQR(radius[Y]))/3.0;
    
    
    for (int i = 0; i < DIM; i ++)
    {
        for (int j = 0; j < DIM; j ++)
        {
            Ii0[i][j] = 0.00;
        }
    }
    
    Ii0[X][X] = 1.0 / inertia[X];
    Ii0[Y][Y] = 1.0 / inertia[Y];
    Ii0[Z][Z] = 1.0 / inertia[Z];
    
    
    
}

-(void)resetCuboids
{
    
    //   NSLog(@"\n reset cuboids");
    
    /*
     eight lines of below, change sign depending on where the corner actually is
     
     
     0 +++
     1 -++
     2 --+
     3 +-+
     
     4 ++-
     5 -+-
     6 ---
     7 +--
     
     cuboid0[?][X]  = +/- radius[X];   cuboid0[0][Y]  = +/- radius[Y];   cuboid0[0][Z]  = +/- radius[Z];
     
     */
    
    
    cuboid0[0][X]  = +radius[X];   cuboid0[0][Y]  = + radius[Y];   cuboid0[0][Z]  = + radius[Z];
    cuboid0[1][X]  = -radius[X];   cuboid0[1][Y]  = + radius[Y];   cuboid0[1][Z]  = + radius[Z];
    cuboid0[2][X]  = -radius[X];   cuboid0[2][Y]  = - radius[Y];   cuboid0[2][Z]  = + radius[Z];
    cuboid0[3][X]  = +radius[X];   cuboid0[3][Y]  = - radius[Y];   cuboid0[3][Z]  = + radius[Z];
    
    cuboid0[4][X]  = +radius[X];   cuboid0[4][Y]  = + radius[Y];   cuboid0[4][Z]  = - radius[Z];
    cuboid0[5][X]  = -radius[X];   cuboid0[5][Y]  = + radius[Y];   cuboid0[5][Z]  = - radius[Z];
    cuboid0[6][X]  = -radius[X];   cuboid0[6][Y]  = - radius[Y];   cuboid0[6][Z]  = - radius[Z];
    cuboid0[7][X]  = +radius[X];   cuboid0[7][Y]  = - radius[Y];   cuboid0[7][Z]  = - radius[Z];
    
    
    
    
    
    // cuboid = cuboid0
    
    
    for (int n = 0; n < CORNERS; n ++)
    {
        for (int axis = 0; axis < DIM; axis ++)
        {
            cuboid[n][axis] = cuboid0[n][axis];
        }
    }
    
    
}

-(void)resetRotation
{
    
  //  NSLog(@"\n reset rotations");
    
    /*
     R = 1     0     0
     0     1     0
     0     0     1
     
     
     R[X][X] = 1, etcetra
     
     */
    
    
    for (int i =0; i < DIM; i ++)
    {for (int j = 0; j < DIM; j++)
    {
        rotations[i][j] = 0;
    }
    }
    
    rotations[X][X] = 1;
    rotations[Y][Y] = 1;
    rotations[Z][Z] = 1;
    
    
}


-(void) evolve:(id) object
{
    while (YES)
    {
        backGroundNumber = (backGroundNumber + 1) % 4;
        
        // NSLog(@"\nevolve");
        for ( int i = 0; i < 100; i++)
        {
            //update InverseInertia, Omega, RotationMatrix, Cuboid
            [ self updateII];
            [self updateOmega];
            [self updateRotationMatrix];
            [ self updateCuboids];
            
        }
        [self display];
        
        //[self setNeedsDisplay:YES];
        [NSThread sleepForTimeInterval:0.003];
    }
    
    //Update display
    
    
}


-(void)updateII
{
    

    
    
    //STEP 1> Io-1 RT   ( note that Rt = R )
    long double I_Rt [DIM][DIM];
    {
        // calculateing traspose of R
        
        long double rotationsT[DIM][DIM];
        
        for (int i = 0 ; i < DIM; i ++ )
        {
            for (int j = 0; j < DIM; j++)
            {
                rotationsT[i][j] = rotations[j][i];
            }
            
        }
        
        
        // 1st row
        I_Rt[X][X] = Ii0[X][X] * rotationsT[X][X]  + Ii0[X][Y] * rotationsT[Y][X] + Ii0[X][Z] * rotationsT[Z][X];
        I_Rt[X][Y] = Ii0[X][X] * rotationsT[X][Y]  + Ii0[X][Y] * rotationsT[Y][Y] + Ii0[X][Z] * rotationsT[Z][Y];
        I_Rt[X][Z] = Ii0[X][X] * rotationsT[X][Z]  + Ii0[X][Y] * rotationsT[Y][Z] + Ii0[X][Z] * rotationsT[Z][Z];
        
        //2nd row
        I_Rt[Y][X] = Ii0[Y][X] * rotationsT[X][X]  + Ii0[Y][Y] * rotationsT[Y][X] + Ii0[Y][Z] * rotationsT[Z][X];
        I_Rt[Y][Y] = Ii0[Y][X] * rotationsT[X][Y]  + Ii0[Y][Y] * rotationsT[Y][Y] + Ii0[Y][Z] * rotationsT[Z][Y];
        I_Rt[Y][Z] = Ii0[Y][X] * rotationsT[X][Z]  + Ii0[Y][Y] * rotationsT[Y][Z] + Ii0[Y][Z] * rotationsT[Z][Z];
        
        //3rd row
        I_Rt[Z][X] = Ii0[Z][X] * rotationsT[X][X]  + Ii0[Z][Y] * rotationsT[Y][X] + Ii0[Z][Z] * rotationsT[Z][X];
        I_Rt[Z][Y] = Ii0[Z][X] * rotationsT[X][Y]  + Ii0[Z][Y] * rotationsT[Y][Y] + Ii0[Z][Z] * rotationsT[Z][Y];
        I_Rt[Z][Z] = Ii0[Z][X] * rotationsT[X][Z]  + Ii0[Z][Y] * rotationsT[Y][Z] + Ii0[Z][Z] * rotationsT[Z][Z];
    }
    
    
    
    //STEP 2> R ( I_Rt)
    {
        //1st row
        Ii[X][X] = rotations[X][X] * I_Rt[X][X]  + rotations[X][Y] * I_Rt[Y][X] + rotations[X][Z] * I_Rt[Z][X];
        Ii[X][Y] = rotations[X][X] * I_Rt[X][Y]  + rotations[X][Y] * I_Rt[Y][Y] + rotations[X][Z] * I_Rt[Z][Y];
        Ii[X][Z] = rotations[X][X] * I_Rt[X][Z]  + rotations[X][Y] * I_Rt[Y][Z] + rotations[X][Z] * I_Rt[Z][Z];
        
        //2nd row
        Ii[Y][X] = rotations[Y][X] * I_Rt[X][X]  + rotations[Y][Y] * I_Rt[Y][X] + rotations[Y][Z] * I_Rt[Z][X];
        Ii[Y][Y] = rotations[Y][X] * I_Rt[X][Y]  + rotations[Y][Y] * I_Rt[Y][Y] + rotations[Y][Z] * I_Rt[Z][Y];
        Ii[Y][Z] = rotations[Y][X] * I_Rt[X][Z]  + rotations[Y][Y] * I_Rt[Y][Z] + rotations[Y][Z] * I_Rt[Z][Z];
        
        //3rd row
        Ii[Z][X] = rotations[Z][X] * I_Rt[X][X]  + rotations[Z][Y] * I_Rt[Y][X] + rotations[Z][Z] * I_Rt[Z][X];
        Ii[Z][Y] = rotations[Z][X] * I_Rt[X][Y]  + rotations[Z][Y] * I_Rt[Y][Y] + rotations[Z][Z] * I_Rt[Z][Y];
        Ii[Z][Z] = rotations[Z][X] * I_Rt[X][Z]  + rotations[Z][Y] * I_Rt[Y][Z] + rotations[Z][Z] * I_Rt[Z][Z];
        
    }
    
    
    
}


-(void) updateOmega
{
    
    
    //  NSLog(@"\n update omeg");
    /*omega = I^-1 L */
    
    omega[X] = Ii[X][X] * angularMomentum[X]  + Ii[X][Y] * angularMomentum[Y]   + Ii[X][Z] * angularMomentum[Z];
    omega[Y] = Ii[Y][X] * angularMomentum[X]  + Ii[Y][Y] * angularMomentum[Y]   + Ii[Y][Z] * angularMomentum[Z];
    omega[Z] = Ii[Z][X] * angularMomentum[X]  + Ii[Z][Y] * angularMomentum[Y]   + Ii[Z][Z] * angularMomentum[Z];
    
}


-(void) updateRotationMatrix
{
    // NSLog(@"\n update rotations2");
    long double dR[DIM];
    for (int d = 0; d < DIM; d++)
    {
        dR[d] = 0;
    }
    
    for (int d = 0; d < DIM; d++)
    {
        
        dR[X]=    (omega[Y]*rotations[Z][d] - omega[Z] * rotations[Y][d])* dt ;
        dR[Y]=    (omega[Z]*rotations[X][d] - omega[X] * rotations[Z][d])* dt;
        dR[Z]=    (omega[X]*rotations[Y][d] - omega[Y] * rotations[X][d])* dt;
        
        rotations[X][d] = rotations[X][d] + dR[X];
        rotations[Y][d] = rotations[Y][d] + dR[Y];
        rotations[Z][d] = rotations[Z][d] + dR[Z];
        
           }
}

-(void) updateCuboids
{
    
    // NSLog(@"\n cuboids II");
    
    //C = R Co
    
    for ( int corner = 0; corner < CORNERS; corner ++)
    {
        cuboid[corner][X] = (rotations[X][X] * cuboid0[corner][X]) + (rotations[X][Y] * cuboid0[corner][Y]) + (rotations[X][Z] * cuboid0[corner][Z]);
        cuboid[corner][Y] = (rotations[Y][X] * cuboid0[corner][X]) + (rotations[Y][Y] * cuboid0[corner][Y]) + (rotations[Y][Z] * cuboid0[corner][Z]);
        cuboid[corner][Z] = (rotations[Z][X] * cuboid0[corner][X]) + (rotations[Z][Y] * cuboid0[corner][Y]) + (rotations[Z][Z] * cuboid0[corner][Z]);
    }
    
    
    //    for ( int r = 0; r < DIM; r ++)
    //    {
    //        for ( int c = 0; c < CORNERS; c++ )
    //        {
    //            cuboid[c][r] = 0;
    //            for  (int s = 0; s < DIM; s++)
    //            {
    //                cuboid[c][r] += rotations[s][r] * cuboid0[c][s];
    //            }
    //        }
    //    }
    //
    
    //
    //    //1st row
    //    cuboid[X][X] = rotations[X][X] * cuboid0[X][X]  + rotations[X][Y] * cuboid0[Y][X] + rotations[X][Z] * cuboid0[Z][X];
    //    cuboid[X][Y] = rotations[X][X] * cuboid0[X][Y]  + rotations[X][Y] * cuboid0[Y][Y] + rotations[X][Z] * cuboid0[Z][Y];
    //    cuboid[X][Z] = rotations[X][X] * cuboid0[X][Z]  + rotations[X][Y] * cuboid0[Y][Z] + rotations[X][Z] * cuboid0[Z][Z];
    //
    //    //2nd row
    //    cuboid[Y][X] = rotations[Y][X] * cuboid0[X][X]  + rotations[Y][Y] * cuboid0[Y][X] + rotations[Y][Z] * cuboid0[Z][X];
    //    cuboid[Y][Y] = rotations[Y][X] * cuboid0[X][Y]  + rotations[Y][Y] * cuboid0[Y][Y] + rotations[Y][Z] * cuboid0[Z][Y];
    //    cuboid[Y][Z] = rotations[Y][X] * cuboid0[X][Z]  + rotations[Y][Y] * cuboid0[Y][Z] + rotations[Y][Z] * cuboid0[Z][Z];
    //
    //    //3rd row
    //    cuboid[Z][X] = rotations[Z][X] * cuboid0[X][X]  + rotations[Z][Y] * cuboid0[Y][X] + rotations[Z][Z] * cuboid0[Z][X];
    //    cuboid[Z][Y] = rotations[Z][X] * cuboid0[X][Y]  + rotations[Z][Y] * cuboid0[Y][Y] + rotations[Z][Z] * cuboid0[Z][Y];
    //    cuboid[Z][Z] = rotations[Z][X] * cuboid0[X][Z]  + rotations[Z][Y] * cuboid0[Y][Z] + rotations[Z][Z] * cuboid0[Z][Z];
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    static const NSImage *backImage = [ NSImage imageNamed: @"3"];
    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
    
    [ backImage drawInRect:dirtyRect
                  fromRect:backRect
                 operation:NSCompositeCopy
                  fraction:1.0];

    
    
    switch (BackgroundStyle)
    {
    
  
 
        case 0: // normal
        {static const NSImage *backImage = [ NSImage imageNamed: @"LightSpeed"];
            static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
            
            [ backImage drawInRect:dirtyRect
                          fromRect:backRect
                         operation:NSCompositeCopy
                          fraction:1.0];
        }
            break;
            
        case 1: // blue
        {
            
            static const NSImage *backImage = [ NSImage imageNamed: @"BluePrints"];
            static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
            
            [ backImage drawInRect:dirtyRect
                          fromRect:backRect
                         operation:NSCompositeCopy
                          fraction:1.0];
            
        } break;
            
            
            
        case 2: // falling
        { switch (backGroundNumber)
            {
                case 0:{static const NSImage *backImage = [ NSImage imageNamed: @"0"];
                    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
                    
                    [ backImage drawInRect:dirtyRect
                                  fromRect:backRect
                                 operation:NSCompositeCopy
                                  fraction:1.0];
                }break;
                case 1:{static const NSImage *backImage = [ NSImage imageNamed: @"2"];
                    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
                    
                    [ backImage drawInRect:dirtyRect
                                  fromRect:backRect
                                 operation:NSCompositeCopy
                                  fraction:1.0];
                }break;
                case 2:{static const NSImage *backImage = [ NSImage imageNamed: @"1"];
                    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
                    
                    [ backImage drawInRect:dirtyRect
                                  fromRect:backRect
                                 operation:NSCompositeCopy
                                  fraction:1.0];
                }break;
                case 3:{static const NSImage *backImage = [ NSImage imageNamed: @"3"];
                    static const NSRect backRect = NSMakeRect(0, 0, [backImage size].width, [backImage size].height);
                    
                    [ backImage drawInRect:dirtyRect
                                  fromRect:backRect
                                 operation:NSCompositeCopy
                                  fraction:1.0];
                }break;
                    
            }
        }
            break;
            
    }

    
    
    
    //NSLog(@"\n drawrect");
    // make points from coreners
    for(int c = 0; c < CORNERS; c++)
    {
        
        long double lambdaP = 1 / (1- cuboid[c][Z] / eye);
        
        projection[c].x = magnify * lambdaP* cuboid[c][X];
        projection[c].y = magnify * lambdaP* cuboid[c][Y];
    }
    
    // draw Edges with move to line to
    
    
    
    
    [[NSColor redColor] set];

    
    switch (DrawingStyle)
    {
        case 0: // frame
        {
            
            [self drawEdges];
        
        }
            break;
        case 1: // faces
        {
            
            

            
            
            [self drawEdges];
            [self drawFaces];
        }
            break;
    }


    //  NSLog(@"corner 0 %Lf", cuboid[0][X]);
    
    
    
}


- (void) drawEdges
{
    [[NSColor redColor] set];
    NSBezierPath *frame = [NSBezierPath bezierPath];
    {
        // move to 0 point, line to 1, 2, 3, 0
        [frame moveToPoint:projection[0]];
        [frame lineToPoint:projection[1]];
        [frame lineToPoint:projection[2]];
        [frame lineToPoint:projection[3]];
        [frame lineToPoint:projection[0]];
        
        // move to 4 corner, line to 5, 6, 7, 4
        [frame moveToPoint:projection[4]];
        [frame lineToPoint:projection[5]];
        [frame lineToPoint:projection[6]];
        [frame lineToPoint:projection[7]];
        [frame lineToPoint:projection[4]];
        
        
        //move to 4, line to 0
        [frame moveToPoint:projection[4]];
        [frame lineToPoint:projection[0]];
        
        //move to 5, line to 1
        [frame moveToPoint:projection[5]];
        [frame lineToPoint:projection[1]];
        
        //move to 6, line to 1
        [frame moveToPoint:projection[6]];
        [frame lineToPoint:projection[2]];
        
        //move to 7, line to 3
        [frame moveToPoint:projection[7]];
        [frame lineToPoint:projection[3]];
    }
    [frame stroke];
}


-(void)drawFaces
{
    long double gray;
    
    
     //side 1
    if ( ( gray = [self grayForVerticies: 0 : 1 : 2]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[0]];
            [face lineToPoint : projection[1]];
            [face lineToPoint : projection[2]];
            [face lineToPoint : projection[3]];
           
        }
        [face fill];
    }
    
    // side 2
    if ( ( gray = [self grayForVerticies: 1 : 5 : 6]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[1]];
            [face lineToPoint : projection[5]];
            [face lineToPoint : projection[6]];
            [face lineToPoint : projection[2]];
                    }
        [face fill];
    }

    // side 3
    if ( ( gray = [self grayForVerticies: 2 : 6 : 7]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[2]];
            [face lineToPoint : projection[6]];
            [face lineToPoint : projection[7]];
            [face lineToPoint : projection[3]];
        }
        [face fill];
    }
    
    
    // side 4
    if ( ( gray = [self grayForVerticies: 0 : 3 : 7]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[0]];
            [face lineToPoint : projection[3]];
            [face lineToPoint : projection[7]];
            [face lineToPoint : projection[4]];
        }
        [face fill];
    }
    
    
    
    // side 5
    if ( ( gray = [self grayForVerticies: 1 : 0 : 4]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[1]];
            [face lineToPoint : projection[0]];
            [face lineToPoint : projection[4]];
            [face lineToPoint : projection[5]];
        }
        [face fill];
    }
    
    
    // side 6
    if ( ( gray = [self grayForVerticies: 5 : 4 : 7]) > 0 )// 0, 1, 2 are corner IDs if not visible, then negative value. iF gray positive than k
    {
        [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint : projection[5]];
            [face lineToPoint : projection[4]];
            [face lineToPoint : projection[7]];
            [face lineToPoint : projection[6]];
        }
        [face fill];
    }
}

long double DOT(long double x[3] , long double y[3])
{
    return ((x[0]*y[0]) + (x[1]*y[1]) + (x[2]*y[2]));
}

-(long double) grayForVerticies:(int)i0 :(int) i1 :(int) i2
{
    
    //  long double vectorV01[DIM], vectorV02[DIM];
    
    
    long double  vectorV01[DIM] = {
        (cuboid [i1][X] - cuboid[i0][X]) ,
        (cuboid [i1][Y] - cuboid[i0][Y])  ,
        (cuboid [i1][Z] - cuboid[i0][Z])
    };
    
    long double vectorV02[DIM] = {
        cuboid [i2][X] - cuboid[i1][X],
        cuboid [i2][Y] - cuboid[i1][Y],
        cuboid [i2][Z] - cuboid[i1][Z]
    };
    
    
    long double magnitudeV01, magnitudeV02;
    magnitudeV01 = sqrtl(DOT(vectorV01, vectorV01));
    magnitudeV02 = sqrtl(DOT(vectorV02, vectorV02));
    
    long double unitV01[DIM], unitV02[DIM];
    
    unitV01[X] = vectorV01[X] / magnitudeV01;
    unitV01[Y] = vectorV01[Y] / magnitudeV01;
    unitV01[Z] = vectorV01[Z] / magnitudeV01;
    
    unitV02[X] = vectorV02[X] / magnitudeV02;
    unitV02[Y] = vectorV02[Y] / magnitudeV02;
    unitV02[Z] = vectorV02[Z] / magnitudeV02;
    
    
    
    long double normal[DIM]; // cross product of unit vec 1 X unit vec 2
    normal[X] = (unitV01[Y] * unitV02[Z])  - (unitV01[Z] * unitV02[Y]);
    normal[Y] = (unitV01[Z] * unitV02[X])  - (unitV01[X] * unitV02[Z]);
    normal[Z] = (unitV01[X] * unitV02[Y])  - (unitV01[Y] * unitV02[X]);
    // a X b = < [(a1 b3) - (a3 b1)] [(a3 b1) - (a1 b3)] [(a1 b2)-(a2 b1)]>
    

    
    long double vectorCenter[DIM];
    vectorCenter[X] = (cuboid[i0][X] + cuboid[i2][X])/2.0;
    vectorCenter[Y] = (cuboid[i0][Y] + cuboid[i2][Y])/2.0;
    vectorCenter[Z] = (cuboid[i0][Z] + cuboid[i2][Z])/2.0;
    
    
    long double vectorE[DIM];
    vectorE[X] = 0;vectorE[Y] =0; vectorE[Z] = eye; // = e
    
    long double vectorCenterEye[DIM];
    vectorCenterEye[X] = vectorE[X] - vectorCenter[X];
    vectorCenterEye[Y] = vectorE[Y] - vectorCenter[Y];
    vectorCenterEye[Z] = vectorE[Z] - vectorCenter[Z];
    
    long double eyeDotNormal;
    eyeDotNormal = DOT(vectorCenterEye, normal);
    
    if (eyeDotNormal >0.0)
    {
        long double hatLight[DIM];
        hatLight[X] = 1/sqrtl(2);
        hatLight[Y] = 0;
        hatLight[Z] = 1/sqrtl(2);
        
        
        long double normalDotLight = DOT(normal,hatLight);

        
        // brightest when light is head on, and smaller as you get the normal to go horizontal to light.
        
        static long double grayMin = 0.1;
        static long double grayMax = 0.9;
        
        long double gray = grayMin + (grayMax - grayMin) * ( (normalDotLight + 1.0) / 2.0);
        

        

       
        return gray;
        
    }
    
    else // face pointed away from user
    {
        return -1.0;
    }
    
    
    /*
     
     ALGORITHM
     
     vecV01 = Ci1 - Ci0
     vecV02 = Ci2 - Ci0
     
     magV01 = Sqrt(V01 . V01)
     magV02 = Sqrt(V02 . V02)
     
     unitV01 = vecV01 / magV01
     unitV02 = vecV02 / magV02
     
     normal = unitV01 X unitV02
     
     long double normal [DIM] =
     {
     hat01[Y] *hat 12[Z] - hat01[X]*hat12[Y],
     etc
     };
     
     VecCenter = (Ci0 + Ci2) / 2.0
     
     vec_e = {0,0,e};
     
     vecCenterEye = vec_e-vecCenter
     eyeDotNormal = vecCenterEye . normal
     
     if (eyeDotNormal  > 0.0)
     {
     vector hatLight = { 1/sqrt(2), 0, 1/sqrt(2)}
     normalDotLight = normal . hatLight
     
     // brightest when light is head on, and smaller as you get the normal to go horizontal to light.
     
     static double grayMin = 0.1;
     static double grayMax = 0.9;
     
     long double gray = grayMin + (grayMax - grayMin) * ( (normalDotLight + 1.0) / 2.0)
     
     return gray;
     
     }
     
     else // face pointed away from user
     {
     return -1.0;
     }
     
     */
    
}

-(void)resetForLengths
{
    // TWO RESETS AND THREE OR FOUR UPDATES
    

    [self resetInertia];
    [self resetMomentum];
    [self resetCuboids];
    [self updateII];
    [self updateOmega];
    [self updateRotationMatrix];
    [self updateCuboids];
}

-(IBAction)UpdateX:(id)sender
{
    radius[X] = [RadXSlider doubleValue];
    [self resetForLengths];
    
    [self setNeedsDisplay:YES];
}
-(IBAction)UpdateY:(id)sender
{
    radius[Y] = [RadYSlider doubleValue];
    [self resetForLengths];
    
    [self setNeedsDisplay:YES];
}
-(IBAction)UpdateZ:(id)sender;
{
    radius[Z] = [RadZSlider doubleValue];
    [self resetForLengths];
    
    [self setNeedsDisplay:YES];
}

-(IBAction)updateGeneral:(id)sender
{
    eye  = [eyeSlider doubleValue];
    magnify  = [magnifySlider doubleValue];
    
    [ self updateII];
    [self updateOmega];
    [self updateRotationMatrix];
    [ self updateCuboids];
    
    [self setNeedsDisplay:YES];

}


-(IBAction)updateOmega:(id)sender
{
    omega0[X]  = [OmegXSlider doubleValue];
    omega0[Y]  = [OmegYSlider doubleValue];
    omega0[Z]  = [OmegZSlider doubleValue];
    
    [OmegXText setDoubleValue:     omega0[X] ];
    [OmegYText setDoubleValue:     omega0[Y] ];
    [OmegZText     setDoubleValue:     omega0[Z]     ];
    

    [self resetOmega];
    [self resetMomentum];
    [self resetRotation];

    
    [ self updateII];
    [self updateOmega];
    [self updateRotationMatrix];
    [ self updateCuboids];

    
}




- (IBAction)chageBackgroundStyle:(id)sender
{
    BackgroundStyle = [sender tag];
   // NSLog(@"BackGroundStyle %ld", (long)[sender tag]);
    
    [self display];
}
- (IBAction)chageDrawingStyle:(id)sender
{
    DrawingStyle = [sender tag];
    [self display];
}


@end
