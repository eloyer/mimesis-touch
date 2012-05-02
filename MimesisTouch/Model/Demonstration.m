//
//  Demonstration.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///  The Demonstration class defines the assignment of events to specific ranges of 
///  emotional intensity. An emotion's demonstrations are evaluated in the order they 
///  are specified in the narrative script, as if in a sequence of if and else-if clauses.

#import "Demonstration.h"
#import "TreeNode.h"
#import "Event.h"
#import "NarrativeModel.h"


@implementation Demonstration

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Demonstration.
 * @param node A TreeNode representing the XML in the narrative script that defines the demonstration.
 * @return The new Demonstration.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		TreeNode *data;
		NSArray *dataArray;
        
        operatorName = [node attributeForKey:@"operator"];
        value = [[node attributeForKey:@"value"] floatValue];
		
		// parse events
        events = [[NSMutableArray alloc] init];
        Event *event;
		dataArray = [node objectsForKey:@"event"];
		for (data in dataArray) {
			event = [[Event alloc] initWithNode:data];
			[model.events setObject:event forKey:event.identifier];
			[events addObject:event];
		}
		
	}
	
	return self;
}

- (void) dealloc {
	[operatorName release];
    [events release];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Evaluate whether the demonstration should be triggered
 * given the specified emotional strength.
 * @param strength The emotional strength value to be tested.
 * @return Returns true of the strength condition is met.
 */
- (BOOL) evaluate:(CGFloat)strength {
    
    BOOL result = false;
    
    if ([operatorName isEqualToString:@"<"]) {
        result = (strength < value);
    } else if ([operatorName isEqualToString:@"<="]) {
        result = (strength <= value);
    } else if ([operatorName isEqualToString:@"=="]) {
        result = (strength == value);
    } else if ([operatorName isEqualToString:@">="]) {
        result = (strength >= value);
    } else if ([operatorName isEqualToString:@">"]) {
        result = (strength > value);
    } else if (operatorName == nil) {
        result = true;
    }
    
    return result;
}

/**
 * Returns a demonstration event (randomly chosen if there's more than one).
 * @return A single event.
 */
- (Event *) getEvent {
    
    Event *event = nil;
    
    if ([events count] > 0) {
        int index = rand() % [events count];
        event = [events objectAtIndex:index];
    }
    
    return event;
}

@end
