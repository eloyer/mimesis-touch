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

#import "Actor.h"
#import "NarrativeModel.h"
#import "TreeNode.h"
#import "EventAtom.h"
#import "Sentiment.h"
#import "Topic.h"
#import "Emotion.h"
#import "Globals.h"
#import "Event.h"
#import "Setting.h"
#import "EventGroup.h"
#import "Shot.h"


@implementation Actor

@synthesize identifier;
@synthesize actorName;
@synthesize subjectivePronoun;
@synthesize objectivePronoun;
@synthesize iconFilename;
@synthesize changedProperties;
@synthesize sentiments;
@synthesize onStage;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Actor.
 * @param node A TreeNode representing the XML in the narrative script that defines the actor.
 * @return The new Actor.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		TreeNode *data;
		NSArray *dataArray;
		
		//self.changedProperties = [[NSMutableArray alloc] init];
        propTracker = [[PropertyChangeTracker alloc] initWithDelegate:self];
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.actors allValues] count];
			self.identifier = [NSString stringWithFormat:@"actor%i", count];
		}
		
		self.actorName = [node attributeForKey:@"name"];
		self.subjectivePronoun = [node attributeForKey:@"subjectivePronoun"];
		self.objectivePronoun = [node attributeForKey:@"objectivePronoun"];
        self.iconFilename = [node attributeForKey:@"icon"];
        
        self.onStage = false;
        
        // parse sentiments
		self.sentiments = [[NSMutableDictionary alloc] init];
		Sentiment *sentiment;
		dataArray = [node objectsForKey:@"sentiment"];
		for (data in dataArray) {
			sentiment = [[Sentiment alloc] initWithNode:data];
			[sentiments setObject:sentiment forKey:sentiment.topic.identifier];
		}
        
        
		
	}
	
	return self;
}

- (void) dealloc {
	self.identifier = nil;
	self.actorName = nil;
    self.subjectivePronoun = nil;
    self.objectivePronoun = nil;
    self.iconFilename = nil;
	[mood release];
	//self.changedProperties = nil;
    self.sentiments = nil;
    [propTracker release];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Takes any action relevant to the execution of the specified event atom.
 * @param eventAtom The event atom currently being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
	
    // if the event atom is referring to this actor, then
	if ([eventAtom.itemRef isEqualToString:identifier]) {
        
		NarrativeModel *model = [NarrativeModel sharedInstance];
        NSDictionary *content;
        Sentiment *sentiment;
        Emotion *emotion;
        Event *event;
		
        // set the actor's mood
		if ([eventAtom.command isEqualToString:@"setMood"]) {
            mood = eventAtom.content;
			[eventAtom handleEnd];
			
        // express the actor's sentiment about the topic they're currently thinking about
        } else if ([eventAtom.command isEqualToString:@"expressSentiment"]) {
            Topic *topic = [model parseItemRef:eventAtom.content];
            if ((self == eventAtom.item) && topic) {
                event = [self eventForTopic:topic];
                if (event) {
                    // this expression is a nested event, i.e. an event triggered
                    // from inside another event
                    [event playNested:eventAtom];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NestedEventStart" object:event];
                }
            }
			
        // modify one of the actor's emotions (either internal or external)
		} else if ([eventAtom.command isEqualToString:@"modifyEmotion"]) {
            content = [self parseCommand:eventAtom];
            if (content) {
                emotion = [content objectForKey:@"emotion"];
                if ([[content objectForKey:@"locus"] isEqualToString:@"internal"]) {
                    emotion.internalStrength += [(NSNumber *)[content objectForKey:@"value"] floatValue];
                } else if ([[content objectForKey:@"locus"] isEqualToString:@"external"]) {
                    emotion.externalStrength += [(NSNumber *)[content objectForKey:@"value"] floatValue];
                }
            }
			[eventAtom handleEnd];
			
        // set one of the actor's emotions (internal or external) to a given value
		} else if ([eventAtom.command isEqualToString:@"setEmotion"]) {
            content = [self parseCommand:eventAtom];
            if (content) {
                emotion = [content objectForKey:@"emotion"];
                if ([[content objectForKey:@"locus"] isEqualToString:@"internal"]) {
                    emotion.internalStrength = [(NSNumber *)[content objectForKey:@"value"] floatValue];
                } else if ([[content objectForKey:@"locus"] isEqualToString:@"external"]) {
                    emotion.externalStrength = [(NSNumber *)[content objectForKey:@"value"] floatValue];
                }
            }
			[eventAtom handleEnd];
			
        // set the transparency of one of the actor's sentiments
		} else if ([eventAtom.command isEqualToString:@"setTransparency"]) {
            content = [self parseCommand:eventAtom];
            if (content) {
                sentiment = [content objectForKey:@"sentiment"];
                sentiment.transparency = [[content objectForKey:@"value"] floatValue];
            }
			[eventAtom handleEnd];
            
        // store the transparency of one of the actor's sentiments
        } else if ([eventAtom.command isEqualToString:@"storeTransparency"]) {
            content = [self parseCommand:eventAtom];
            if (content) {
                sentiment = [content objectForKey:@"sentiment"];
                [sentiment storeTransparency];
            }
			[eventAtom handleEnd];
            
        // record that the actor is now on stage
        } else if ([eventAtom.command isEqualToString:@"enter"]) {
            self.onStage = true;
			[eventAtom handleEnd];
            
        // record that the actor is now off stage
        } else if ([eventAtom.command isEqualToString:@"exit"]) {
            self.onStage = false;
			[eventAtom handleEnd];
            
		}
		
	}
	
}

