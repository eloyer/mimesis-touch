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
        
        //[self watchForPan:@selector(panning:) number:1];
        [self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionUp number:1];
        [self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionDown number:1];
        [self watchForPinch:@selector(pinching:)];
        
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

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
            switch (recognizer.direction) {
                    
                case UISwipeGestureRecognizerDirectionUp:
                    [octopus.actor modifyTransparency:0.1];
                    break;
                    
                case UISwipeGestureRecognizerDirectionDown:
                    [octopus.actor modifyTransparency:-0.1];
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
    
    //CGPoint p;
    //CGPoint v;
    
    switch( recognizer.state ) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something when the pan begins)
            NSLog(@"pinch began");
            break;
        case UIGestureRecognizerStateChanged:
            //p = [recognizer locationInView:[CCDirector sharedDirector].openGLView];
            //(do something while the pan is in progress)
            NSLog(@"pinch in progress");
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"pinch ended");
            if (recognizer.scale > 1) {
                [octopus.actor setMood:@"aggressive"];                
            } else {
                [octopus.actor setMood:@"oblivious"];                
            }
            break;
        case UIGestureRecognizerStateCancelled:
            //(do something when the pan ends)
            //(the below gets the velocity; good for letting player "fling" things)
            //v = [recognizer velocityInView:[CCDirector sharedDirector].openGLView];
            NSLog(@"pinch cancelled");
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



