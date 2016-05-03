//
//  triangle.cpp
//  TrackCylinder
//
//  Created by Avi on 5/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#include "triangle.hpp"


triangle::triangle()
{
    myVerticies.x = 0;
    myVerticies.y = 0;
    myVerticies.z = 0;
    
    
    for (int i = 0; i < 3; i++)
    {
        neighbours[i].x = -1;
        neighbours[i].y = -1;
        neighbours[i].z = -1;
    }
    
}

triangle::triangle(verticies myVertex, verticies nbr[3])
{
    
    myVerticies.x = myVertex.x;
    myVerticies.y = myVertex.y;
    myVerticies.z = myVertex.z;
    
    
    for ( int i = 0; i < 3; i++)
    {
    neighbours[0].x = nbr[0].x;
    neighbours[0].y = nbr[0].y;
    neighbours[0].z = nbr[0].z;
    }
    
    
}