/**
 * Parses the content of a command event atom into the four components needed
 * to modify an emotion, returning them as a dictionary.
 * @param eventAtom The event atom to be parsed.
 * @return A dictionary containing the parsed components of the command.
 */
- (NSDictionary *) parseCommand:(EventAtom*)eventAtom {
    
    NSDictionary *result = nil;
    NSArray *components = [eventAtom.content componentsSeparatedByString:@":"];
    
    Sentiment *sentiment;
    Emotion *emotion;
    NSString *locus;
    NSNumber *value;
    CGFloat aFloat;
    
    // command = modifyEmotion, setEmotion
    // The sentiment, emotion, locus (internal/external) and value must be specified
    if ([eventAtom.command isEqualToString:@"modifyEmotion"] || [eventAtom.command isEqualToString:@"setEmotion"]) {
    
        if ([components count] == 4) {
            sentiment = [sentiments objectForKey:[components objectAtIndex:0]];
            emotion = [sentiment.emotions objectForKey:[components objectAtIndex:1]];
            locus = [components objectAtIndex:2];
            value = [NSNumber numberWithFloat:[[components objectAtIndex:3] floatValue]];
            if (sentiment && emotion && ([locus isEqualToString:@"internal"] || [locus isEqualToString:@"external"])) {
                result = [NSDictionary dictionaryWithObjectsAndKeys:sentiment, @"sentiment", emotion, @"emotion", locus, @"locus", value, @"value", nil];
            }
        }
        
    // command = setTransparency
    // The sentiment and new transparency value must be specified
    } else if ([eventAtom.command isEqualToString:@"setTransparency"]) {
        
        if ([components count] == 2) {
            sentiment = [sentiments objectForKey:[components objectAtIndex:0]];
            if ([[components objectAtIndex:1] isEqualToString:@"random"]) {
                aFloat = (rand() % 100) * .01;
            } else {
                aFloat = [[components objectAtIndex:1] floatValue];
            }
            value = [NSNumber numberWithFloat:fmin(1, fmax(0, aFloat))];
            if (sentiment) {
                result = [NSDictionary dictionaryWithObjectsAndKeys:sentiment, @"sentiment", value, @"value", nil];
            }
        }
        
    // command = storeTransparency
    // The sentiment must be specified
    } else if ([eventAtom.command isEqualToString:@"storeTransparency"]) {
        sentiment = [sentiments objectForKey:[components objectAtIndex:0]];
        if (sentiment) {
            result = [NSDictionary dictionaryWithObjectsAndKeys:sentiment, @"sentiment", nil];
        }
    }
    
    return result;
}

