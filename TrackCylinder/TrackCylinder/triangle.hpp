//
//  triangle.hpp
//  TrackCylinder
//
//  Created by Avi on 5/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#ifndef triangle_hpp
#define triangle_hpp

#include <stdio.h>

struct verticies
{
    int x, y, z;
    
    verticies()
    {
        x = 0; y = 0; z = 0;
    }
    
    verticies( int a, int b, int c )
    {
        x = a; y = b; z = c;
    };
    
    
    bool operator==(const verticies& a) const
    {
        return (x == a.x && y == a.y && z == a.z);
    }
};

class triangle
{
public:
    
    verticies myVerticies;
    verticies neighbours[3];
    
    
    triangle ();
    triangle (verticies myVertex, verticies nbr[3]);

    
    //
};


#endif /* triangle_hpp */
