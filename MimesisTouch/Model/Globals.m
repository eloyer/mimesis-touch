//
//  Globals.h
//  GeNIE
//
//  Created by Erik Loyer on 11/29/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//  

///
/// Global variables and functions.
///

/**
 * Converts degrees to radians.
 * @param degrees The degree value to be converted.
 * @return The converted value.
 */
CGFloat DegreesToRadians(CGFloat degrees) { 
	return degrees * M_PI / 180;
};

/**
 * Converts radians to degrees.
 * @param degrees The radian value to be converted.
 * @return The converted value.
 */
CGFloat RadiansToDegrees(CGFloat radians) {
	return radians * 180 / M_PI;
};

/**
 * Calculates the distance between two points.
 * @param point1 The first point.
 * @param point2 The second point.
 * @return The distance between the two points.
 */
CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2) {
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy );
};

/**
 * Creates a CGColorRef from the specified rgba values.
 * @param r The red value (0.0 - 1.0).
 * @param g The green value (0.0 - 1.0).
 * @param b The blue value (0.0 - 1.0).
 * @param a The alpha value (0.0 - 1.0).
 * @return The CGColorRef derived from the specified values.
 */
CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = {r, g, b, a};
    CGColorRef color = CGColorCreate(rgb, comps);
    CGColorSpaceRelease(rgb);
    return color;
};

/**
 * Converts hsv color components to rgb color components.
 * @param *r Pointer to the variable that will hold the converted red value.
 * @param *g Pointer to the variable that will hold the converted green value.
 * @param *b Pointer to the variable that will hold the converted blue value.
 * @param h The hue value (0.0 - 1.0).
 * @param h The saturation value (0.0 - 1.0).
 * @param h The brightness value (0.0 - 1.0).
 */
void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v )
{
	//NSLog(@"Hue %f",h);
	int i;
	float f, p, q, t;
	if( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	h /= 60;			// sector 0 to 5
	i = floor( h );
	f = h - i;			// factorial part of h
	p = v * ( 1 - s );
	q = v * ( 1 - s * f );
	t = v * ( 1 - s * ( 1 - f ) );
	switch( i ) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2:
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:		// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}