/**
 * Given a topic, returns an event that expresses the actor's sentiment
 * on that topic.
 * @param topic The topic for which an expressive event is sought.
 * @return An event which represents how the actor feels about the topic, or nil if none can be found.
 */
- (Event *) eventForTopic:(Topic *)topic {
    
    Sentiment *sentiment = [sentiments objectForKey:topic.identifier];
    Event *event = nil;
    
    if (sentiment) {
        event = [sentiment getEvent];
    }

    return event;
}

#pragma mark -
#pragma mark Delegate methods

/**
 * Adds the specified property to the list of changed properties.
 * @param propertyName The name of the property that was changed.
 */
- (void) addChangedProperty:(NSString *)propertyName {
    [propTracker _addChangedProperty:propertyName];
}

/**
 * Returns true if the specified property was changed recently, and
 * removes the property from the list of changed properties.
 * @param propertyName The name of the property that was changed.
 */
- (BOOL) propertyWasChanged:(NSString *)propertyName {
    return [propTracker _propertyWasChanged:propertyName];
}

#pragma mark -
#pragma mark Getters/setters

/**
 * Returns the name of the actor's current mood.
 * @return The mood's name.
 */
- (NSString *) mood {
    return mood;
}

/**
 * Updates the name of the actor's current mood, modifying the emotions associated
 * with the current topic at the same time. If the actor has a topic in mind, and has
 * a sentiment associated with that topic, and an emotion which matches the name of
 * the new mood, then the intensity of that emotion is increased by one. If the
 * current shot is an "internal" shot (i.e. represents an internal mental state), then
 * the internal strength of the emotion is increased; otherwise the external strength
 * of the emotion goes up.
 * @param newMood Name of the character's new mood.
 */
- (void) setMood:(NSString *)newMood {
    
    // update the mood
	if (![mood isEqualToString:newMood]) {
        [mood release];
        mood = [newMood copy];
		[self addChangedProperty:@"mood"];
    }
    
    // if the actor is currently thinking about a topic, then
    if (currentTopic) {
        
		NarrativeModel *model = [NarrativeModel sharedInstance];
        Sentiment *sentiment = [sentiments objectForKey:currentTopic.identifier];
        Emotion *emotion;
        
        // if the actor feels something about the current topic, then
        if (sentiment) {
            emotion = [sentiment.emotions objectForKey:mood];
            if (emotion) {
                
                // apply moods set during "internal" shots to the actor's internal emotion
                if (model.currentSetting.currentShot.isInternal) {
                    emotion.internalStrength++;
                    /*EventAtom *eventAtom = [[EventAtom alloc] initWithItemRef:@"narrator" command:@"say" content:[NSString stringWithFormat:@"%@ inward %@ %@ increased.", [objectivePronoun capitalizedString], emotion.description, currentTopic.description]];
                    [model.currentSetting.currentEventGroup enqueueImmediateEventAtom:eventAtom];*/
                    //DLog(@"%@ %@ about %@: %f", actorName, mood, currentTopic.identifier, emotion.internalStrength);
                    
                // apply moods set during "external" shots to the actor's external emotion
                } else {
                    emotion.externalStrength++;
                    /*EventAtom *eventAtom = [[EventAtom alloc] initWithItemRef:@"narrator" command:@"say" content:[NSString stringWithFormat:@"%@ outward %@ %@ increased.", [objectivePronoun capitalizedString], emotion.description, currentTopic.description]];
                    [model.currentSetting.currentEventGroup enqueueImmediateEventAtom:eventAtom];*/
                   // DLog(@"%@ %@ about %@: %f", actorName, mood, currentTopic.identifier, emotion.externalStrength);
                }
                
                // remember that the property was changed
                [self addChangedProperty:[NSString stringWithFormat:@"sentiments.%@", sentiment.topic.identifier]];
            }
        }
    }
}

