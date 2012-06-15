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

#import "NarratorView.h"
#import "EventAtom.h"
#import "Actor.h"
#import "NarrativeModel.h"
#import "Globals.h"


@implementation NarratorView

#pragma mark -
#pragma mark Instance methods

// TODO implement changes in main GeNIE repo

/**
 * Initializes a new NarratorView.
 * @param cntrllr Instance of the narrative controller.
 * @return The new NarratorView.
 */
- (id) initWithController:(NarrativeController *)cntrllr {
	
	if ((self = [super init])) {
		
		controller = cntrllr;
        lastActor = NULL;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];

        // set up background
		background = [[CCSprite spriteWithFile:@"narration_bg.png"] retain];
		background.position = ccp(winSize.width * .5, 30);
        background.scaleX = winSize.width / 16;
		[self addChild:background];
		
		// set up caption label
		captionLayer = [[CCLabelTTF alloc] initWithString:@"" dimensions:CGSizeMake(winSize.width - 80, 50) alignment:UITextAlignmentLeft fontName:@"TrebuchetMS-Bold" fontSize:16];
		captionLayer.anchorPoint = ccp(0,0);
		captionLayer.position = ccp(70, 5);
		[self addChild:captionLayer];
        
        // view is initially hidden
        self.position = ccp(0, -60);
        
        eventAtomQueue = [[NSMutableArray alloc] init];
		
	}
	
	return self;
}

- (void) dealloc {
	[captionLayer removeFromParentAndCleanup:TRUE];
	[captionLayer release];
    [background removeFromParentAndCleanup:TRUE];
    [background release];
    [eventAtomQueue release];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Narrates the specified event atom, or places it in a queue if
 * something is already being narrated.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {

    if (!isNarrating) {
        [self narrateEventAtom:eventAtom];
    } else {
        [eventAtomQueue addObject:eventAtom];
    }
		
}

// TODO: Move changes back to main repo

/**
 * Narrates the specified event atom.
 * @param eventAtom The event atom to be narrated.
 */
- (void) narrateEventAtom:(EventAtom *)eventAtom {
	
	NSString *contentString;
	NarrativeModel *model = [NarrativeModel sharedInstance];
	Actor *originator = NULL;
	Actor *recipient;
    
    DLog(@"----narrate atom %@", eventAtom.command);
    
	// narrate an actor saying something
	if ([eventAtom.command isEqualToString:@"say"]) {
        currentEventAtom = [eventAtom retain];
		originator = (Actor *)currentEventAtom.item;
        if ([originator.identifier isEqualToString:@"narrator"]) {
            [self narrate:currentEventAtom.content duration:3.5];
        } else {
            [self narrate:[NSString stringWithFormat:@"“%@”", currentEventAtom.content] duration:3.5];
        }
        
        // narrate an actor thinking something
    } else if ([eventAtom.command isEqualToString:@"think"]) {
        currentEventAtom = [eventAtom retain];
        originator = (Actor *)currentEventAtom.item;
        [self narrate:[NSString stringWithFormat:@"<< %@ >>", currentEventAtom.content] duration:3.5];
		
        // narrate one actor looking at another
	} else if ([eventAtom.command isEqualToString:@"lookAt"]) {
        currentEventAtom = [eventAtom retain];
		originator = (Actor *)currentEventAtom.item;
		recipient = [model.actors objectForKey:currentEventAtom.content];
		if (recipient != nil) {
			contentString = [NSString stringWithFormat:@"%@ looks at %@", originator.actorName, recipient.actorName]; 
			[self narrate:contentString duration:1.0];
		}
		
        // narrate one actor looking away from another
	} else if ([eventAtom.command isEqualToString:@"lookAwayFrom"]) {
        currentEventAtom = [eventAtom retain];
		originator = (Actor *)currentEventAtom.item;
		recipient = [model.actors objectForKey:currentEventAtom.content];
		if (recipient != nil) {
			contentString = [NSString stringWithFormat:@"%@ looks away from %@", originator.actorName, recipient.actorName]; 
			[self narrate:contentString duration:1.0];
		}
	}
    
    // if the originating actor is new, then create and show the actor's icon
    if ((lastActor != originator) && (originator != NULL)) {
        
        // dispose of the old icon
        if (icon != NULL) {
            [icon removeFromParentAndCleanup:TRUE];
            [icon release];
        }
        
        icon = [[self iconForActor:originator] retain];
        icon.position = ccp(30, 30);
        icon.opacity = 0;
        [self addChild:icon];
        [icon runAction:[CCFadeIn actionWithDuration:0.25]];
        if (lastActor != NULL) [lastActor release];
        lastActor = [originator retain];
    }    
}

/**
 * Displays the given string for the given length of time.
 * @param content The string to be displayed.
 * @param duration The amount of time the content is to be displayed, in seconds.
 */
- (void) narrate:(NSString *)content duration:(CGFloat)duration {
    
    //DLog(@"say %@", content);
	
    // updates and vertically centers the text
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
	CGSize compSize = [content sizeWithFont:font constrainedToSize:CGSizeMake(winSize.width - 80, 50) lineBreakMode:UILineBreakModeWordWrap];	
	captionLayer.opacity = 0;
	[captionLayer setString:content];
	captionLayer.position = ccp(70, 7 - (50 - compSize.height) * .5);
	[captionLayer stopAllActions];
	[captionLayer runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.25], [CCDelayTime actionWithDuration:duration], [CCFadeOut actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(handleNarrateEnd)], [CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(tryToHideView)], nil]];
    
    // animates the view upwards if necessary
    if (self.position.y < 0) {
        [self stopAllActions];
        [self runAction:[CCEaseExponentialInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:ccp(0, 0)]]];
    }
    
    isNarrating = TRUE;
	
}

/**
 * Narrates the next event atom in the queue (if any).
 */
- (void) narrateEventAtomFromQueue {
    
    EventAtom *eventAtom;
    
    if ([eventAtomQueue count] > 0) {
        eventAtom = [eventAtomQueue objectAtIndex:0];
        [eventAtomQueue removeObject:eventAtom];
        [self narrateEventAtom:eventAtom];
    }
}

/**
 * Handles the completion of a narration action.
 */
- (void) handleNarrateEnd {
    lastEndDate = [[NSDate date] retain];
 	[controller handleEventAtomEnd:currentEventAtom];
    isNarrating = FALSE;
    [self narrateEventAtomFromQueue];
}

/**
 * Returns the icon for the given actor (this class should be extended and this method replaced
 * with one that will return appropriate icons for each actor).
 * @param actor The actor for whom an icon is to be returned.
 */
- (CCSprite*) iconForActor:(Actor *)actor {
    return [CCSprite spriteWithFile:@"generic_icon.png"];
}

/**
 * Tries to hide the view after a period of inactivity.
 */
- (void) tryToHideView {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastEndDate];
    if (interval >= 1) {
        [self stopAllActions];
        [self runAction:[CCEaseExponentialInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:ccp(0, -60)]]];
    }
}

/**
 * Pauses all shot view activity when game is paused; resumes it when unpaused.
 * @param state The current game state.
 */
- (void) setPausedState:(bool)state {
	
	if (state) {
		[captionLayer pauseSchedulerAndActions];
	} else {
		[captionLayer resumeSchedulerAndActions];
	}
	
}

@end
