//
//  ThoughtSpaceShot.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShotView.h"

@class OctopusInternal;

@interface ThoughtSpaceShot : ShotView {
    
    CCSprite        *background;            // sprite for the background
    NSMutableArray  *gestureRecognizers;    // gesture recognizers for the view
    OctopusInternal *octopusInternal;       // thought space view of octopus
   
}

- (UISwipeGestureRecognizer *)watchForSwipe:(SEL)selector direction:(UISwipeGestureRecognizerDirection)direction number:(int)touchesRequired;
- (void)unwatch:(UIGestureRecognizer *)gr;
- (void)swiping:(UISwipeGestureRecognizer *)recognizer;
- (void) suspectDiscrimination;
- (void) unsuspectDiscrimination;
- (void) exitThoughts;

@end
