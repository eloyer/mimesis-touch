//
//  ThoughtSpaceShot.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtSpaceShot.h"
#import "NarrativeModel.h"
#import "Shot.h"
#import "Actor.h"
#import "OctopusInternal.h"
#import "Setting.h"

@implementation ThoughtSpaceShot

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
        
        background = [[CCSprite spriteWithFile:@"thought_background.png"] retain];
        [self addChild:background];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        background.position = ccp(winSize.width * .5, winSize.height * .5);	
        
        NarrativeModel *model = [NarrativeModel sharedInstance];
        
		// octopus actor view
		Actor *octopusActor = [model.currentSetting.actors objectForKey:@"octopus"];
		if (octopusActor != nil) {
			octopusInternal = [[OctopusInternal alloc] initWithModel:octopusActor controller:controller];
			octopusInternal.position = ccp(winSize.width * .5, winSize.height * .4);
            [self addChild:octopusInternal];
		}		
        
        /*
		// anglerfish actor view
		Actor *anglerfishActor = [model.currentSetting.actors objectForKey:@"anglerfish"];
		if (anglerfishActor != nil) {
			anglerfish = [[Anglerfish alloc] initWithModel:anglerfishActor controller:controller];
			[self addChild:anglerfish];
		}	
         */
        
        gestureRecognizers = [[NSMutableArray alloc] init];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionUp number:1]];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionDown number:1]];
        [gestureRecognizers addObject:[self watchForSwipe:@selector(swiping:) direction:UISwipeGestureRecognizerDirectionUp number:2]];
        
	}
	
	return self;
}

- (void) dealloc {
    for (UIGestureRecognizer* gr in gestureRecognizers) {
        [self unwatch:gr];
    }
    [gestureRecognizers release];
    [background removeFromParentAndCleanup:TRUE];
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

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
                    
                case 1:
                    switch (recognizer.direction) {
                            
                        case UISwipeGestureRecognizerDirectionDown:              
                            [octopusInternal.actor modifyEmotion:@"suspicious" forSentiment:@"discriminationExists" amount:1 internal:false];
                            [octopusInternal.actor modifyEmotion:@"aggressive" forSentiment:@"discriminationExists" amount:1 internal:true];
                            break;
                            
                        case UISwipeGestureRecognizerDirectionUp:
                            [octopusInternal.actor modifyEmotion:@"oblivious" forSentiment:@"discriminationExists" amount:1 internal:false];
                            [octopusInternal.actor modifyEmotion:@"confused" forSentiment:@"discriminationExists" amount:1 internal:true];
                            break;
                            
                    }
                    [octopusInternal updatePose];
                    break;
                    
                case 2:
                    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
                        Shot *adjacentShot = [shot adjacentShotForKey:@"exitThoughts"];
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

@end
