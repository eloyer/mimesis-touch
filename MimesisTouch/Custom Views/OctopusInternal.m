//
//  OctopusInternal.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OctopusInternal.h"
#import "Sentiment.h"
#import "Actor.h"
#import "Emotion.h"
#import "EventAtom.h"
#import "NarrativeModel.h"

@implementation OctopusInternal

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
        
		[[NarrativeModel sharedInstance] addObserver:self];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        head = [CCSprite spriteWithFile:@"oct_cu_head.png"];
 		//head.position = ccp(winSize.width * .5, winSize.height * .5);
        [self addChild:head];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"octopus_eye.plist"];
        
        eyeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"octopus_eye.png"];
        [self addChild:eyeSpriteSheet];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"oct_eye_negative.png"]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"oct_eye_neutral.png"]];
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"oct_eye_positive.png"]];
        CCAnimation *anim = [CCAnimation animationWithFrames:animFrames delay:0.1f];
        [[CCAnimationCache sharedAnimationCache] addAnimation:anim name:@"eyeAnimation"];
        
        eye = [CCSprite spriteWithSpriteFrameName:@"oct_eye_neutral.png"];
        eye.position = ccp(25, 75);
        
        [eyeSpriteSheet addChild:eye];
		
		[self scheduleUpdate];
        
        [self updatePose];
		
	}
	
	return self;
}

- (void) dealloc {
    [[NarrativeModel sharedInstance] removeObserver:self];
	[eyeSpriteSheet removeFromParentAndCleanup:TRUE];
    [eye removeFromParentAndCleanup:TRUE];
    [head removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Updates the pose of the view to match the actor's internal state.
 */
- (void) updatePose {
    
    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    Emotion *emotion = [sentiment strongestInternalEmotion];
    int frame;
    
    if ([emotion.name isEqualToString:@"aggressive"]) {
        frame = 0;
    } else if ([emotion.name isEqualToString:@"confused"]) {
        frame = 2;
    }
    
    [eye setDisplayFrameWithAnimationName:@"eyeAnimation" index:frame];
    
}

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
    
    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    Emotion *emotion = [sentiment strongestInternalEmotion];
    CGFloat ratio = fmin(10, emotion.internalStrength) / 10.0;
    int randAmount = round(20 * ratio);
    eye.position = ccp(25 + (random() % randAmount) - (randAmount / 2), 25 + (random() % randAmount) - (randAmount / 2));

}

@end
