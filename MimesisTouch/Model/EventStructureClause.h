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

#import <Foundation/Foundation.h>

// The EventStructureClauseState enum defines the possible states of an event structure clause.
typedef enum {
	ClauseDormant,          // The clause has not yet been activated.
	ClausePlaying,          // The clause is currently playing.
	ClausePlayingSubClause, // The clause is currently playing a nested subclause.
	ClauseDone              // The clause has finished playing.
} EventStructureClauseState;

@class TreeNode;

@interface EventStructureClause : NSObject {
	
	TreeNode					*sourceData;		///< Source data for the clause.
	NSString					*identifier;		///< Unique identifier for the clause.
	EventStructureClauseState	state;				///< Current state of the clause.
	int							minCount;			///< Minimum number of times the clause must be played.
	int							maxCount;			///< Maximum number of times the clause can be played.
	int							playCount;			///< Number of times the clause has been played.
	int							currentMaxCount;	///< Number of times the clause will be played in this iteration.
	EventStructureClause		*subClause;			///< Subsequent nested clause to be executed.
	EventStructureClause		*superClause;		///< The clause which caused this clause to be executed (variable at run-time).
	EventStructureClause		*nextClause;		///< Subsequent clause to be executed after all nested clauses have executed.

}

@property (nonatomic, retain) NSString *identifier;
@property (readwrite) EventStructureClauseState state;
@property (readwrite) int minCount;
@property (readwrite) int maxCount;
@property (readwrite) int playCount;
@property (readwrite) int currentMaxCount;
@property (nonatomic, retain) EventStructureClause *subClause;
@property (nonatomic, retain) EventStructureClause *superClause;
@property (nonatomic, retain) EventStructureClause *nextClause;

- (id) initWithNode:(TreeNode *)node;
- (void) parseLinkedClauses;
- (void) play;
- (EventStructureClause *) nextClause;

@end
