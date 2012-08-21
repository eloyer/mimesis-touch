//
//  Emotion.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///  The Emotion class defines an atom of sentiment: one component of how a 
///  character feels about a topic.

#import "Emotion.h"
#import "TreeNode.h"
#import "Demonstration.h"
#import "Event.h"


@implementation Emotion

@synthesize name;
@synthesize description;
@synthesize internalStrength;
@synthesize externalStrength;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Emotion.
 * @param node A TreeNode representing the XML in the narrative script that defines the emotion.
 * @return The new Emotion.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		TreeNode *data;
		NSArray *dataArray;
		
		self.name = [node attributeForKey:@"name"];
		self.description = [node attributeForKey:@"description"];
		self.internalStrength = [[node attributeForKey:@"internalStrength"] floatValue];
		self.externalStrength = [[node attributeForKey:@"externalStrength"] floatValue];
        
        propTracker = [[PropertyChangeTracker alloc] initWithDelegate:self];
		
		// parse demonstrations
		demonstrations = [[NSMutableArray alloc] init];
		Demonstration *demonstration;
		dataArray = [node objectsForKey:@"demonstration"];
		for (data in dataArray) {
			demonstration = [[Demonstration alloc] initWithNode:data];
			[demonstrations addObject:demonstration];
		}
		
	}
	
	return self;
}

- (void) dealloc {
	self.name = nil;
    self.description = nil;
    [demonstrations release];
    [propTracker release];
	[super dealloc];
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
#pragma mark Utility methods

/**
 * Modifies the internal or external strength of the emotion by the specified amount.
 * @param amount The amount by which to modify the emotion's strength.
 * @param internal If true, the modification will be applied to the emotion's internal strength (external otherwise).
 */
- (void) modifyStrength:(CGFloat)amount internal:(BOOL)internal {
    if (internal) {
        internalStrength += amount;
        [self addChangedProperty:@"internalStrength"];
    } else {
        externalStrength += amount;
        [self addChangedProperty:@"externalStrength"];
    }
}

/**
 * Modifies the internal or external strength of the emotion by the specified amount.
 * @param strength The new value of the emotion's strength.
 * @param internal If true, the modification will be applied to the emotion's internal strength (external otherwise).
 */
- (void) setStrength:(CGFloat)strength internal:(BOOL)internal {
    if (internal) {
        internalStrength = strength;
        [self addChangedProperty:@"internalStrength"];
    } else {
        externalStrength = strength;
        [self addChangedProperty:@"externalStrength"];
    }
}

/**
 * Returns an event matching the current intensity (either internal or external) of
 * this emotion.
 * @param isInternal Should the event come from the actor's internal incarnation of the emotion?
 * @return A single event is one is found, otherwise nil.
 */
- (Event *) getEvent:(BOOL)isInternal {
    
    Event *event = nil;
    Demonstration *demonstration;
    CGFloat strength;
    
    if (isInternal) {
        strength = internalStrength;
    } else {
        strength = externalStrength;
    }
    
    // evaluate each demonstration in turn, get an event from the first one
    // that matches
    int i;
    int n = [demonstrations count];
    for (i=0; i<n; i++) {
        demonstration = [demonstrations objectAtIndex:i];
        if ([demonstration evaluate:strength]) {
            event = [demonstration getEvent];
            break;
        }
    }
    
    return event;
}

@end
