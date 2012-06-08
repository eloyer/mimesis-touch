//
//  Sentiment.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Sentiment class bundles together all the conflicting emotions an actor may feel about a topic.

#import <Foundation/Foundation.h>

@class Topic;
@class TreeNode;
@class Event;
@class Emotion;

@interface Sentiment : NSObject {
    
    Topic                   *topic;                         ///< The topic toward which the sentiment is directed.
    CGFloat                 transparency;                   ///< Likelihood that the character's internal emotions about the topic will be expressed (0.0 = no chance; 1.0 = 100% chance).
    CGFloat                 storedTransparency;             ///< A past transparency value that was saved for later retrieval.
    NSMutableDictionary     *emotions;                      ///< All emotions associated with the topic.
    
}

@property (nonatomic, retain) Topic *topic;
@property (readwrite) CGFloat transparency;
@property (readwrite) CGFloat storedTransparency;
@property (nonatomic, retain) NSMutableDictionary *emotions;

- (id) initWithNode:(TreeNode *)node;
- (Event *) getEvent;
- (Emotion *) strongestInternalEmotion;
- (Emotion *) strongestExternalEmotion;
- (void) storeTransparency;

// TODO: Move current version to GeNIE project

@end
