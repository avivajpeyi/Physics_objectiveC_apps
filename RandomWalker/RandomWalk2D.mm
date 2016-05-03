
// draw grid


// 100 walkers, 100 steps

// then

// 100 walkers, 1000 steps

// 100 walk


// define constants of the trig values as clock times


#import "RandomWalk2D.h"

@implementation RandomWalk2D




-(void)awakeFromNib
{
    
    //We are drawing a bounding rectangle
    NSRect myRect = [self bounds];
    //[self translateOriginToPoint:NSMakePoint(myRect.size.width/2, myRect.size.height/2)];
    // add tracking rect checks when the cursor enters/exits the custom view
    [self addTrackingRect:myRect owner:self userData:nil assumeInside:NO];
    [self addCursorRect:myRect cursor:[NSCursor openHandCursor]];
    
    
    
    [self initialisations];
      [self reset:self];
    
}

-(void)initialisations
{
    
    startPoint = NSMakePoint(0,0);
    [lengthText setDoubleValue:     length = 5];
    [timeText setDoubleValue: time = 10000];
    [numWalkersText setDoubleValue: numWalkers = 1];
    
    
    // PUSH WALKERS ONTO THE VECTOR
    int timeDuration = time;
    float decreaseFactor = 2.0/3.0;
    for (int i = 0; i < numWalkers; i++)
    {
        walker.push_back(randomWalker(timeDuration));
        timeDuration = timeDuration* decreaseFactor;

    }
    
    
    
}


