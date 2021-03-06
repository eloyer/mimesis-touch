//
//  Anglerfish.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActorView.h"

@interface Anglerfish : ActorView {
    
	CCSprite			*sprite;				// anglerfish sprite
    CGSize              winSize;                // size of the window
    CGFloat             sinValue;               // value for sin wave bobbing
    BOOL                onStage;                // contains true if the view is currently visible
    
}

@end
