//
//  ResizeView.h
//  Resize
//
//  Created by Avi on 3/7/16.
//  Copyright © 2016 AVI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResizeView : NSView
{

IBOutlet id foreColorWell;
IBOutlet id backColorWell;
}


- (void) awakeFromNib;
- (IBAction) update:(id)sender;
- (void) WindowResized: (NSNotification *) notification;

@end
