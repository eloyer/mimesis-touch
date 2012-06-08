//
//  Anglerfish.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Anglerfish.h"
#import "NarrativeModel.h"
#import "EventAtom.h"

@implementation Anglerfish

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
        
		[[NarrativeModel sharedInstance] addObserver:self];
		
        winSize = [[CCDirector sharedDirector] winSize];
		sprite = [[CCSprite spriteWithFile:@"anglerfish.png"] retain];
		sprite.position = ccp(winSize.width * .75, winSize.height * .5);
		[self addChild:sprite];
        
        sinValue = 0;
		
		[self scheduleUpdate];
		
	}
	
	return self;
}

- (void) dealloc {
	[sprite removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

- (void) poke {
    sprite.scale = 1.25;
}

/**
 * Updates the state of the octopus when necessary.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
    
    Actor *originator;
    
	if ([eventAtom.command isEqualToString:@"say"]) {
		originator = (Actor *)eventAtom.item;
        if (originator == actor) {
            [self poke];
        }
    }
    
}

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
    
    sinValue += (dt * 2);
    sprite.position = ccp(sprite.position.x, (winSize.height * .5) + (10 * sin(sinValue)));
    sprite.scale += (1.0 - sprite.scale) * (dt * 2);
	
}


@end
