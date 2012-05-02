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

#import "EventAtom.h"
#import "NarrativeModel.h"
#import "TreeNode.h"


@implementation EventAtom

@synthesize itemRef;
@synthesize item;
@synthesize command;
@synthesize content;
@synthesize isRunning;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new EventAtom.
 * @param node A TreeNode representing the XML in the narrative script that defines the event atom.
 * @return The new EventAtom.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		self.itemRef = [node attributeForKey:@"itemRef"];
		self.command = [node attributeForKey:@"command"];
		self.content = [node attributeForKey:@"content"];
		self.isRunning = FALSE;
        
	}
	
	return self;
}

/**
 * This method designed for initializing event atoms on the fly; requires that the
 * item indicated by itemRef already exists.
 * @param anItemRef The identifier of an item defined in the narrative script.
 * @param aCommamd Name of the command to be executed.
 * @param someContent Content associated with the command.
 * @return The new EventAtom.
 */
- (id) initWithItemRef:(NSString *)anItemRef command:(NSString *)aCommand content:(NSString *)someContent {
    
    if ((self = [super init])) {
        self.itemRef = anItemRef;
        self.command = aCommand;
        self.content = someContent;
        [self parseItemRef];
    }
    
    return self;
}

- (void) dealloc {
	self.itemRef = nil;
	self.item = nil;
	self.command = nil;
	self.content = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Retrieves the actual item from the itemRef.
 * Not included in the <code>initWithNode:</code> function because all objects need to be
 * created first before the referenced item can be retrieved.
 */
- (void) parseItemRef {
	NarrativeModel *model = [NarrativeModel sharedInstance];
	self.item = [model parseItemRef:itemRef];
}

/**
 * Housekeeping related to executing the event atom.
 */
- (void) handleExecute {
    self.isRunning = TRUE;
}

/**
 * Informs the model that the event atom has finished playing.
 */
- (void) handleEnd {
    if (self.isRunning) {
        self.isRunning = FALSE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EventAtomEnd" object:self];
    }
}

@end
