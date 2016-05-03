//
//  QuantumScattering.h
//  QuantumScattering
//
//  Created by Avi on 3/7/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define SQR(x) ((x)*(x))


static int const N_UNIVERSE = 4000;
 struct complex
{
    double real, imaginary;
};



@interface QuantumScattering : NSView

{
    int nSystem, nStart, nStop; // in pixels 
    
    double potential[N_UNIVERSE];
    complex psi[N_UNIVERSE][3];
    int t_old, t_now, t_new;
    
    
    double dt_dx2, dx, dt;
    
    double psi2Scaling, potentialScaling;
    
    double vLeft, vCenter, vRight;
    IBOutlet id vLeftText, vCenterText, vRightText;
    BOOL vLeftDragging, vCenterDragging, vRightDragging;

    double xLeft, xRight; // in meters
    IBOutlet id xLeftText, xRightText;
    BOOL xLeftDragging, xRightDragging;
    
    
    double initialPosition, initialSigma, initialEnergy;
    IBOutlet id initPosText, initSigText, initEnergyTex;
    BOOL energyDragging;
    
    NSInteger potentialDrawingStyle;
    
    
    IBOutlet id foreColorWell; NSColor *foreColor;
    IBOutlet id backColorWell; NSColor *backColor;
    IBOutlet id psiColorWell;  NSColor *psiColor;
    
        IBOutlet id ScalingSlider;
    IBOutlet id psi2ScalingSlider;
    
    IBOutlet id pauseButton;
        IBOutlet id speedSlider;
    
    
        IBOutlet id  drawEnergyLine;
    
    
}


-(void)awakeFromNib;
- (void)initialisations;
-(IBAction)reset:(id)sender;

-(complex) initWavePacketAtT: (double) t andX: (double) x;




//animate

- (void)animate:(id)anObject;
- (void)animateStep;


-(void)mouseDown:(NSEvent *)theEvent;
-(void)mouseUp:(NSEvent *)theEvent;
-(void)mouseDragged:(NSEvent *)theEvent;
-(void)mouseEntered:(NSEvent *)theEvent;
-(void)mouseExited:(NSEvent *)theEvent;

-(double)Magnitude: (complex *) a;


- (IBAction)chagePotentialStyle:(id)sender;
-(IBAction)update:(id)sender;


@end
