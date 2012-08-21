//
//  PropertyChangeTracker.h
//  GeNIE
//
//  Created by Erik Loyer on 5/17/12.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

// The PropertyChangeTracker is a protocol which enables a class to manage a history
// of changes to its properties.

#import <UIKit/UIKit.h>
#import "EventAtom.h"

@protocol PropertyChangeTrackerDelegate <NSObject>

@required
- (void) addChangedProperty:(NSString *)propertyName;
- (BOOL) propertyWasChanged:(NSString *)propertyName;
- (void) handleEventAtomEnd:(EventAtom *)eventAtom;

@end

@interface PropertyChangeTracker : NSObject {
    NSObject <PropertyChangeTrackerDelegate> *delegate;
	NSMutableArray			*changedProperties;				///< Array of recently changed properties.
    NSMutableArray          *propertyAges;                  ///< Number of turns ago that the property changed.
}

@property (nonatomic, assign) id delegate;

- (id) initWithDelegate:(NSObject *)del;
- (void) _addChangedProperty:(NSString *)propertyName;
- (BOOL) _propertyWasChanged:(NSString *)propertyName;
- (void) _handleEventAtomEnd:(EventAtom *)eventAtom;
@end
