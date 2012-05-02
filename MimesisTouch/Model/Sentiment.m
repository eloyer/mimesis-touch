//
//  Sentiment.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Sentiment class bundles together all the conflicting emotions an actor may feel about a topic.

#import "Sentiment.h"
#import "TreeNode.h"
#import "Emotion.h"
#import "NarrativeModel.h"
#import "Topic.h"
#import "Event.h"


@implementation Sentiment

@synthesize topic;
@synthesize transparency;
@synthesize emotions;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Sentiment.
 * @param node A TreeNode representing the XML in the narrative script that defines the sentiment.
 * @return The new Sentiment.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		
		NarrativeModel *model = [NarrativeModel sharedInstance];
		TreeNode *data;
		NSArray *dataArray;
		
		self.transparency = MIN(1.0, MAX(0.0, [[node attributeForKey:@"transparency"] floatValue]));
        self.topic = [model parseItemRef:[node attributeForKey:@"topicRef"]];
		
		// parse emotions
		self.emotions = [[NSMutableDictionary alloc] init];
		Emotion *emotion;
		dataArray = [node objectsForKey:@"emotion"];
		for (data in dataArray) {
 			emotion = [[Emotion alloc] initWithNode:data];
            [emotions setObject:emotion forKey:emotion.name];
		}
		
	}
	
	return self;
}

- (void) dealloc {
	self.topic = nil;
    self.emotions = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Returns a demonstration event that expresses the current state of the sentiment.
 * @return An event which demonstrates the sentiment (if available).
 */
- (Event *) getEvent {
    
    Emotion *emotion;
    Event *event = nil;
    
    // decide whether we're going to express an internal or external emotion
    BOOL isInternal = (((rand() % 100) / 100.0) <= transparency);
    
    NSArray *emotionArray = [emotions allValues];
    NSMutableArray *eligibleEmotions = [NSMutableArray array];
    int i;
    int n = [emotions count];
    CGFloat totalWeight = 0.0;
    
    // gather eligible emotions (internal or external) and keep
    // track of their relative weights
    if (isInternal) {
        for (i=0; i<n; i++) {
            emotion = [emotionArray objectAtIndex:i];
            if (emotion.internalStrength > 0) {
                [eligibleEmotions addObject:emotion];
                totalWeight += emotion.internalStrength;
            }
        }
    } else {
        for (i=0; i<n; i++) {
            emotion = [emotionArray objectAtIndex:i];
            if (emotion.externalStrength > 0) {
                [eligibleEmotions addObject:emotion];
                totalWeight += emotion.externalStrength;
            }
        }
    }
    
    // make a weighted choice of one emotion
    if ([eligibleEmotions count] > 0) {
        CGFloat randomWeight = ((rand() % 100) / 100.0) * totalWeight;
        CGFloat weightCount = 0;
        n = [eligibleEmotions count];
        for (i=0; i<n; i++) {
            emotion = [eligibleEmotions objectAtIndex:i];
            if (isInternal) {
                weightCount += emotion.internalStrength;
            } else {
                weightCount += emotion.externalStrength;
            }
            if (randomWeight <= weightCount) {
                break;
            }
        }
        event = [emotion getEvent:isInternal];
    }
    
    return event;
}

@end
