//
//  TopicView.h
//  GeNIE
//
//  Created by Erik Loyer on 9/15/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The TopicView class is responsible for rendering a given topic. Extend this abstract 
///	class to create individual topic classes with custom behavior. Note that the names of 
/// topic view classes must correspond to their ids in the narrative data file. For example, 
/// if a topic's id in the data file is "hatTopic," then its corresponding class must be 
/// named "HatTopic".

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class NarrativeController;
@class Topic;

@interface TopicView : CCNode {
	
	NarrativeController		*controller;			///< Instance of the narrative controller.
	Topic					*topic;					///< Topic model which the topic view is rendering.
    
}

@property (nonatomic, retain) Topic *topic;

- (id) initWithModel:(Topic *)modelTopic controller:(NarrativeController *)cntrllr;
- (void) update:(ccTime)dt;

@end
