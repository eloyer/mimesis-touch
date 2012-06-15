//
//  PropertyChangeTracker.m
//  MimesisTouch
//
//  Created by Erik Loyer on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// TODO: Add this to the main GeNIE repo and document

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
 * Returns true if the specified property was changed recently, and
 * removes the property from the list of changed properties.
 * @param propertyName The name of the property that was changed.
 */
- (BOOL) _propertyWasChanged:(NSString *)propertyName {
	BOOL result = [changedProperties containsObject:propertyName];
    //NSLog(@"check for changed property: %@", propertyName);
	/*if (result) {
		[changedProperties removeObject:propertyName];
	}*/
	return result;
}

// TODO: Add changes to main repo

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
