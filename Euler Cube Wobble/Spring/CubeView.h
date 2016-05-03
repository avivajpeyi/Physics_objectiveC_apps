//
//  SpringView.h
//  Spring
//
//  Created by John Lindner on 4/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//


#define SQR(x) ((x) * (x))

#import <Cocoa/Cocoa.h>


struct vector { double x, y; } ;

enum indicies {X,Y,Z};
const short DIM = 3; // dimensions
const short CORNERS = 8;



double density = 1.0;

@interface CubeView : NSView
{
    // variables for the
    long double cuboid   [CORNERS][DIM];  //holds current corners
    long double cuboid0 [CORNERS][DIM]; //holds initial corners
    
    long double radius[DIM], inertia[DIM]; //principle moments
    IBOutlet id RadXSlider, RadYSlider, RadZSlider;
    
    long double Ii[DIM][DIM], Ii0[DIM][DIM]; // inverse inertia tensor and initial inverse inertia tensor
    
    long double omega[DIM], omega0[DIM];
    IBOutlet id OmegXText, OmegYText, OmegZText,  OmegXSlider, OmegYSlider, OmegZSlider;
    
    
    long double angularMomentum[DIM];

    
    long double rotations[DIM][DIM];
    
    NSPoint projection [CORNERS];
    // alternate way of doing this:  double proj[CORNERS][2]
    
    
    
    
    // miscellaneous variables
    
    long double dt, magnify; IBOutlet id magnifySlider;
    
    int eye; IBOutlet id eyeSlider;
    
    NSInteger DrawingStyle, BackgroundStyle;
    
    int backGroundNumber;

}

-(void)awakeFromNib;
- (void)drawRect:(NSRect)dirtyRect;
-(IBAction)resetWobble: (id) sender;

-(IBAction)UpdateX:(id)sender;
-(IBAction)UpdateY:(id)sender;
-(IBAction)UpdateZ:(id)sender;
-(void)resetForLengths;

-(void) resetOmega;
-(void)resetMomentum;
-(void)resetInertia;
-(void)resetCuboids;
-(void)resetRotation;

-(void) evolve:(id) object;

-(IBAction)updateGeneral:(id)sender;


-(void)updateII;
-(void) updateOmega;
-(void) updateRotationMatrix;

- (void) drawEdges;
- (void) drawFaces;
-(long double) grayForVerticies:(int)i0 :(int) i1 :(int) i2 ;


- (IBAction)chageBackgroundStyle:(id)sender;
- (IBAction)chageDrawingStyle:(id)sender;

@end
