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

#import <Foundation/Foundation.h>

@class TreeNode;
@class Event;

@interface Demonstration : NSObject {
    
    NSString                *operatorName;                  ///< Name of the operator to be used when evaluating the emotional strength that will trigger this demonstration.
    CGFloat                 value;                          ///< Emotional strength value to be used when evaluating whether to trigger this demonstration.
    NSMutableArray          *events;                        ///< Array of possible events to be triggered in this demonstration.
    
}

- (id) initWithNode:(TreeNode *)node;
- (BOOL) evaluate:(CGFloat)strength;
- (Event *) getEvent;

@end
