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
@class Shark;
@class Seahorse;

@interface WideShot : ShotView {

    CCSprite        *background;            // sprite for the background
    Octopus         *octopus;               // actor view for the octopus
    Anglerfish      *anglerfish;            // actor view for the anglerfish
    Shark           *shark;                 // actor view for the shark
    Seahorse        *seahorse;              // actor view for the seahorse
    CGFloat         initialPinchVelocity;   // velocity at start of pinch
    NSMutableArray  *gestureRecognizers;    // gesture recognizers for the view

}

- (UITapGestureRecognizer *)watchForTap:(SEL)selector taps:(int)tapsRequired touches:(int)touchesRequired;
- (UIPanGestureRecognizer *)watchForPan:(SEL)selector number:(int)tapsRequired;
- (UISwipeGestureRecognizer *)watchForSwipe:(SEL)selector direction:(UISwipeGestureRecognizerDirection)direction number:(int)touchesRequired;
- (UIPinchGestureRecognizer *)watchForPinch:(SEL)selector;
- (void)setupGestureRecognizers;
- (void)killGestureRecognizers;
- (void)unwatch:(UIGestureRecognizer *)gr;
- (void)tapping:(UITapGestureRecognizer *)recognizer;
- (void)panning:(UIPanGestureRecognizer *)recognizer;
- (void)swiping:(UISwipeGestureRecognizer *)recognizer;
- (void)pinching:(UIPinchGestureRecognizer *)recognizer;

@end
