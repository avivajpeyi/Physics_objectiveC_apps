//
//  BitMapView.h
//  BitMap
//
//  Created by Avi on 3/28/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

const int size = 256; // or 512 by 512

@interface BitMapView : NSView
{
    NSImage *myImage;
    NSBitmapImageRep *myBitMapRep;
    
}

-(void) awakeFromNib;
-(IBAction)reset:(id)sender;
-(void)drawRect:(NSRect)dirtyRect;
-(IBAction)saveImage:(id)sender;




@end