/**
 * Alters the transparency of the actor's sentiment for the current topic by
 * the specified amount, making them either more or less likely to express their
 * "true" (i.e. internal) feelings about a topic when prompted by a call to
 * <code>eventForTopic:</code>.
 * @param amount The amount by which the transparency value should be modified.
 */
- (void) modifyTransparency:(CGFloat)amount {
    
    // if the actor is currently thinking about a topic, then
    if (currentTopic) {
		NarrativeModel *model = [NarrativeModel sharedInstance];
        Sentiment *sentiment = [sentiments objectForKey:currentTopic.identifier];
        if (sentiment) {
            
            CGFloat lastTransparency = sentiment.transparency;
            sentiment.transparency = MIN(1.0, MAX(0.0, sentiment.transparency + amount));
            
            // if transparency is decreasing, have the narrator say something to that effect
            /*if (sentiment.transparency < lastTransparency) {
                EventAtom *eventAtom = [[EventAtom alloc] initWithItemRef:@"narrator" command:@"say" content:[NSString stringWithFormat:@"%@ buried %@ true feelings about %@ deeper inside.", [subjectivePronoun capitalizedString], objectivePronoun, currentTopic.description]];
                [model.currentSetting.currentEventGroup enqueueImmediateEventAtom:eventAtom];
                
            // if transparency is increasing, have the narrator say something to that effect
            } else if (sentiment.transparency > lastTransparency) {
                EventAtom *eventAtom = [[EventAtom alloc] initWithItemRef:@"narrator" command:@"say" content:[NSString stringWithFormat:@"%@ let %@ true feelings about %@ come closer to the surface.", [subjectivePronoun capitalizedString], objectivePronoun, currentTopic.description]];
                [model.currentSetting.currentEventGroup enqueueImmediateEventAtom:eventAtom];
            }*/
            
            [self addChangedProperty:[NSString stringWithFormat:@"sentiments.%@", sentiment.topic.identifier]];
        }
    }    
}

/**
 * Alters the strength of the specified emotion.
 * @param emotionId The emotion's identifier.
 * @param sentimentId The identifier of the sentiment containing the emotion to be modified.
 * @param amount The amount by which the emotion's strength is to be modified.
 * @param internal If true, the internal strength of the emotion will be modified, as opposed to the external strength.
 */
- (void) modifyEmotion:(NSString *)emotionId forSentiment:(NSString *)sentimentId amount:(CGFloat)amount internal:(BOOL)internal {
    
    Sentiment *sentiment = [sentiments objectForKey:sentimentId];
    if (sentiment) {
        Emotion *emotion = [sentiment.emotions objectForKey:emotionId];
        if (emotion) {
            [emotion modifyStrength:amount internal:internal];
        }
        [self addChangedProperty:[NSString stringWithFormat:@"sentiments.%@", sentiment.topic.identifier]];
    }
    
}

/**
 * Set the strength of the specified emotion to a new value.
 * @param emotionId The emotion's identifier.
 * @param sentimentId The identifier of the sentiment containing the emotion to be modified.
 * @param strength The new value of the emotion's strength.
 * @param internal If true, the internal strength of the emotion will be modified, as opposed to the external strength.
 */
- (void) setEmotion:(NSString *)emotionId forSentiment:(NSString *)sentimentId strength:(CGFloat)strength internal:(BOOL)internal {
    
    Sentiment *sentiment = [sentiments objectForKey:sentimentId];
    if (sentiment) {
        Emotion *emotion = [sentiment.emotions objectForKey:emotionId];
        if (emotion) {
            [emotion setStrength:strength internal:internal];
        }
        [self addChangedProperty:[NSString stringWithFormat:@"sentiments.%@", sentiment.topic.identifier]];
    }
    
}

/**
 * Returns the topic the actor is currently thinking about.
 * @return The topic the actor is currently thinking about.
 */
- (Topic *) currentTopic {
    return currentTopic;
}

/**
 * Sets the topic the actor is currently thinking about.
 */
- (void) setCurrentTopic:(Topic *)topic {
    currentTopic = topic;
}

@end
