//
//  DuffingSimple.h
//  DuffingSimple
//
//  Created by Avi Vajpeyi on 2/17/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DuffingSimple : NSView
{
    double position;
    double velocity;
    double time;
    
    double amplitude;   IBOutlet id amplitudeText;
    double frequency;   IBOutlet id frequencyText;
    double dt;          IBOutlet id dtText;
    double scale;       IBOutlet id scaleText;
    
    
    double stiffness, hardness, viscosity; //nonlinear spring
    
    IBOutlet id pauseButton;

}



-(void)awakeFromNib;
-(void)start;

-(IBAction)reset:(id)sender;
-(IBAction)animate :(id)object;
-(void)animateStep;



@end
