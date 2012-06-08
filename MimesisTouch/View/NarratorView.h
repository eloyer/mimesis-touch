//
//  NarratorView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/25/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The NarratorView is an abstract class defining an interface for communicating
/// textual story information to the player. When textual information is to be
/// displayed, a translucent bar slides upwards from the bottom of the screen,
/// and the text is shown next to an icon representing the character originating it.
/// This class can be used as is, but if so then all icons will be set to the
/// default "narrator" icon.

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NarrativeController.h"

// TODO implement changes in main GeNIE repo

@class Actor;
@class EventAtom;

@interface NarratorView : CCLayer {
	
	NarrativeController			*controller;				///< Instance of the narrative controller.
	CCLabelTTF					*captionLayer;				///< Label for the caption.
	EventAtom					*currentEventAtom;			///< Event atom currently being executed.
    CCSprite                    *background;                ///< Background for the view.
    CCSprite                    *icon;                      ///< Current actor icon.
    Actor                       *lastActor;                 ///< Last actor to be narrated.
    NSDate                      *lastEndDate;               ///< End date of the last say action.
    NSMutableArray              *eventAtomQueue;            ///< Queue of event atoms waiting to be executed.
    BOOL                        isNarrating;                ///< Is the view currently narrating something?

}

- (id) initWithController:(NarrativeController *)cntrllr;
- (void) executeEventAtom:(EventAtom *)eventAtom;
- (void) narrate:(NSString *)content duration:(CGFloat)duration;
- (void) narrateEventAtom:(EventAtom *)eventAtom;
- (void) narrateEventAtomFromQueue;
- (void) handleNarrateEnd;
- (CCSprite*) iconForActor:(Actor *)actor;
- (void) tryToHideView;
- (void) setPausedState:(bool)state;

@end
