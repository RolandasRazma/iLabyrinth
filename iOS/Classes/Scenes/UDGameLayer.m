//
//  UDGameLayer.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/21/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDGameLayer.h"
#import "UDPickMapScene.h"
#import "UDGameEndScene.h"
#import "SimpleAudioEngine.h"


@implementation UDGameLayer


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		[self setIsTouchEnabled: YES];

		_winSize		= [[CCDirector sharedDirector] winSize];
		_mapTiles		= [[NSMutableDictionary alloc] initWithCapacity:150];
		
		_backgroundLayer = [CCSpriteBatchNode batchNodeWithFile:[iLabyrinth textureName]];
		[[_backgroundLayer texture] setAliasTexParameters];
		[self addChild:_backgroundLayer];
		 
		_backSprite = [CCSprite spriteWithSpriteFrameName:@"back.png"];
		[_backgroundLayer addChild:_backSprite z:10];
	}
	return self;
}


- (void)dealloc {
	[_mapTiles release];
	[super dealloc];
}


#pragma mark -
#pragma mark UDGameLayer


- (void)loadMapNo:(NSUInteger)mapNo {
	// Reset
	[_mapTiles removeAllObjects];
	
	for( NSUInteger y=0; y<100; y++ ){
		for( NSUInteger x=0; x<100; x++ ){
			for( NSUInteger s=0; s<4; s++ ){
				_map[x][y][s] = WalkPathNoPath;
			}
		}
	}
	
	// Load
	_mapNo = mapNo;

    // Add background
	CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"sand.png"];
	[sprite setAnchorPoint:CGPointMake(0, 0)];
	[sprite setPosition:CGPointMake(0, 0)];
	[_backgroundLayer addChild:sprite];
	
    // Add character
	_char = [UDCharacter spriteWithSpriteFrameName:@"CH1.png"];
	[_char setDelegate:self];
	[_backgroundLayer addChild:_char z:10];
		
	// Add tiles
	NSString *path = [CCFileUtils fullPathFromRelativePath:[NSString stringWithFormat:@"map%02d%@.plist", mapNo, (isDeviceIPad()?@"~ipad":@"")]];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	
	uint width;
	uint height = [dict count];
	for( uint tr=0; tr<height; tr++ ){
		NSDictionary *trData = [dict objectForKey:[NSString stringWithFormat:@"tr%u", tr]];
		
		width = [trData count];
		for( uint td=0; td<width; td++ ){
			[self addTileWithData: [[trData objectForKey:[NSString stringWithFormat:@"td%u", td]] componentsSeparatedByString:@"|"] 
								x: td
								y: tr];
		}
	}

    // Update oriantations for "Special" tiles
	[self rotateChar];
	[self rotateExit];
}


- (void)rotateChar {
	
	// Rotate char
	for( NSUInteger y=0; y<100; y++ ){
		for( NSUInteger x=0; x<100; x++ ){
			if( _map[x][y][0] == WalkPathEntrance ){
				
				//check where char can go
				if( y != 0 && _map[x][y-1][SideTop] && !(_map[x][y-1][SideTop] & WalkPathNoPath) ){
					[_char rotateToSide:SideBottom];
					return;
				}else if( _map[x][y+1][SideBottom] && !(_map[x][y+1][SideBottom] & WalkPathNoPath) ){
					[_char rotateToSide:SideTop];
					return;
				}
				else if( x != 0 && _map[x-1][y][SideRight] && !(_map[x-1][y][SideRight] & WalkPathNoPath) ){
					[_char rotateToSide:SideLeft];
					return;
				}else if( _map[x+1][y][SideLeft] && !(_map[x+1][y][SideLeft] & WalkPathNoPath) ){
					[_char rotateToSide:SideRight];
					return;
				}
				
				
			}
		}
	}
	
}


- (void)rotateExit {
	
	// Rotate exit
	for( NSUInteger y=0; y<100; y++ ){
		for( NSUInteger x=0; x<100; x++ ){
			if( _map[x][y][0] == WalkPathExit ){

				//check where char can go
				if( y != 0 && _map[x][y-1][SideTop] && !(_map[x][y-1][SideTop] & WalkPathNoPath) ){
					[_exit setRotation: SideTop *90];
				}else if( _map[x][y+1][SideBottom] && !(_map[x][y+1][SideBottom] & WalkPathNoPath) ){
					[_exit setRotation: SideBottom *90];
				}
				else if( x != 0 && _map[x-1][y][SideRight] && !(_map[x-1][y][SideRight] & WalkPathNoPath) ){
					[_exit setRotation: SideRight *90];
				}else if( _map[x+1][y][SideLeft] == 0 || !(_map[x+1][y][SideLeft] & WalkPathNoPath) ){
					[_exit setRotation: SideLeft *90];
				}else if( y == 0 ){
                    [_exit setRotation: SideBottom *90];
                }
                
				return;
			}
		}
	}
	
}


