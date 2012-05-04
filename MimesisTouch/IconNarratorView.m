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


@implementation IconNarratorView

/**
 * Returns the icon for the given actor (this class should be subclassed and this method replaced
 * with one that will return appropriate icons for each actor).
 */
- (CCSprite*) iconForActor:(Actor *)actor {
    
    NSString *filename;
    
    if ([actor.identifier isEqualToString:@"anglerfish"]) {
        filename = @"anglerfish_icon.png";
    } else if ([actor.identifier isEqualToString:@"octopus"]) {
        filename = @"octopus_icon.png";
    } else {
        filename = @"generic_icon.png";
    }
    
    return [CCSprite spriteWithFile:filename];
}

@end
