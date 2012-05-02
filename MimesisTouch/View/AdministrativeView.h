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

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NarrativeController.h"


@interface AdministrativeView : CCLayer {
	
	NarrativeController		*controller;			///< Pointer to the narrative controller.
	CCMenu					*mainMenu;				///< The main menu.
	CCMenuItemLabel			*newMenuItem;           ///< New game menu item.
	CCMenuItemLabel			*resumeMenuItem;		///< Resume game menu item.
	CCMenuItemLabel			*aboutMenuItem;         ///< About the game menu item.
	CCMenuItemLabel			*creditsMenuItem;       ///< Credits menu item.
	CCMenu					*gameMenu;				///< The in-game menu.

}

- (id) initWithController:(NarrativeController *)cntrllr;
- (void) setStartedState:(NSString *)state;
- (void) setPausedState:(NSString *)state;
- (void) showMainMenu;
- (void) hideMainMenu;
- (void) showGameMenu;
- (void) hideGameMenu;
- (void) showAboutView;
- (void) showCreditsView;

@end
