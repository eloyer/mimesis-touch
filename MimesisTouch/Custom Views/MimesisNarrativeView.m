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
#import "PlayerConfigShot.h"
#import "ThoughtSpaceShot.h"
#import "AdministrativeView.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"

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
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"underwater.mp3"];
		
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
		
		// PLAYER CONFIG SHOT
		if ([shot.identifier isEqualToString:@"playerConfigShot"]) {
			[self cleanupShotView];
			currentShotView = [[PlayerConfigShot alloc] initWithModel:shot controller:controller];
			[self addChild:currentShotView];
		
		// WIDE SHOT
		} else if ([shot.identifier isEqualToString:@"wideShot"]) {
			[self cleanupShotView];
			currentShotView = [[WideShot alloc] initWithModel:shot controller:controller];
			[self addChild:currentShotView];
			
        // THOUGHT SPACE SHOT
		} else if ([shot.identifier isEqualToString:@"thoughtSpaceShot"]) {
			[self cleanupShotView];
			currentShotView = [[ThoughtSpaceShot alloc] initWithModel:shot controller:controller];
			[self addChild:currentShotView];
			
		}
		
	}
	
}


/**
 * Handles updates to the property indicating whether the narrative
 * has been started yet or not.
 * @param state The new state of the 'hasStarted' property, as a string.
 */
- (void) setStartedState:(NSString *)state {
    
    NSLog(@"set started state yo");
	
	BOOL hasStarted = [state boolValue];
	
	if (hasStarted) {
        
        //if (currentShotView) {
            [[NarrativeModel sharedInstance] removeObserver:adminView];
            [adminView removeFromParentAndCleanup:TRUE];
            //[adminView release];
            [[NarrativeModel sharedInstance] removeObserver:narratorView];
            [narratorView removeFromParentAndCleanup:TRUE];
            //[narratorView release];
        //}
		
        // text commentary on the narrative
		narratorView = [[IconNarratorView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:narratorView];
		[self addChild:narratorView z:9000];
		
        // menu interface
		adminView = [[AdministrativeView alloc] initWithController:controller];
		[[NarrativeModel sharedInstance] addObserver:adminView];
		[self addChild:adminView z:10000];
        
        NarrativeModel *model = [NarrativeModel sharedInstance];
        [self setCurrentShot:model.currentSetting.currentShot];
        
	}
	
}

@end
