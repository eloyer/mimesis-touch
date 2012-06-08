//
//  OctopusInternal.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActorView.h"
#import "cocos2d.h"

@interface OctopusInternal : ActorView {
    
    CCSprite                *head;                      // the octopus' head
    CCSpriteBatchNode       *eyeSpriteSheet;            // batch node for the octopus' eye
    CCSprite                *eye;                       // the octopus' eye
  
}

@end
