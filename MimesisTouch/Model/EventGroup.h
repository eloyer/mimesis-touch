//
//  EventGroup.h
//  GeNIE
//
//  Created by Erik Loyer on 10/25/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

//	The EventGroup class defines a collection of Events that can occur in a
//	Setting, along with their start and end trigger conditions.

#import <Foundation/Foundation.h>


@class Event;
@class EventAtom;
@class TreeNode;

@interface EventGroup : NSObject {
	
	NSString					*identifier;				///< Unique identifier for the event group.
	NSArray						*types;						///< The event group's types (determines the event structure clauses during which the event group can be played).
	NSMutableArray				*startConditions;			///< Cconditions that must be fulfilled before the event group can be triggered.
	NSString					*startConditionsOperator;	///< Operator to be applied across all start conditions.
	NSMutableDictionary			*events;					///< Dictionary of events that can be played during this event group.
	Event						*initialEvent;				///< Event to be played when the event starts.
	NSMutableArray				*currentEvents;				///< Events that are currently playing.
    NSMutableArray              *immediateEvents;           ///< Events to be played back immediately.
	NSMutableArray				*endConditions;				///< Conditions that must be fulfilled to complete the event group.
	NSString					*endConditionsOperator;		///< Operator to be applied across all end conditions.

}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) NSMutableArray *startConditions;
@property (nonatomic, retain) NSString *startConditionsOperator;
@property (nonatomic, retain) NSMutableDictionary *events;
@property (nonatomic, retain) Event *initialEvent;
@property (nonatomic, retain) NSMutableArray *currentEvents;
@property (nonatomic, retain) NSMutableArray *endConditions;
@property (nonatomic, retain) NSString *endConditionsOperator;

- (id) initWithNode:(TreeNode *)node;
- (void) setCurrentEvent:(Event *)event;
- (void) handleEventAtomEnd:(NSNotification *)notification;
- (void) handleNestedEventStart:(NSNotification *)notification;
- (void) handleEventEnd:(NSNotification *)notification;
- (void) enqueueImmediateEventAtom:(EventAtom *)eventAtom;
- (void) update:(NSTimer *)timer;
- (void) end;
- (void) reset;

@end
