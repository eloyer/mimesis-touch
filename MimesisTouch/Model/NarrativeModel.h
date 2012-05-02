//
//  NarrativeModel.h
//  GeNIE
//
//  Created by Erik Loyer on 10/12/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The primary model class for the narrative. Its contents are largely defined by
/// the narrative script at startup, but it's state changes as the narrative is
/// played. A singleton.

#import <Foundation/Foundation.h>


@class Setting;
@class EventStructureMachine;

@interface NarrativeModel : NSObject {
	
	bool					hasStarted;						///< Contains true if the narrative has been started.
	bool					isPaused;						///< Contains true if the narrative is paused.
	NSMutableArray			*observers;						///< An array of all objects observing the model.
	EventStructureMachine	*eventStructureMachine;			///< This class handles the high-level sequencing of narrative events.
	NSMutableDictionary		*settings;						///< A dictionary of all of the settings (i.e. scenes) in the current narrative.
	Setting					*initialSetting;				///< The setting to load on narrative start.
	Setting					*currentSetting;				///< The currently active setting.
	NSMutableDictionary		*shots;							///< A dictionary of all shots in the current narrative.
	NSMutableDictionary		*eventStructureClauses;			///< A dictionary of all clauses in the current narrative.
	NSMutableDictionary		*actors;						///< A dictionary of all actors in the current narrative.
	NSMutableDictionary		*props;							///< A dictionary of all props in the current narrative.
	NSMutableDictionary		*topics;						///< A dictionary of all topics in the current narrative.
	NSMutableDictionary		*eventGroups;					///< A dictionary of all event groups in the current narrative.
	NSMutableArray			*conditions;					///< An array of all conditional statements in the current narrative.
	NSMutableDictionary		*events;						///< A dictionary of all events in the current narrative.
	NSMutableArray			*eventAtoms;					///< An array of all event atoms in the current narrative.
	NSTimer					*updateTimer;					///< Regulates the narrative update event loop.
	NSArray					*searchDomains;					///< An array of places to look for named items in the narrative.
    NSString                *lastMessage;                   ///< The most recent system message.

}

@property (readwrite) bool hasStarted;
@property (readwrite) bool isPaused;
@property (nonatomic, retain) EventStructureMachine *eventStructureMachine;
@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) Setting *initialSetting;
@property (nonatomic, retain) Setting *currentSetting;
@property (nonatomic, retain) NSMutableDictionary *shots;
@property (nonatomic, retain) NSMutableDictionary *eventStructureClauses;
@property (nonatomic, retain) NSMutableDictionary *actors;
@property (nonatomic, retain) NSMutableDictionary *props;
@property (nonatomic, retain) NSMutableDictionary *topics;
@property (nonatomic, retain) NSMutableDictionary *eventGroups;
@property (nonatomic, retain) NSMutableArray *conditions;
@property (nonatomic, retain) NSMutableDictionary *events;
@property (nonatomic, retain) NSMutableArray *eventAtoms;
@property (nonatomic, retain) NSString *lastMessage;

+ (id) sharedInstance;
- (void) addObserver:(id)observer;
- (void) removeObserver:(id)observer;
- (void) forward:(SEL)selector object:(id)object;
- (void) parseNarrativeScript:(NSString *)resource;
- (void) setCurrentSetting:(Setting *)setting;
- (void) setStartedState:(NSString *)state;
- (void) setPausedState:(NSString *)state;
- (void) executeSystemMessage:(NSString *)message;
- (id) parseItemRef:(NSString *)itemRef;
- (void) update:(NSTimer *)timer;
- (void) reset;

@end
