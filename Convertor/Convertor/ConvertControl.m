//
//  ConvertControl.m
//  Convertor
//
//  Created by Avi Vajpeyi on 2/15/16.
//  Copyright © 2016 Avi Vajpeyi. All rights reserved.
//

#import "ConvertControl.h"

@implementation ConvertControl


- (IBAction)convert:(id)sender
{
    double mi = [miText doubleValue]; // ni = miText.doubleValue
    double km = mi * 1.609;
    [kmText setDoubleValue:km];
    
    [secText setDoubleValue: [minText doubleValue] * 60];
}

@end
