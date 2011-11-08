//
//  UDIsoMath.m
//  UDGame
//
//  Created by Rolandas Razma on 1/27/11.
//  Copyright 2011 UD7. All rights reserved.
//


#import "UDIsoMath.h"


UDIsoPoint UDIsoPointFromCGPoint( CGPoint possition ) {
    return UDIsoPointFromCGPointWithTileHeight( possition, ISO_TILE_HEIGHT );
}

UDIsoPoint UDIsoPointFromCGPointWithTileHeight( CGPoint possition, CGFloat tileHeight ){
    return UDIsoPointMake(floorf( possition.x /(tileHeight *2) -possition.y /tileHeight), floorf(-possition.x /(tileHeight *2) -possition.y /tileHeight));
}


CGPoint CGPointFromUDIsoPoint( UDIsoPoint possition ) {
    return CGPointFromUDIsoPointWithTileHeight( possition, ISO_TILE_HEIGHT );
}

CGPoint CGPointFromUDIsoPointWithTileHeight( UDIsoPoint possition, CGFloat tileHeight ) {
    return CGPointMake( tileHeight *(possition.x -possition.y -1), tileHeight /2 *(-possition.x -possition.y -2));
}


NSString *NSStringFromUDIsoPoint(UDIsoPoint possition) {
    return [NSString stringWithFormat:@"{%.f,%.f}", possition.x, possition.y];
}
