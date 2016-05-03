//
//  SphereView.m
//  Sphere
//
//  Created by Avi on 4/25/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "SphereView.h"

@implementation SphereView


-(void)awakeFromNib
{
    //translate origin to the center
    {
    NSRect boundsRect = [self bounds];
    double x = boundsRect.size.width / 2;
    double y = boundsRect.size.height / 2;
    [self translateOriginToPoint:NSMakePoint(x, y)];
    }
    
    [self initalisations];
    [self reset:self];

    
    

}
-(void)initalisations
{
    // initialise the input text field values
    {
        [slicesText   setDoubleValue:   numSlices= 30];
        [wedgesText   setDoubleValue:   numWedges= 30];
        [slicesSlider setDoubleValue:   numSlices];
        [wedgesSlider setDoubleValue:   numWedges];
        
        [radiusText   setDoubleValue:   radius= 10];
        [radiusSlider setDoubleValue:   radius];
        
        [eyeSlider   setIntValue:   eye= 20];

    }
    
    // initialise data structure for sphere
    {
    numPoints = numSlices * numWedges;

        
    
    }
    
    
    
    
}



-(IBAction) reset:(id)sender
{
    numWedges             = [wedgesSlider intValue];
    numSlices             = [slicesSlider intValue];
    radius             = [radiusSlider doubleValue];
    eye                 = [eyeSlider intValue];

    [slicesSlider setIntValue:   numSlices];
    [wedgesSlider setIntValue:   numWedges];
    [radiusSlider setIntValue:   radius];

    int numWalkers = 1;
    for (int  i= 0; i < numWalkers; i++)
    {
        Walkers.push_back(randomWalker(1000));
       // timeDuration = timeDuration* decreaseFactor;
        
    }

    
    [self display];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] set];
    [ NSBezierPath fillRect:dirtyRect];


  // [self drawSphere];
   [self drawSphereFaces];
    [self drawWalker:Walkers[0]];
}


-(void)drawSphere
{
    
    
    double dTheta = (M_PI) / numSlices;
    double dPhi = (2*M_PI) / numWedges;
    

    
    for ( int n = 0; n < numSlices; n++)
    {
        double theta = n*dTheta;
        
        for (int m = 0; m <= numWedges; m++)
        {
            double phi = m*dPhi;
            
            
            
            sphere[n][m].x = sin(theta) * cos(phi) * radius;
            sphere[n][m].y = sin(theta) * sin(phi) * radius;
            sphere[n][m].z = cos(theta) * radius;
            
            //  NSLog(@"X = %lf, Y= %lf, Z = %lf", sphere[n][m].x, sphere[n][m].y, sphere[n][m].z );
        }
    }
    
    
    
    for ( int n = 0; n < numSlices; n++)
    {
        
        for (int m = 0; m <= numWedges; m++)
        {
            
            long double lambdaP = 1 / (1- sphere[n][m].z / eye);
            
            projection[n][m].x = radius * sphere[n][m].x *lambdaP; // *lambdaP
            projection[n][m].y = radius * sphere[n][m].y *lambdaP; // *lambdaP
            
            
        }
    }
    

    
    
    
    // Creating the sphere grid
    [[NSColor redColor] set];
    NSBezierPath *frame = [NSBezierPath bezierPath];
    [frame moveToPoint:NSMakePoint(0, 0)];
   for ( int n = 0; n < numSlices; n++)
    {
        for (int m = 0; m <= numWedges; m++)
        {
            NSPoint spherePoint= projection[n][m];
           // [frame moveToPoint: spherePoint];
            [frame lineToPoint: spherePoint];
        }
    }
    [frame stroke];
    
    
    
    
    [[NSColor blueColor] set];
    NSBezierPath *triangel = [NSBezierPath bezierPath];
    

    
    // creating the even triangles
       {
        for ( int n = 0; n < numSlices; n++)
        {
            for (int m = 0; m <= numWedges; m++)
            {
                
                       
                [triangel moveToPoint: projection[n][m]];
                [triangel lineToPoint: projection[n][m+1]];
                [triangel lineToPoint: projection[n+1][m]];
                [triangel lineToPoint: projection[n][m]];
               
                
                
                
            }
        }
        
        
 
    }   [triangel fill];
    
    
    // creating the odd triangels
    [[NSColor greenColor] set];
    NSBezierPath *triangel2 = [NSBezierPath bezierPath];
    {
        for ( int n = 0; n < numSlices; n++)
        {
            for (int m = 0; m <= numWedges; m++)
            {
                
                [triangel2 moveToPoint: projection[n][m]];
                [triangel2 lineToPoint: projection[n+1][m]];
                [triangel2 lineToPoint: projection[n+1][m-1]];
                [triangel2 lineToPoint: projection[n][m]];
            }
        }
        
        
        
    }   [triangel2 fill];
    
    
    
    // how is above working? Shouldnt it be below?
    [[NSColor yellowColor] set];
    NSBezierPath *test = [NSBezierPath bezierPath];
    {
        for (int n = 0; n < numSlices ; n ++){
        for (int m = 0; m < numWedges; m++){
        //int n = 1;
        
//        [test moveToPoint: projection[5][5]];
//        [test lineToPoint: projection[6][5]];
//        [test lineToPoint: projection[6][4]];
//        
//        [test moveToPoint: projection[5][6]];
//        [test lineToPoint: projection[6][6]];
//        [test lineToPoint: projection[6][5]];
            
            [test moveToPoint: projection[n][m]];
            [test lineToPoint: projection[n][m+1]];
            [test lineToPoint: projection[n+1][m]];

            
//            
//            [test moveToPoint: projection[n][m]];
//            [test lineToPoint: projection[n-1][m+1]];
//            [test lineToPoint: projection[n][m+1]];
            
        }}
        
    }[test fill];
    
    
}