-(IBAction)reset:(id)sender
{
    length    = [lengthText doubleValue];
    numWalkers = [numWalkersText integerValue];
    
    // PUSH WALKERS ONTO THE VECTOR
    int timeDuration = time;
    float decreaseFactor = 2.0/3.0;
    for (int i = 0; i < numWalkers; i++)
    {
        walker.push_back(randomWalker(timeDuration));
        timeDuration = timeDuration* decreaseFactor;
        
    }

    
    for (int i = 0; i < num_choices_taken; i++)
        path[i] = 0 ;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // COLORING THE BACKGROUND
    {
        NSColor *backColor = [NSColor blackColor];
        [ backColor set];
        [ NSBezierPath fillRect:dirtyRect];
    }
    
    switch (pathType)
    {
        case 0: //4 path
        {
            // Drawing the grid
            /*
            { [ [NSColor grayColor] set];
                NSBezierPath *path4grid_line = [NSBezierPath bezierPath];
                {
                    NSRect boundingBox = [self bounds];
                    
                    [path4grid_line setLineWidth: 1.0];
                    for (int i = 0; i < boundingBox.size.width; i= i + length)
                    {
                        [path4grid_line moveToPoint: NSMakePoint(i,0)];
                        [path4grid_line lineToPoint: NSMakePoint(i,boundingBox.size.height)];
                        
                    }
                    
                    for (int i = 0; i < boundingBox.size.height; i= i +length)
                    {
                        [path4grid_line moveToPoint: NSMakePoint(0,i)];
                        [path4grid_line lineToPoint: NSMakePoint(boundingBox.size.width,i)];
                        
                    }
                    
                    [path4grid_line stroke];
                }
                
                
            }*/
            
            


            
            for (int i = 0; i < numWalkers; i++)
            {
                
                float rand_max = RAND_MAX;
                float red = rand() / rand_max;
                float green = rand() / rand_max;
                float blue = rand() / rand_max;
                NSColor* myColor = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
                [ myColor set];
                [self randomWalk4path: walker[i]];
                
                NSLog(@"Number %d", i);
            }
            

        }
            break;
            
        case 1: //6 path
        {
            // DRAWING THE GRID
//            {
//                
//                [ [NSColor grayColor] set];
//                NSBezierPath *path4grid_line = [NSBezierPath bezierPath];
//                {
//                    NSRect boundingBox = [self bounds];
//                    
//                    [path4grid_line setLineWidth: 1.0];
//                    
//                    
//                    for (int i = 0; i < boundingBox.size.width; i= i + length)
//                    {
//                        [path4grid_line moveToPoint: NSMakePoint(i,0)];
//                        [path4grid_line lineToPoint: NSMakePoint(i,boundingBox.size.height)];
//                        
//                    }
//                    
//                    for (int i = 0; i < boundingBox.size.height; i= i +length)
//                    {
//                        [path4grid_line moveToPoint: NSMakePoint(0,i)];
//                        [path4grid_line lineToPoint: NSMakePoint(boundingBox.size.width,i)];
//                        
//                    }
//                    
//                    [path4grid_line stroke];
//                    
//                    
//                }
//            
//                
//            }
            // DRAW PATH OF THE WALKER
            {
                [ [NSColor blueColor] set];
                NSBezierPath *walker_line = [NSBezierPath bezierPath];
                {
                    [walker_line setLineWidth: 3.0];
                    [walker_line moveToPoint: startPoint ];
                    
                    // move according to the choices made
                    for (int i = 0 ; i < num_choices_taken; i ++)
                    {
                        switch (path[i])
                        {
                            case 1:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos(0), length*sin (0))];
                            }
                                break;
                            case 2:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 2* M_PI / 6 ), length* sin( 2* M_PI / 6 ))];
                            }
                                break;
                                
                            case 3:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 2 *2* M_PI / 6), length*sin ( 2*2* M_PI / 6))];
                            }
                                break;
                                
                            case 4:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 3*2* M_PI / 6),length* sin (3* 2* M_PI / 6))];
                            }
                                break;
                                
                            case 5:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 4*2* M_PI / 6), length*sin (4* 2* M_PI / 6))];
                            }
                                break;
                                
                            case 6:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos(5* 2* M_PI / 6),length* sin (5* 2* M_PI / 6))];
                            }
                                break;
                                
                        }
                    }
                    
                }
                [walker_line stroke];
            }
            
            
            
            
            
        }
            break;
            
        case 2: //3 path
        {
            // DRAWING THE GRID
//            {
//                
//                [ [NSColor redColor] set];
//                NSBezierPath *path3grid_line = [NSBezierPath bezierPath];
//                {
//                   // NSRect boundingBox = [self bounds];
//                    
//                    [path3grid_line setLineWidth: 5.0];
//                    
//                    
////
//                        // source : http://www.codeproject.com/Articles/14948/Hexagonal-grid-for-games-and-other-projects-Part
//                        double h = sin( 30 * M_PI/180.0) * length;
//                        double r = cos( 30 * M_PI/180.0 ) * length;
//                        double b = length + (2 * h);
//                        double a = 2 * r;
//                    
//                    
//                        int height =[self bounds].size.height;
//                        int width =[self bounds].size.width;
//                    
//                        double hexWidth = r + r;
//                        double hexHeight = length + h;
//                        double pixelWidth = (width * hexWidth) + r;
//                        double pixelHeight = (height * hexHeight) + h;
//                    
//                    
//                    
//                    double n = (width + length) / (2*length * (1 + sin(M_PI / 6.0) )) ;
//                    double xOffset = (n-1) * r;
//                    double yOffset = height - hexHeight;
//                    
//
//                    
//                    int j = 0;
//                    
//                    
//                    NSLog(@"(hex left (%lf, %lf)", j+xOffset, j+yOffset-r);
//                    NSLog(@"n : %lf ", n);
//                    
//                    [self makeHexagonalAtxVal: (j+xOffset) yVal: (j+yOffset -r) ];
//                    
//                    [path3grid_line moveToPoint: hexagonal.points[0]];
//                    for (int vertex = 1; vertex < 6; vertex++)
//                    {
//                        [path3grid_line lineToPoint: hexagonal.points[vertex] ];
//                    }
//                    [path3grid_line lineToPoint:hexagonal.points[0]];
//                    
//
//                    
//                    
//                    for ( int xPosition = j+xOffset; xPosition <= 34*a; xOffset += a )
//                    {
//                        [self makeHexagonalAtxVal: (j+xOffset) yVal: (j+yOffset -r) ];
//                        
//                        [path3grid_line moveToPoint: hexagonal.points[0]];
//                        for (int vertex = 1; vertex < 6; vertex++)
//                        {
//                            [path3grid_line lineToPoint: hexagonal.points[vertex] ];
//                        }
//                        [path3grid_line lineToPoint:hexagonal.points[0]];
//                        
//                    }
//
//                    
//                    
//                    
//                    
//                    
//                    [path3grid_line stroke];
//                    
//                    
//                }
//                
//            
//            }
            // DRAW PATH OF THE WALKER
            {
                [ [NSColor blueColor] set];
                NSBezierPath *walker_line = [NSBezierPath bezierPath];
                {
                    [walker_line setLineWidth: 3.0];
                    [walker_line moveToPoint: startPoint ];
                    
                    
                    
                    
                    // move according to the choices made
                    for (int i = 0 ; i < num_choices_taken; i ++)
                    {
                        switch (path[i])
                        {
                            case 1:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos(0), length*sin (0))];
                            }
                                break;
                            case 2:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 2* M_PI / 3 ), length* sin( 2* M_PI / 3 ))];
                            }
                                break;
                                
                            case 3:
                            {
                                [walker_line relativeLineToPoint: NSMakePoint(length*cos( 2 *2* M_PI / 3), length*sin ( 2*2* M_PI / 3))];
                            }
                                break;
                                
                                
                        }
                    }
                    
                }
                [walker_line stroke];
            }
            
            
            
            
            
        }
            break;
            
            
            
    }
    
    
    
    
    
}







