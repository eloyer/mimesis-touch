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

#import "EventGroup.h"
#import "NarrativeModel.h"
#import "Event.h"
#import "Condition.h"
#import "TreeNode.h"
#import "Setting.h"
#import "Globals.h"


@implementation EventGroup

@synthesize identifier;
@synthesize types;
@synthesize startConditions;
@synthesize startConditionsOperator;
@synthesize events;
@synthesize initialEvent;
@synthesize currentEvents;
@synthesize endConditions;
@synthesize endConditionsOperator;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new EventGroup.
 * @param node A TreeNode representing the XML in the narrative script that defines the event group.
 * @return The new EventGroup.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		self.types = [[NSMutableArray alloc] init];
		self.startConditions = [[NSMutableArray alloc] init];
		self.events = [[NSMutableDictionary alloc] init];
		self.currentEvents = [[NSMutableArray alloc] init];
		self.endConditions = [[NSMutableArray alloc] init];
        immediateEvents = [[NSMutableArray alloc] init];
		
		TreeNode *data;
		NSArray *dataArray;
		NarrativeModel *model = [NarrativeModel sharedInstance];
		NSString *typeString;
		Condition *condition;
		Event *event;
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.eventGroups allValues] count];
			self.identifier = [NSString stringWithFormat:@"eventGroup%i", count];
		}
		
		// parse types
		typeString = [node attributeForKey:@"type"];
		if (typeString != nil) {
			self.types = [typeString componentsSeparatedByString:@","];
		}
		
		// parse start conditions and operator
		data = [node objectForKey:@"startConditions"];
		dataArray = [data objectsForKey:@"condition"];
		for (data in dataArray) {
			condition = [[Condition alloc] initWithNode:data];
			[startConditions addObject:condition];
			[model.conditions addObject:condition];
		}
		self.startConditionsOperator = @"and";
		if ([data hasAttribute:@"operator"]) {
			self.startConditionsOperator = [data attributeForKey:@"operator"];
		}
		
		// parse events
		dataArray = [node objectsForKey:@"event"];
		for (data in dataArray) {
			event = [[Event alloc] initWithNode:data];
			NSLog(@"add event %@", event.identifier);
			[events setObject:event forKey:event.identifier];
			[model.events setObject:event forKey:event.identifier];
		}
		
		// parse initial event
		data = [node objectForKey:@"initialEvent"];
		if (data != nil) {
			self.initialEvent = [events objectForKey:[data attributeForKey:@"eventRef"]];
		}
		
		// parse end conditions and operator
		data = [node objectForKey:@"endConditions"];
		self.endConditionsOperator = @"and";
		if ([data hasAttribute:@"operator"]) {
			self.endConditionsOperator = [data attributeForKey:@"operator"];
		}
		dataArray = [data objectsForKey:@"condition"];
		for (data in dataArray) {
			condition = [[Condition alloc] initWithNode:data];
			[endConditions addObject:condition];
			[model.conditions addObject:condition];
		}
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNestedEventStart:) name:@"NestedEventStart" object:nil];
		
	}
	
	return self;
	
}

