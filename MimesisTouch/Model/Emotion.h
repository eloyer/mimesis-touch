//
//  Emotion.h
//  GeNIE
//
//  Created by Erik Loyer on 9/13/11.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

///  The Emotion class defines an atom of sentiment: one component of how a 
///  character feels about a topic.

#import <Foundation/Foundation.h>
#import "PropertyChangeTracker.h"

// TODO add changes to main GeNIE repo.

@class TreeNode;
@class Event;

@interface Emotion : NSObject <PropertyChangeTrackerDelegate> {
    
    NSString                *name;                              // Name of the emotion
    NSString                *description;                       // Description of the emotion
    CGFloat                 internalStrength;                   // Internal strength of the emotion
    CGFloat                 externalStrength;                   // External strength of the emotion
    NSMutableArray          *demonstrations;                    // Expressions of the emotion
    PropertyChangeTracker   *propTracker;                   ///< Class which tracks changes to properties.
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (readwrite) CGFloat internalStrength;
@property (readwrite) CGFloat externalStrength;

- (id) initWithNode:(TreeNode *)node;
- (void) modifyStrength:(CGFloat)amount internal:(BOOL)internal;
- (Event *) getEvent:(BOOL)isInternal;

@end
