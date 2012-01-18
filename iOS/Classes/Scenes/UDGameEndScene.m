//
//  UDGameEndScene.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 6/26/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDGameEndScene.h"
#import "UDMenuScene.h"
#import "iLabyrinth.h"


@implementation UDGameEndScene


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		[self addChild: [UDGameEndLayer node]];
	}
	return self;
}


@end


@implementation UDGameEndLayer


#pragma mark -
#pragma mark NSObject


- (id)init {
    
    if ( (self = [super init]) ) {
        [self setIsTouchEnabled:YES];
        
        CGSize _winSize = [[CCDirector sharedDirector] winSize];
        
        _backgroundLayer = [CCSpriteBatchNode batchNodeWithFile:[iLabyrinth textureName]];
		[[_backgroundLayer texture] setAliasTexParameters];
		[self addChild:_backgroundLayer];
		
        // Add background
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"sand.png"];
		[sprite setAnchorPoint:CGPointZero];
		[sprite setPosition:CGPointZero];
		[_backgroundLayer addChild:sprite];
        
        // Construct look
		CCSprite *endSprite = [CCSprite spriteWithSpriteFrameName:@"end.png"];
        [endSprite setAnchorPoint:CGPointMake(0.0f, 0.5f)];
        [endSprite setPosition:CGPointMake(0.0f, _winSize.height /2)];
		[_backgroundLayer addChild:endSprite];
        
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Congratulations!"
                                       dimensions:CGSizeMake(_winSize.width, _winSize.height) 
                                        alignment:UITextAlignmentCenter 
                                         fontName:@"MarkerFelt-Thin" 
                                         fontSize:(isDeviceIPad()?98:46)];
        [label setPosition:CGPointMake(_winSize.width/2, _winSize.height -(isDeviceIPad()?100:50))];
        
        [label setColor:ccc3(60, 29, 3)];
        [label setAnchorPoint:CGPointMake(0.5f, 1.0f)];
        [label setOpacity:200];
        [self addChild:label];
    }
    return self;
}


#pragma mark -
#pragma mark CCStandardTouchDelegate


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	

    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDMenuScene node]]];
    
}


@end
