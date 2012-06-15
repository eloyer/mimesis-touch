//
//  Octopus.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Octopus.h"
#import "Sentiment.h"
#import "Actor.h"
#import "Emotion.h"
#import "EventAtom.h"
#import "NarrativeModel.h"
#import "SimpleAudioEngine.h"

@implementation Octopus

#pragma mark -
#pragma mark Instance methods

- (id) initWithModel:(Actor *)modelActor controller:(NarrativeController *)cntrllr; {
	
	if (self = [super initWithModel:modelActor controller:cntrllr]) {
        
		[[NarrativeModel sharedInstance] addObserver:self];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"octopus.plist"];
        
        octopusSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"octopus.png"];
        [self addChild:octopusSpriteSheet];
        
        int i;
        
        // build aggressive animation
        NSMutableArray *aggressiveFrames = [NSMutableArray array];
        for (i=30; i<=39; i++) {
            [aggressiveFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *aggressiveAnim = [CCAnimation animationWithFrames:aggressiveFrames delay:0.1f];
        
        // build confused animation
        NSMutableArray *confusedFrames = [NSMutableArray array];
        for (i=20; i<=29; i++) {
            [confusedFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *confusedAnim = [CCAnimation animationWithFrames:confusedFrames delay:0.1f];
        
        // build oblivious animation
        NSMutableArray *obliviousFrames = [NSMutableArray array];
        for (i=11; i<=19; i++) {
            [obliviousFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *obliviousAnim = [CCAnimation animationWithFrames:obliviousFrames delay:0.1f];
        
        // build suspicious animation
        NSMutableArray *suspiciousFrames = [NSMutableArray array];
        for (i=1; i<=10; i++) {
            [suspiciousFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"octopus-%d.png", i]]];
        }
        CCAnimation *suspiciousAnim = [CCAnimation animationWithFrames:suspiciousFrames delay:0.1f];
       
        [[CCAnimationCache sharedAnimationCache] addAnimation:aggressiveAnim name:@"aggressive"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:confusedAnim name:@"confused"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:obliviousAnim name:@"oblivious"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:suspiciousAnim name:@"suspicious"];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        octopus = [CCSprite spriteWithSpriteFrameName:@"octopus-1.png"];
 		octopus.position = ccp(winSize.width * .25, winSize.height * .5);
        
        octopusProxy = [CCSprite spriteWithSpriteFrameName:@"octopus-1.png"];
 		octopusProxy.position = ccp(winSize.width * .25, winSize.height * .5);
        octopusProxy.opacity = 100;
        
        sinValue = 0.0;
        
        [octopusSpriteSheet addChild:octopus];
        [octopusSpriteSheet addChild:octopusProxy];
        
        transparency = 0.0;
        transparencyVelocity = 0.0;
        maxTransparencyVelocity = 0.0;
        isTransparencyGestureActive = false;
        
        emotionLabel = [CCLabelTTF labelWithString:@"Oblivious" fontName:@"Helvetica-Bold" fontSize:36];
        emotionLabel.position = ccp(winSize.width * .25, octopus.position.y - 50);
        emotionLabel.color = ccRED;
        emotionLabel.opacity = 0;
        [self addChild:emotionLabel];
		
		[self scheduleUpdate];
        
        [self updatePose];
		
	}
	
	return self;
}

- (void) dealloc {
    [[NarrativeModel sharedInstance] removeObserver:self];
	[octopusSpriteSheet removeFromParentAndCleanup:TRUE];
    [octopus removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

- (void) startTransparencyGesture {
    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    transparency = sentiment.transparency;
}

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

- (void) poke {
    octopus.scale = 1.25;
}

/**
 * Returns true if the point is within the actor sprite.
 */
- (BOOL) containsPoint:(CGPoint)point {
    return CGRectContainsPoint(octopus.boundingBox, point);
}

/**
 * Updates the state of the octopus when necessary.
 * @param eventAtom The event atom being executed.
 */
- (void) executeEventAtom:(EventAtom *)eventAtom {
    
    Actor *originator;
    
    DLog(@"got event atom");
    
	if ([eventAtom.command isEqualToString:@"setTransparency"]) {
		originator = (Actor *)eventAtom.item;
        if (originator == actor) {
            Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
            DLog(@"updating actor transparency: %f", sentiment.transparency);
            [self updatePose];
        }
    }
    
}

- (void) showCurrentEmotion {
    
    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    Emotion *emotion;
    
    if (sentiment.transparency > 0.5) {
        emotion = [sentiment strongestInternalEmotion];
    } else {
        emotion = [sentiment strongestExternalEmotion];
    }
    
    if ([emotion.name isEqualToString:@"oblivious"]) {
        emotionLabel.color = ccc3(35, 108, 182);
    } else if ([emotion.name isEqualToString:@"confused"]) {
        emotionLabel.color = ccc3(101, 234, 0);
    } else if ([emotion.name isEqualToString:@"suspicious"]) {
        emotionLabel.color = ccc3(248, 221, 0);
    } else if ([emotion.name isEqualToString:@"aggressive"]) {
        emotionLabel.color = ccc3(236, 24, 5);
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@.mp3", emotion.name]];
    
    [emotionLabel setString:emotion.name];
    emotionLabel.opacity = 255;
    
}

/**
 * Updates the pose of the view to match the actor's internal state.
 */
- (void) updatePoseForSprite:(CCSprite *)sprite withTransparency:(CGFloat)t {

    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    Emotion *emotion = [sentiment strongestInternalEmotion];
    CGFloat emotionRatio = fminf(emotion.internalStrength, 5.0) / 5.0;
    CCAnimation *animation;
    NSString *animationName;
    int frame;
    
    if ([emotion.name isEqualToString:@"aggressive"]) {
        if (t > .5) {
            animationName = @"aggressive";
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
            frame = (emotionRatio * ((t - 0.5) * 2.0)) * ([animation.frames count] - 1);
        } else {
            animationName = @"suspicious";
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
            frame = (emotionRatio * ((0.5 - t) * 2.0)) * ([animation.frames count] - 1);
        }
    } else if ([emotion.name isEqualToString:@"confused"]) {
        if (t > .5) {
            animationName = @"confused";
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
            frame = (emotionRatio * ((t - 0.5) * 2.0)) * ([animation.frames count] - 1);
        } else {
            animationName = @"oblivious";
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
            frame = (emotionRatio * ((0.5 - t) * 2.0)) * ([animation.frames count] - 1);
        }
    }
   
    [sprite setDisplayFrameWithAnimationName:animationName index:frame];
  
}

- (void) updatePose {
    
    Sentiment *sentiment = [actor.sentiments objectForKey:@"discriminationExists"];
    [self updatePoseForSprite:octopus withTransparency:sentiment.transparency];
    
}

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
   
    transparencyVelocity *= .9;
    transparency = fminf(fmaxf(transparency + transparencyVelocity, 0), 1);
    
    [self updatePoseForSprite:octopusProxy withTransparency:transparency];
    
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
    octopusProxy.position = ccp(x, octopusProxy.position.y);
    octopusProxy.scale += (targetScale - octopusProxy.scale) * (dt * animSpeed);
    octopusProxy.opacity += (targetOpacity - octopusProxy.opacity) * (dt * animSpeed);
    
    sinValue += (dt * 3);
    octopus.position = ccp(octopus.position.x, (winSize.height * .5) + (10 * sin(sinValue)));
    octopus.scale += (1.0 - octopus.scale) * (dt * animSpeed);
    
    emotionLabel.opacity += (0 - emotionLabel.opacity) * (.5 * dt);
	
}

@end
