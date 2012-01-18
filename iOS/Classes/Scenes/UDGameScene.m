//
//  UDGameScene.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDGameScene.h"


@implementation UDGameScene


#pragma mark -
#pragma mark UDGameScene


+ (id)sceneWithMap:(NSUInteger)mapNo {
	return [[[self alloc] initWithMap:mapNo] autorelease];
}


- (id)initWithMap:(NSUInteger)mapNo {
	if( (self = [super init]) ){
        _gameLayer = [UDGameLayer node];
		[_gameLayer loadMapNo:mapNo];
		[self addChild:_gameLayer];
	}
	return self;
}


- (void)deviceOrientationDidChange {
    [_gameLayer deviceOrientationDidChange];
}


@end



