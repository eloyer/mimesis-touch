//
//  WideShot.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShotView.h"
#import "cocos2d.h"

@class Octopus;
@class Anglerfish;

@interface WideShot : ShotView {

    CCSprite        *background;            // sprite for the background
    Octopus         *octopus;               // actor view for the octopus
    Anglerfish      *anglerfish;            // actor view for the anglerfish
    CGFloat         initialPinchVelocity;   // velocity at start of pinch

}

- (UIPanGestureRecognizer *)watchForPan:(SEL)selector number:(int)tapsRequired;
- (UISwipeGestureRecognizer *)watchForSwipe:(SEL)selector direction:(UISwipeGestureRecognizerDirection)direction number:(int)touchesRequired;
- (UIPinchGestureRecognizer *)watchForPinch:(SEL)selector;
- (void)unwatch:(UIGestureRecognizer *)gr;
- (void)panning:(UIPanGestureRecognizer *)recognizer;
- (void)swiping:(UISwipeGestureRecognizer *)recognizer;
- (void)pinching:(UIPinchGestureRecognizer *)recognizer;

@end
