//
//  ActorView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/19/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//
 
///	The ActorView is responsible for rendering an actor model as defined by the
/// narrative script. To create your own ActorViews, extend this abstract class to
/// create new classes for each actor, each with its own custom behavior.

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class NarrativeController;
@class Actor;

@interface ActorView : CCNode {
	
	NarrativeController		*controller;			///< Pointer to the narrative controller.
	Actor					*actor;					///< Pointer to the actor model which this view is rendering.
	
}

@property (nonatomic, retain) Actor *actor;

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr;
- (void) update:(ccTime)dt;

@end
