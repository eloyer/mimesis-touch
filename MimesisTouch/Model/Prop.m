//
//  Prop.h
//  GeNIE
//
//  Created by Erik Loyer on 10/15/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Prop class defines an inanimate object in the narrative.

#import "Prop.h"
#import "NarrativeModel.h"
#import "TreeNode.h"
#import "Topic.h"


@implementation Prop

@synthesize identifier;
@synthesize topic;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Prop.
 * @param node A TreeNode representing the XML in the narrative script that defines the prop.
 * @return The new Prop.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.props allValues] count];
			self.identifier = [NSString stringWithFormat:@"prop%i", count];
		}
        
        // parse the topic reference (if any)
        topicRef = [node attributeForKey:@"topicRef"];
		
	}
	
	return self;
}

- (void) dealloc {
	self.identifier = nil;
    self.topic = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Retrieves the actual topic from the topicRef.
 * Not included in the <code>initWithNode:</code> function because all objects need to be
 * created first before the referenced topic can be retrieved.
 */
- (void) parseTopicRef {
	NarrativeModel *model = [NarrativeModel sharedInstance];
    self.topic = [model parseItemRef:topicRef];
}

@end
