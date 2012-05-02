//
//  EventStructureMachine.h
//  GeNIE
//
//  Created by Erik Loyer on 11/5/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

//	The EventStructureMachine defines how event structure clauses
//	are processed and selected.

#import "EventStructureMachine.h"
#import "EventStructureClause.h"
#import "NarrativeModel.h"
#import "Globals.h"


@implementation EventStructureMachine

@synthesize currentClause;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes the EventStructureMachine.
 * @return The new EventStructureMachine.
 */
- (id) init {
	
	if (self = [super init]) {
		self.currentClause = nil;
	}
	
	return self;
}

- (void) dealloc {
	[clauses release];
	self.currentClause = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Updates the event structure machine's library of clauses.
 * @param newClauses The new clauses to be stored.
 * @param clause The first clause to be played.
 */
- (void) setClauses:(NSDictionary *)newClauses withInitialClause:(EventStructureClause *)clause {
	clauses = newClauses;
	initialClause = clause;
	self.currentClause = nil;
}

/**
 * Figures out the next clause to be executed and starts it.
 */
- (void) startNextClause {
	
	// if no clauses are currently running, then start the first one
	if (currentClause == nil) {
		self.currentClause = initialClause;
		[initialClause play];
		
	// otherwise, start the next one
	} else {
		self.currentClause = [currentClause nextClause];
	}
	
	DLog(@"start next clause: %@", currentClause.identifier);
	
}

@end
