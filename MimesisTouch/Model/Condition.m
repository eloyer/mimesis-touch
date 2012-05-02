//
//  Condition.h
//  GeNIE
//
//  Created by Erik Loyer on 10/25/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//

/// The Condition class defines and evaluates a single requirement to be met within
/// the narrative.

#import "Condition.h"
#import "NarrativeModel.h"
#import "TreeNode.h"
#import "Globals.h"


@implementation Condition

@synthesize itemRef;
@synthesize item;
@synthesize property;
@synthesize operatorName;
@synthesize stringValue;
@synthesize booleanValue;
@synthesize objectValue;
@synthesize valueType;

#pragma mark -
#pragma mark Instance methods

/**
 * Initializes a new Condition.
 * @param node A TreeNode representing the XML in the narrative script that defines the condition.
 * @return The new Condition.
 */
- (id) initWithNode:(TreeNode *)node {
	
	if ((self = [super init])) {
		self.itemRef = [node attributeForKey:@"itemRef"];
		self.property = [node attributeForKey:@"property"];
		self.operatorName = [node attributeForKey:@"operator"];
		self.stringValue = [node attributeForKey:@"value"];
	}
	
	return self;
}

- (void) dealloc {
	self.itemRef = nil;
	self.item = nil;
	self.property = nil;
	self.operatorName = nil;
    self.stringValue = nil;
    self.objectValue = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utility methods

/**
 * Retrieves the actual item from its identifier, and the actual value from the value 
 * string. Not included in the <code>initWithNode:</code> function because all items 
 * need to be created first before the referenced item can be retrieved.
 */
- (void) parseItemAndValue {
    
	NarrativeModel *model = [NarrativeModel sharedInstance];
	self.item = [model parseItemRef:itemRef];
    
    // booleans
    if ([property isEqualToString:@"isCompleted"] || 
        [operatorName isEqualToString:@"changed"] || 
        ([property isEqualToString:@"internalState"] && [operatorName isEqualToString:@"changed"]) || 
        ([property isEqualToString:@"externalState"] && [operatorName isEqualToString:@"changed"])
        ) {
        self.valueType = BooleanType;
        self.booleanValue = [stringValue boolValue];
        
    // objects
    } else if ([property isEqualToString:@"currentShot"]) {
        self.valueType = ObjectType;
        self.objectValue = [model parseItemRef:stringValue];
        
    // strings
    } else {
        self.valueType = StringType;
    }
    
}

/**
 * Returns true if the condition is currently satisfied.
 * @return The current value to which the condition evaluates.
 */
- (bool) hasBenMet {
	
	bool result;
	
    // equality / inequality
	if ([operatorName isEqualToString:@"=="] || [operatorName isEqualToString:@"!="]) {
        
        BOOL booleanPropertyValue;
        NSString *stringPropertyValue;
        id objectPropertyValue;
        
        switch (valueType) {
                
            case BooleanType:
                booleanPropertyValue = [[item valueForKey:property] boolValue];
                result = (booleanPropertyValue == booleanValue);
                break;
                
            case StringType:
                stringPropertyValue = [item valueForKey:property];
                result = [stringPropertyValue isEqualToString:stringValue];
                break;
                
            case ObjectType:
                objectPropertyValue = [item valueForKey:property];
                result = (objectPropertyValue == objectValue);
                break;
                
        }
        
        if ([operatorName isEqualToString:@"!="]) {
            result = !result;
        }
        
    // changed value
	} else if ([operatorName isEqualToString:@"changed"]) {
		result = [item propertyWasChanged:property];
	}
    
    if (result) DLog(@"%@ %@ %@ %@", itemRef, property, operatorName, stringValue);
	
	return result;
}

@end
