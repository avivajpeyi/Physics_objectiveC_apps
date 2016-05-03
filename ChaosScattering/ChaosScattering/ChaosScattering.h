/**********************************************************************
 
                Chaos Scattering on A Complex Topography
                              Header File
 
 Name: Avi Vajpeyi
 Assignment: Final Project
 Title: Chaos Scattering
 Course: CS 200
 Semester: Spring 2016
 Instructor: D. Byrnes
 Date: April 14th, 2016
 
 Sources consulted: Dr. Lindner of the College of Wooster, Physics Dpt
 Program description: This program simulates the trajectory of a 
                      particle through a region with four symetric 
                      Gaussian Potentials
 
 Known bugs: if the time step is decreased below 0.03, then the number
             points we integrate over is not enough to complete path

**********************************************************************/

#import <Cocoa/Cocoa.h>

/**********************************************************************
 *                 Macro Functions and Constants                      *
 **********************************************************************/

/*--------------------------------------------------------------------*
 * SQR (x)                                                            *
 *  - computes the square of varible x                                *
 *--------------------------------------------------------------------*/
#define SQR(x) ((x)*(x))

/*--------------------------------------------------------------------*
 * acceleration_X(x,y) and acceleration_Y(x,y)                        *
 *  - compute the value of the X and Y component of acceleration      *
 *    due to the four symetric Gaussian Potentials                    *
 *--------------------------------------------------------------------*/
#define acceleration_X(x,y) ((-2) * exp (- (SQR(x)) - (SQR(y)) ) * (x) * (-1 + (SQR(x))) * (SQR(y)) )
#define acceleration_Y(x,y) ((-2) * exp (- (SQR(x)) - (SQR(y)) ) * (y) * (-1 + (SQR(y))) * (SQR(x)) )







// xWidth -> Bounds of the screen in pixels
static const int xWidth = 512;

// numPoints -> number of points for integration
static const int numPoints = 1000;

// compenets -> define x and y as 0 and 1 if used as indicies
enum components { x = 0 , y = 1};

// vector -> an ADT that has two compnents to it
struct vector { double x; double y; };


/**********************************************************************
 *                     Interface Data Members                         *
 **********************************************************************/
@interface ChaosScattering : NSView
{
    
    
    double time;
    
    //radius of the circle with which we calculate the scattering angle
    double radiusScattering;
    
    // time step for integration
    double dt;
    IBOutlet id dtText;
    
    // scale helps us switch between pixels and real world values
    double scale;
    
    // b is the impact parameter
    double b, bStart, bEnd, db;
        //b start, end and db are used to reocrd data for changing b
    double* b_archive;
        //b archive is where the data for changing db is stored
    IBOutlet id bStartText, bEndText, dbText, bText;

    
    // velX is the initial x velocity of the particle
    double velX , vStart, vEnd, dv;
        //vStart, vEnd, dv are used to record data for chaning velocity
    IBOutlet id velXText, vStartText, vEndText, dvText, velSlider;
    
    
    //Velocity - holds the velocity of the particle at time 't'
    vector Velocity;
    
    //Position - holds the velocity of the particle at time 't'
    vector Position;
    vector Position_archive[numPoints];
    
    //ScatteringAngle - the scattering angle of the trajectory
    vector Scattering_points[2];
    double scatteringAngle;     IBOutlet id scatteringAngleText;
    double* scatteringAngle_archive;
    
    
    //Energy - the energy of the particle at a particular point
    double Energy;
    IBOutlet id energyText;

    
    int N;
    
    
    IBOutlet id pauseButton;
    IBOutlet id speedSlider;
    
    Boolean trajectoryLine;
    
    IBOutlet id TrajectoryColorWell;      NSColor *TrajectoryColor;
    IBOutlet id DotColorWell;            NSColor *DotColor;

    NSInteger TrajectoryStyle;
    NSInteger BackgroundStyle;
    NSInteger IntegrationStyle;
    
    
    
    double numDxPerPixel, dx; //SHOULD I USE THIS APPROACH
    
    
    // the first index where the particle actually enters the screen
    int indexStart;
    
    
    NSImageView *backgroundImage;
    
    NSImage *myImage;
    NSBitmapImageRep *myBitMapRep;
    
    
    SEL algorithm; // selector algorithm

    double AcelType; // a double value which swiches accelceration
    
}


/**********************************************************************
 *                        Calculations                                *
 **********************************************************************/

/*--------------------------------------------------------------------
 ChaoticComputation:
 
 - This function calculates the trajectory of the particle, and 
    calculates the scatering angle for the given trajectory
 
 Precondition : All data memebers have been initialised
 Postcondition: Position of the particle's path has been computed,
                and the scattering angle has been calculated
 --------------------------------------------------------------------*/
