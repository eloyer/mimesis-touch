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

#import <Foundation/Foundation.h>


@class EventStructureClause;

@interface EventStructureMachine : NSObject {
	
	NSDictionary				*clauses;			///< Dictionary of event structure clauses.
	EventStructureClause		*initialClause;		///< The first clause to be played (required).
	EventStructureClause		*currentClause;		///< The currently active clause.

}

@property (nonatomic, retain) EventStructureClause *currentClause;

- (void) setClauses:(NSDictionary *)newClauses withInitialClause:(EventStructureClause *)clause;
- (void) startNextClause;

@end
