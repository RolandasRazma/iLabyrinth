//
//  UDMath.m
//
//  Created by Rolandas Razma on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UDMath.h"


uint UDRand(uint min, uint max) {
	return min +arc4random() %(max -min +1);
}


BOOL UDTrueWithPossibility( float possibility ){
	if( possibility < 0 ) return false;
	return ((random() / (float)0x7fffffff ) <= possibility);
}
