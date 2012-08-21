//
//  NarrativeModel.m
//  GeNIE
//
//  Created by Erik Loyer on 10/12/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The primary model class for the narrative. Its contents are largely defined by
/// the narrative script at startup, but it's state changes as the narrative is
/// played. A singleton.

#import "NarrativeModel.h"
#import "Setting.h"
#import "Shot.h"
#import "Prop.h"
#import "Actor.h"
#import "EventGroup.h"
#import "Event.h"
#import "EventAtom.h"
#import "EventStructureMachine.h"
#import "EventStructureClause.h"
#import "XMLParser.h"
#import "TreeNode.h"
#import "Condition.h"


static NarrativeModel *sharedInstance = nil;

@implementation NarrativeModel

@synthesize hasStarted;
@synthesize isPaused;
@synthesize eventStructureMachine;
@synthesize settings;
@synthesize initialSetting;
@synthesize currentSetting;
@synthesize shots;
@synthesize eventStructureClauses;
@synthesize actors;
@synthesize props;
@synthesize topics;
@synthesize eventGroups;
@synthesize conditions;
@synthesize events;
@synthesize eventAtoms;
@synthesize lastMessage;

#pragma mark -
#pragma mark Singleton methods

/**
 * Creates/returns the singleton instance of the model.
 */
+ (id) sharedInstance {
	@synchronized(self) {
		if(sharedInstance == nil)
			[[self alloc] init];
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedInstance == nil)  {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release {
	// never release
}

- (id)autorelease {
	return self;
}

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes the narrative model.
 */
- (id) init {
	
	if ((self = [super init])) {
		
		hasStarted = FALSE;
		isPaused = TRUE;
        self.lastMessage = nil;
		
		observers = [[NSMutableArray alloc] init];
		self.settings = [[NSMutableDictionary alloc] init];
		self.shots = [[NSMutableDictionary alloc] init];
		self.eventStructureClauses = [[NSMutableDictionary alloc] init];
		self.actors = [[NSMutableDictionary alloc] init];
		self.eventGroups = [[NSMutableDictionary alloc] init];
		self.conditions = [[NSMutableArray alloc] init];
		self.props = [[NSMutableDictionary alloc] init];
		self.topics = [[NSMutableDictionary alloc] init];
		self.events = [[NSMutableDictionary alloc] init];
		self.eventAtoms = [[NSMutableArray alloc] init];
		self.eventStructureMachine = [[EventStructureMachine alloc] init];
		searchDomains = [[NSArray arrayWithObjects:settings, shots, actors, props, topics, eventGroups, events, nil] retain];
		
	}
	
	return self;
}

#pragma mark -
#pragma mark Observer methods

// Observer methods by Sean Maher: http://deadpanic.com/cocoa_observer

/**
 * Add a new observer of the model.
 * @param observer The observer object to be added.
 */
- (void) addObserver:(id)observer {
    //observers is an NSMutableArray
	[observers addObject:observer];
}

/**
 * Decommission the specified observer of the model.
 * @param observer The object which will no longer observe the model.
 */
- (void) removeObserver:(id)observer {
	[observers removeObject:observer];
}

/**
 * Forwards a message from the game state object to each observer that wants it
 * (the object may be "nil" if you're forwarding a method with no parameters).
 * @param selector The selector message to be forwarded.
 * @param object Optional parameters to forward along with the message.
 */
- (void) forward:(SEL)selector object:(id)object {
    //loop through the list of  observers
    NSArray *temp = [NSArray arrayWithArray:observers]; // work with a copy of the array so it doesn't get mutated while being iterated
    for (id observer in temp) {
        //check if the observer repsonds to this method selector, and call the method
        if ([observer respondsToSelector:selector])
            [observer performSelector:selector withObject:object];
    }
}

#pragma mark -
#pragma mark Utility methods

/**
 * Parses the specified narrative script.
 * @param resource The name of the script file.
 */
- (void) parseNarrativeScript:(NSString *)resource {
    
    // parse narrative data
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"xml"];
    NSURL *url = [NSURL fileURLWithPath:path];
    TreeNode *root = [[XMLParser sharedInstance] parseXMLFromURL:url];
    
    TreeNode *data;
    NSArray *dataArray;
    Setting *setting;
    Condition *condition;
    EventAtom *eventAtom;
    Prop *prop;
    
    // parse settings
    dataArray = [root objectsForKey:@"setting"];
    for (data in dataArray) {
        setting = [[Setting alloc] initWithNode:data];
        [settings setObject:setting forKey:setting.identifier];
    }
    
    // parse initial setting
    data = [root objectForKey:@"initialSetting"];
    if (data != nil) {
        self.initialSetting = [settings objectForKey:[data attributeForKey:@"settingRef"]];
    }
    
    // parse condition item references, now that all items have been created
    for (condition in conditions) {
        [condition parseItemAndValue];
    }
    
    // parse event atom item references, now that all items have been created
    for (eventAtom in eventAtoms) {
        [eventAtom parseItemRef];
    }
    
    // parse event topic references, now that all items have been created
    NSArray *propArray = [props allValues];
    for (prop in propArray) {
        [prop parseTopicRef];
    }
    
}

/**
 * Makes the specified setting (i.e. scene) the current setting.
 * @param setting The setting to be activated.
 */
- (void) setCurrentSetting:(Setting *)setting {
	
	if (setting != currentSetting) {
		
		DLog(@"new setting");
		
		currentSetting = setting;
		
		// put the setting's event structure clauses into the event structure machine
		[eventStructureMachine setClauses:currentSetting.eventStructureClauses withInitialClause:currentSetting.initialClause];
		
		// initialize the setting with its first declared shot
		[currentSetting setCurrentShot:currentSetting.initialShot];
		
		// begin the setting by playing its first event group
		[currentSetting startNextEventGroup];
		
	}
	
}

/**
 * Handles updates to the property indicating whether the narrative
 * has been started yet or not.
 * @param state The new state of the 'hasStarted' property, as a string.
 */
- (void) setStartedState:(NSString *)state {
	
	hasStarted = [state boolValue];
	
	// if the narrative is starting, and is not paused, then start the update timer
	if (hasStarted) {
		if (!isPaused) {
			updateTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:YES] retain];
		}
		
	// otherwise, if the timer is already running, then stop it
	} else {
		if ([updateTimer isValid]) {
			[updateTimer invalidate];
		}
	}
	
	// pass the message along
	[self forward:_cmd object:state];
	
}

