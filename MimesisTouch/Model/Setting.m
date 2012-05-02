//
//  Setting.h
//  GeNIE
//
//  Created by Erik Loyer on 10/13/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Setting class defines a "container" of narrative content, including actors, 
/// props, event groups and shots.

#import "Setting.h"
#import "NarrativeModel.h"
#import "EventGroup.h"
#import "Event.h"
#import "EventAtom.h"
#import "EventStructureClause.h"
#import "EventStructureMachine.h"
#import "Shot.h"
#import "TreeNode.h"
#import "Actor.h"
#import "Prop.h"
#import "Topic.h"
#import "Globals.h"


@implementation Setting

@synthesize identifier;
@synthesize eventStructureClauses;
@synthesize initialClause;
@synthesize shots;
@synthesize initialShot;
@synthesize currentShot;
@synthesize props;
@synthesize topics;
@synthesize actors;
@synthesize eventGroups;
@synthesize eventGroupsByType;
@synthesize initialEventGroup;
@synthesize currentEventGroup;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Setting.
 * @param node A TreeNode representing the XML in the narrative script that defines the setting.
 * @return The new Setting.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		self.eventStructureClauses = [[NSMutableDictionary alloc] init];
		self.shots = [[NSMutableDictionary alloc] init];
		self.props = [[NSMutableDictionary alloc] init];
		self.topics = [[NSMutableDictionary alloc] init];
		self.actors = [[NSMutableDictionary alloc] init];
		self.eventGroups = [[NSMutableDictionary alloc] init];
		self.eventGroupsByType = [[NSMutableDictionary alloc] init];
		
		TreeNode *data;
		TreeNode *eventStructureData;
		NSArray *dataArray;
		NarrativeModel *model = [NarrativeModel sharedInstance];
		Shot *shot;
		EventStructureClause *clause;
		Actor *actor;
		Prop *prop;
		Topic *topic;
		EventGroup *eventGroup;
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.settings allValues] count];
			self.identifier = [NSString stringWithFormat:@"setting%i", count];
		}
		
		// parse shots
		dataArray = [node objectsForKey:@"shot"];
		for (data in dataArray) {
			shot = [[Shot alloc] initWithNode:data];
			[shots setObject:shot forKey:shot.identifier];
			[model.shots setObject:shot forKey:shot.identifier];
		}
		
		// parse adjacent shots
		dataArray = [shots allValues];
		for (shot in dataArray) {
			[shot parseAdjacentShots];
		}
		
		// parse initial shot
		data = [node objectForKey:@"initialShot"];
		if (data != nil) {
			self.initialShot = [shots objectForKey:[data attributeForKey:@"shotRef"]];
		}
		
		// parse event structure data
		self.initialClause = nil;
		eventStructureData = [node objectForKey:@"eventStructure"];
		dataArray = [eventStructureData objectsForKey:@"eventClause"];
		for (data in dataArray) {
			clause = [[EventStructureClause alloc] initWithNode:data];
			[self.eventStructureClauses setObject:clause forKey:clause.identifier];
			[model.eventStructureClauses setObject:clause forKey:clause.identifier];
			if (initialClause == nil) {
				self.initialClause = clause;
			}
		}
			
		// parse event structure clause links
		dataArray = [eventStructureClauses allValues];
		for (clause in dataArray) {
			[clause parseLinkedClauses];
		}
		
		// parse props
		dataArray = [node objectsForKey:@"prop"];
		for (data in dataArray) {
			prop = [[Prop alloc] initWithNode:data];
			[props setObject:prop forKey:prop.identifier];
			[model.props setObject:prop forKey:prop.identifier];
		}
		
		// parse topics
		dataArray = [node objectsForKey:@"topic"];
		for (data in dataArray) {
			topic = [[Topic alloc] initWithNode:data];
			[topics setObject:topic forKey:topic.identifier];
			[model.topics setObject:topic forKey:topic.identifier];
		}
		
		// parse actors
		dataArray = [node objectsForKey:@"actor"];
		for (data in dataArray) {
			actor = [[Actor alloc] initWithNode:data];
			[actors setObject:actor forKey:actor.identifier];
			[model.actors setObject:actor forKey:actor.identifier];
			[model addObserver:actor];
		}
		
		// parse event groups
		dataArray = [node objectsForKey:@"eventGroup"];
		for (data in dataArray) {
			eventGroup = [[EventGroup alloc] initWithNode:data];
			[self addEventGroup:eventGroup];
			[model.eventGroups setObject:eventGroup forKey:eventGroup.identifier];
		}
		
		// parse initial event group
		data = [node objectForKey:@"initialEventGroup"];
		if (data != nil) {
			self.initialEventGroup = [eventGroups objectForKey:[data attributeForKey:@"eventGroupRef"]];
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventAtomEnd:) name:@"EventAtomEnd" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventEnd:) name:@"EventEnd" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventGroupEnd:) name:@"EventGroupEnd" object:nil];
		
	}
	
	return self;
}