-(void)randomWalk4path:(randomWalker) myWalker
{
    
        NSBezierPath *walker_line = [NSBezierPath bezierPath];
        {
            [walker_line setLineWidth: 3.0];
            [walker_line moveToPoint: startPoint ];
            
            // move according to the choices made
            for (int i = 0 ; i < myWalker.num_choices_taken; i ++)
            {
                int choice = arc4random() % 4; // either 1, 2, 3 , 0 (which is 4)
                
                
                switch (choice)
                {
                    case 1:
                    {
                        myWalker.path[i] = 1;
                        [walker_line relativeLineToPoint: NSMakePoint(length,0)];
                    }
                        break;
                    case 2:
                    {
                        myWalker.path[i] = 2;
                        [walker_line relativeLineToPoint: NSMakePoint(-length,0)];
                    }
                        break;
                        
                    case 3:
                    {
                        myWalker.path[i] = 3;
                        [walker_line relativeLineToPoint: NSMakePoint(0,-length)];
                    }
                        break;
                        
                    case 0:
                    {
                        myWalker.path[i] = 0;
                        [walker_line relativeLineToPoint: NSMakePoint(0,length)];
                    }
                        break;
                        
                        
                }
            }
            
        }
        [walker_line stroke];


}



-(void)randomWalk6path
{
    for (int i = 0 ; i < num_choices_taken; i ++ )
    {
        int choice = arc4random() % 6; // either 1, 2, 3 , 4, 5, 0 (which is 6)
        
        switch (choice)
        {
            case 1:
            {
                path[i] = 1;
            }
                break;
                
            case 2:
            {
                path[i] = 2;
            }
                break;
                
            case 3:
            {
                path[i] = 3;
            }
                break;
                
            case 4:
            {
                path[i] = 4;
            }
                break;
                
            case 5:
            {
                path[i] = 5;
            }
                break;
                
            case 0: //when the number is 4
            {
                path[i] = 6;
            }
                break;
                
        }
        
    }
    
    
    
   }



/*
 
 need to look into odds and evens - two families of nodes 
 
 counter start off at tye 1 at even
 go to second 
 
 */
