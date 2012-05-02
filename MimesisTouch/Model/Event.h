//
//  Event.h
//  GeNIE
//
//  Created by Erik Loyer on 10/25/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The Event class defines a collection of actions (EventAtoms) that are executed
///	when the event is triggered.

#import <Foundation/Foundation.h>


@class EventAtom;
@class TreeNode;

@interface Event : NSObject {

	NSString				*identifier;					///< Unique identifier for the event.
	NSMutableArray			*startConditions;				///< Conditions that must be fulfilled to trigger the event.
	NSString				*startConditionsOperator;		///< Operator to be applied across all start conditions.
	NSMutableArray			*eventAtoms;					///< Event atoms that comprise the event.
	EventAtom				*currentEventAtom;				///< The currently active event atom.
    NSMutableArray          *immediateEventAtoms;           ///< Queue of event atoms to be played immediately (before the next scheduled atom that belongs to the event).
    EventAtom               *parentEventAtom;               ///< The event atom that triggered this event's playback (for nested events).
	int						maxCount;						///< Number of times the event can be played.
	int						playCount;						///< Number of times the event has been played.
    int                     weight;                         ///< Likelihood that the event will be played relative to other eligible events.
	BOOL					isRandom;						///< Will this event play a single randomly chosen event atom instead of all of its atoms in sequence?
	BOOL					isCompleted;					///< Has the event been completed?
    int                     lastIndex;                      ///< Index of the last non-immediate atom played.
	
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSMutableArray *startConditions;
@property (nonatomic, retain) NSString *startConditionsOperator;
@property (nonatomic, retain) NSMutableArray *eventAtoms;
@property (nonatomic, retain) EventAtom *currentEventAtom;
@property (nonatomic, retain) NSMutableArray *immediateEventAtoms;
@property (readwrite) int maxCount;
@property (readwrite) int playCount;
@property (readwrite) int weight;
@property (readwrite) BOOL isRandom;
@property (readwrite) BOOL isCompleted;

- (id) initWithNode:(TreeNode *)node;
- (id) initWithEventAtom:(EventAtom *)eventAtom;
- (BOOL) play;
- (void) playNested:(EventAtom*)eventAtom;
- (BOOL) startConditionsHaveBeenMet;
- (void) enqueueImmediateEventAtom:(EventAtom *)eventAtom;
- (void) executeEventAtom:(EventAtom *)eventAtom;
- (void) handleEventAtomEnd:(NSNotification *)notification;
- (void) reset;

@end
