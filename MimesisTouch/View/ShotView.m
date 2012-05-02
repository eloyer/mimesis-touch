//
//  ShotView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/13/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The ShotView class is responsible for rendering a given shot. Extend this abstract 
///	class to create individual shot classes with custom behavior.

#import "ShotView.h"


@implementation ShotView

@synthesize shot;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new ShotView.
 * @param modelShot The shot model which this view is rendering.
 * @param cntrllr Instance of the narrative controller.
 * @return The new ShotView.
 */
- (id) initWithModel:(Shot *)modelShot controller:(NarrativeController *)cntrllr; {
	
	if (self = [super init]) {
		
		shot = modelShot;
		controller = cntrllr;
		
	}
	
	return self;
}

- (void) dealloc {
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
