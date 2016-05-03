//
//  WavesView.h
//  WaveOnString
//
//  Created by Avi on 2/22/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>


const short ViewWidth = 512.0;
const double xPixels_xReal = 512.0; // x pixesl per real unit
const double yPixels_yReal = 140.0; // y pixels per real unit





@interface WavesView : NSView
{
    int tNew, tOld, tNow;
    
    
    double sigma; IBOutlet id sigmaText;
    double init_X_Real_Position; IBOutlet id init_X_Real_PositionText;
    double yPixel [ViewWidth+1][3];
 
    IBOutlet id pauseButton;
    IBOutlet id thicknessSlider;
    
    IBOutlet id speedSlider;
   // IBOutlet id startAngleSlider;   double startAngle;
    
    NSInteger style;
    NSInteger initialCondition;
    NSInteger boundaryCondition;
    
    
    
    
    IBOutlet id foreColorWell;      NSColor *foreColor;
    IBOutlet id backColorWell;      NSColor *backColor;
    

}




- (void) awakeFromNib;


- (IBAction)reset:(id)sender;
- (IBAction)redraw:(id)sender;


- (IBAction)update:(id)sender;

-(double)yRealAt: (double) xReal;


-(void) drawRect:(NSRect)dirtyRect;


- (void)animate:(id)anObject;
- (void)animateStep;

- (IBAction)chageStyle:(id)sender;
- (IBAction)changeInitialCondition:(id)sender;
- (IBAction)changeBoundaryCondition:(id)sender;



@end



