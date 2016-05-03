//
//  TrackView.m
//  TrackCylinder
//
//  Created by John Lindner on 4/30/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import "TrackView.h"

@implementation TrackView

-(void)awakeFromNib
{
    NSRect box = [self bounds];
    [self translateOriginToPoint:NSMakePoint(box.size.width/2, box.size.height/2)];
    
    theta = 0;
    [self updateRotationMatrix];
    [self updateVertices];

    magnify = 100.0;
    eyePoint = 20.0;
    
    
    for (int i =0; i < N_TRIANGLES; i++)
    {
        
        verticies myVerticies( triangleVertices[i][X] , triangleVertices[i][Y], triangleVertices[i][Z]);
        
        verticies neighbours[3];
        
        /*
         following section of code goes through the triangle verticies and finds the triangles sharing sides
         */
        for (int j = 0; j < N_TRIANGLES; j++)
        {
            
            verticies searchVal(triangleVertices[j][X] , triangleVertices[j][Y], triangleVertices[j][Z]);
            
            
//            NSLog(@"******* TRIANGLE %d ********\n", i);
//           NSLog(@"Search Val (%d,%d,%d)\n", searchVal.x,searchVal.y,searchVal.z );
//            NSLog(@"My Val (%d,%d,%d)\n", myVerticies.x,myVerticies.y,myVerticies.z );

            
            
            bool firstValMatch  = ((searchVal.x == myVerticies.x) || (searchVal.x == myVerticies.y) ||(searchVal.x == myVerticies.z));
            bool secondValMatch = ((searchVal.y == myVerticies.x) || (searchVal.y == myVerticies.y) ||(searchVal.y == myVerticies.z));
            bool thirdValMatch  = ((searchVal.z == myVerticies.x) || (searchVal.z == myVerticies.y) ||(searchVal.z == myVerticies.z));
            

            
            
          // if ( ((searchVal.x == myVerticies.x) && (searchVal.y == myVerticies.y) && (searchVal.z == myVerticies.z)) == false)
            
            if (not (firstValMatch && secondValMatch && thirdValMatch) )
            {
                    NSLog(@"true? \n");
                
                if ( firstValMatch && secondValMatch )
                {
                   // NSLog(@"Found Neighbour 1 \n");
                    neighbours[0].x = searchVal.x;
                    neighbours[0].y = searchVal.y;
                    neighbours[0].z = searchVal.z;
                }
                
                
                if ( firstValMatch && thirdValMatch)
                {
                   //  NSLog(@"Found Neighbour 2 \n");
                    neighbours[1].x = searchVal.x;
                    neighbours[1].y = searchVal.y;
                    neighbours[1].z = searchVal.z;
                }
                
                if (secondValMatch && thirdValMatch)
                {
                   // NSLog(@"Found Neighbour 3 \n");
                    neighbours[2].x = searchVal.x;
                    neighbours[2].y = searchVal.y;
                    neighbours[2].z = searchVal.z;
                }
            
                
                //USE A STACK!!!
                

            }
//            else
//            {NSLog(@"Search Val is the same as the myVert (%d,%d,%d)\n", searchVal.x,searchVal.y,searchVal.z );}
            // at this point, we will have populated our neighbour array with adjacent triangle verticies
        }
        
        
        
        NSLog(@"Triangle: (%d,%d,%d)\n",    myVerticies.x,    myVerticies.y,    myVerticies.z);
        
        NSLog(@"Neighbour1: (%d,%d,%d)\n",  neighbours[0].x,  neighbours[0].y,  neighbours[0].z);
        
        
        NSLog(@"Neighbour2: (%d,%d,%d)\n",  neighbours[1].x,  neighbours[1].y,  neighbours[1].z);
        
        
        NSLog(@"Neighbour3: (%d,%d,%d)\n",  neighbours[2].x,  neighbours[2].y,  neighbours[2].z);
        
        triangle myTriangle( myVerticies, neighbours);
        triangleList.push_back(myTriangle);
    }
    
    
    for (int i = 0; i < N_TRIANGLES; i ++)
    {
//        NSLog(@"******* TRIANGLE %d ********", i);
//        
//        NSLog(@"Triangle: (%d,%d,%d)\n",   triangleList[i].myVerticies.x,   triangleList[i].myVerticies.y,   triangleList[i].myVerticies.z);
//        
//        NSLog(@"Neighbour1: (%d,%d,%d)\n", triangleList[i].neighbours[0].x, triangleList[i].neighbours[0].y, triangleList[i].neighbours[0].z);
//        
//        
//        NSLog(@"Neighbour2: (%d,%d,%d)\n", triangleList[i].neighbours[1].x, triangleList[i].neighbours[1].y, triangleList[i].neighbours[1].z);
//        
//        
//        NSLog(@"Neighbour3: (%d,%d,%d)\n", triangleList[i].neighbours[2].x, triangleList[i].neighbours[2].y, triangleList[i].neighbours[2].z);
        
        
    }
    
}

- (void)updateRotationMatrix
{
    R[X][X] = 1;		R[Y][X] = 0;                R[Z][X] = 0;
    R[X][Y] = 0;		R[Y][Y] = cosl(theta);		R[Z][Y] = -sinl(theta);
    R[X][Z] = 0;        R[Y][Z] = sinl(theta);      R[Z][Z] = cosl(theta);
}

