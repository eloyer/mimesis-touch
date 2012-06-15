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

#import "Event.h"
#import "NarrativeModel.h"
#import "EventAtom.h"
#import "TreeNode.h"
#import "Condition.h"
#import "Actor.h"
#import "Topic.h"
#import "Globals.h"


@implementation Event

@synthesize identifier;
@synthesize startConditions;
@synthesize startConditionsOperator;
@synthesize eventAtoms;
@synthesize currentEventAtom;
@synthesize immediateEventAtoms;
@synthesize maxCount;
@synthesize playCount;
@synthesize isRandom;
@synthesize isCompleted;
@synthesize weight;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Event.
 * @param node A TreeNode representing the XML in the narrative script that defines the event.
 * @return The new Event.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		self.maxCount = 99999;
		self.playCount = 0;
		self.startConditions = [[NSMutableArray alloc] init];
		self.eventAtoms = [[NSMutableArray alloc] init];
        self.immediateEventAtoms = [[NSMutableArray alloc] init];
		self.isCompleted = FALSE;
        parentEventAtom = nil;
        lastIndex = 0;
		
		TreeNode *data;
		NSArray *dataArray;
		NarrativeModel *model = [NarrativeModel sharedInstance];
		EventAtom *eventAtom;
		Condition *condition;
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.events allValues] count];
			self.identifier = [NSString stringWithFormat:@"event%i", count];
		}
		
		// parse max count
		if ([node hasAttribute:@"maxCount"]) {
			self.maxCount = [[node attributeForKey:@"maxCount"] intValue];
		}
		
		// random access?
		self.isRandom = FALSE;
		if ([node hasAttribute:@"random"]) {
			self.isRandom = [[node attributeForKey:@"random"] isEqualToString:@"true"];
		}
        
        // trigger probability weighting
        self.weight = 1;
        if ([node hasAttribute:@"weight"]) {
            self.weight = [[node attributeForKey:@"weight"] intValue];
        }
		
		// parse start conditions
		data = [node objectForKey:@"startConditions"];
		self.startConditionsOperator = @"and";
		if ([data hasAttribute:@"operator"]) {
			self.startConditionsOperator = [data attributeForKey:@"operator"];
		}
		dataArray = [data objectsForKey:@"condition"];
		for (data in dataArray) {
			condition = [[Condition alloc] initWithNode:data];
			[startConditions addObject:condition];
			[model.conditions addObject:condition];
		}
		
		// parse event atoms
		dataArray = [node objectsForKey:@"eventAtom"];
		for (data in dataArray) {
			eventAtom = [[EventAtom alloc] initWithNode:data];
			[eventAtoms addObject:eventAtom];
			[model.eventAtoms addObject:eventAtom];
		}
		
	}
	
	return self;
	
}

/**
 * Creates a one-off event for the purposes of playing a specified event atom.
 * @param eventAtom The event atom to be played.
 * @return The new Event.
 */
- (id) initWithEventAtom:(EventAtom *)eventAtom {
	
	if ((self = [super init])) {
		
		self.maxCount = 99999;
		self.playCount = 0;
		self.startConditions = [[NSMutableArray alloc] init];
		self.eventAtoms = [[NSMutableArray alloc] init];
        self.immediateEventAtoms = nil;
		self.isCompleted = FALSE;
        parentEventAtom = nil;
		self.isRandom = FALSE;
        self.weight = 1;
        self.identifier = @"temporaryEvent";
        
        [eventAtoms addObject:eventAtom];
		
	}
	
	return self;    
}

