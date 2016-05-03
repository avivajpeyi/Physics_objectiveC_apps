//
//  RandomWalk2D.h
//  RandomWalker
//
//  Created by Avi on 3/14/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <vector>

using namespace std;

static const int num_choices_taken = 10000;

struct Hex
{
    NSPoint points[6];
};

class randomWalker
{
public:
    int num_choices_taken;
    int *path;
    randomWalker(int num_points) { path = new int [num_points]; num_choices_taken = num_points; };
};

enum FlatVertice
{
    UpperLeft = 0,
    UpperRight = 1,
    MiddleRight = 2,
    BottomRight = 3,
    BottomLeft = 4,
    MiddleLeft = 5
};

@interface RandomWalk2D : NSView
{
   
    IBOutlet id timeText; double time;
    IBOutlet id lengthText; double length;
    
    IBOutlet id numWalkersText; int numWalkers;
    
    
    vector <randomWalker> walker;

    int path[num_choices_taken];

    NSPoint startPoint;

        NSInteger pathType;
    
        Hex hexagonal;
    
}

-(void)initialisations; 

-(void)awakeFromNib;
-(IBAction)reset:(id)sender;
-(void)drawRect:(NSRect)dirtyRect;

-(void)randomWalk3path;
-(void)randomWalk4path: (randomWalker) myWalker;
-(void)randomWalk6path;
-(void)makeHexagonalAtxVal:(double)xvalue yVal:(double)yvalue;
-(Hex*)makeHexBoard;

-(void)mouseDown:(NSEvent *)theEvent;
-(void)mouseUp:(NSEvent *)theEvent;
-(void)mouseDragged:(NSEvent *)theEvent;
-(void)mouseEntered:(NSEvent *)theEvent;
-(void)mouseExited:(NSEvent *)theEvent;


- (IBAction)chagePath:(id)sender;

-(IBAction)update: (id) sender;




@end
