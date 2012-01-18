//
//  UDMenuScene.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDMenuScene.h"
#import "UDPickMapScene.h"
#import "SimpleAudioEngine.h"
#import "UDHelpScene.h"
#import "iLabyrinth.h"
#import "CCDirector.h"


@implementation UDMenuScene


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		[self addChild:[UDMenuLayer node]];
	}
	return self;
}


@end


@implementation UDMenuLayer


#pragma mark -
#pragma mark NSObject


- (id)init {
	
	if( (self = [super init]) ){
		[self setIsTouchEnabled: YES];
        
        CGSize _winSize = [[CCDirector sharedDirector] winSize];

        // Add background
		CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"menu%@.png", (isDeviceIPad()?@"~ipad":([iLabyrinth hightRes]?@"@2x":@""))]];
		[sprite setAnchorPoint:CGPointZero];
		[self addChild:sprite];

		_backgroundLayer = [CCSpriteBatchNode batchNodeWithFile:[iLabyrinth textureName]];
		[[_backgroundLayer texture] setAliasTexParameters];
		[self addChild:_backgroundLayer];

		// Add "Pay" button
		CCSprite *playSprite = [CCSprite spriteWithSpriteFrameName:@"play.png"];
        [playSprite setTag:MenuButtonPlay];
        [playSprite setAnchorPoint:CGPointMake(0.5f, 0.0f)];
        [playSprite setPosition:CGPointMake(_winSize.width /2, _winSize.height /2)];
		[_backgroundLayer addChild:playSprite];

		// Add "Help" button        
		CCSprite *helpSprite = [CCSprite spriteWithSpriteFrameName:@"help.png"];
        [helpSprite setAnchorPoint:CGPointMake(0.5f, 1.0f)];
        [helpSprite setTag:MenuButtonHelp];
        [helpSprite setPosition:CGPointMake(_winSize.width /2, _winSize.height /2 -[helpSprite boundingBox].size.height /2)];
		[_backgroundLayer addChild:helpSprite];
	}
	
	return self;
}


#pragma mark -
#pragma mark CCStandardTouchDelegate


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
	CGPoint touchPoint = [_backgroundLayer convertTouchToNodeSpace:[touches anyObject]];
	
	for( CCSprite *sprite in [_backgroundLayer children] ){
        if( [sprite tag] <= 0 ) continue;

		if( CGRectContainsPoint([sprite boundingBox], touchPoint) ){
            
            [sprite setColor:ccGREEN];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
            
            switch ( [sprite tag] ) {
                case MenuButtonPlay: {
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDPickMapScene node]]];
                    break;
                }
                case MenuButtonHelp: {
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDHelpScene node]]];
                    break;
                }
            }
            
			return;
		}
        
	}
    
}


@end
