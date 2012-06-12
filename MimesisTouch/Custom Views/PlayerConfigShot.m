//
//  PlayerConfigShot.m
//  MimesisTouch
//
//  Created by Erik Loyer on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerConfigShot.h"
#import "Shot.h"

@implementation PlayerConfigShot

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new ShotView.
 * @param modelShot The shot model which this view is rendering.
 * @param cntrllr Instance of the narrative controller.
 * @return The new ShotView.
 */
- (id) initWithModel:(Shot *)modelShot controller:(NarrativeController *)cntrllr; {
	
	if ((self = [super initWithModel:modelShot controller:cntrllr])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // octopus icon
		CCSprite *sprite = [[CCSprite spriteWithFile:@"octopus_icon.png"] retain];
		sprite.position = ccp(winSize.width * .5, winSize.height * .5);
		[self addChild:sprite];
        
        // continue button
        continueBtn = [CCLabelTTF labelWithString:@"Continue" fontName:@"Helvetica-Bold" fontSize:24];
        continueBtn.position = ccp(winSize.width * .5, 100);
        [self addChild:continueBtn];

        // set up gesture recognition
        gestureRecognizers = [[NSMutableArray alloc] init];
        [gestureRecognizers addObject:[self watchForTap:@selector(tapping:) taps:1 touches:1]];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionLeft number:1]];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionRight number:1]];
        
	}
	
	return self;
}

- (void) dealloc {
    for (UIGestureRecognizer* gr in gestureRecognizers) {
        [self unwatch:gr];
    }
    [gestureRecognizers release];
    [continueBtn removeAllChildrenWithCleanup:TRUE];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

- (UITapGestureRecognizer *)watchForTap:(SEL)selector taps:(int)tapsRequired touches:(int)touchesRequired {
    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
    recognizer.numberOfTapsRequired = tapsRequired;
    recognizer.numberOfTouchesRequired = touchesRequired;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:recognizer];
    return recognizer;
}

- (UISwipeGestureRecognizer *)watchForSwipe:(SEL)selector direction:(UISwipeGestureRecognizerDirection)direction number:(int)touchesRequired {
    UISwipeGestureRecognizer *recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
    recognizer.direction = direction;
    recognizer.numberOfTouchesRequired = touchesRequired;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:recognizer];
    return recognizer;
}

- (void)unwatch:(UIGestureRecognizer *)gr {
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:gr];
}

- (void)tapping:(UITapGestureRecognizer *)recognizer {
    
    CGPoint p;
    
    switch( recognizer.state ) {
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        case UIGestureRecognizerStateEnded:
            p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            p = [[CCDirector sharedDirector] convertToGL: p];
            if (CGRectContainsPoint(continueBtn.boundingBox, p)) {
                Shot *adjacentShot = [shot adjacentShotForKey:@"startNarrative"];
                if (adjacentShot != nil) {
                    [controller setShot:adjacentShot];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
    }
    
}

- (void)swiping:(UISwipeGestureRecognizer *)recognizer {
    
    switch( recognizer.state ) {
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            NSLog(@"swipe began");
            break;
            
        case UIGestureRecognizerStateChanged:
            NSLog(@"swipe in progress");
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        case UIGestureRecognizerStateEnded:
            NSLog(@"swipe ended");
            break;
            
        case UIGestureRecognizerStateCancelled:
            NSLog(@"swipe cancelled");
            break;
            
    }
    
}

@end
