//
//  UDHelpScene.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 7/4/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDHelpScene.h"
#import "SimpleAudioEngine.h"
#import "UDMenuScene.h"
#import "iLabyrinth.h"


@implementation UDHelpScene

#pragma mark -
#pragma mark NSObject

- (id)init {
	if( (self = [super init]) ){
        [self addChild:[UDHelpLayer node]];
	}
	return self;
}

@end


@implementation UDHelpLayer


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
        [self setIsTouchEnabled:YES];
        
        _winSize		= [[CCDirector sharedDirector] winSize];
        
		CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"menu%@.png", ([iLabyrinth hightRes]?@"~ipad":@"")]];
		[sprite setAnchorPoint:CGPointZero];
		[self addChild:sprite];
        
		CCSpriteBatchNode *backgroundLayer = [CCSpriteBatchNode batchNodeWithFile:[iLabyrinth textureName]];
		[[backgroundLayer texture] setAliasTexParameters];
		[self addChild:backgroundLayer];
        
		_backSprite = [CCSprite spriteWithSpriteFrameName:@"back2.png"];
		[_backSprite setAnchorPoint:CGPointMake(1, 1)];
		[_backSprite setPosition:CGPointMake(_winSize.width, _winSize.height)];
		[backgroundLayer addChild:_backSprite];
     
        CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"about" ofType:nil] encoding:NSUTF8StringEncoding error:NULL] 
                                             dimensions: CGSizeMake(_winSize.width -20, _winSize.height) 
                                              alignment: UITextAlignmentCenter 
                                               fontName: @"Arial" 
                                               fontSize: (isDeviceIPad()?32:15)];
        
        if( isDeviceIPad() ){
            [label setPosition:CGPointMake(_winSize.width /2, _winSize.height -240)];
        }else{
            [label setPosition:CGPointMake(_winSize.width /2, _winSize.height -70)];
        }

        [label setColor:ccBLACK];
        [label setAnchorPoint:CGPointMake(0.5f, 1.0f)];
        [self addChild:label];

	}
	return self;
}


#pragma mark -
#pragma mark CCStandardTouchDelegate


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];

	CGSize mySize = [_backSprite textureRect].size;
	mySize.width  *= scaleX_;
	mySize.height *= scaleY_;
	CGRect frame = CGRectMake([_backSprite position].x -mySize.width *[_backSprite anchorPoint].x, [_backSprite position].y -mySize.height *[_backSprite anchorPoint].y, mySize.width, mySize.height);
	if( CGRectContainsPoint(frame, touchPoint) ){
        [_backSprite setColor:ccGREEN];
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
        
		[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDMenuScene node]]];

		return;
	}
    
}


@end
