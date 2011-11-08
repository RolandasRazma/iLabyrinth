//
//  UDIsoMath.h
//  UDGame
//
//  Created by Rolandas Razma on 1/27/11.
//  Copyright 2011 UD7. All rights reserved.
//

#define ISO_TILE_HEIGHT 80
#define ISO_TILE_WIDTH ISO_TILE_HEIGHT *2
#define UDIsoPointMake CGPointMake

typedef struct CGPoint UDIsoPoint;

UDIsoPoint UDIsoPointFromCGPoint( CGPoint possition );
UDIsoPoint UDIsoPointFromCGPointWithTileHeight( CGPoint possition, CGFloat tileHeight );

CGPoint CGPointFromUDIsoPoint( UDIsoPoint possition );
CGPoint CGPointFromUDIsoPointWithTileHeight( UDIsoPoint possition, CGFloat tileHeight );

NSString *NSStringFromUDIsoPoint(UDIsoPoint possition);
