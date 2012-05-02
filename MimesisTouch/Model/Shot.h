//
//  Shot.h
//  GeNIE
//
//  Created by Erik Loyer on 10/13/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Shot class defines a view of a setting.

#import <Foundation/Foundation.h>


@class TreeNode;

@interface Shot : NSObject {
	
	TreeNode				*sourceData;					///< Source data for the shot.
	NSString				*identifier;					///< Unique identifier for the shot.
	NSMutableDictionary		*adjacentShots;					///< Shots to which this shot can transition.
    BOOL                    isMuted;                        ///< If true, keeps the shot out of random shot selections.
    BOOL                    isInternal;                     ///< If true, then changes to an actor's sentiments while the shot is active will affect their internal, as opposed to their external, emotions.
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSMutableDictionary *adjacentShots;
@property (readwrite) BOOL isMuted;
@property (readwrite) BOOL isInternal;

- (id) initWithNode:(TreeNode *)node;
- (void) parseAdjacentShots;
- (Shot *) adjacentShotForKey:(NSString *)key;

@end
