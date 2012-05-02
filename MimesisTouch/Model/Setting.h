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

#import <Foundation/Foundation.h>


@class Shot;
@class EventGroup;
@class EventStructureClause;
@class TreeNode;

@interface Setting : NSObject {
	
	NSString					*identifier;						///< Unique identifier for the setting.
	NSMutableDictionary			*eventStructureClauses;				///< Dictionary of all event structure clauses.
	EventStructureClause		*initialClause;						///< The first event structure clause to be played.
	NSMutableDictionary			*shots;								///< Dictionary of all the shots in the setting, indexed by identifier.
	Shot						*initialShot;						///< Shot to be shown when the setting first loads.
	Shot						*currentShot;						///< The currently active shot.
	NSMutableDictionary			*props;								///< Inanimate elements of the setting.
	NSMutableDictionary			*topics;							///< Things actors can think and feel about.
	NSMutableDictionary			*actors;							///< Characters in the setting.
	NSMutableDictionary			*eventGroups;						///< Event groups for the setting, indexed by identifier.
	NSMutableDictionary			*eventGroupsByType;					///< Arrays of event groups, indexed by type.
	EventGroup					*initialEventGroup;					///< Event group to play wihen the setting first loads.
	EventGroup					*currentEventGroup;					///< Currently active event group.

}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSMutableDictionary *eventStructureClauses;
@property (nonatomic, retain) EventStructureClause *initialClause;
@property (nonatomic, retain) NSMutableDictionary *shots;
@property (nonatomic, retain) Shot *initialShot;
@property (nonatomic, retain) Shot *currentShot;
@property (nonatomic, retain) NSMutableDictionary *props;
@property (nonatomic, retain) NSMutableDictionary *topics;
@property (nonatomic, retain) NSMutableDictionary *actors;
@property (nonatomic, retain) NSMutableDictionary *eventGroups;
@property (nonatomic, retain) NSMutableDictionary *eventGroupsByType;
@property (nonatomic, retain) EventGroup *initialEventGroup;
@property (nonatomic, retain) EventGroup *currentEventGroup;

- (id) initWithNode:(TreeNode *)node;
- (void) setCurrentShot:(Shot *)shot;
- (void) addEventGroup:(EventGroup *)eventGroup;
- (void) setCurrentEventGroup:(EventGroup *)eventGroup;
- (void) handleEventAtomEnd:(NSNotification *)notification;
- (void) handleEventEnd:(NSNotification *)notification;
- (void) handleEventGroupEnd:(NSNotification *)notification;
- (void) startNextEventGroup;
- (void) update:(NSTimer *)timer;
- (void) reset;

@end
