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

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class NarrativeController;
@class ShotView;
@class Shot;
@class AdministrativeView;
@class NarratorView;

@interface NarrativeView : CCLayer {
	
	NarrativeController		*controller;					///< Instance of the narrative controller.
	ShotView				*currentShotView;				///< The currently active shot view.
	AdministrativeView		*adminView;						///< The administrative interface (menu) view.
	NarratorView            *narratorView;					///< View which provides textual content about the narrative.

}

@property (nonatomic, retain) NarrativeController *controller;

- (id) initWithController:(NarrativeController *)cntrllr;
- (void) setCurrentShot:(Shot *)shot;
- (void) cleanupShotView;
- (void) setPausedState:(bool)state;

@end
