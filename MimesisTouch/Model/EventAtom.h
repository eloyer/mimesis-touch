//
//  EventAtom.h
//  GeNIE
//
//  Created by Erik Loyer on 10/25/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The EventAtom class defines the smallest unit of narrative content: a single
///	command to be executed.

#import <Foundation/Foundation.h>


@class TreeNode;

@interface EventAtom : NSObject {

	NSString					*itemRef;				///< Unique identifier for the event atom.
	id							item;					///< The item performing the command.
	NSString					*command;				///< Name of command to execute.
	NSString					*content;				///< Content associated with command.
    BOOL                        isRunning;              ///< Is this event atom currently running?
	
}

@property (nonatomic, retain) NSString *itemRef;
@property (nonatomic, retain) id item;
@property (nonatomic, retain) NSString *command;
@property (nonatomic, retain) NSString *content;
@property (readwrite) BOOL isRunning;

- (id) initWithNode:(TreeNode *)node;
- (id) initWithItemRef:(NSString *)anItemRef command:(NSString *)aCommand content:(NSString *)someContent;
- (void) parseItemRef;
- (void) handleExecute;
- (void) handleEnd;

@end