- (void)addTileWithData:(NSArray *)data x:(NSUInteger)x y:(NSUInteger)y {
	
	NSUInteger side0 = [[data objectAtIndex:0] intValue];
	NSUInteger side1 = [[data objectAtIndex:1] intValue];
	NSUInteger side2 = [[data objectAtIndex:2] intValue];
	NSUInteger side3 = [[data objectAtIndex:3] intValue];
	
    
    // Remove helpers (white lines in map editor)
    if( side0 & ZeroPathToTop )     side0 ^= ZeroPathToTop;
    if( side0 & ZeroPathToRight )   side0 ^= ZeroPathToRight;
    if( side0 & ZeroPathToBottom )  side0 ^= ZeroPathToBottom;
    if( side0 & ZeroPathToLeft )    side0 ^= ZeroPathToLeft;

    if( side1 & ZeroPathToTop )     side1 ^= ZeroPathToTop;
    if( side1 & ZeroPathToRight )   side1 ^= ZeroPathToRight;
    if( side1 & ZeroPathToBottom )  side1 ^= ZeroPathToBottom;
    if( side1 & ZeroPathToLeft )    side1 ^= ZeroPathToLeft;
    
    if( side2 & ZeroPathToTop )     side2 ^= ZeroPathToTop;
    if( side2 & ZeroPathToRight )   side2 ^= ZeroPathToRight;
    if( side2 & ZeroPathToBottom )  side2 ^= ZeroPathToBottom;
    if( side2 & ZeroPathToLeft )    side2 ^= ZeroPathToLeft;
    
    if( side3 & ZeroPathToTop )     side3 ^= ZeroPathToTop;
    if( side3 & ZeroPathToRight )   side3 ^= ZeroPathToRight;
    if( side3 & ZeroPathToBottom )  side3 ^= ZeroPathToBottom;
    if( side3 & ZeroPathToLeft )    side3 ^= ZeroPathToLeft;
    
    // Possition of tile in points
	CGPoint tilePos = CGPointMake(x *TILE_SIZE() +TILE_SIZE() /2, y *TILE_SIZE() +TILE_SIZE() /2);
    
	if( side0 == WalkPathEntrance ){
		
		[_char setPosition:tilePos];
		
		_map[x][y][0] = WalkPathEntrance;
		_map[x][y][1] = WalkPathEntrance;
		_map[x][y][2] = WalkPathEntrance;
		_map[x][y][3] = WalkPathEntrance;
		
		return;
	}else if( side0 == WalkPathExit ){
		_exit = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
		[_exit setColor:ccBLACK];
		[_exit setPosition:tilePos];
		[_backgroundLayer addChild:_exit];
		
		_map[x][y][0] = WalkPathExit;
		_map[x][y][1] = WalkPathExit;
		_map[x][y][2] = WalkPathExit;
		_map[x][y][3] = WalkPathExit;
		
		return;
	}else if( [[data objectAtIndex:0] characterAtIndex:0] == 'S' ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", [data objectAtIndex:0]]];
		[sprite setPosition:tilePos];
		[_backgroundLayer addChild:sprite];
		
        // Animated texture
		if( [[data objectAtIndex:0] isEqualToString:@"S21"] ){
			CCSprite *upperSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", [data objectAtIndex:0]]];
			[upperSprite setPosition:tilePos];
			[_backgroundLayer addChild:upperSprite];
			
			NSMutableArray *animFrames = [NSMutableArray array];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_2.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_3.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_4.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_5.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_6.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_7.png"]];
			[animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"S21_8.png"]];
            
			[upperSprite runAction:[CCRepeatForever actionWithAction: 
                                    [CCAnimate actionWithAnimation: 
                                     [CCAnimation animationWithFrames:animFrames delay:0.5f]]]];
		}
		
		_map[x][y][0] = WalkPathNoPath;
		_map[x][y][1] = WalkPathNoPath;
		_map[x][y][2] = WalkPathNoPath;
		_map[x][y][3] = WalkPathNoPath;
		
		return;
	}else if( side0 == WalkPathWalk && side1 == WalkPathWalk && side2 == WalkPathWalk && side3 == WalkPathWalk ){
		_map[x][y][0] = WalkPathWalk;
		_map[x][y][1] = WalkPathWalk;
		_map[x][y][2] = WalkPathWalk;
		_map[x][y][3] = WalkPathWalk;
        
		return;
	}
	
	//construct map
	_map[x][y][0] = side0;
	_map[x][y][1] = side1;
	_map[x][y][2] = side2;
	_map[x][y][3] = side3;
	
	//0 Side
	if( side0 & WalkPathToRight ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"A%u.png", WalkPathToRight]];
		[self setPath:sprite fromSide:0 atX:x y:y];
	}
	if( side0 & WalkPathToBottom ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"A%u.png", WalkPathToBottom]];
		[self setPath:sprite fromSide:0 atX:x y:y];
	}
	if( side0 & WalkPathToLeft ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"A%u.png", WalkPathToLeft]];
		[self setPath:sprite fromSide:0 atX:x y:y];
	}
	
	//1 Side
	if( side1 & WalkPathToTop ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"B%u.png", WalkPathToTop]];
		[self setPath:sprite fromSide:1 atX:x y:y];
	}
	if( side1 & WalkPathToBottom ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"B%u.png", WalkPathToBottom]];
		[self setPath:sprite fromSide:1 atX:x y:y];
	}
	if( side1 & WalkPathToLeft ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"B%u.png", WalkPathToLeft]];
		[self setPath:sprite fromSide:1 atX:x y:y];
	}
	
	//2 Side
	if( side2 & WalkPathToTop ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"C%u.png", WalkPathToTop]];
		[self setPath:sprite fromSide:2 atX:x y:y];
	}
	if( side2 & WalkPathToRight ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"C%u.png", WalkPathToRight]];
		[self setPath:sprite fromSide:2 atX:x y:y];
	}
	if( side2 & WalkPathToLeft ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"C%u.png", WalkPathToLeft]];
		[self setPath:sprite fromSide:2 atX:x y:y];
	}
	
	//3 Side
	if( side3 & WalkPathToTop ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"D%u.png", WalkPathToTop]];
		[self setPath:sprite fromSide:3 atX:x y:y];
	}
	if( side3 & WalkPathToRight ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"D%u.png", WalkPathToRight]];
		[self setPath:sprite fromSide:3 atX:x y:y];
	}
	if( side3 & WalkPathToBottom ){
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"D%u.png", WalkPathToBottom]];
		[self setPath:sprite fromSide:3 atX:x y:y];
	}
	
	return;
}


