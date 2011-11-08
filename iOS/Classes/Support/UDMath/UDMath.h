//
//  UDMath.h
//
//  Created by Rolandas Razma on 11/14/09.
//  Copyright 2009 UD7. All rights reserved.
//

#import <Foundation/Foundation.h>


/** converts degree to radians */
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0f * (float)M_PI)


/** generates random number between min and max (including min and max) */
uint UDRand(uint min, uint max);


/** returns true with possibility */
BOOL UDTrueWithPossibility( float possibility );
