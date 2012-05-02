//
//  Topic.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Topic class defines something an actor can think and feel about in the narrative.

#import <Foundation/Foundation.h>

@class TreeNode;

@interface Topic : NSObject {
    
	NSString				*identifier;					///< Unique identifier for the topic.
    NSString                *description;                   ///< Description of the topic (for display to player).
    
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *description;

- (id) initWithNode:(TreeNode *)node;

@end