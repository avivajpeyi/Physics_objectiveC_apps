//
//  SphereView.h
//  Sphere
//
//  Created by Avi on 4/25/16.
//  Copyright © 2016 AVI. All rights reserved.
//



#define SQR(x) ((x) * (x))

#import <Cocoa/Cocoa.h>
#include <vector>

using namespace std;

struct Vector { double x, y; } ;
struct vec3D { double x, y, z;};

class randomWalker
{
public:
    int num_choices_taken;
    int *path;
    randomWalker(int num_points){
        path = new int [num_points];
        num_choices_taken = num_points; };
};


int const maxWedges = 100;
int const maxSlices =100;

enum indicies {X,Y,Z};
const short DIM = 3; // dimensions
double density = 1.0;


const int numPoints = 100;

@interface SphereView : NSView


{
    
    vec3D sphere[maxSlices][maxWedges+1];
    
    
    int numSlices, numWedges; //principle moments
    IBOutlet id slicesSlider, slicesText, wedgesSlider, wedgesText;
    
   int numPoints;
    
    double radius;
    IBOutlet id radiusSlider, radiusText;
    
    double eye; IBOutlet id eyeSlider;
    
    
    vector <randomWalker> Walkers;
    
    NSPoint projection[maxSlices][maxWedges+1];
    
//    long double Ii[DIM][DIM], Ii0[DIM][DIM]; // inverse inertia tensor and initial inverse inertia tensor
//    long double omega[DIM], omega0[DIM];
//    IBOutlet id OmegXText, OmegYText, OmegZText,  OmegXSlider, OmegYSlider, OmegZSlider;
//    long double angularMomentum[DIM];
//    long double rotations[DIM][DIM];
//    NSPoint projection [numPoints];
//    // alternate way of doing this:  double proj[CORNERS][2]
//
//    // miscellaneous variables
//    long double dt, magnify; IBOutlet id magnifySlider;
//    int eye; IBOutlet id eyeSlider;
//    NSInteger DrawingStyle, BackgroundStyle;
//    int backGroundNumber;
    
}

-(void)awakeFromNib;
-(IBAction)reset: (id) sender;
-(void)initialisations;
- (void)drawRect:(NSRect)dirtyRect;
-(void)drawSphere;









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
