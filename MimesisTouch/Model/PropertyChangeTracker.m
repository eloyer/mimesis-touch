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

#import "PropertyChangeTracker.h"
#import "EventAtom.h"

@implementation PropertyChangeTracker

@synthesize delegate;

- (id) initWithDelegate:(NSObject *)del {
	
	if ((self = [super init])) {
		changedProperties = [[NSMutableArray alloc] init];
        propertyAges = [[NSMutableArray alloc] init];
        self.delegate = del;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventAtomEnd:) name:@"EventAtomEnd" object:nil];
    }

    return self;
    
}

- (void) dealloc {
    [changedProperties release];
    [propertyAges release];
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
        [propertyAges addObject:[NSNumber numberWithInt:0]];
        //NSLog(@"add changed property: %@", propertyName);
	}
}

/**
 * Returns true if the specified property was changed recently.
 * @param propertyName The name of the property that was changed.
 */
- (BOOL) _propertyWasChanged:(NSString *)propertyName {
	BOOL result = [changedProperties containsObject:propertyName];
    //NSLog(@"check for changed property: %@", propertyName);
	return result;
}

/**
 * When an event atom ends, increments the ages of all property change records.
 * If a change is older than 1 turn, it is removed from the list of changed properties.
 * @param eventAtom The event atom that just finished playing.
 */
- (void) handleEventAtomEnd:(EventAtom *)eventAtom {
    int i;
    int n = [changedProperties count];
    int age;
    for (i=n-1; i>=0; i--) {
        age = [[propertyAges objectAtIndex:i] intValue];
        age++;
        if (age > 1) {
            [changedProperties removeObjectAtIndex:i];
            [propertyAges removeObjectAtIndex:i];
        } else {
            [propertyAges replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:age]];
        }
    }
}

@end
