//
//  MimesisNarrativeView.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MimesisNarrativeView.h"
#import "NarrativeModel.h"
#import "IconNarratorView.h"
#import "Shot.h"
#import "WideShot.h"
#import "AdministrativeView.h"

@implementation MimesisNarrativeView

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
		narratorView = [[IconNarratorView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:narratorView];
		[self addChild:narratorView z:9000];
		
        // menu interface
		adminView = [[AdministrativeView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:adminView];
		[self addChild:adminView z:10000];
		
		[self scheduleUpdate];
		
	}
	
	return self;
}

#pragma mark -
#pragma mark Utility methods

/**
 * Deactivates the current shot view (if any) and activates the shot view associated with
 * the specified shot model.
 * @param shot The shot to be activated.
 */
- (void) setCurrentShot:(Shot *)shot {
	
	if (shot != currentShotView.shot) {
		
		// WIDE SHOT
		if ([shot.identifier isEqualToString:@"wideShot"]) {
			[self cleanupShotView];
			currentShotView = [[WideShot alloc] initWithModel:shot controller:controller];
			[self addChild:currentShotView];
			
        // THOUGHT SPACE SHOT
		/*} else if ([shot.identifier isEqualToString:@"thoughtSpaceShot"]) {
			
			// both the close up and the thought space are handled by the same shot view,
			// so only remove the current shot view if we aren't currently rendering either one
			if (![currentShotView.shot.identifier isEqualToString:@"closeUpShot"]) {
				[self cleanupShotView];
				currentShotView = [[CloseUp_ThoughtSpace alloc] initWithModel:shot controller:controller];
				[self addChild:currentShotView];
				
                // otherwise, just tell the current view to change shots
			} else {
				[(CloseUp_ThoughtSpace *)currentShotView setCurrentShot:shot];
			}*/
			
		}
		
		
	}
	
}

@end
