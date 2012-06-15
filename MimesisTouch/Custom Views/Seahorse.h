//
//  Seahorse.h
//  MimesisTouch
//
//  Created by Erik Loyer on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActorView.h"

@interface Seahorse : ActorView {
    
    CCSprite			*sprite;				// anglerfish sprite
    CGSize              winSize;                            // size of the window
    CGFloat             sinValue;                           // value for sin wave bobbing
    
}

@end
