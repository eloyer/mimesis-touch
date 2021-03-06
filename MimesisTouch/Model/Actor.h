//
//  Actor.h
//  GeNIE
//
//  Created by Erik Loyer on 10/15/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Actor class is the model for an actor defined in the narrative script,
/// and maintains state for that actor over the course of the narrative.

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "PropertyChangeTracker.h"


@class TreeNode;
@class EventAtom;
@class Event;
@class Topic;

@interface Actor : NSObject <PropertyChangeTrackerDelegate> {
	
	NSString				*identifier;					///< Unique identifier for the actor.
	NSString				*actorName;						///< Display name of the actor.
    NSString                *subjectivePronoun;             ///< Pronoun that describes the actor as a subject.
    NSString                *objectivePronoun;              ///< Pronoun that describes the actor as an object.
    NSString                *iconFilename;                  ///< Filename for actor icon (icons should be 52x52 for non-retina displays).
	NSString				*mood;                          ///< Name of the actor's current emotional state.
    NSMutableDictionary     *sentiments;                    ///< Dictionary of feelings of the character has about particular topics.
    Topic                   *currentTopic;                  ///< Topic the character is thinking about (may be nil).
    PropertyChangeTracker   *propTracker;                   ///< Class which tracks changes to properties.
    BOOL                    onStage;                        ///< Contains true if the actor is currently participating in the setting.

}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *actorName;
@property (nonatomic, retain) NSString *subjectivePronoun;
@property (nonatomic, retain) NSString *objectivePronoun;
@property (nonatomic, retain) NSString *iconFilename;
@property (nonatomic, retain) NSMutableArray *changedProperties;
@property (nonatomic, retain) NSMutableDictionary *sentiments;
@property (readwrite) BOOL onStage;

- (id) initWithNode:(TreeNode *)node;
- (void) executeEventAtom:(EventAtom *)eventAtom;
- (NSDictionary *) parseCommand:(EventAtom*)eventAtom;
- (Event *) eventForTopic:(Topic *)topic;
- (void) addChangedProperty:(NSString *)propertyName;
- (BOOL) propertyWasChanged:(NSString *)propertyName;
- (NSString*) mood;
- (void) setMood:(NSString *)newMood;
- (void) modifyTransparency:(CGFloat)amount;
- (void) modifyEmotion:(NSString *)emotionId forSentiment:(NSString *)sentimentId amount:(CGFloat)amount internal:(BOOL)internal;
- (void) setEmotion:(NSString *)emotionId forSentiment:(NSString *)sentimentId strength:(CGFloat)strength internal:(BOOL)internal;
- (Topic*) currentTopic;
- (void) setCurrentTopic:(Topic *)topic;

@end