- (void) dealloc {
	self.identifier = nil;
	self.startConditions = nil;
	self.startConditionsOperator = nil;
	self.eventAtoms = nil;
    [immediateEventAtoms release];
	self.currentEventAtom = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Starts playback of the event.
 * @return Returns true if the event was started successfully.
 */
- (BOOL) play {
	
	if ((playCount < maxCount) || (maxCount == 99999)) {
		NSLog(@"%@ PLAY ------------", identifier);
        
        if (parentEventAtom) {
            [parentEventAtom release];
        }
		
		// sequential playback
		if (!isRandom) {
			self.currentEventAtom = [eventAtoms objectAtIndex:0];
			
		// random access playback
		} else {
			self.currentEventAtom = [eventAtoms objectAtIndex:rand() % [eventAtoms count]];
		}

		[self executeEventAtom:currentEventAtom];
        
        return true;
	} else {
		NSLog(@"%@ COULD NOT PLAY", identifier);
        return false;
    }
	
}

/**
 * Starts playback of the event, with reference to the
 * event atom that triggered playback.
 * @param eventAtom The event atom that triggered playback of this atom.
 */
- (void) playNested:(EventAtom*)eventAtom {
    
    NSLog(@"%@ PLAY NESTED ------------", identifier);
    if ([self play]) parentEventAtom = [eventAtom retain];
    
}

/**
 * Returns true if the event's start conditions have been met.
 * @return Returns true if the event's start conditions have been met.
 */
- (BOOL) startConditionsHaveBeenMet {
	
	BOOL startConditionsMet = FALSE;
	BOOL anyConditionMet;
	BOOL allConditionsMet;
    
    //NSLog(@"%@ check start conditions met", identifier);
	
	if (playCount < maxCount) {
		
		// if there are no start conditions, then this event can start on its own
		if ([startConditions count] == 0) {
			anyConditionMet = TRUE;
			allConditionsMet = TRUE;
			
        // if there are start conditions, test them
		} else {
			anyConditionMet = FALSE;
			allConditionsMet = TRUE;
			Condition *condition;
			for (condition in startConditions) {
				if (![condition hasBenMet]) {
					allConditionsMet = FALSE;
				} else {
					anyConditionMet = TRUE;
				}
			}
		}
		
		// AND operator: if all conditions have been met, event can start
		if ([startConditionsOperator isEqualToString:@"and"]) {
			startConditionsMet = allConditionsMet;
			
        // OR operator: if any condition has been met, event can start
		} else if ([startConditionsOperator isEqualToString:@"or"]) {
			startConditionsMet = anyConditionMet;
		}
		
	}
    
    //DLog(@"result: %@ %@ %@ %@", startConditionsOperator, (startConditionsMet) ? @"true" : @"false", (allConditionsMet) ? @"true" : @"false", (anyConditionMet) ? @"true" : @"false");
    
    if (startConditionsMet) NSLog(@"-------- %@ START CONDITIONS MET", identifier);
    
	return startConditionsMet;
}

// TODO: Add this change to the main GeNIE repo

/**
 * Adds an event atom to the queue of atoms to be played immediately, if the queue
 * doesn't contain it already.
 * @param The event atom to be played immediately.
 */
- (void) enqueueImmediateEventAtom:(EventAtom *)eventAtom {
    if (![immediateEventAtoms containsObject:eventAtom]) {
        [immediateEventAtoms addObject:eventAtom];
    }
}

/**
 * Sends a message to model observers that the specified event
 * atom is to be executed.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
    
    NarrativeModel *model = [NarrativeModel sharedInstance];
    Event *event = nil;
    BOOL alreadyPlayed = false;
	NSLog(@"%@ ATOM EXECUTE: %@ %@", eventAtom.itemRef, eventAtom.command, eventAtom.content);
    
    // system commands
    if ([currentEventAtom.itemRef isEqualToString:@"system"]) {
        
        // wait
        if ([currentEventAtom.command isEqualToString:@"wait"]) {
            [currentEventAtom performSelector:@selector(handleEnd) withObject:NULL afterDelay:[currentEventAtom.content floatValue]];
            
        // playEvent
        } else if ([currentEventAtom.command isEqualToString:@"playEvent"]) {
            [eventAtom handleExecute];
            [[NarrativeModel sharedInstance] forward:_cmd object:eventAtom]; // inform model observers
            event = [model parseItemRef:eventAtom.content];
            [event playNested:eventAtom];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NestedEventStart" object:event];
            alreadyPlayed = true;
        }
     }
    
    // notifies the rest of the system that the atom has been played
    // (unless it was a nested event)
    if (!alreadyPlayed) {
        [eventAtom handleExecute];
        [[NarrativeModel sharedInstance] forward:_cmd object:eventAtom]; // inform model observers
    }
    
}

/**
 * Handles completion of an event atom.
 * @param notification The notification that the event atom has been completed.
 */
- (void) handleEventAtomEnd:(NSNotification *)notification {
	
	EventAtom *eventAtom = [notification object];
    int index;
    
    NSLog(@"%@ ATOM END", identifier);
    
    // if it was an immediate event atom, remove it from the list
    index = [immediateEventAtoms indexOfObject:eventAtom];
    if (index != NSNotFound) {
        [immediateEventAtoms removeObjectAtIndex:index];
        index = lastIndex;
    } else {
        index = [eventAtoms indexOfObject:eventAtom];
    }
    
	if (index != NSNotFound) {
		
        // if there are immediate event atoms to be played, then play the next one
        if ([immediateEventAtoms count] > 0) {
            NSLog(@"%@ START IMMEDIATE ATOM", identifier);
            self.currentEventAtom = [immediateEventAtoms objectAtIndex:0];
			[self executeEventAtom:currentEventAtom];

		// the event isn't finished yet; start the next event atom
		} else if (((index+1) < [eventAtoms count]) && (!isRandom)) {
            //DLog(@"event %@: start next atom", identifier);
			self.currentEventAtom = [eventAtoms objectAtIndex:index+1];
			[self executeEventAtom:currentEventAtom];
            lastIndex = index + 1;
			
		// the event is finished; notify the model
		} else {
			playCount++;
			self.isCompleted = TRUE;
            
            // and notify that the event is done
            NSLog(@"%@ DONE", identifier);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EventEnd" object:self];
            
            // this is a nested event; notify that the parent event atom is done
            if (parentEventAtom) {
                NSLog(@"%@ NOTIFYING PARENT", identifier);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EventAtomEnd" object:parentEventAtom];
            }
		}

	}
}

/**
 * Resets the event.
 */
- (void) reset {
	self.playCount = 0;
	self.currentEventAtom = nil;
	self.isCompleted = FALSE;
}

@end