-(void)ChaoticComputation;

/*--------------------------------------------------------------------
 FractalAngleDataOld:
 
 - Called by 'Awake from Nib', and initialises the various data
 members of the ChaoticScattering Class
 
 Precondition : None
 Postcondition: Sets the data members of the ChaoticScattering class
 to their default values.
 --------------------------------------------------------------------*/
-(IBAction)FractalAngleDataOld:(id)sender;

/*--------------------------------------------------------------------
 FractalAngleSaveData:
 
 - Iterates 'b' from a starting positition to a stopping position, 
    and calculates the value for the scattering angle at each 
    value of 'b' during the transit.
 
 Precondition : The button to save fractal data has been triggerd
 Postcondition: Creates a file with the values of 'b' and the 
                scattering angles.
 --------------------------------------------------------------------*/
-(IBAction)FractalAngleSaveData:(id)sender;

/*--------------------------------------------------------------------
 VelocitiesSaveData:
 
 - Iterates 'initial velocity' from a starting velocity to a
    stopping velocity, and calculates the value for the scattering angle
    at each value of 'initial velocity' for transits.
 
 Precondition : The button to save velocities data has been triggerd
 Postcondition: Creates a file with the values of 'vel' and the
                scattering angles.
 --------------------------------------------------------------------*/
-(IBAction)VelocitiesSaveData:(id)sender;


- (void)CalculateEnergyWithVel : (vector) V andPosit: (vector) X;
- (IBAction)EnergyData:(id)sender;

/*--------------------------------------------------------------------
 eulerCromer:
 
 - A numerical integration technique that updates the velocity and
    position of the particle. This is better than RK1.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
-(void)eulerCromer;

/*--------------------------------------------------------------------
 RK1:
 
 - A numerical integration technique, called Runge-Kutta 1, that
   updates the velocity and position of the particle. This is 
    very similar to Euler Cromer, however less accurate.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
-(void) RK1;

/*--------------------------------------------------------------------
 RK2:
 
 - A numerical integration technique, called Runge-Kutta 2, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and RK1.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
-(void) RK2;

/*--------------------------------------------------------------------
 RK3:
 
 - A numerical integration technique, called Runge-Kutta 3, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and the previous RK's.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
-(void) RK3;

/*--------------------------------------------------------------------
 RK4:
 
 - A numerical integration technique, called Runge-Kutta 4, that
 updates the velocity and position of the particle. This is
 better than Euler Cromer and the previous RK's.
 
 Precondition : None
 Postcondition: Updates velocity and position of the particle
 --------------------------------------------------------------------*/
-(void) RK4;




/**********************************************************************/





/**********************************************************************
 *                        Initialisations                             *
 **********************************************************************/

/*--------------------------------------------------------------------
 Awake From Nib:
 
 -  A function present in all objective C classes that is called 
    whenever the window needs to be recreated, and the first function 
    called when the program is run. This includes when the window 
    is moved.
 
 Precondition : None
 Postcondition: Creates a window for the Application as displayed
                in the 'MainMenu.xib' file.
 --------------------------------------------------------------------*/
-(void)awakeFromNib;


/*--------------------------------------------------------------------
 start:
 
 - Called by 'Awake from Nib', and initialises the various data 
    members of the ChaoticScattering Class
 
 Precondition : None
 Postcondition: Sets the data members of the ChaoticScattering class
                to their default values.
 --------------------------------------------------------------------*/
-(void)start;



/**********************************************************************/






/**********************************************************************
 *                        Updates                                     *
 **********************************************************************/


/*--------------------------------------------------------------------
 reset:
 
 - Called by 'Awake from Nib', and various locations in the program
    to reset the values of the application to the user defined values
    and to restart the aniumation process.
 
 Precondition : None
 Postcondition: Resets the values of the data memebers of the 
                ChaoticScattering class to user defined values.
 --------------------------------------------------------------------*/
-(IBAction)reset:(id)sender;

/*--------------------------------------------------------------------
 animate:
 
 - Called by the animation thread generated by the 'awake from nib' 
    function, and constantly updates the value of 'N' and redraws the 
    data on the screen. By updating 'N' the animation of the particle
    traversing the hills gets moved to the next position.
 
 Precondition : None
 Postcondition: Updates value of N, and redraws the data on screen
 --------------------------------------------------------------------*/
-(IBAction)animate :(id)object;


