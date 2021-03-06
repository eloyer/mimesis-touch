//
//  PropView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/15/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The PropView class is responsible for rendering a given prop. Extend this abstract 
///	class to create individual prop classes with custom behavior.

#import "PropView.h"


@implementation PropView

@synthesize prop;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new PropView.
 * @param modelProp The prop model which this view is rendering.
 * @param cntrllr Instance of the narrative controller.
 * @return The new PropView.
 */
- (id) initWithModel:(Prop *)modelProp controller:(NarrativeController *)cntrllr {
 	
	if ((self = [super init])) {
		
		self.prop = modelProp;
		controller = cntrllr;
		
	}
	
	return self;
}

- (void) dealloc {
    self.prop = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
	
}

@end
