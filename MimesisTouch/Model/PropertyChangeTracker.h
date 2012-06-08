//
//  PropertyChangeTracker.h
//  MimesisTouch
//
//  Created by Erik Loyer on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// TODO: Add this to the main GeNIE repo and document

#import <UIKit/UIKit.h>

@protocol PropertyChangeTrackerDelegate <NSObject>

@required
- (void) addChangedProperty:(NSString *)propertyName;
- (BOOL) propertyWasChanged:(NSString *)propertyName;

@end

@interface PropertyChangeTracker : NSObject {
    NSObject <PropertyChangeTrackerDelegate> *delegate;
	NSMutableArray			*changedProperties;				///< Array of recently changed properties.
}

@property (nonatomic, assign) id delegate;

- (id) initWithDelegate:(NSObject *)del;
- (void) _addChangedProperty:(NSString *)propertyName;
- (BOOL) _propertyWasChanged:(NSString *)propertyName;

@end
