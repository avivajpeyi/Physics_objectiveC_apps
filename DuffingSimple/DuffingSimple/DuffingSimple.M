//
//  DuffingSimple.m
//  DuffingSimple
//
//  Created by Avi Vajpeyi on 2/17/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import "DuffingSimple.h"

@implementation DuffingSimple

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.

    [ [ NSColor blackColor] set];
    [ NSBezierPath fillRect:dirtyRect];
    
    [[NSColor blueColor] set];
    static const short RADIUS = 5;
    
    NSRect square = NSMakeRect(scale*position-RADIUS, scale*velocity-RADIUS, 2*RADIUS, 2*RADIUS);
    
    
    [ [NSBezierPath bezierPathWithOvalInRect:square] fill];
    
    
}





-(void)awakeFromNib
{

    NSRect box = [self bounds];
    [self translateOriginToPoint:NSMakePoint(box.size.width/2, box.size.height/2)];
    
    [NSThread detachNewThreadSelector:@selector(animate:) toTarget:self withObject:nil]; // stat animation
    
    
    [self start];
    
    [amplitudeText setDoubleValue:amplitude];
    [frequencyText setDoubleValue:frequency];
    [dtText setDoubleValue:dt];
    [scaleText setDoubleValue:scale];
    
    
    
}


-(void)start
{
    amplitude = 0.19;
    frequency = 0.833;
    dt = 0.01 * 2 * M_PI / frequency;
    scale = 100.0;
    
    stiffness = 0.5;
    hardness = 0.5;
    viscosity = 0.15;
    
}

-(IBAction)reset:(id)sender
{
    
    //IN CASE USER CHANGES THE VALUES
    amplitude = [amplitudeText doubleValue];
    frequency = [frequencyText doubleValue];
    dt = [dtText doubleValue];
    scale = [scaleText doubleValue];
    
    time = 0;
    position = 0;
    velocity = 0;

    [self setNeedsDisplay:YES]; //invoke draw rect
    
    
    
    
    
}


-(IBAction)animate :(id)object
{

    NSLog(@"Animate");
    
    
while (YES)
{
    if (not [pauseButton state])
    {
        [self animateStep];
    }
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1/60.0] ];
}
    



}

-(void)animateStep
{
    NSLog(@"Animate Step");
    
    double acceleration = -viscosity * velocity + stiffness - hardness * pow(position,3) + amplitude * cos(frequency*time);
    
    velocity+=acceleration*dt;
    position += velocity*dt;
    time += dt;

    [self setNeedsDisplay:YES];

}



@end
