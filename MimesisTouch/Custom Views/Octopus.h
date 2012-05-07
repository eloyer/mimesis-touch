//
//  Octopus.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActorView.h"
#import "cocos2d.h"

@interface Octopus : ActorView {

    CCSpriteBatchNode   *octopusSpriteSheet;                // batch node for the octopus sprite sheet
    CCSprite            *octopus;                           // octopus sprite
    CCSprite            *octopusProxy;                      // octopus proxy sprite
    CGFloat             transparencyVelocity;               // velocity of transparency change
    CGFloat             transparency;                       // current prospective transparency
    CGFloat             maxTransparencyVelocity;            // maximum velocity of transparency during the current gesture
    bool                isTransparencyGestureActive;        // contains true if a transparency gesture is currently being executed
   
}

- (void) setTransparencyVelocity:(CGFloat)velocity;
- (void) endTransparencyGesture;

@end
