//
//  PlayerConfigShot.h
//  MimesisTouch
//
//  Created by Erik Loyer on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShotView.h"
#import "cocos2d.h"

@interface PlayerConfigShot : ShotView {
    
    CCLabelTTF      *continueBtn;           // button which starts the narrative
    NSMutableArray  *gestureRecognizers;    // gesture recognizers for the view
    
}

- (UITapGestureRecognizer *)watchForTap:(SEL)selector taps:(int)tapsRequired touches:(int)touchesRequired;
- (UISwipeGestureRecognizer *)watchForSwipe:(SEL)selector direction:(UISwipeGestureRecognizerDirection)direction number:(int)touchesRequired;
- (void)unwatch:(UIGestureRecognizer *)gr;
- (void)tapping:(UITapGestureRecognizer *)recognizer;
- (void)swiping:(UISwipeGestureRecognizer *)recognizer;

@end
