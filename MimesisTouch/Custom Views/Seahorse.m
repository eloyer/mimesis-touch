//
//  Seahorse.m
//  MimesisTouch
//
//  Created by Erik Loyer on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Seahorse.h"
#import "NarrativeModel.h"
#import "EventAtom.h"
#import "Actor.h"
#import "SimpleAudioEngine.h"

@implementation Seahorse

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
        
		[[NarrativeModel sharedInstance] addObserver:self];
		
        winSize = [[CCDirector sharedDirector] winSize];
		sprite = [[CCSprite spriteWithFile:@"seahorse.png"] retain];
		sprite.position = ccp(winSize.width * .75, winSize.height * .5);
        sprite.visible = actor.onStage;
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
    int num = rand() % 2 + 1;
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"sfx%i.mp3", num]];
}

/**
 * Updates the state of the octopus when necessary.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
    
    Actor *originator = (Actor *)eventAtom.item;
    
    if (originator == actor) {
        if ([eventAtom.command isEqualToString:@"say"]) {
            [self poke];
        } else if ([eventAtom.command isEqualToString:@"enter"]) {
            sprite.visible = actor.onStage;
        } else if ([eventAtom.command isEqualToString:@"exit"]) {
            sprite.visible = actor.onStage;
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