- (void)setPath:(CCSprite *)path fromSide:(NSUInteger)side atX:(NSUInteger)x y:(NSUInteger)y {
	CGPoint tilePos = CGPointMake(x *TILE_SIZE() +TILE_SIZE() /2, y *TILE_SIZE() +TILE_SIZE() /2);
	NSString *posName = [NSString stringWithFormat:@"%i|%i|%i", x, y, side];

	if( ![_mapTiles objectForKey:posName] ){
		[_mapTiles setObject:[NSMutableArray arrayWithCapacity:4] forKey:posName];
	}
		
	[[_mapTiles objectForKey:posName] addObject:path];
	[path setPosition:tilePos];
	[_backgroundLayer addChild:path];
}


- (void)mapCompleated {
    
	[[iLabyrinth sharedInstance] setMap:_mapNo asCompleated:YES];

    if( _mapNo == TOTAL_MAPS ){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDGameEndScene node]]];
    }else{
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDPickMapScene node]]];
    }
    
}


#pragma mark -
#pragma mark CCNode


- (void)onEnter {
    [self deviceOrientationDidChange];
    [super onEnter];
}


- (void)onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];
	[self charDidFinishWalking];
}


- (void)deviceOrientationDidChange {

	switch( [[UIDevice currentDevice] orientation] ) {
		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationLandscapeRight: {
            [_backSprite setPosition:CGPointMake(_winSize.width -[_backSprite contentSize].width /1.5f, _winSize.height -[_backSprite contentSize].height /1.5f)];
            [_backSprite setRotation:0];
			break;
		}
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown: {
            [_backSprite setPosition:CGPointMake(_winSize.width -[_backSprite contentSize].width /1.5f, [_backSprite contentSize].height /1.5f)];
            [_backSprite setRotation:90];
			break;
		}
		default:
			break;
	}
    
}