/**
 * Sets the current paused/unpaused state.
 * @param state The new state of the 'isPaused' property.
 */
- (void) setPausedState:(NSString *)state {
	
	isPaused = [state boolValue];
	
	// if we are unpausing, and the narrative has started, then start the update timer
	if (!isPaused) {
		if (hasStarted) {
			updateTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:YES] retain];
		}
		
	// otherwise, if the timer is already running, then stop it
	} else {
		if ([updateTimer isValid]) {
			[updateTimer invalidate];
		}
	}
	
	// pass the message along
	[self forward:_cmd object:state];
	
}

/**
 * Executes a system message (doesn't really do much of anything currently).
 * @param message The message to be executed.
 */
- (void) executeSystemMessage:(NSString *)message {
    self.lastMessage = message;
    /*[self forward:_cmd object:message];
    self.lastMessage = nil;
    NSLog(@"message: %@", message);*/
    [currentSetting.currentEventGroup update:nil];
}
		 
/**
 * Given an identifier (as specified in the narrative script), returns the 
 * corresponding narrative model object (if any).
 * @param itemRef The identifier of the object to be found.
 * @return The object with the given identifier, if any.
 */
- (id) parseItemRef:(NSString *)itemRef {
    
	id result = nil;
	NSMutableDictionary *domain;
    
    if ([itemRef isEqualToString:@"system"]) {
        result = self;
    } else {
        for (domain in searchDomains) {
            result = [domain objectForKey:itemRef];
            if (result != nil) {
                break;
            }
        }
    }

	return result;
}

/**
 * The narrative's event loop.
 * @param timer The timer which is driving the event loop.
 */
- (void) update:(NSTimer *)timer {
	
	//NSLog(@"narrative update");
	
	[currentSetting update:timer];
	
}

/**
 * Resets the narrative.
 */
- (void) reset {
    NSArray *settingsArr = [settings allValues];
    for (Setting *setting in settingsArr) {
        [setting reset];
    }
	self.currentSetting = nil;
	self.hasStarted = FALSE;
}

@end
