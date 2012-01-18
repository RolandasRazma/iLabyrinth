//
//  UDCharacter.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/21/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDCharacter.h"


@implementation UDCharacter


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		NSMutableArray *walkFrames = [NSMutableArray array];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH1.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH2.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH3.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH4.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH5.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH6.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH7.png"]];
		[walkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"CH8.png"]];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:[CCAnimation animationWithFrames:walkFrames] name:@"walk"];
		
        [self reset];
	}
	return self;
}


#pragma mark -
#pragma mark UDCharacter


- (NSUInteger)opositeSideOfSide:(NSUInteger)side {
	
	switch ( side ) {
		case SideTop:
			return SideBottom;
		case SideRight:
			return SideLeft;
		case SideBottom:
			return SideTop;
		case SideLeft:
			return SideRight;
	}
	
	return side;
}


- (void)rotateToSide:(Side)side {
	[self rotateNode:self toSide:side];
}


- (void)rotateNode:(CCNode *)node toSide:(Side)side {
	[node setRotation: side *90];
}


- (NSUInteger)rotationSide {
	return [self rotation] /90;
}


- (void)walkByPath:(NSUInteger)path {
	
	CGPoint pathPart1 = CGPointZero;
	CGPoint pathPart2 = CGPointZero;
	NSInteger side	  = -1;
		
	switch ( [self opositeSideOfSide:[self rotationSide]] ) {
		case SideTop: {
			switch ( path ) {
				case WalkPathToRight: {
					pathPart1 = CGPointMake(0, -TILE_SIZE());
					pathPart2 = CGPointMake(TILE_SIZE(), 0);
					side	  = SideRight;
					break;
				}
				case WalkPathToBottom: {
					pathPart1 = CGPointMake(0, -TILE_SIZE());
					pathPart2 = CGPointMake(0, -TILE_SIZE());
					side	  = SideBottom;
					break;
				}
				case WalkPathWalk: {
					pathPart1 = CGPointMake(0, -TILE_SIZE());
					pathPart2 = CGPointZero;
					side	  = SideBottom;
					break;
				}
				case WalkPathToLeft: {
					pathPart1 = CGPointMake(0, -TILE_SIZE());
					pathPart2 = CGPointMake(-TILE_SIZE(), 0);
					side	  = SideLeft;
					break;
				}
			}
			break;
		}
		case SideRight: {
			switch ( path ) {
				case WalkPathToTop: {
					pathPart1 = CGPointMake(-TILE_SIZE(), 0);
					pathPart2 = CGPointMake(0, TILE_SIZE());
					side	  = SideTop;
					break;
				}
				case WalkPathToBottom: {
					pathPart1 = CGPointMake(-TILE_SIZE(), 0);
					pathPart2 = CGPointMake(0, -TILE_SIZE());					
					side	  = SideBottom;
					break;
				}
				case WalkPathToLeft: {
					pathPart1 = CGPointMake(-TILE_SIZE(), 0);
					pathPart2 = CGPointMake(-TILE_SIZE(), 0);
					side	  = SideLeft;
					break;
				}
				case WalkPathWalk: {
					pathPart1 = CGPointMake(-TILE_SIZE(), 0);
					pathPart2 = CGPointZero;
					side	  = SideLeft;
					break;
				}
			}
			break;
		}
		case SideBottom: {
			switch ( path ) {
				case WalkPathToTop: {
					pathPart1 = CGPointMake(0, TILE_SIZE());
					pathPart2 = CGPointMake(0, TILE_SIZE());
					side	  = SideTop;
					break;
				}
				case WalkPathWalk: {
					pathPart1 = CGPointMake(0, TILE_SIZE());
					pathPart2 = CGPointZero;
					side	  = SideTop;
					break;
				}
				case WalkPathToRight: {
					pathPart1 = CGPointMake(0, TILE_SIZE());
					pathPart2 = CGPointMake(TILE_SIZE(), 0);					
					side	  = SideRight;
					break;
				}
				case WalkPathToLeft: {
					pathPart1 = CGPointMake(0, TILE_SIZE());
					pathPart2 = CGPointMake(-TILE_SIZE(), 0);
					side	  = SideLeft;
					break;
				}
			}
			break;
		}
		case SideLeft: {
			switch ( path ) {
				case WalkPathToTop: {
					pathPart1 = CGPointMake(TILE_SIZE(), 0);
					pathPart2 = CGPointMake(0, TILE_SIZE());
					side	  = SideTop;
					break;
				}
				case WalkPathToRight: {
					pathPart1 = CGPointMake(TILE_SIZE(), 0);
					pathPart2 = CGPointMake(TILE_SIZE(), 0);					
					side	  = SideRight;
					break;
				}
				case WalkPathWalk: {
					pathPart1 = CGPointMake(TILE_SIZE(), 0);
					pathPart2 = CGPointZero;					
					side	  = SideRight;
					break;
				}
				case WalkPathToBottom: {
					pathPart1 = CGPointMake(TILE_SIZE(), 0);
					pathPart2 = CGPointMake(0, -TILE_SIZE());
					side	  = SideBottom;
					break;
				}
			}
			break;
		}
	}
	
    // Will character walk straight line, or will he will make turn?
	if( pathPart2.x == 0 && pathPart2.y == 0 ){
		[self runAction:[CCSequence actions: 
						 [CCCallFunc actionWithTarget:_delegate selector:@selector(charWillBeginWalking)],
						 [CCMoveBy actionWithDuration:0.5f position:pathPart1],
						 [CCCallFunc actionWithTarget:self selector:@selector(reset)],
						 [CCCallFunc actionWithTarget:_delegate selector:@selector(charDidFinishWalking)],
						 nil]];
	}else{
		[self runAction:[CCSequence actions: 
						 [CCCallFunc actionWithTarget:_delegate selector:@selector(charWillBeginWalking)],
						 [CCMoveBy actionWithDuration:0.5f position:pathPart1], 
						 [CCCallFuncND actionWithTarget:self selector:@selector(rotateNode:toSide:) data:(void *)side],
						 [CCMoveBy actionWithDuration:0.5f position:pathPart2], 
						 [CCCallFunc actionWithTarget:self selector:@selector(reset)],
						 [CCCallFunc actionWithTarget:_delegate selector:@selector(charDidFinishWalking)],
						 nil]];
	}
}


- (CGPoint)gridPosition {
	return CGPointMake( [self position].x /TILE_SIZE(), [self position].y /TILE_SIZE());
}


- (CGPoint)lookingAtGridPosition {
	CGPoint gridPosition = [self gridPosition];

	switch ( [self opositeSideOfSide: [self rotationSide]] ) {
		case SideTop:
			gridPosition.y--;
			break;
		case SideRight:
			gridPosition.x--;
			break;
		case SideBottom:
			gridPosition.y++;
			break;
		case SideLeft:
			gridPosition.x++;			
			break;
	}
	
	return gridPosition;
}


- (BOOL)isBussy {
	return ( [self numberOfRunningActions] != 0 );
}


- (void)setPosition:(CGPoint)pos {
	[super setPosition:pos];
	
	if( ccpDistance(pos, _lastFramePos) >= 2 ){
		[self nextFrame];
		_lastFramePos = pos;
	}
}


- (void)nextFrame {
    // Manualy advance animation frame
    [self setDisplayFrameWithAnimationName:@"walk" index:_charFrame];

	if( ++_charFrame > 7 ) _charFrame = 0;
}


- (void)reset {
	_charFrame=2;

    // Reset animation frame
    [self setDisplayFrameWithAnimationName:@"walk" index:1];
}


@synthesize delegate=_delegate;
@end