-(void)randomWalk3path
{
    for (int i = 0 ; i < num_choices_taken; i ++ )
    {
        int choice = arc4random() % 3; // either 1, 2, 3 , 4, 5, 0 (which is 6)
        
        switch (choice)
        {
            case 0:
            {
                path[i] = 1;
            }
                break;
                
            case 1:
            {
                path[i] = 2;
            }
                break;
                
            case 2:
            {
                path[i] = 3;
            }
                break;
                
                
        }
        
    }
    
    
    
    
    int count [4];
    
    
    count [0] = 0;
    count [1] = 0;
    count [2] = 0;
    count [3] = 0;
    
    
    
    
    
    
    for (int i = 0; i < num_choices_taken ; i++)
    {
        count[path[i]] += 1;
        
        //   NSLog(@"val at %d = %d", i, path[i] );
    }
    
    NSLog(@"\n 1's : %d \n 2's : %d \n 3's : %d \n", count[1], count[2], count[3]);
    
}



#pragma mark -
////////////////// MOUSE STUFF ///////////////////////////////////////



-(void)mouseDown:(NSEvent *)theEvent
{
    //need to check if the user has clicked on the line
    
    
    //convert window coord to the clickPoint
    startPoint = [self convertPoint: [theEvent locationInWindow] fromView:nil ];
    NSLog(@"click point (%lf, %lf)", (double)startPoint.x, (double)startPoint.y);
    
    
    [self update:self];
    
    
}
-(void)mouseUp:(NSEvent *)theEvent
{
    // frame returns rectangle of the custom view, in the windows referenece
    if ( [self mouse: [theEvent locationInWindow] inRect:[self frame]])
    {
        [[NSCursor pointingHandCursor] set];
    }
    else // mouse up, oustside custom view
    {
        [ [NSCursor arrowCursor] set];
    }
    
    
    
}
-(void)mouseDragged:(NSEvent *)theEvent
{
    
}
-(void)mouseEntered:(NSEvent *)theEvent
{
    [[NSCursor pointingHandCursor]set];
    NSLog(@"Mouse Entered");
}
-(void)mouseExited:(NSEvent *)theEvent
{
    [ [ NSCursor arrowCursor] set];
    NSLog(@"Mouse Exit");
}





- (void)update:(id)sender
{
    [self reset:self];
    switch (pathType)
    {
        case 0: // 4 path
            [self randomWalk4path:walker[0]];  break;
            
        case 1: // 6 path
            [self randomWalk6path];  break;
            
        case 2: // 3 path
            [self randomWalk3path];  break;
    }
    
    [self setNeedsDisplay:YES]; // invokes draw rect
}





-(void)makeHexagonalAtxVal:(double)xvalue yVal:(double)yvalue
{
    
    double x = xvalue;
    double y = yvalue;
    
    // source : http://www.codeproject.com/Articles/14948/Hexagonal-grid-for-games-and-other-projects-Part
    double h = sin( 30 * M_PI/180.0) * length;
    double r = cos( 30 * M_PI/180.0 ) * length;
    double b = length + (2 * h);
    double a = 2 * r;
    
    

    
    
    hexagonal.points[0] = NSMakePoint(x, y);
    hexagonal.points[1] = NSMakePoint(x + r, y + h);
    hexagonal.points[2] = NSMakePoint(x + r, y + length + h);
    hexagonal.points[3] = NSMakePoint(x, y + length + h + h);
    hexagonal.points[4] = NSMakePoint(x - r, y + length + h);
    hexagonal.points[5] = NSMakePoint(x - r, y + h);
    

}

