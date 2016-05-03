//
//  SpringView.h
//  Spring
//
//  Created by John Lindner on 4/2/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#define a(t,x,v) (-(w2 * x))  // Hooke + Newton

#import <Cocoa/Cocoa.h>

@interface SpringView : NSView
{
    double x, v;
    double t, dt;
    double w2;  // parameter
    
    SEL algorithm;
}

- (void)awakeFromNib;
- (IBAction)reset:(id)sender;
- (IBAction)algorithmChooser:(id)sender;

- (void)evolve:(id)object;
- (void)eulerCromer;
- (void)RK1;

@end
