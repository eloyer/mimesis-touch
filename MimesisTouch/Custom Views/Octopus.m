//
//  Octopus.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Octopus.h"

@implementation Octopus

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"octopus.plist"];
        
        octopusSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"octopus.png"];
        [self addChild:octopusSpriteSheet];
        
        int i;
        
        // build aggressive animation
        NSMutableArray *aggressiveFrames = [NSMutableArray array];
        for (i=1; i<=10; i++) {
            [aggressiveFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *aggressiveAnim = [CCAnimation animationWithFrames:aggressiveFrames delay:0.1f];
        
        // build confused animation
        NSMutableArray *confusedFrames = [NSMutableArray array];
        for (i=11; i<=19; i++) {
            [confusedFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *confusedAnim = [CCAnimation animationWithFrames:confusedFrames delay:0.1f];
        
        // build oblivious animation
        NSMutableArray *obliviousFrames = [NSMutableArray array];
        for (i=20; i<=29; i++) {
            [obliviousFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *obliviousAnim = [CCAnimation animationWithFrames:obliviousFrames delay:0.1f];
        
        // build suspicious animation
        NSMutableArray *suspiciousFrames = [NSMutableArray array];
        for (i=30; i<=39; i++) {
            [suspiciousFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *suspiciousAnim = [CCAnimation animationWithFrames:suspiciousFrames delay:0.1f];
       
        [[CCAnimationCache sharedAnimationCache] addAnimation:aggressiveAnim name:@"aggressive"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:confusedAnim name:@"confused"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:obliviousAnim name:@"oblivious"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:suspiciousAnim name:@"suspicious"];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        octopus = [CCSprite spriteWithSpriteFrameName:@"octopus-1.png"];
 		octopus.position = ccp(winSize.width * .25, winSize.height * .5);
        
        octopusProxy = [CCSprite spriteWithSpriteFrameName:@"octopus-1.png"];
 		octopusProxy.position = ccp(winSize.width * .25, winSize.height * .5);
        octopusProxy.opacity = 100;
        
        [octopusSpriteSheet addChild:octopus];
        [octopusSpriteSheet addChild:octopusProxy];
        
        transparency = 0.0;
        transparencyVelocity = 0.0;
        maxTransparencyVelocity = 0.0;
        isTransparencyGestureActive = false;
		
		[self scheduleUpdate];
		
	}
	
	return self;
}

- (void) dealloc {
	[octopusSpriteSheet removeFromParentAndCleanup:TRUE];
    [octopus removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

- (void) setTransparencyVelocity:(CGFloat)velocity {
    transparencyVelocity = fmaxf(-.1, fminf(.1, velocity));
    maxTransparencyVelocity = fmaxf(fabs(transparencyVelocity), maxTransparencyVelocity);
    //NSLog(@"velocity: %f %f %f", velocity, fabs(transparencyVelocity), maxTransparencyVelocity);
    isTransparencyGestureActive = true;
}

- (void) endTransparencyGesture {
    isTransparencyGestureActive = false;
    maxTransparencyVelocity = 0;
}

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
   
    transparencyVelocity *= .9;
    transparency = fminf(fmaxf(transparency + transparencyVelocity, 0), 1);
    
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"aggressive"];
    int frame = transparency * ([animation.frames count] - 1);
    [octopusProxy setDisplayFrameWithAnimationName:@"aggressive" index:frame];
    
    CGFloat targetX;
    CGFloat targetScale;
    CGFloat targetOpacity;
    CGFloat animSpeed;
    CGFloat normTransparencyVelocity = maxTransparencyVelocity / 0.1;
    //NSLog(@"norm velocity: %f", normTransparencyVelocity);
    if (isTransparencyGestureActive) {
        targetX = octopus.position.x + (200 * normTransparencyVelocity);
        targetScale = 1 + (normTransparencyVelocity * .75);
        targetOpacity = fminf(150, 150 * normTransparencyVelocity);
        animSpeed = 10;
    } else {
        targetX = octopus.position.x;
        targetScale = 1;
        targetOpacity = 0;
        animSpeed = 2;
    }
    CGFloat x = octopusProxy.position.x + ((targetX - octopusProxy.position.x) * (dt * animSpeed));
    octopusProxy.position = ccp(x, octopus.position.y);
    octopusProxy.scale += (targetScale - octopusProxy.scale) * (dt * animSpeed);
    octopusProxy.opacity += (targetOpacity - octopusProxy.opacity) * (dt * animSpeed);
	
}

@end
