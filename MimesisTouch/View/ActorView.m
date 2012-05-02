//
//  ActorView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/19/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The ActorView is responsible for rendering an actor model as defined by the
/// narrative script. To create your own ActorViews, extend this abstract class to
/// create new classes for each actor, each with its own custom behavior.

#import "ActorView.h"


@implementation ActorView

@synthesize actor;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new ActorView.
 * @param modelActor The actor model which this view will render.
 * @param cntrllr The main narrative controller.
 * @return The new ActorView.
 */
- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if ((self = [super init])) {
		actor = modelActor;
		controller = cntrllr;
	}
	
	return self;
}

- (void) dealloc {
    self.actor = nil;
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