/*
//-(Hex*)makeHexBoard
//{
//    
//
//    // source : http://www.codeproject.com/Articles/14948/Hexagonal-grid-for-games-and-other-projects-Part
//    double h = sin( 30 * M_PI/180.0) * length;
//    double r = cos( 30 * M_PI/180.0 ) * length;
//    double b = length + (2 * h);
//    double a = 2 * r;
//    
//    
//    int height =[self bounds].size.height;
//    int width =[self bounds].size.width;
//    
//    double hexWidth = r + r;
//    double hexHeight = length + h;
//    double pixelWidth = (width * hexWidth) + r;
//    double pixelHeight = (height * hexHeight) + h;
//    
//    
//    
//    bool inTopRow = false;
//    bool inBottomRow = false;
//    bool inLeftColumn = false;
//    bool inRightColumn = false;
//    bool isTopLeft = false;
//    bool isTopRight = false;
//    bool isBotomLeft = false;
//    bool isBottomRight = false;
//    
//
//    
//    Hex * hexes;
//      hexes = new Hex[height];
//    
//    // i = y coordinate (rows), j = x coordinate
//    //      (columns) of the hex tiles 2D plane
//    
//    for (int i = 0; i < height; i++)
//    {
//        for (int j = 0; j < width; j++)
//        {
//            // Set position booleans
//            {
//            if (i == 0)
//            {
//                inTopRow = true;
//            }
//            else
//            {
//                inTopRow = false;
//            }
//            if (i == height - 1)
//            {
//                inBottomRow = true;
//            }
//            else
//            {
//                inBottomRow = false;
//            }
//            if (j == 0)
//            {
//                inLeftColumn = true;
//            }
//            else
//            {
//                inLeftColumn = false;
//            }
//            if (j == width - 1)
//            {
//                inRightColumn = true;
//            }
//            else
//            {
//                inRightColumn = false;
//            }
//            if (inTopRow && inLeftColumn)
//            {
//                isTopLeft = true;
//            }
//            else
//            {
//                isTopLeft = false;
//            }
//            if (inTopRow && inRightColumn)
//            {
//                isTopRight = true;
//            }
//            else
//            {
//                isTopRight = false;
//            }
//            if (inBottomRow && inLeftColumn)
//            {
//                isBotomLeft = true;
//            }
//            else
//            {
//                isBotomLeft = false;
//            }
//            if (inBottomRow && inRightColumn)
//            {
//                isBottomRight = true;
//            }
//            else
//            {
//                isBottomRight = false;
//            }
//            }
//            
//            //
//            // Calculate Hex positions
//            //
//            
//            if (isTopLeft)
//            {
//                //First hex
//             //   NSPoint *firstPoint = NSMakePoint(0 + h + xOffset, 0 + yOffset);
//               // hexes[0] =  [self makeHexagonalAtPoint: firstPoint];
//            }
//        else
//        {
//            if (inLeftColumn)
//            {
//                // Calculate from hex above
//                hexes[i, j] = new Hex(hexes[i - 1, j].
//                                      Points[(int)Hexagonal.FlatVertice.BottomLeft],
//                                      side, orientation);
//            }
//            else
//            {
//                // Calculate from Hex to the left
//                // and need to stagger the columns
//                if (j % 2 == 0)
//                {
//                    // Calculate from Hex to left's
//                    // Upper Right Vertice plus h and R offset
//                    float x = hexes[i, j - 1].Points[
//                                                     (int)Hexagonal.FlatVertice.UpperRight].X;
//                    float y = hexes[i, j - 1].Points[
//                                                     (int)Hexagonal.FlatVertice.UpperRight].Y;
//                    x += h;
//                    y -= r;
//                    hexes[i, j] = new Hex(x, y, side, orientation);
//                }
//                else
//                {
//                    // Calculate from Hex to left's Middle Right Vertice
//                    hexes[i, j] = new Hex(hexes[i, j - 1].Points[
//                                                                 (int)Hexagonal.FlatVertice.MiddleRight],
//                                          side, orientation);
//                }
//            }
//        }
//    }
//}
//}
*/
        
        // Radio button actions to change one pulse/ two pulse
        - (IBAction)chagePath:(id)sender
        {
            pathType = [sender tag];
            [self display];
        }
        


        
        @end
