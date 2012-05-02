//
//  Shot.h
//  GeNIE
//
//  Created by Erik Loyer on 10/13/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Shot class defines a view of a setting.

#import "Shot.h"
#import "NarrativeModel.h"
#import "TreeNode.h"


@implementation Shot

@synthesize identifier;
@synthesize adjacentShots;
@synthesize isMuted;
@synthesize isInternal;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Shot.
 * @param node A TreeNode representing the XML in the narrative script that defines the shot.
 * @return The new Shot.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		sourceData = node;
		adjacentShots = [[NSMutableDictionary alloc] init];
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		
		// if identifier is not provided, generate one
		if ([node hasAttribute:@"id"]) {
			self.identifier = [node attributeForKey:@"id"];
		} else {
			int count = [[model.shots allValues] count];
			self.identifier = [NSString stringWithFormat:@"shot%i", count];
		}
        
        self.isMuted = FALSE;
        if ([node hasAttribute:@"muted"]) {
            self.isMuted = [[node attributeForKey:@"muted"] boolValue];
        }
        
        self.isInternal = FALSE;
        if ([node hasAttribute:@"internal"]) {
            self.isInternal = [[node attributeForKey:@"internal"] boolValue];
        }
			
	}
	
	return self;
	
}

- (void) dealloc {
	self.identifier = nil;
	self.adjacentShots = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Parses source data derived from XML to create adjacent shot links.
 * Not included in the <code>initWithNode:</code> function because all shots need to be
 * created first before links can be made.
 */
- (void) parseAdjacentShots {
	
	TreeNode *data;
	NSArray *dataArray;
	NarrativeModel *model = [NarrativeModel sharedInstance];
	Shot *shot;
	NSString *key;
	
	dataArray = [sourceData objectsForKey:@"adjacentShot"];
	for (data in dataArray) {
		key = [data attributeForKey:@"direction"];
		shot = [model.shots objectForKey:[data attributeForKey:@"shotRef"]];
		if ((key != nil) && (shot != nil)) {
			[adjacentShots setObject:shot forKey:key];
		}
	}
	
}

/**
 * Returns the adjacent shot (if any) which matches the specified key.
 * @return The matching adjacent shot (if any).
 */
- (Shot *) adjacentShotForKey:(NSString *)key {
	return [adjacentShots objectForKey:key];
}

@end
