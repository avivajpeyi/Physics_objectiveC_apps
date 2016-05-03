//
//  IsingView.h
//  Ising
//
//  Created by Avi on 3/28/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
# import <time.h>







#define RANDOM ( (double) ( random() ) / RAND_MAX )
#define RH(n) ( (n < size) ? n : 0      )
#define RL(n) ( (n >= 0  ) ? n : size-1 )
#define SQR(x) ((x)*(x))

const short size = 512;

@interface IsingView : NSView
{
    
      NSImage *myImage;
    
    clock_t start, end;
    
    double cpu_time_used;
    
    short spin[size][size];
    
    
    double temprature, energy, magnetisation;



    double absMinEnergy, maxMagnetisim;
    
    

    NSBitmapImageRep *myBitMapRep;
    
    
    IBOutlet id pauseButton;
    IBOutlet id speedSlider;
    IBOutlet id dataAquireTempButton;
    IBOutlet id dataAquireTimeButton;
    
    double EnergyRatio, MagnetisationRatio;
    IBOutlet id tempratureText, MagnetisationRatioText, EnergyRatioText;
    
    double dT, stoppingTemp;
    IBOutlet id tempStepText, stoppingTempText;
    
    double duration;
    IBOutlet id durationText;
    
    
    NSInteger drawingStyle;
    
    
}


- (void) drawRect:(NSRect)dirtyRect;
- (IBAction)reset:(id)sender;
-(IBAction)saveDataTemp:(id)sender;
-(IBAction)saveDataTime:(id)sender;
-(IBAction)saveDataTempButton:(id)sender;

-(void)animateStep;
- (void)animate:(id)anObject;
-(IBAction)saveImage:(id)sender;

@end
