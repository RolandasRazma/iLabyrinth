//
//  UDCharacter.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/21/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "cocos2d.h"
#import "iLabyrinth.h"


@protocol UDCharacterDelegate;


@interface UDCharacter : CCSprite {
    id <UDCharacterDelegate>_delegate;
	CGPoint                 _lastFramePos;
	NSUInteger              _charFrame;
}

@property(nonatomic, assign) id delegate;

- (void)rotateToSide:(Side)side;
- (void)rotateNode:(CCNode *)node toSide:(Side)side;
- (CGPoint)gridPosition;
- (NSUInteger)rotationSide;
- (void)walkByPath:(NSUInteger)path;
- (NSUInteger)opositeSideOfSide:(NSUInteger)side;
- (CGPoint)lookingAtGridPosition;
- (BOOL)isBussy;
- (void)nextFrame;
- (void)reset;

@end


@protocol UDCharacterDelegate <NSObject>
@required

- (void)charWillBeginWalking;
- (void)charDidFinishWalking;

@end
