//
//  IconNarratorView.m
//  GeNIE
//
//  Created by Erik Loyer on 9/15/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

#import "IconNarratorView.h"
#import "cocos2d.h"
#import "Actor.h"
#import "NarrativeModel.h"
#import "Setting.h"


@implementation IconNarratorView

/**
 * Narrates the specified event atom, or places it in a queue if
 * something is already being narrated.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
    
    NarrativeModel *model = [NarrativeModel sharedInstance];
    
    if (!isNarrating) {
        if (model.currentSetting.currentShot != [model parseItemRef:@"thoughtSpaceShot"]) {
            [self narrateEventAtom:eventAtom];
        } else {
            if ([eventAtomQueue count] == 0) {
                [self performSelector:@selector(handleNarrateEnd) withObject:NULL afterDelay:0.5];
            }
            [eventAtomQueue addObject:eventAtom];
        }
    } else {
        [eventAtomQueue addObject:eventAtom];
    }
    
}

/**
 * Returns the icon for the given actor (this class should be subclassed and this method replaced
 * with one that will return appropriate icons for each actor).
 */
- (CCSprite*) iconForActor:(Actor *)actor {
    
    NSString *filename;
    
    if ([actor.identifier isEqualToString:@"anglerfish"]) {
        filename = @"anglerfish_icon.png";
    } else if ([actor.identifier isEqualToString:@"shark"]) {
        filename = @"shark_icon.png";
    } else if ([actor.identifier isEqualToString:@"seahorse"]) {
        filename = @"seahorse_icon.png";
    } else if ([actor.identifier isEqualToString:@"octopus"]) {
        filename = @"octopus_icon.png";
    } else {
        filename = @"generic_icon.png";
    }
    
    return [CCSprite spriteWithFile:filename];
}

/**
 * Handles the completion of a narration action.
 */
- (void) handleNarrateEnd {
    
    NarrativeModel *model = [NarrativeModel sharedInstance];
    
    // if we're in the thought space, don't unspool the queue
    if (model.currentSetting.currentShot == [model parseItemRef:@"thoughtSpaceShot"]) {
        [self performSelector:@selector(handleNarrateEnd) withObject:NULL afterDelay:0.5];
        
    // otherwise, narrate the next atom
    } else {
        lastEndDate = [[NSDate date] retain];
        [controller handleEventAtomEnd:currentEventAtom];
        isNarrating = FALSE;
        [self narrateEventAtomFromQueue];
    }
    
}

@end
