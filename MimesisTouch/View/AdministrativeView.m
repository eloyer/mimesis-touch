//
//  AdministrativeView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/19/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The AdministrativeView class is reponsible for rendering various administrative
/// interfaces like menus, credits, etc.

#import "AdministrativeView.h"
#import "NarrativeController.h"
#import "Globals.h"


@implementation AdministrativeView

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes the AdministrativeView.
 * @param cntrllr The main narrative controller.
 * @return The new AdministrativeView.
 */
- (id) initWithController:(NarrativeController *)cntrllr {
	
	if (self = [super init]) {
		
		controller = cntrllr;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		// set up main menu
		newMenuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"New" fontName:@"Helvetica-Bold" fontSize:36] target:controller selector:@selector(startNarrative)];
		aboutMenuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"About" fontName:@"Helvetica-Bold" fontSize:24] target:self selector:@selector(showAboutView)];
		creditsMenuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Credits" fontName:@"Helvetica-Bold" fontSize:24] target:self selector:@selector(showCreditsView)];
		resumeMenuItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Resume" fontName:@"Helvetica-Bold" fontSize:36] target:controller selector:@selector(resumeNarrative)];
		[resumeMenuItem setIsEnabled:FALSE];
		resumeMenuItem.disabledColor = ccc3(45, 45, 45);
		mainMenu = [CCMenu menuWithItems:newMenuItem, resumeMenuItem, /*aboutMenuItem, creditsMenuItem,*/ nil];
		[mainMenu alignItemsVerticallyWithPadding:10];
		mainMenu.position = ccp(winSize.width * .5, winSize.height * .5);
		[self addChild:mainMenu];
		
		// set up game menu
		CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"icon-pause.png" selectedImage:@"icon-pause.png" target:controller selector:@selector(pauseNarrative)];
		gameMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
		pauseMenuItem.anchorPoint = ccp(0, 1);
		gameMenu.anchorPoint = ccp(0, 1);
		gameMenu.position = ccp(5, winSize.height - 5);
		[self addChild:gameMenu];
		
	}
	
	return self;
}

- (void) dealloc {
	[controller release];
	[mainMenu release];
	[gameMenu release];
	[super dealloc];
}
	
#pragma mark -
#pragma mark Utility methods

/**
 * Disables/enables the Resume menu item depending on whether the game has been started.
 * @param state If true, then the game has been started and the Resume item is enabled.
 */
- (void) setStartedState:(NSString *)state {
    BOOL stateVal = [state boolValue];
	[newMenuItem setIsEnabled:!stateVal];
	[resumeMenuItem setIsEnabled:!stateVal];
	//[aboutMenuItem setIsEnabled:!state];
	//[creditsMenuItem setIsEnabled:!state];
}

/**
 * Shows the main menu when the game is paused; the game menu when unpaused.
 * @param state The current game state; menus will be shown/hidden accordingly.
 */
- (void) setPausedState:(NSString *)state {
    BOOL stateVal = [state boolValue];
	[newMenuItem setIsEnabled:stateVal];
	[resumeMenuItem setIsEnabled:stateVal];
	//[aboutMenuItem setIsEnabled:state];
	//[creditsMenuItem setIsEnabled:state];
	if (stateVal) {
		[self showMainMenu];
		[self hideGameMenu];
	} else {
		[self showGameMenu];
		[self hideMainMenu];
	}
}

/**
 * Shows the main menu.
 */
- (void) showMainMenu {
	[mainMenu runAction:[CCFadeIn actionWithDuration:.25]];
}

/**
 * Hides the main menu.
 */
- (void) hideMainMenu {
	[mainMenu runAction:[CCFadeOut actionWithDuration:.25]];
}

/**
 * Shows the game menu.
 */
- (void) showGameMenu {
	[gameMenu runAction:[CCFadeIn actionWithDuration:.25]];
}

/**
 * Hides the game menu.
 */
- (void) hideGameMenu {
	[gameMenu runAction:[CCFadeOut actionWithDuration:.25]];
}

/**
 * Shows information about the game (stub).
 */
- (void) showAboutView {
	DLog(@"about view not yet implemented");
}

/**
 * Shows the game's credits (stub).
 */
- (void) showCreditsView {
	DLog(@"credits view not yet implemented");
}

@end
