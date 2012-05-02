//
//  Prop.h
//  GeNIE
//
//  Created by Erik Loyer on 10/15/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Prop class defines an inanimate object in the narrative.

#import <Foundation/Foundation.h>


@class TreeNode;
@class Topic;

@interface Prop : NSObject {
	
	NSString				*identifier;					///< The unique identifier for the prop.
    NSString                *topicRef;                      ///< Identifier of the topic which this prop represents (optional).
    Topic                   *topic;                         ///< The topic which the prop represents (optional).

}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) Topic *topic;

- (id) initWithNode:(TreeNode *)node;
- (void) parseTopicRef;

@end
