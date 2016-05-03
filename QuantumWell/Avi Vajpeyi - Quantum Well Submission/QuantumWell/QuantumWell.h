//
//  QuantumWell.h
//  QuantumWell
//
//  Created by Avi on 2/29/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//  y = ( x< 3) ? 5:7  , if x < 3, then 5, else 7

# define V(x)  ((x < xLeft) ?  VLeft:((x < xRight)?VCenter:VRight) )


const int xWidth = 512;





@interface QuantumWell : NSView
{
    //--------- DEFENITIONS FOR VARIABLES------//
    
    double psi [xWidth+1];
    double lastPsi; //value pf psi at xwidth
    
    double VLeft, VCenter, VRight;
    double xLeft, xRight;
    double energy, energyScale, psiScale;
    
    double numDxPerPixel, dx, dx2;
    
    double xStart;
    
    //-----------------------------------------//
    
    
    IBOutlet id EnergyText;
    IBOutlet id VLeftText;
    IBOutlet id VCenterText;
    IBOutlet id VRightText;
    IBOutlet id PsiScaleText;

    IBOutlet id xLeftText;
    IBOutlet id xRightText;
    
    
    Boolean energyLine;
    Boolean VLeftLine;
    Boolean VCenterLine;
    Boolean VRightLine;
    Boolean PsiLine;
    Boolean xLeftLine;
    Boolean xRightLine;
}


-(void)awakeFromNib;
-(void)reset:(id)sender;



-(void)mouseDown:(NSEvent *)theEvent;
-(void)mouseUp:(NSEvent *)theEvent;
-(void)mouseDragged:(NSEvent *)theEvent;
-(void)mouseEntered:(NSEvent *)theEvent;
-(void)mouseExited:(NSEvent *)theEvent;



-(void) computePsi;






@end
