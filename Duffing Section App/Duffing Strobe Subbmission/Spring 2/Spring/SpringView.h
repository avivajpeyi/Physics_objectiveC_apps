

#define a(t,x,v) (- viscosity * (v) + stiff * (x) - hard *(x)*(x)*(x) + amplitude * cos( frequency * (t) + phase))


#import <Cocoa/Cocoa.h>

@interface SpringView : NSView

{
    // ASK ABOUT WIDTH AND HEIGHT
    
    int width, height;
    
    
    
    double position, velocity, t;
    double dt;
    
    double stiff, hard, viscosity, amplitude, frequency, period, phase;
    
    int nDtPerPeriod, nPeriodPerTransiet, nDisplay ; // we will wait n forcing periods before we begin drawing
    
    double scale, deltaPhase; //this will give us 40 cross sections
    
    
    IBOutlet id phaseText, scaleText, amplitudeText, frequencyText, nPeriodPerTransientText, NdtText, nDisplayText;
    IBOutlet id phaseSlider, ScalingSlider, amplitudeSlider, frequencySlider, nPeriodPerTransientSlider, NdtSlider, nDsiplaySlider, speedSlider;
    
    
    IBOutlet id pauseButton, origValuesButton;
    
    
    
    double  mX, bX, mY, bY;
    
    SEL algorithm; // selector algorithm
    short alg;
    
    NSImage *myImage;
    NSBitmapImageRep *myBitMapRep;
}


- (void) awakeFromNib;
- (IBAction) reset:(id)sender;
-(IBAction)OrigValuesReset:(id)sender;


- (IBAction) update:(id)sender;

- (void) animate: (id) object;



- (void) eulerCromer;
- (void) RK1;
- (void) RK2;
- (void) RK3;
- (void) RK4;
- (IBAction)algorithmChooser:(id)sender;



-(IBAction) saveImage:(id)sender;

@end