/*--------------------------------------------------------------------
 WindowResized:
 
 - Called by the application automatically if the window of the app
 is resized to a different value.
 
 Precondition : Window resizing must be within the bounds specified
 by the 'MainMenu.xib' file
 Postcondition: Resizes the window arroding to a mouse drag
 --------------------------------------------------------------------*/
- (void) WindowResized: (NSNotification *) notification;


/*--------------------------------------------------------------------
 drawRect:
 
 - Called when the application is first run, and whenever there need
    to be updates made for the on screen display in the view. This 
    is where all the commands for draing on the screen are given.
 
 Precondition : None
 Postcondition: Draws on the Custom View in the MainMenu.xib
 --------------------------------------------------------------------*/
-(void)drawRect:(NSRect)dirtyRect;


/*--------------------------------------------------------------------
 update:
 
 - A helper function that is liked to varius items in the MainMen.xib
    and hence is called when the item is intieracted with. It then 
    calls the drawRect function
 
 Precondition : None
 Postcondition: Calls the drawRect function
 --------------------------------------------------------------------*/
-(IBAction)update :(id)object;

/**********************************************************************
 *                        Mouse tracking                              *
 **********************************************************************/



/*--------------------------------------------------------------------
 mouseDown:
 
 - sets the values of 'b' to be the coordinate where the cursor was 
    placed down on the screen, if the cursor is in the 'View'
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the value of 'b' and the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseDown:(NSEvent *)theEvent;

/*--------------------------------------------------------------------
 mouseUp:
 
 - changes the shape of the mouse if the mouse is up to arrow/hand 
    depending on where it is on the screen
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseUp:(NSEvent *)theEvent;

/*--------------------------------------------------------------------
 mouseDragged:
 
 - if the mouse is dragged, then 'b' continuously changes along with 
    the coordinates of the mouse on the screen. Changes the cursor to 
    a closed hand cursor.
 
 Precondition : The mouse is on the screen and down
 Postcondition: Updates the shape of the cursor and value of 'b'
 --------------------------------------------------------------------*/
-(void)mouseDragged:(NSEvent *)theEvent;

/*--------------------------------------------------------------------
 mouseEntered:
 
 - if the mouse is moved above the view, then the cursor changes to 
    hand instead of arrow, and vice versa.
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseEntered:(NSEvent *)theEvent;

/*--------------------------------------------------------------------
 mouseExited:
 
 - if the mouse is moved out of the view, then the cursor changes to
    arrow instead of hand, and vice versa.
 
 Precondition : The mouse is on the screen
 Postcondition: Updates the shape of the cursor
 --------------------------------------------------------------------*/
-(void)mouseExited:(NSEvent *)theEvent;

/*--------------------------------------------------------------------
 createTrackingArea:
 
 - Creates the dimensions for the appliaciton to be able to track the
    position of the mouse, to be able to do other mouse function. 
    Called by the 'Awake from Nib' function.
 
 Precondition : None
 Postcondition: Creates the dimensions for where the mouse is tracked
 --------------------------------------------------------------------*/
-(void) createTrackingArea;

/*--------------------------------------------------------------------
updatingTrackingAreas:
 
 - This updates the tracking area of the mouse if there are changes 
    in the size of the window, if the window is minimized, etc.
 
 Precondition : The window's dimensions or position changes
 Postcondition: Updates the tracking dimensions for the mouse
 --------------------------------------------------------------------*/
-(void)updateTrackingAreas;

/**********************************************************************/



/**********************************************************************
 *                        Other Features                              *
 **********************************************************************/


/*--------------------------------------------------------------------
 Radio button actions
 
 - these following IBAction functions recive data from several radio 
    buttons in the 'MainMenu.xib' file, and accordingly make changes 
    to an option present in other location of the program with the 
    help of switch cases.
 
 Precondition : A radio button must be pressed
 Postcondition: the specific radio button's value is recorded
 --------------------------------------------------------------------*/
- (IBAction)chageBackgroundStyle:(id)sender;
- (IBAction)chagePotentialStyle:(id)sender;
- (IBAction)chageIntegrationStyle:(id)sender;



/*--------------------------------------------------------------------
writeToLogFile
 
 - This helps save data from the application window.
 
 Precondition : None
 Postcondition: data is saved in a text file
 --------------------------------------------------------------------*/
-(void) writeToLogFile:(NSString*)content;



/*--------------------------------------------------------------------
 saveImage
 
 - This saves an image of the current version of the chaotic 
    scattering regime
 
 Precondition : None
 Postcondition: An image of the chaotic scattering is stored
 --------------------------------------------------------------------*/
-(IBAction)saveImage:(id)sender;





@property (nonatomic, retain) NSTrackingArea* trackingArea;

@end
