//
//  Anglerfish.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Anglerfish.h"

@implementation Anglerfish

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
		
        CGSize winSize = [[CCDirector sharedDirector] winSize];
		sprite = [[CCSprite spriteWithFile:@"anglerfish.png"] retain];
		sprite.position = ccp(winSize.width * .75, winSize.height * .5);
		[self addChild:sprite];
		
	}
	
	return self;
}

- (void) dealloc {
	[sprite removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

@end
