//
//  UDGameLayer.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/21/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "cocos2d.h"
#import "UDCharacter.h"
#import "iLabyrinth.h"


@interface UDGameLayer : CCLayer <CCStandardTouchDelegate, UDCharacterDelegate> {
	CGSize              _winSize;
	CCSpriteBatchNode	*_backgroundLayer;
	UDCharacter         *_char;
	CCSprite            *_exit;
	
	NSUInteger          _mapNo;
	NSMutableDictionary	*_mapTiles;
	NSUInteger          _map[100][100][4];
	NSUInteger          _possiblePaths;
	
	CCSprite            *_backSprite;
    
    NSUInteger          _crossRoads;
}

- (void)loadMapNo:(NSUInteger)mapNo;
- (void)addTileWithData:(NSArray *)data x:(NSUInteger)x y:(NSUInteger)y;
- (void)mapCompleated;
- (void)setPath:(CCSprite *)path fromSide:(NSUInteger)side atX:(NSUInteger)x y:(NSUInteger)y;

- (void)rotateChar;
- (void)rotateExit;

- (void)deviceOrientationDidChange;

@end
