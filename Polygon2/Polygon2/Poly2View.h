//
//  Poly2View.h
//  Polygon2
//
//  Created by John Lindner on 2/23/16.
//  Copyright © 2016 John Lindner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Poly2View : NSView
{
    IBOutlet id nSidesSlider;       int nSides;
    IBOutlet id speedSlider; 
    
    IBOutlet id startAngleSlider;   double startAngle;
    
    IBOutlet id foreColorWell;      NSColor *foreColor;
    IBOutlet id backColorWell;      NSColor *backColor;
    
    IBOutlet id pauseButton;
    
    
    NSInteger style;
    // same thing as int style except that
    
    
}

- (void)awakeFromNib;
- (void)initialize;
- (IBAction)update:(id)sender;

- (void)animate:(id)anObject;
- (void)animateStep;

- (IBAction)chageStyle:(id)sender;


@end