- (void) dealloc {
	
	NarrativeModel *model = [NarrativeModel sharedInstance];
	
	self.identifier = nil;
	self.eventStructureClauses = nil;
	self.shots = nil;
	self.currentShot = nil;
	self.props = nil;
    self.topics = nil;
	
	Actor *actor;
	for (actor in actors) {
		[model removeObserver:actor];
	}
	self.actors = nil;
	
	self.eventGroups = nil;
	self.eventGroupsByType = nil;
	self.initialEventGroup = nil;
	self.currentEventGroup = nil;
	[super dealloc];
    
}

#pragma mark -
#pragma mark Utility methods

/**
 * Makes the specified shot the current shot.
 * @param shot The shot to be made active.
 */
- (void) setCurrentShot:(Shot *)shot {
	
	if ((shot != currentShot) && (shot != nil)) {
		
		// TODO: add error checking in case shot is not in the setting
		
		currentShot = shot;
		[[NarrativeModel sharedInstance] forward:_cmd object:currentShot]; // inform model observers
		
	}
	
}

/**
 * Adds the specified event group to the setting.
 * @param eventGroup The event group to be added.
 */
- (void) addEventGroup:(EventGroup *)eventGroup {
	
	NSArray *eventGroupArr = [eventGroups allValues];
	NSMutableArray *eventGroupTypeArr;
	NSString *type;
	
	// if the event group is not nil and hasn't already been added, then
	if (![eventGroupArr containsObject:eventGroup] && (eventGroup != nil)) {
		
		// add it to the dictionary of event groups
		[eventGroups setObject:eventGroup forKey:eventGroup.identifier];
		
		// loop through all of the event group's types
		for (type in eventGroup.types) {
		
			// check to see if an array for event groups of this group's type has already been created
			eventGroupTypeArr = [eventGroupsByType objectForKey:type];
			
			// if not, then create one
			if (eventGroupTypeArr == nil) {
				eventGroupTypeArr = [NSMutableArray arrayWithObject:eventGroup];
				[eventGroupsByType setObject:eventGroupTypeArr forKey:type];
				
			// otherwise, add it to the existing one
			} else {
				[eventGroupTypeArr addObject:eventGroup];
			}
		}
	}
	
}

/**
 * Makes the specified event group the current event group.
 * @param eventGroup The event group to be made active.
 */
- (void) setCurrentEventGroup:(EventGroup *)eventGroup {
	
	if (eventGroup != nil) {
		
		// TODO: add error checking in case event is not in the setting
		
		DLog(@"set current event group: %@", eventGroup.identifier);
		
		currentEventGroup = eventGroup;
		[[NarrativeModel sharedInstance] forward:_cmd object:currentEventGroup]; // inform model observers
		
		[eventGroup setCurrentEvent:eventGroup.initialEvent];
		
	}
	
}

/**
 * Handles completion of an event atom.
 * @param notification The notificiation object which triggered the call.
 */
- (void) handleEventAtomEnd:(NSNotification *)notification {
	[currentEventGroup handleEventAtomEnd:notification];
}

/**
 * Handles completion of an event.
 * @param notification The notificiation object which triggered the call.
 */
- (void) handleEventEnd:(NSNotification *)notification {
	[currentEventGroup handleEventEnd:notification];
}
	
/**
 * Handles the end of an event group by selecting a new event group to play.
 * @param notification The notificiation object which triggered the call.
 */
- (void) handleEventGroupEnd:(NSNotification *)notification {
	[self startNextEventGroup];
}

/**
 * Figures out the event group that should be played next and activates it.
 */
- (void) startNextEventGroup {
	
	EventGroup *eventGroup = nil;
	
	// if we haven't played any event groups yet, and an initial event group
	// was specified, then play it
	if ((currentEventGroup == nil) && (initialEventGroup != nil)) {
		eventGroup = initialEventGroup;
		
	// otherwise, use the event structure machine to figure out what event group should be next
	} else {
		NarrativeModel *model = [NarrativeModel sharedInstance];
		[model.eventStructureMachine startNextClause];
		
		// if the narrative hasn't ended, then pick a random event group of the type that matches the
		// id of the currently playing event structure clause
		if (model.eventStructureMachine.currentClause != nil) {
			NSArray *eventGroupArr = [eventGroupsByType objectForKey:model.eventStructureMachine.currentClause.identifier];
 			
			// TODO: Add check for event group's trigger conditions (if any)
			
			if ([eventGroupArr count] > 0) {
				eventGroup = [eventGroupArr objectAtIndex:rand() % [eventGroupArr count]];
			}
		}
		
	}
	
	if (eventGroup == nil) {
		DLog(@"Couldn't find another event group to start.");
	}
    [self setCurrentEventGroup:eventGroup];
	
}

/**
 * The setting's event loop.
 * @param timer The timer object that drives the loop.
 */
- (void) update:(NSTimer *)timer {
	
    if (currentEventGroup != nil) {
        [currentEventGroup update:timer];
    }
	
}

/**
 * Resets the setting.
 */
- (void) reset {
	self.currentShot = nil;
	[currentEventGroup reset];
	self.currentEventGroup = nil;
}

@end
