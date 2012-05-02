//
//  ShotView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/13/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The ShotView class is responsible for rendering a given shot. Extend this abstract 
///	class to create individual shot classes with custom behavior.

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class NarrativeController;
@class Shot;

@interface ShotView : CCLayer {
	
	NarrativeController		*controller;			// controller for the application
	Shot					*shot;					// shot model which the shot view is rendering

}

@property (nonatomic, retain) Shot *shot;

- (id) initWithModel:(Shot *)modelShot controller:(NarrativeController *)cntrllr;
- (void) update:(ccTime)dt;

@end