-(void)drawSphereFaces
{
    
    
    double dTheta = (M_PI) / numSlices;
    double dPhi = (2*M_PI) / numWedges;
    
    
    

    
    
    //  int n, m;
    
    for ( int n = 0; n < numSlices; n++)
    {
        double theta = n*dTheta;
        
        for (int m = 0; m <= numWedges; m++)
        {
            double phi = m*dPhi;
            
            
            
            sphere[n][m].x = sin(theta) * cos(phi) * radius;
            sphere[n][m].y = sin(theta) * sin(phi) * radius;
            sphere[n][m].z = cos(theta) * radius;
            
            //  NSLog(@"X = %lf, Y= %lf, Z = %lf", sphere[n][m].x, sphere[n][m].y, sphere[n][m].z );
        }
    }
    
    
    
    for ( int n = 0; n < numSlices-1; n++)
    {
        
        for (int m = 0; m <= numWedges; m++)
        {
            
            long double lambdaP = 1 / (1- sphere[n][m].z / eye);
            
            projection[n][m].x = radius * lambdaP* sphere[n][m].x;
            projection[n][m].y = radius * lambdaP* sphere[n][m].y;
            
            
        }
    }
    

    
    
    
    
    
    // Creating the sphere grid
    [[NSColor redColor] set];
    NSBezierPath *frame = [NSBezierPath bezierPath];
    [frame moveToPoint:projection[0][0]];
    for ( int n = 0; n < numSlices; n++)
    {
        for (int m = 0; m <= numWedges; m++)
        {

            [frame lineToPoint: projection[n][m]];
        }
    }
    [frame stroke];
    
    
    
    
    double gray = 0;
    
    
    // creating the even triangles
    {
        for ( int n = 1; n < numSlices-1; n++)
        {
            for (int m = 0; m < numWedges; m++)
            {
                
                [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
                    //[[NSColor redColor] set];
                NSBezierPath *triangel = [NSBezierPath bezierPath];
                if((gray = [self grayForVerticiesEven:n : m] > 0))
                {
                    
                    [triangel moveToPoint: projection[n][m]];
                    [triangel lineToPoint: projection[n][m+1]];
                    [triangel lineToPoint: projection[n+1][m]];
                    [triangel lineToPoint: projection[n][m]];

                }
                
                
                [triangel fill];
                
                
                
                
                
            }
        }
        
        
        
    }
    
    
    // creating the odd triangels

    {
        for ( int n = 1; n <= numSlices; n++)
        {
            for (int m = 0; m <= numWedges-1; m++)
            {
                [[NSColor colorWithCalibratedWhite:gray alpha: 1.0] set];
                NSBezierPath *triangel = [NSBezierPath bezierPath];
                if((gray = [self grayForVerticiesOdd:n : m] > 0))
                {


                    [triangel moveToPoint: projection[n][m]];
                    [triangel lineToPoint: projection[n-1][m+1]];
                    [triangel lineToPoint: projection[n][m+1]];
                    [triangel lineToPoint: projection[n][m]];

                }
                [triangel fill];
            }
        }
        
        
        
    }
    
}



-(IBAction)update:(id)sender
{
    [self reset:self];
}






long double DOT(long double x[3] , long double y[3])
{
    return ((x[0]*y[0]) + (x[1]*y[1]) + (x[2]*y[2]));
}



/*
 V1 = vec from (n,m) --> (n,m+1)
 v2 = vec from (n,m) --> (n+1,m)
 
 
 (n, m) (n, m+1)
    *****
    *  *
    * *
    **
    *
 (n+1,m)
 
 */
-(long double) grayForVerticiesEven:(int)n :(int)m
{
    
    

    //  vec from x to y = y-x
    
    
    long double  vectorV01[DIM] =
    {

        
        
        (sphere  [n+1][m].x - sphere [n][m].x) ,
        (sphere  [n+1][m].y - sphere [n][m].y) ,
        (sphere  [n+1][m].z - sphere [n][m].z)

    };
    
    long double vectorV02[DIM] =
    {
        sphere [n][m+1].x - sphere [n][m].x,
        sphere [n][m+1].y - sphere [n][m].y,
        sphere [n][m+1].z - sphere [n][m].z
        
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
    vectorCenter[X] = (sphere[n][m+1].x + sphere[n+1][m].x)/2.0;
    vectorCenter[Y] = (sphere[n][m+1].y + sphere[n+1][m].y)/2.0;
    vectorCenter[Z] = (sphere[n][m+1].z + sphere[n+1][m].z)/2.0;
    
    
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
    
    
    
    
}




/*
 V1 = vec from (n,m+1) --> (n-1,m+1)
 v2 = vec from (n,m+2) --> (n,  m  )
 
 
           (n-1, m+1)
         ....*
         ...**
         ..* *
         .*  *
         *****
      (n,m)  (n, m+1)
 
 */
-(long double) grayForVerticiesOdd:(int)n :(int)m
{
    
    
    //  vec from x to y = y-x
    
    
    long double  vectorV01[DIM] = {
        (sphere  [n-1][m+1].x - sphere [n][m+1].x) ,
        (sphere  [n-1][m+1].y - sphere [n][m+1].y) ,
        (sphere  [n-1][m+1].z - sphere [n][m+1].z)
    };
    
    long double vectorV02[DIM] = {
        sphere [n][m].x - sphere [n][m+1].x,
        sphere [n][m].y - sphere [n][m+1].y,
        sphere [n][m].z - sphere [n][m+1].z
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
    vectorCenter[X] = (sphere[n][m-1].x + sphere[n+1][m].x)/2.0;
    vectorCenter[Y] = (sphere[n][m-1].y + sphere[n+1][m].y)/2.0;
    vectorCenter[Z] = (sphere[n][m-1].z + sphere[n+1][m].z)/2.0;
    
    
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
    
    
    
    
}




-(void)drawWalker:(randomWalker)myWalker
{
    [[NSColor redColor] set];
    NSBezierPath *walker_line = [NSBezierPath bezierPath];
    {
        
        double diagLength  = radius;
        double horizLength =radius;
        double vertLength  =radius;
        
        
        
        [walker_line setLineWidth: 3.0];
        
        int n,m;
        n=5; m=5;
        [walker_line moveToPoint: projection[n][m] ];
        
        
        // move according to the choices made
        for (int i = 0 ; i < myWalker.num_choices_taken; i ++)
        {
            int choice = arc4random() % 6; // either 1, 2, 3 , 4, 0 (which is 5)
            
            
            switch (choice)
            {
                case 0:
                {
                    
                    if (m < maxWedges){

                    myWalker.path[i] = 0;
                    
                                       // [walker_line relativeLineToPoint: NSMakePoint(horizLength*cos(0), horizLength*sin (0))];
                    [walker_line lineToPoint:projection[n][m+1]];
                    m+=1;
                    
                    //m = (maxWedges -1 ) ? m : m+=1 ;
                    }
                }
                    break;

                    
                case 1:
                {
                    if (m < maxWedges && n > 1){
                    myWalker.path[i] = 1;
                    //[walker_line relativeLineToPoint: NSMakePoint(diagLength*cos(  M_PI / 8 ), diagLength* sin(  M_PI / 8 ))];
                    [walker_line lineToPoint:projection[n-1][m+1]];
                    
//                    m = (maxWedges -1 ) ? m : m+=1 ;
//                    n = (1) ? n : n=n-1;
//
                    n=n-1;
                    m+=1;
                    }
                }
                    break;
                case 2:
                {
                    if ( n > 1){
                    myWalker.path[i] = 2;
                    //[walker_line relativeLineToPoint: NSMakePoint(vertLength*cos( 2* M_PI / 8 ), vertLength* sin( 2* M_PI / 8 ))];
                    [walker_line lineToPoint:projection[n-1][m]];
                    n=n-1;
//                    n = (1) ? n : n=n-1;
                    }
                    
                }
                    break;
                    
                case 3:
                {
                    if (m > 0){
                    myWalker.path[i] = 3;
                   // [walker_line relativeLineToPoint: NSMakePoint(horizLength*cos( 4* M_PI / 8 ), horizLength* sin( 4* M_PI / 8 ))];
                    [walker_line lineToPoint:projection[n][m-1]];
                   m=m-1;
//                    m = (1) ? m : m=m-1;
                    }

                }
                    break;
                    
                case 4:
                { if (n < maxSlices && m >= 1){
                    myWalker.path[i] = 4;
                   // [walker_line relativeLineToPoint: NSMakePoint(diagLength*cos(  5*M_PI / 8 ), diagLength* sin( 5* M_PI / 8 ))];
 [walker_line lineToPoint:projection[n+1][m-1]];
                    n+=1; m=m-1;
                    
//                    m = (1) ? m : m=m-1 ;
//                    n = (maxSlices -1 ) ? n : n=n+1;
//
                }
                }
                    break;
                    
                    
                case 5:
                {
                    if(n < maxSlices){
                    myWalker.path[i] = 5;
                 //   [walker_line relativeLineToPoint:  NSMakePoint(vertLength*cos( 6* M_PI / 8 ), vertLength* sin( 6* M_PI / 8 ))];
                 [walker_line lineToPoint:projection[n+1][m]];
                    n+=1;
                    
//                     n = (maxSlices -1 ) ? n : n=n+1;
                        
                    }
                }
                    break;
            }
        }
        
    }
    [walker_line stroke];
    
    

    
}



@end
