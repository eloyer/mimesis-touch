//
//  NarrativeController.h
//  GeNIE
//
//  Created by Erik Loyer on 10/12/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	Controller for the narrative. Receives commands and routes them to 
/// enact changes in program state.

#import "NarrativeController.h"
#import "NarrativeModel.h"
#import "Shot.h"
#import "EventAtom.h"
#import "cocos2d.h"
#import "Setting.h"
#import "EventGroup.h"
#import "Event.h"
#import "Shot.h"
#import "Globals.h"


@implementation NarrativeController

@synthesize model;
@synthesize view;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new NarrativeController
 * @return The new NarrativeController.
 */
- (id) init {
	
	if (self = [super init]) {
		
	}
	
	return self;
}

- (void) dealloc {
	self.view = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Launches the narrative.
 */
- (void) startNarrative {
	
	// TODO: reset narrative state
	
	if (model.hasStarted) {
		[model reset];
	}
	
	[model setStartedState:@"true"];
	[model setPausedState:@"false"];
	
	// we start the narrative with the first declared setting
	[model setCurrentSetting:model.initialSetting];
	
}

/**
 * Pauses the narrative.
 */
- (void) pauseNarrative {
	[model setPausedState:@"true"];
}

/**
 * Resumes the narrative.
 */
- (void) resumeNarrative {
	[model setPausedState:@"false"];
}

/**
 * Makes the specified shot the current shot in the current scene (if possible).
 * @param shot The shot to be made current.
 */
- (void) setShot:(Shot *)shot {
    DLog(@"--------- new shot: %@", shot.identifier);
	[model.currentSetting setCurrentShot:shot];
}

/**
 * Takes any action relevant to the execution of the specified event atom.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {

    // setCurrentShot
    if ([eventAtom.command isEqualToString:@"setCurrentShot"]) {
        Shot *shot = [model parseItemRef:eventAtom.content];
        if (shot != nil) {
            [self setShot:shot];
        }
        [eventAtom performSelector:@selector(handleEnd) withObject:NULL afterDelay:0.5];
    }
	
}

/**
 * Advances to the next event atom in all currently playing events.
 */
- (void) nextEventAtom {
    
    int i;
    int n = [model.currentSetting.currentEventGroup.currentEvents count];
    Event *event;
    for (i=0; i<n; i++) {
        event = [model.currentSetting.currentEventGroup.currentEvents objectAtIndex:i];
        [self handleEventAtomEnd:event.currentEventAtom];
    }
    
}

/**
 * Picks a shot adjacent to the current shot and makes it the current shot.
 */
- (void) setAdjacentShotAsCurrent {
    NSArray *shots = [model.currentSetting.currentShot.adjacentShots allValues];
    Shot *newShot;
    do {
        newShot = [shots objectAtIndex:rand() % [shots count]];
    } while (newShot.isMuted); // TODO: Fix this so you can't get in an infinite loop
    [self setShot:newShot];
}

/**
 * The view calls this method to let the controller know an event atom has
 * finished playing.
 * @param eventAtom The event atom which has been completed.
 */
- (void) handleEventAtomEnd:(EventAtom *)eventAtom {
	[eventAtom handleEnd];
}

@end
