//
//  Topic.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Topic class defines something an actor can think and feel about in the narrative.

#import "Topic.h"
#import "TreeNode.h"
#import "NarrativeModel.h"


@implementation Topic

@synthesize identifier;
@synthesize description;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Topic.
 * @param node A TreeNode representing the XML in the narrative script that defines the topic.
 * @return The new Topic.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.topics allValues] count];
			self.identifier = [NSString stringWithFormat:@"topic%i", count];
		}
        
        self.description = [node attributeForKey:@"description"];
		
	}
	
	return self;
}

- (void) dealloc {
	self.identifier = nil;
    self.description = nil;
	[super dealloc];
}

@end
