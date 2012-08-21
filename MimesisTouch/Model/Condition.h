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

#import <Foundation/Foundation.h>

// The ValueType enum defines what kind of value this condition is testing.
typedef enum {
	BooleanType,
	StringType,
    ObjectType,
    FloatType
} ValueType;

@class TreeNode;

@interface Condition : NSObject {
	
	NSString				*itemRef;				///< Identifier of the item referenced in the condition.
	id						item;					///< The item whose property is to be tested.
	NSString				*property;				///< Name of the property being tested.
    NSString                *lastComponent;         ///< The final component of the property specification.
	NSString				*operatorName;			///< The operator to be applied.
	NSString				*stringValue;			///< String describing the value being compared.
	BOOL                    booleanValue;           ///< Boolean value to be compared.
    id                      objectValue;            ///< Object to be compared.
    CGFloat                 floatValue;             ///< Float value to be compared.
    ValueType               valueType;              ///< The value's type.

}

@property (nonatomic, retain) NSString *itemRef;
@property (nonatomic, retain) id item;
@property (nonatomic, retain) NSString *property;
@property (nonatomic, retain) NSString *operatorName;
@property (nonatomic, retain) NSString *stringValue;
@property (readwrite) BOOL booleanValue;
@property (nonatomic, retain) id objectValue;
@property (readwrite) float floatValue;
@property (readwrite) ValueType valueType;

- (id) initWithNode:(TreeNode *)node;
- (void) parseItemAndValue;
- (void) evaluateProperty;
- (bool) hasBenMet;

@end
