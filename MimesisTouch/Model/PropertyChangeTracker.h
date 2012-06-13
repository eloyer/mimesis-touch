//
//  PropertyChangeTracker.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// TODO: Add this to the main GeNIE repo and document

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
