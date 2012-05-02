//
//  PropView.h
//  GeNIE
//
//  Created by Erik Loyer on 10/15/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///	The PropView class is responsible for rendering a given prop. Extend this abstract 
///	class to create individual prop classes with custom behavior.

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class NarrativeController;
@class Prop;

@interface PropView : CCNode {
	
	NarrativeController		*controller;			///< Instance of the narrative controller.
	Prop					*prop;					///< Prop model which the prop view is rendering.

}

@property (nonatomic, retain) Prop *prop;

- (id) initWithModel:(Prop *)modelProp controller:(NarrativeController *)cntrllr;
- (void) update:(ccTime)dt;

@end
