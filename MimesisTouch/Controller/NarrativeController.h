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

#import <Foundation/Foundation.h>

@class NarrativeModel;
@class NarrativeView;
@class Shot;
@class EventAtom;

@interface NarrativeController : NSObject {

	NarrativeModel				*model;						///< Instance of the narrative model.
	NarrativeView				*view;						///< Instance of the primary narrative view.
	
}

@property (nonatomic, retain) NarrativeModel *model;
@property (nonatomic, retain) NarrativeView *view;

- (void) startNarrative;
- (void) pauseNarrative;
- (void) resumeNarrative;
- (void) setShot:(Shot *)shot;
- (void) nextEventAtom;
- (void) setAdjacentShotAsCurrent;
- (void) handleEventAtomEnd:(EventAtom *)eventAtom;

@end
