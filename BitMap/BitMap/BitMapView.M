//
//  BitMapView.m
//  BitMap
//
//  Created by Avi on 3/28/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "BitMapView.h"

@implementation BitMapView


-(void)awakeFromNib
{
   // srand(1234);  //initialises a pseudo-random number generator (setting a number inside will let us generate the numbers in a same sequence
    
    srand(unsigned(time(nil)));
    
    
    myImage = [[NSImage alloc] initWithSize:NSMakeSize(size, size)];

    
    
    myBitMapRep = [[NSBitmapImageRep alloc]
                   initWithBitmapDataPlanes:nil
                   pixelsWide:size
                   pixelsHigh:size
                   bitsPerSample:8
                   samplesPerPixel:3  //RGB
                   hasAlpha:NO        //No Transprency
                   isPlanar:NO
                   colorSpaceName:NSDeviceRGBColorSpace
                   bytesPerRow:0
                   bitsPerPixel:0];
    
    
    [self reset:self];
}


- (IBAction)reset:(id)sender
{
    [self display];
}


- (void)drawRect:(NSRect)dirtyRect
{
    unsigned char *myBitmapData = [myBitMapRep bitmapData];
    for ( int x = 0; x < size; x++) // We're going through every 'x' pixel,
    {
        for (int y = 0; y < size; y++) // we're going through every 'y' pixel
        {
            unsigned char grayByte = random() % UCHAR_MAX; // random number / 256 's remainder
            
            int index = 3 * ( (size - 1 - y ) * size + x ); /// WHAAATTT???
            
            myBitmapData [index]     = grayByte; // Red
            myBitmapData [index +1]  = grayByte; // Green
            myBitmapData [index +2]  = grayByte; // Blue
            

        }
    }
    
    [ myImage addRepresentation:myBitMapRep];
    
    [ myImage drawAtPoint:NSMakePoint(0, 0)
                 fromRect:NSMakeRect(0, 0, size, size)
                operation:NSCompositeCopy
                 fraction:1.0];
    
    [myImage removeRepresentation:myBitMapRep];
    [myImage recache]; // free memory for improved performance
}

-(void) saveImage:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"myBitmap.png"];
    [savePanel beginSheetModalForWindow:[self window] // the window we want to save - since we want to save bit map view, we return self's window
                      completionHandler:^(NSInteger result)
    {
        if (result == NSModalResponseOK)
        {
            NSDictionary *imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
            NSData *data = [myBitMapRep representationUsingType:NSPNGFileType properties:imageProperties];
            [data writeToFile:[[savePanel URL] path] atomically:NO];
        }
    }];
}


- ( IBAction)saveData:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"myData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
         if (result == NSModalResponseOK)
         {
             [savePanel close]; // close save panel while data is being aquired
             
             // expertiment goes here
             
             // --
//             NSString *myString = @"data is good";
//             [myString
//              writeToFile: [[savePanel URL]path]
//              atomically: NO
//              encoding:NSUTF8StringEncoding
//              error: nil];
             //
             
             
             const char *cFileName =
             
             [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
             FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
             {
                 fprintf(dataFileP, "C styled Data is good");
                 
             }
             fclose(dataFileP);
             
             
             
             
             
             
             NSBeep(); //alert user for completion of data recording
             
         }
    }];
    
    
    
}


@end