#pragma mark -
#pragma mark UDCharacterDelegate


- (void)charWillBeginWalking {
	// Looking at
	CGPoint lookingAt = [_char lookingAtGridPosition];
	
	NSString *posName = [NSString stringWithFormat:@"%i|%i|%i", (int)lookingAt.x, (int)lookingAt.y, [_char opositeSideOfSide:[_char rotationSide]]];
	for( CCSprite *path in [_mapTiles objectForKey:posName] ){
		[path setColor:ccWHITE];
		[path setScale:1.0f];
		[_backgroundLayer reorderChild:path z:0];
	}
}


- (void)charDidFinishWalking {
	
	// Standing on
	uint x	= [_char gridPosition].x;
	uint y	= [_char gridPosition].y;
	
	// Check if we entered exit
	if( _map[x][y][0] == WalkPathExit ){
		[self mapCompleated];
		return;
	}
	
	// Where character looking at
	x	= [_char lookingAtGridPosition].x;
	y	= [_char lookingAtGridPosition].y;
	
    // What are possibile patches
	_possiblePaths = _map[x][y][[_char opositeSideOfSide:[_char rotationSide]]];

	if(	  _possiblePaths == WalkPathToTop
	   || _possiblePaths == WalkPathToRight
	   || _possiblePaths == WalkPathToBottom
	   || _possiblePaths == WalkPathToLeft
	   || _possiblePaths == WalkPathWalk 
	){
		// If player can go one way only - go there
		[_char walkByPath:_possiblePaths];
		return;
	}else{
        // Highlite where player can go
		NSString *posName = [NSString stringWithFormat:@"%i|%i|%i", x, y, [_char opositeSideOfSide:[_char rotationSide]]];
		for( CCSprite *path in [_mapTiles objectForKey:posName] ){
			[path setColor:ccGREEN];
			[_backgroundLayer reorderChild:path z:1];
		}
	}
	
}


#pragma mark -
#pragma mark CCStandardTouchDelegate


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	
	CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
	
    
    // Is back button clicked?
	CGSize mySize = [_backSprite textureRect].size;
	mySize.width  *= scaleX_;
	mySize.height *= scaleY_;
	CGRect frame = CGRectMake([_backSprite position].x -mySize.width *[_backSprite anchorPoint].x, [_backSprite position].y -mySize.height *[_backSprite anchorPoint].y, mySize.width, mySize.height);
	if( CGRectContainsPoint(frame, touchPoint) ){
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
        
		[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDPickMapScene node]]];
		return;
	}
	
    
	// If character still animating don't do anything
	if( [_char isBussy] ) return;
	
	
	CGPoint charPoint = [_char position];
	//Adjust char point to way hes looking
	switch ( [_char rotationSide] ) {
		case SideTop:
			charPoint.y += TILE_SIZE();
			break;
		case SideRight:
			charPoint.x += TILE_SIZE();
			break;
		case SideBottom:
			charPoint.y -= TILE_SIZE();
			break;
		case SideLeft:
			charPoint.x -= TILE_SIZE();
			break;
	}
	
	
	float xDistance = touchPoint.x -charPoint.x;
	float yDistance = touchPoint.y -charPoint.y;
	uint  side;

	if( abs(xDistance) > abs(yDistance) ){
		if( xDistance > 0 ){
			side = SideRight;
		}else{
			side = SideLeft;
		}
	}else if( yDistance > 0 ){
		side = SideTop;
	}else if( yDistance < 0 ){
		side = SideBottom;
	}
	
	// Looking at
	uint x	= [_char lookingAtGridPosition].x;
	uint y	= [_char lookingAtGridPosition].y;
	
	_possiblePaths = _map[x][y][[_char opositeSideOfSide:[_char rotationSide]]];
	
	// Can we walk
	if( (side == SideTop) && (_possiblePaths & WalkPathToTop) ){
		[_char walkByPath:WalkPathToTop];
	}else if( side == SideRight && (_possiblePaths & WalkPathToRight) ){
		[_char walkByPath:WalkPathToRight];
	}else if( side == SideBottom && (_possiblePaths & WalkPathToBottom) ){
		[_char walkByPath:WalkPathToBottom];
	}else if( side == SideLeft && (_possiblePaths & WalkPathToLeft) ){
		[_char walkByPath:WalkPathToLeft];
	}
	
}


@end
