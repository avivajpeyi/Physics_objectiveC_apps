//
//  IsingView.m
//  Ising
//
//  Created by Avi on 3/28/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import "IsingView.h"

@implementation IsingView

- (void)awakeFromNib
{
    
    srand(unsigned (time (nil) ) );
    
   // srand(1234);
    

    
    [tempStepText setDoubleValue: dT = 0.01];
    [stoppingTempText setDoubleValue: stoppingTemp = 5];
    [durationText setDoubleValue: duration = 100];

    
    
    
    [tempratureText setDoubleValue: temprature = 2.0 / log(1+ sqrt(2.0))];
    absMinEnergy = 2 * SQR(size);
    
    maxMagnetisim = SQR(size);
    
    
    
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
    

    
    
    
    //---- Animate
    [NSThread detachNewThreadSelector:@selector(animate:)
                             toTarget:self
                           withObject:nil]; // start animation thread
    

    
    
    [self reset:self];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    
    
    switch (drawingStyle)
    
    {
                
        case 0:
        {
            unsigned char *myBitmapData = [myBitMapRep bitmapData];
            for ( int x = 0; x < size; x++) // We're going through every 'x' pixel,
            {
                for (int y = 0; y < size; y++) // we're going through every 'y' pixel
                {
                    short gray = ((spin[x][y] +1)/ 2.0);
                    unsigned char grayByte = gray* UCHAR_MAX; // random number / 256 's remainder
                    
                    int index = 3 * ( (size - 1 - y ) * size + x ); /// WHAAATTT???
                    
                    myBitmapData [index]     = grayByte; // Red
                    myBitmapData [index +1]  = 0; // Green
                    myBitmapData [index +2]  = 0; // Blue
                    
                    // setting RGB to all the same value hence r+b+g = white
                    
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
        break;
        
        case 1:
        {
            
            
            [[NSColor whiteColor] set];
            NSRectFill(dirtyRect); // erase old drawing
            
            [[NSColor blackColor] set];
            
            // NS RECT FILL
            for ( int x = 0; x < size; x ++)
            {
                for ( int y = 0; y < size; y++)
                {
                    if (spin[x][y] == 1)
                    {
                        NSRect a = NSMakeRect(x, y, 1, 1);
                        NSRectFill(a);
                    }
                }
            }

        }
        break;
    }
    
    
   
}

-(void)reset:(id)sender
{

    temprature    = [tempratureText doubleValue];
    dT            = [tempStepText doubleValue];
    stoppingTemp  = [stoppingTempText doubleValue];
    duration      = [durationText doubleValue];
    
    
    for ( int x = 0; x < size ; x++)
    {
        for ( int y = 0; y < size; y++)
        {
            spin[x][y] =  ( (RANDOM >  0.5 ) ? -1 : 1 );
        
        }
    }
    
    
    energy = 0.0;
    magnetisation = 0.0;
    MagnetisationRatio = 0;
    EnergyRatio = 0;

    
    
    for ( int x = 0; x < size ; x++)
    {
        for ( int y = 0; y < size; y++)
        {
            magnetisation += spin[x][y];
            energy += -spin[x][y] * (spin[RH(x+1)][y] + spin[x][RL(y-1)]);
            
        }
    }
    
//    MagnetisationRatio = magnetisation / maxMagnetisim;
//    EnergyRatio = energy / absMinEnergy;
    
    [MagnetisationRatioText setDoubleValue: MagnetisationRatio = magnetisation / maxMagnetisim];
    [EnergyRatioText        setDoubleValue: EnergyRatio = energy / absMinEnergy];

    
    
    [self setNeedsDisplay:YES];
    
}




- (void)animate:(id)anObject
{
    // NSLog(@"in animate");
    while (YES)
    {
        if (not [pauseButton state])
        {
            [self animateStep];
            [self setNeedsDisplay:YES];
        }
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:  [speedSlider doubleValue] ]];
        //   NSLog(@"speed slider %lf", [speedSlider doubleValue] );
        
    }
}

- (void)animateStep
{
    
    for ( int x = 0; x < size; x++)
    {
        for ( int y = 0; y < size; y++)
        {
            
            double dE = 2 * spin[x][y] * (spin[RH(x+1)][y] + spin[x][RH(y+1)] + spin[RL(x-1)][y] + spin[x][RL(y-1)]);
        
        if ( dE < 0 or (exp(-dE / temprature) > RANDOM) )
        {
            spin [x][y] = -spin[x][y];
            magnetisation += 2 * spin[x][y];
            energy += dE;
            
           
            
        }
            
            
        }
        [MagnetisationRatioText setDoubleValue: MagnetisationRatio = magnetisation / maxMagnetisim];
        [EnergyRatioText        setDoubleValue: EnergyRatio = energy / absMinEnergy];
        

    }
}



- ( IBAction)saveDataTemp:(id)sender
{

    
    
    
    
    dT            = [tempStepText doubleValue];
    stoppingTemp  = [stoppingTempText doubleValue];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"myTempData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK)
        {
            
            
            [savePanel close]; // close save panel while data is being aquired
            
            
            const char *cFileName = [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
            FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
            {
                fprintf(dataFileP, "Temprature \t M_Mo \t E_Eo \n");
                
                for (double t = -10; t < stoppingTemp; t += dT )
                {
                    for ( int x = 0; x < size; x++)
                    {
                        for ( int y = 0; y < size; y++)
                        {
                            
                            double dE = 2 * spin[x][y] * (spin[RH(x+1)][y] + spin[x][RH(y+1)] + spin[RL(x-1)][y] + spin[x][RL(y-1)]);
                            
                            if ( dE < 0 or (exp(-dE / t) > RANDOM) )
                            {
                                spin [x][y] = -spin[x][y];
                                magnetisation += 2 * spin[x][y];
                                energy += dE;
                            }
                        }
                    }
                    fprintf(dataFileP, "%lf \t %lf \t %lf\n", t, magnetisation/maxMagnetisim, energy/absMinEnergy);
                    
                }
                
            }
            fclose(dataFileP);

            
            NSBeep(); //alert user for completion of data recording
            
        }
    }];


    
}