- (void)updateVertices
{
    for(short n = 0; n < N_VERTICES; n++)
    {
        for (short r = 0; r < DIM; r++)
        {
            vertex[n][r] = 0.0;
            for (short c = 0; c < DIM; c++)
            {
                vertex[n][r] += R[r][c] * vertex0[n][c];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    
    for(short n = 0; n < N_VERTICES; n++) // project vertices from 3D to 2D
    {
        double distance = magnify / (1.0 - vertex[n][Z] / eyePoint); // stereo projection
        while(distance != distance) distance = magnify / (1.0 - vertex[n][Z] / eyePoint); // in case NAN bug
        
        projection[n].x = distance*vertex[n][X];
        projection[n].y = distance*vertex[n][Y];
   }
    
    for(short n = 0; n < N_TRIANGLES; n++) // draw triangle faces
    {
        [self drawFace:n];
    }
    
    
    
    [[NSColor redColor] set];
    NSBezierPath *walker_line = [NSBezierPath bezierPath];
    {
        
        
        vector <randomWalker> Walkers;
        
        
        int numWalkers = 1;
        for (int  i= 0; i < numWalkers; i++)
        {
            Walkers.push_back(randomWalker(1000));
            // timeDuration = timeDuration* decreaseFactor;
            
        }

        randomWalker myWalker(1000);
        
        
        [walker_line setLineWidth: 3.0];
        
        int n,m;
        n=5; m=5;
        [walker_line moveToPoint: projection[0]];
        
        
        
        
        
        // move according to the choices made
        for (int i = 0 ; i < N_VERTICES; i ++)
        {
            int choice = arc4random() % 5; // either 1, 2, 3 , 4, 0 (which is 5)
            
            [walker_line lineToPoint: projection[i]];//[choice]];

            switch (choice) {
            
                // move to point up
                case 0:
                {}break;
            
                
                // move to point left
                case 1:
                {}break;
                    
                // move to point right
                case 2:
                {}break;
            
                    
                // move to point bottom left
                case 3:
                {}break;
                    
                // move to point bottom right
                case 4:
                {}break;
                    
                    
            
            }
            
        }
        
    }

        
    
    [walker_line stroke];
    
    
    
    
}



    
    
    


-(void)drawFace:(int)n
{
    int i0 = triangleVertices[n][0];
    int i1 = triangleVertices[n][1];
    int i2 = triangleVertices[n][2];
    
    double vec01[DIM] = {vertex[i1][X]-vertex[i0][X],vertex[i1][Y]-vertex[i0][Y],vertex[i1][Z]-vertex[i0][Z]};
    double vec12[DIM] = {vertex[i2][X]-vertex[i1][X],vertex[i2][Y]-vertex[i1][Y],vertex[i2][Z]-vertex[i1][Z]};
    
    double mag01 = sqrt(vec01[X]*vec01[X]+vec01[Y]*vec01[Y]+vec01[Z]*vec01[Z]);
    double mag12 = sqrt(vec12[X]*vec12[X]+vec12[Y]*vec12[Y]+vec12[Z]*vec12[Z]);
    
    double hat01[DIM] = {vec01[X]/mag01,vec01[Y]/mag01,vec01[Z]/mag01};
    double hat12[DIM] = {vec12[X]/mag12,vec12[Y]/mag12,vec12[Z]/mag12};
    
    double normal[DIM] = // hat01 x hat12
    {
        hat01[Y]*hat12[Z] - hat01[Z]*hat12[Y],
        hat01[Z]*hat12[X] - hat01[X]*hat12[Z],
        hat01[X]*hat12[Y] - hat01[Y]*hat12[X]
    };
    
    double center[DIM] =
    {
        (vertex[i0][X]+vertex[i2][X])/2,
        (vertex[i0][Y]+vertex[i2][Y])/2,
        (vertex[i0][Z]+vertex[i2][Z])/2
    };
    double eye[DIM] = {0, 0, eyePoint};
    double centerEye[DIM] = {eye[X] - center[X], eye[Y] - center[Y], eye[Z] - center[Z]};
    double eyeDotNormal = centerEye[X]*normal[X] + centerEye[Y]*normal[Y] + centerEye[Z]*normal[Z];
    
    if (eyeDotNormal < 0.0) // visible?
    {
        double hatLight[DIM] = {0,-1.0/sqrt(2.0),-1.0/sqrt(2.0)}; // direction toward light
        double normalDotLight = normal[X]*hatLight[X] + normal[Y]*hatLight[Y] + normal[Z]*hatLight[Z];
        
        static double grayMin = 0.1;
        static double grayMax = 0.9;
        double gray = grayMin + (grayMax - grayMin) * (normalDotLight + 1.0)/2.0;
        
        [[NSColor colorWithCalibratedWhite:gray alpha:1.0] set];
    
        NSBezierPath *face = [NSBezierPath bezierPath];
        {
            [face moveToPoint:projection[i0]];
            [face lineToPoint:projection[i1]];
            [face lineToPoint:projection[i2]];
        }
        [face fill];
    }
}

#pragma mark -
/////////////////////////////////////////////////////////////////////////
- (void)mouseDown:(NSEvent *)theEvent
{
    oldMousePoint = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mousePoint = [theEvent locationInWindow];
    
    static const double TRACK_CYLINDER_RADIUS = 40.0;
    theta -= (mousePoint.y - oldMousePoint.y)/TRACK_CYLINDER_RADIUS;
    
    oldMousePoint = mousePoint;
    
    [self updateRotationMatrix];
    [self updateVertices];
    
    [self setNeedsDisplay:true];
}

@end
