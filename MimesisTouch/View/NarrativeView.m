//
//  NarrativeView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/12/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The NarrativeView is an abstract class defining the base view for the application.
/// It should be subclassed and its <code>initWithController:</code> and 
/// <code>setCurrentShot:</code> methods overridden to allow setup of a custom
/// narrator view and individual shots.

#import "NarrativeView.h"
#import "AdministrativeView.h"
#import "NarrativeModel.h"
#import "NarratorView.h"
#import "ShotView.h"


@implementation NarrativeView

@synthesize controller;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new NarrativeView.
 * @param cntrllr Instance of the narrative controller.
 * @return The new NarrativeView.
 */
- (id) initWithController:(NarrativeController *)cntrllr {
	
	if ((self = [super init])) {
		
		controller = cntrllr;
		currentShotView = nil;
		
        // text commentary on the narrative
		narratorView = [[NarratorView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:narratorView];
		[self addChild:narratorView z:9000];
		
        // menu interface
		adminView = [[AdministrativeView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:adminView];
		[self addChild:adminView z:10000];
		
		[self scheduleUpdate];
		
		// set up touch
		self.isTouchEnabled = YES;
		
	}
	
	return self;
}

- (void) dealloc {
	self.controller = nil;
	[currentShotView release];
	[[NarrativeModel sharedInstance] removeObserver:adminView];
	[adminView release];
	[[NarrativeModel sharedInstance] removeObserver:narratorView];
	[narratorView release];
	[super dealloc];
}

/**
 * This method must be overriden to correlate shots as defined in the narrative
 * script with shot views, and to manage the transitions between them.
 * @param shot The shot to be activated.
 */
- (void) setCurrentShot:(Shot *)shot {
	
}
	
/**
 * Removes the specified shot view from the scene and releases its memory.
 */
- (void) cleanupShotView {
	
	if (currentShotView != nil) {
		[currentShotView removeFromParentAndCleanup:TRUE];
		[currentShotView release];
	}
	
}

/**
 * Pauses all shot view activity when game is paused; resumed it when unpaused.
 */
- (void) setPausedState:(bool)state {
	
	if (state) {
		[self pauseSchedulerAndActions];
	} else {
		[self resumeSchedulerAndActions];
	}
	
	[narratorView setPausedState:state];
	
}

/**
 * Called once per frame.
 */
- (void) update:(ccTime)dt {
	
	[currentShotView update:dt];
	
}

@end
