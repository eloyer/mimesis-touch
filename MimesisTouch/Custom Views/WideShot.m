//
//  WideShot.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WideShot.h"
#import "Actor.h"
#import "NarrativeModel.h"
#import "Setting.h"
#import "Octopus.h"
#import "Sentiment.h"
#import "Emotion.h"
#import "Event.h"
#import "EventGroup.h"
#import "Shot.h"
#import "NarrativeController.h"

@implementation WideShot

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
		
		//self.isTouchEnabled = TRUE;
        
        background = [[CCSprite spriteWithFile:@"ocean_background.png"] retain];
        [self addChild:background];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        background.position = ccp(winSize.width * .5, winSize.height * .5);	

        NarrativeModel *model = [NarrativeModel sharedInstance];

		// octopus actor view
		Actor *octopusActor = [model.currentSetting.actors objectForKey:@"octopus"];
        [octopusActor setCurrentTopic:[model.currentSetting.topics objectForKey:@"discriminationExists"]];
		if (octopusActor != nil) {
			octopus = [[Octopus alloc] initWithModel:octopusActor controller:controller];
			[self addChild:octopus];
		}		
        
		// anglerfish actor view
		Actor *anglerfishActor = [model.currentSetting.actors objectForKey:@"anglerfish"];
		if (anglerfishActor != nil) {
			anglerfish = [[Anglerfish alloc] initWithModel:anglerfishActor controller:controller];
			[self addChild:anglerfish];
		}		
        gestureRecognizers = [[NSMutableArray alloc] init];
        [gestureRecognizers addObject:[self watchForTap:@selector(tapping:) taps:1 touches:1]];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionDown number:2]];
        [gestureRecognizers addObject:[self watchForPinch:@selector(pinching:)]];
        
	}
	
	return self;
}

- (void) dealloc {
    for (UIGestureRecognizer* gr in gestureRecognizers) {
        [self unwatch:gr];
    }
    [gestureRecognizers release];
    [background removeAllChildrenWithCleanup:TRUE];
    [octopus release];
    [anglerfish release];
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

- (UIPanGestureRecognizer *)watchForPan:(SEL)selector number:(int)tapsRequired {
    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
    recognizer.minimumNumberOfTouches = tapsRequired;
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

- (UIPinchGestureRecognizer *)watchForPinch:(SEL)selector {
    UIPinchGestureRecognizer *recognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
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
            /*CGSize winSize = [[CCDirector sharedDirector] winSize];
            if (p.x < 20) {
                if ((p.y < 20) || (p.y > (winSize.height - 20))) {
                    [controller pauseNarrative];
                }
            } else if (p.x > (winSize.width - 20)) {
                if ((p.y < 20) || (p.y > (winSize.height - 20))) {
                    [controller pauseNarrative];
                }
            } else*/ if ([octopus containsPoint:p]) {
                NarrativeModel *model = [NarrativeModel sharedInstance];
                Event *event = [model parseItemRef:@"express"];
                [model.currentSetting.currentEventGroup setCurrentEvent:event];
                [octopus poke];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
    }
    
}

- (void)panning:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint p;
    CGPoint v;
    
    switch( recognizer.state ) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something when the pan begins)
            NSLog(@"pan began");
            break;
        case UIGestureRecognizerStateChanged:
            p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something while the pan is in progress)
            NSLog(@"pan in progress");
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"pan ended");
            break;
        case UIGestureRecognizerStateCancelled:
            //(do something when the pan ends)
            //(the below gets the velocity; good for letting player "fling" things)
            v = [recognizer velocityInView:[CCDirector sharedDirector].openGLView];
            NSLog(@"pan cancelled");
            break;
    }
    
}

- (void)swiping:(UISwipeGestureRecognizer *)recognizer {
    
    //CGPoint p;
    //CGPoint v;
    
    // NEED TO CREATE WAY TO INC/DEC MOOD EVEN IF NOT IN THE RIGHT VIEW
    
    switch( recognizer.state ) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something when the pan begins)
            NSLog(@"swipe began");
            break;
        case UIGestureRecognizerStateChanged:
            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something while the pan is in progress)
            NSLog(@"swipe in progress");
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"swipe ended");
            switch (recognizer.numberOfTouchesRequired) {
                    
                case 2:
                    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
                        Shot *adjacentShot = [shot adjacentShotForKey:@"enterThoughts"];
                         if (adjacentShot != nil) {
                            [controller setShot:adjacentShot];
                        }
                    }
                    break;
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            //(do something when the pan ends)
            //(the below gets the velocity; good for letting player "fling" things)
            //v = [recognizer velocityInView:[CCDirector sharedDirector].openGLView];
            NSLog(@"swipe cancelled");
            break;
    }
    
}

- (void)pinching:(UIPinchGestureRecognizer *)recognizer {
    
    switch( recognizer.state ) {
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            initialPinchVelocity = 0;
            [octopus startTransparencyGesture];
            break;
            
        case UIGestureRecognizerStateChanged:
            if (initialPinchVelocity == 0) {
                initialPinchVelocity = recognizer.velocity;
            }
            if ((recognizer.velocity > 0) || (initialPinchVelocity > 0)) {
                [octopus setTransparencyVelocity:recognizer.velocity * .005];
            } else {
                [octopus setTransparencyVelocity:recognizer.velocity * .02];
            }
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        case UIGestureRecognizerStateEnded:
            [octopus endTransparencyGesture];
            if (recognizer.scale > 1) {
                [octopus.actor modifyTransparency:0.1];
            } else {
                [octopus.actor modifyTransparency:-0.1];
            }
            [octopus updatePose];
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
    }
    
}

/**
 * Should be called once per frame if necessary for this view.
 * @param dt Elapsed time in seconds since the last frame.
 */
- (void) update:(ccTime)dt {
	
}

@end



