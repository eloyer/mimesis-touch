//
//  PropertyChangeTracker.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// TODO: Add this to the main GeNIE repo and document

#import "PropertyChangeTracker.h"

@implementation PropertyChangeTracker

@synthesize delegate;

- (id) initWithDelegate:(NSObject *)del {
	
	if ((self = [super init])) {
		changedProperties = [[NSMutableArray alloc] init];
        self.delegate = del;
    }

    return self;
    
}

- (void) dealloc {
    [changedProperties release];
    self.delegate = nil;
    [super dealloc];
}

/**
 * Adds the specified property to the list of changed properties.
 * @param propertyName The name of the property that was changed.
 */
- (void) _addChangedProperty:(NSString *)propertyName {
	if (![changedProperties containsObject:propertyName]) {
		[changedProperties addObject:propertyName];
        //NSLog(@"add changed property: %@", propertyName);
	}
}

/**
 * Returns true if the specified property was changed recently, and
 * removes the property from the list of changed properties.
 * @param propertyName The name of the property that was changed.
 */
- (BOOL) _propertyWasChanged:(NSString *)propertyName {
	BOOL result = [changedProperties containsObject:propertyName];
    NSLog(@"check for changed property: %@", propertyName);
	if (result) {
		[changedProperties removeObject:propertyName];
	}
	return result;
}

@end
