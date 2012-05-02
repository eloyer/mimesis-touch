//
//  EventStructureClause.h
//  GeNIE
//
//  Created by Erik Loyer on 11/4/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The EventStructureClause class defines an atomic unit of narrative in the 
///	event structure machine.

#import "EventStructureClause.h"
#import "NarrativeModel.h"
#import "TreeNode.h"


@implementation EventStructureClause

@synthesize identifier;
@synthesize state;
@synthesize minCount;
@synthesize maxCount;
@synthesize playCount;
@synthesize currentMaxCount;
@synthesize superClause;
@synthesize subClause;
@synthesize nextClause;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new EventStructureClause.
 * @param node A TreeNode representing the XML in the narrative script that defines the event structure clause.
 * @return The new EventStructureClause.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if (self = [super init]) {
		
		self.state = ClauseDormant;
		self.superClause = nil;
		self.subClause = nil;
		self.nextClause = nil;
		self.playCount = 0;
		sourceData = node;
		
		self.identifier = [node attributeForKey:@"type"];
		self.minCount = [[node attributeForKey:@"minCount"] intValue];
		self.maxCount = [[node attributeForKey:@"maxCount"] intValue];
		
	}
	
	return self;
}

- (void) dealloc {
	self.identifier = nil;
	self.superClause = nil;
	self.subClause = nil;
	self.nextClause = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Parses source data derived from XML to create links to referenced clauses.
 * Not included in the <code>initWithNode:</code> function because all clauses need to be
 * created first before links can be made.
 */
- (void) parseLinkedClauses {
	
	NarrativeModel *model = [NarrativeModel sharedInstance];
	
	self.subClause = [model.eventStructureClauses objectForKey:[sourceData attributeForKey:@"subClause"]];
	self.nextClause = [model.eventStructureClauses objectForKey:[sourceData attributeForKey:@"exitTo"]];
	
}

/**
 * Plays the clause.
 */
- (void) play {
	
	// if we're just starting, figure out how many times we're going to repeat
	if (playCount == 0) {
		if (maxCount > minCount) {
			currentMaxCount = minCount + (rand() % (maxCount - minCount));
		} else {
			currentMaxCount = MAX(minCount, maxCount);
		}
	}
	
	self.playCount++;
	self.state = ClausePlaying;
    
}

/**
 * Returns the next clause to be played after this one.
 * @return Returns the subsequent clause to be played, or nil.
 */
- (EventStructureClause *) nextClause {
	
	EventStructureClause *clause = nil;
	
	switch (state) {
			
		// if this clause is currently playing, then
		case ClausePlaying:
			
			// if it has a subclause, then play it
			if (subClause != nil) {
				self.state = ClausePlayingSubClause;
				subClause.superClause = self;
				clause = subClause;
				[clause play];
				
			// otherwise, if it still has repeats to exhaust, then play itself again
			} else if (playCount < currentMaxCount) {
				clause = self;
				[clause play];
				
			// otherwise, if it has a next clause, then play it
			} else if (nextClause != nil) {
				self.state = ClauseDone;
				clause = nextClause;
				[clause play];
				
			// otherwise, if it has a superclause, then return its next clause
			} else if (superClause != nil) {
				self.state = ClauseDone;
				clause = [superClause nextClause];
			}
			break;
			
		// if this clause is currently playing its subclause, then
		case ClausePlayingSubClause:
			
			// if it still has repeats to exhaust, then play itself again
			if (playCount < currentMaxCount) {
				clause = self;
				[clause play];
				
			// otherwise, if it has a next clause, then play it
			} else if (nextClause != nil) {
				self.state = ClauseDone;
				clause = nextClause;
				[clause play];
				
			// otherwise, if it has a superclause, then return its next clause
			} else if (superClause != nil) {
				self.state = ClauseDone;
				clause = [superClause nextClause];
			}
			break;
            
        case ClauseDormant:
        case ClauseDone:
            break;
			
	}
	
	return clause;
}

@end
