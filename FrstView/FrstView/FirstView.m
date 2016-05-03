//
//  FirstView.m
//  FrstView
//
//  Created by Avi Vajpeyi on 2/15/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

- (void)drawRect:(NSRect)dirtyRect {
    
    
    NSLog(@"In drawRect"); // Diagnostic
    [ [ colourWell color]set]; // ses drawnig colour
    [NSBezierPath fillRect:dirtyRect];
}

- (IBAction)updateTitle:(id)sender
{
    
    NSLog(@"In updateTitle"); // Diagnostic
    [[self window] setTitle:[titleText stringValue]];
    
    
}

-(IBAction)updateColor:(id)sender
{
    
    NSLog(@"----"); // Diagnostic
    NSLog(@"In updateColor"); // Diagnostic
    
    [self display]; // calls lock focus, draw rect, unlock focus
    
    
}


- (void) awakeFromNib
{
    //////
    NSLog(@"In awakeFromNib"); // Diagnostic
}

-(void) initialise
{
    
    NSLog(@"In initialise"); // Diagnostic
    [colourWell setColor: [NSColor redColor] ];
    
    // NSString *mystring = @"Hello"; // String Object
    NSString *mystring = [ [NSString alloc] initWithUTF8String:"HELLOOOO"]; // Simple C string
    [ [self window] setTitle: mystring];
    [titleText setStringValue:mystring];
}


@end
