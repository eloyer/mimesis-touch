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

#import "TopicView.h"


@implementation TopicView

@synthesize topic;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new TopicView.
 * @param modelTopic The topic model which this view is rendering.
 * @param cntrllr Instance of the narrative controller.
 * @return The new TopicView.
 */
- (id) initWithModel:(Topic *)modelTopic controller:(NarrativeController *)cntrllr; {
	
	if ((self = [super init])) {
		
		self.topic = modelTopic;
		controller = cntrllr;
		
	}
	
	return self;
}

- (void) dealloc {
    self.topic = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
	
}

@end