- (void) dealloc {
	self.identifier = nil;
	self.types = nil;
	self.startConditions = nil;
	self.startConditionsOperator = nil;
	self.events = nil;
	self.currentEvents = nil;
    [immediateEvents release];
	self.endConditions = nil;
	self.endConditionsOperator = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Makes the specified event the current event.
 * @param event The event to be made current.
 */
- (void) setCurrentEvent:(Event *)event {
	
	if ((![currentEvents containsObject:event]) && (event != nil)) {
		
		// TODO: add error checking in case event is not in the event group
		
		//DLog(@"set current event: %@", event.identifier);
		
		[currentEvents addObject:event];
		[[NarrativeModel sharedInstance] forward:_cmd object:event]; // inform model observers
		
		[event play];
		
	}
	
}

/**
 * Handles completion of an event atom.
 * @param notification The notification that the event atom has been completed.
 */
- (void) handleEventAtomEnd:(NSNotification *)notification {
	
	Event *event;
	for (event in currentEvents) {
		if ([event.eventAtoms containsObject:[notification object]] || [event.immediateEventAtoms containsObject:[notification object]]) {
			[event handleEventAtomEnd:notification];
		}
	}
			 
}

/**
 * Handles the start of a nested event.
 * @param notification The notification that a nested event has started.
 */
- (void) handleNestedEventStart:(NSNotification *)notification {
    
    [currentEvents addObject:[notification object]];
    
    //DLog(@"add nested event");
    
}

/**
 * Handles completion of an event.
 * @param notification The notification that an event has been completed.
 */
- (void) handleEventEnd:(NSNotification *)notification {
	
	[currentEvents removeObject:[notification object]];
	
	// if no other events are playing, and there are no ending conditions, then end the event group
	if (([immediateEvents count] == 0) && ([currentEvents count] == 0) && ([endConditions count] == 0)) {
        [self end];
	}
	
}

/**
 * Queues up the specific event atom for immediate playback.
 * @param eventAtom The event atom to be played immediately.
 */
- (void) enqueueImmediateEventAtom:(EventAtom *)eventAtom {
    if ([currentEvents count] > 0) {
        [[currentEvents lastObject] enqueueImmediateEventAtom:eventAtom];
    } else {
        Event *event = [[Event alloc] initWithEventAtom:eventAtom];
        [self setCurrentEvent:event];
    }
}

/**
 * The event group's event loop.
 * @param timer The timer object which calls this method.
 */
- (void) update:(NSTimer *)timer {
	
	// if no events are currently playing, and there are end conditions to be met, then
	if ([currentEvents count] == 0) {
		
		BOOL eventGroupWillEnd = FALSE;
		
        // if there are some end conditions, then
		if ([endConditions count] > 0) {
			
			// check to see if the end conditions have been met
			BOOL anyConditionMet = FALSE;
			BOOL allConditionsMet = TRUE;
			Condition *condition;
			for (condition in endConditions) {
				if (![condition hasBenMet]) {
					allConditionsMet = FALSE;
				} else {
					anyConditionMet = TRUE;
				}
			}
			
			// AND operator: if all conditions have been met, the event group ends
			if ([endConditionsOperator isEqualToString:@"and"]) {
				eventGroupWillEnd = allConditionsMet;
				
			// OR operator: if any condition has been met, the event group ends
			} else if ([endConditionsOperator isEqualToString:@"or"]) {
				eventGroupWillEnd = anyConditionMet;
			}
		}
		
		// end the event group if necessary
		if (eventGroupWillEnd) {
			[self end];

		// otherwise, check to see if a new event can be started
		} else {
            
			NSArray *eventArray = [events allValues];
            NSMutableArray *eligibleEvents = [NSMutableArray array];
            int totalWeight = 0;
			Event *event;
			int i;
			int n = [eventArray count];
            
            DLog(@"----");
            
            // gather all the events that are eligible to be triggered
			for (i=0; i<n; i++) {
				event = [eventArray objectAtIndex:i];
				if ((event.weight > 0) && [event startConditionsHaveBeenMet]) { // ignore events with zero weight
                    [eligibleEvents addObject:event];
                    //NSLog(@"eligible: %@", event.identifier);
                    totalWeight += event.weight;
				}
			}
            
            // make a weighted choice of one event
            if ([eligibleEvents count] > 0) {
                int randomWeight = rand() % totalWeight;
                int weightCount = 0;
                n = [eligibleEvents count];
                for (i=0; i<n; i++) {
                    event = [eligibleEvents objectAtIndex:i];
                    weightCount += event.weight;
                    if (randomWeight < weightCount) {
                        [self setCurrentEvent:event];
                        break;
                    }
                }
            }
             
		}
		
	}
	
}

/**
 * Ends the event group.
 */
- (void) end {
    //[self reset];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventGroupEnd" object:self];
}

/**
 * Resets the event group.
 */
- (void) reset {
	NSArray *eventArr = [events allValues];
	Event *event;
	for (event in eventArr) {
		[event reset];
	}
	[currentEvents removeAllObjects];
}

@end