- ( IBAction)saveDataTime:(id)sender
{
    
    
    start = clock();
    
    
    duration            = [durationText doubleValue];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"myTimeData.txt"];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK)
        {
            
            
            [savePanel close]; // close save panel while data is being aquired
            
            
            const char *cFileName = [[[ savePanel URL ]path ] cStringUsingEncoding:NSUTF8StringEncoding];
            FILE *dataFileP = fopen(cFileName, "w");   // c - style IO is okay
            {
                fprintf(dataFileP, "Time \t M_Mo \t E_Eo \n");
                
                for (double t = 0; t < duration; t ++ )
                {
                    for ( int x = 0; x < size; x++)
                    {
                        for ( int y = 0; y < size; y++)
                        {
                            
                            double dE = 2 * spin[x][y] * (spin[RH(x+1)][y] + spin[x][RH(y+1)] + spin[RL(x-1)][y] + spin[x][RL(y-1)]);
                            
                            if ( dE < 0 or (exp(-dE / temprature) > RANDOM) )
                            {
                                spin [x][y] = -spin[x][y];
                                magnetisation += 2 * spin[x][y];
                                energy += dE;
                            }
                        }
                    }
                    fprintf(dataFileP, "%lf \t %lf \t %lf\n", t, magnetisation/maxMagnetisim, energy/absMinEnergy);
                    
                }
                
            }
            fclose(dataFileP);
            
            

            
            NSBeep(); //alert user for completion of data recording
            
        }
    }];
    
    
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    
    
    NSLog(@"time used %lf", cpu_time_used);
    
}



-(IBAction)saveDataTempButton:(id)sender
{
    if ([dataAquireTempButton state])
    {
        [self saveDataTemp:self];
    }
    
}


-(IBAction)saveDataTimeButton:(id)sender
{
    if ([dataAquireTimeButton state])
    {
        [self saveDataTime:self];
    }
    
}

// Radio button actions to change one pulse/ two pulse
- (IBAction)changeDrawingStyle:(id)sender
{
    drawingStyle = [sender tag];
    [self display];
}


-(void) saveImage:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"Ising.png"];
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



@end
