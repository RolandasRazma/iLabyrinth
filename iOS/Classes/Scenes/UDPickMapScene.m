//
//  UDPickMapScene.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/22/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDPickMapScene.h"
#import "UDGameScene.h"
#import "iLabyrinth.h"
#import "UDMenuScene.h"
#import "SimpleAudioEngine.h"


@implementation UDPickMapScene


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		[self addChild:[UDPickMapLayer node]];
	}
	return self;
}


@end


@implementation UDPickMapLayer


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		[self setIsTouchEnabled:YES];
        [self setPosition: CGPointMake(self.position.x, [[iLabyrinth sharedInstance] scrollOffset])];
		
		_winSize		= [[CCDirector sharedDirector] winSize];

        // Add background
		_backgroundLayer = [CCSpriteBatchNode batchNodeWithFile:[iLabyrinth textureName]];
		[[_backgroundLayer texture] setAliasTexParameters];
		[self addChild:_backgroundLayer];

        
		{
            CCSprite *sand1 = [CCSprite spriteWithSpriteFrameName:@"sand.png"];
            [sand1 setAnchorPoint:CGPointZero];
            [sand1 setPosition:CGPointZero];
            [_backgroundLayer addChild:sand1];
            
            CCSprite *sand2 = [CCSprite spriteWithSpriteFrameName:@"sand.png"];
            [sand2 setAnchorPoint:CGPointZero];
            [sand2 setPosition:CGPointMake(0, -[sand1 boundingBox].size.height)];
            [_backgroundLayer addChild:sand2];
            
            CCSprite *sand3 = [CCSprite spriteWithSpriteFrameName:@"sand.png"];
            [sand3 setAnchorPoint:CGPointZero];
            [sand3 setPosition:CGPointMake(0, [sand2 boundingBox].origin.y -[sand2 boundingBox].size.height)];
            [_backgroundLayer addChild:sand3];
        }
        
        
		_backSprite = [CCSprite spriteWithSpriteFrameName:@"back2.png"];
		[_backSprite setAnchorPoint:CGPointMake(1, 1)];
		[_backSprite setPosition:CGPointMake(_winSize.width, _winSize.height)];
		[_backgroundLayer addChild:_backSprite];

		
        float top  = 0;
        
        
        {
            float left = 0;
            for ( uint no=1; no <=4; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:no at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width;
                if( !top ) top = _winSize.height -[map boundingBox].size.height *0.8f;
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90];
                [feets setPosition:CGPointMake([map position].x +[map boundingBox].size.width /2 +[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 4 ){
                    [feets setPosition: CGPointMake([feets position].x, [feets position].y -[map boundingBox].size.height /2)];
                    [feets setRotation:150];
                    
                    top -= [map boundingBox].size.height *1.2f;
                }
            }
		}
		
        
        {
            float left = 0;
            for ( uint no=5; no <=9; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:(14 -no) at:CGPointZero];

                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90*3];
                [feets setPosition:CGPointMake([map position].x -[map boundingBox].size.width /2 -[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 5 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                }else if ( no == 9 ) {
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}

        
#ifdef DEMO
        CCSprite *like_game = [CCSprite spriteWithSpriteFrameName:@"like_game.png"];
        [like_game setTag:-678];
        [like_game setPosition:CGPointMake(_winSize.width/2, (_winSize.height -top) /2)];
        [self addChild:like_game];
        
        return self;
#endif
        
        {
            float left = 0;
            for ( uint no=10; no <=14; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:no at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90];
                [feets setPosition:CGPointMake([map position].x +[map boundingBox].size.width /2 +[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 14 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                    
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}
        

        {
            float left = 0;
            for ( uint no=15; no <=19; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:(34 -no) at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90 *3];
                [feets setPosition:CGPointMake([map position].x -[map boundingBox].size.width /2 -[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 15 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                }else if ( no == 19 ) {
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}

        
        {
            float left = 0;
            for ( uint no=20; no <=24; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:no at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90];
                [feets setPosition:CGPointMake([map position].x +[map boundingBox].size.width /2 +[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 24 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                    
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}
        
        
        {
            float left = 0;
            for ( uint no=25; no <=29; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:(54 -no) at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90 *3];
                [feets setPosition:CGPointMake([map position].x -[map boundingBox].size.width /2 -[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 25 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                }else if ( no == 29 ) {
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}
        
        
        {
            float left = 0;
            for ( uint no=30; no <=34; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:no at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90];
                [feets setPosition:CGPointMake([map position].x +[map boundingBox].size.width /2 +[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 34 ){
                    [feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    [feets setRotation:90 *2];
                    
                    top -= [map boundingBox].size.height *1.5f;
                }
            }
		}
        
        
        {
            float left = 0;
            for ( uint no=35; no <=39; no++ ) {
                CCSprite *map = [self addButtonOfMapNo:(74 -no) at:CGPointZero];
                if( !left ) left = [map boundingBox].size.width /2;
                
                [map setPosition:CGPointMake(left, top)];
                
                CCSprite *feets = [CCSprite spriteWithSpriteFrameName:@"pedos.png"];
                [feets setRotation:90 *3];
                [feets setPosition:CGPointMake([map position].x -[map boundingBox].size.width /2 -[feets boundingBox].size.width /1.6f, [map position].y)];
                [self addChild:feets];
                
                left += [map boundingBox].size.width +[feets boundingBox].size.width *1.4f;
                
                if( no == 35 ){
                    [feets setVisible:NO];
                    //[feets setPosition: CGPointMake([map position].x, [map position].y -[map boundingBox].size.height /1.3f)];
                    //[feets setRotation:90 *2];
                }else if ( no == 39 ) {
                    //top -= [map boundingBox].size.height *1.5f;
                }
            }
		}

        
        // Calculate where last map button placed
        _lowestPoint = top;
        for( CCNode *node in [self children] ){
            if( [node isEqual:_backgroundLayer] ) continue;
            _lowestPoint = MIN(_lowestPoint, [node boundingBox].origin.y);
        }
        _lowestPoint = abs(_lowestPoint -20);
	}
	
	return self;
}


#pragma mark -
#pragma mark PickMapLayer


- (CCSprite *)addButtonOfMapNo:(NSUInteger)no at:(CGPoint)pos {
	CCSprite *map		= nil;
	CCSprite *lockSprite= nil;
	CCLabelTTF	 *mapNo	    = nil;
	
	if( [[iLabyrinth sharedInstance] canPlayMap:no] ){
		map = [CCSprite spriteWithSpriteFrameName:@"map.png"];
		[map setTag:no];
		mapNo = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%u", no] fontName:@"MarkerFelt-Thin" fontSize:(isDeviceIPad()?42:22)];
		[mapNo setColor:ccc3(91, 90, 51)];
        [mapNo setPosition:CGPointMake([map boundingBox].size.width /2, [map boundingBox].size.height /2)];
		[map addChild:mapNo];
	}else{
		map = [CCSprite spriteWithSpriteFrameName:@"map_locked.png"];
		lockSprite = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        [lockSprite setPosition:CGPointMake([map boundingBox].size.width /2, [map boundingBox].size.height /2)];
		[map addChild:lockSprite];        
	}
	
    if( [[CCDirector sharedDirector] contentScaleFactor] > 1.0f ){
        [map setScale:0.9f];
    }
    
	[map setPosition:pos];
	[self addChild:map];
	
    return map;
}


#pragma mark -
#pragma mark CCStandardTouchDelegate

 
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _didScroll = NO;
    _touchDownLocation = [self convertTouchToNodeSpace: [touches anyObject]];
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ( [touches count] == 1 ) {
		UITouch *touch = [touches anyObject];
		
        CGPoint touchUpLocation = [self convertTouchToNodeSpace: touch];
        
        if( _didScroll == NO && ccpDistance(_touchDownLocation, touchUpLocation) < 20 ) return;
        
        
		CGPoint touchLocation = [touch locationInView: [touch view]];
		CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
		
		touchLocation = [self convertToNodeSpace:touchLocation];
		prevLocation  = [self convertToNodeSpace:prevLocation];		
		
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
		prevLocation  = [[CCDirector sharedDirector] convertToGL: prevLocation];

        
        CGPoint newPos = ccpAdd([self position], ccpSub(touchLocation, prevLocation));
        if( newPos.y < 0 ) newPos.y = 0;
        if( newPos.y > _lowestPoint ) newPos.y = _lowestPoint;
        
        if( self.position.y != newPos.y ){
            newPos.x = self.position.x;
            [self setPosition: newPos];
            _didScroll = YES;
            [[iLabyrinth sharedInstance] setScrollOffset:newPos.y];
        }
	}
	
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if( _didScroll ) return;
    
	CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
	
	for( CCSprite *sprite in children_ ){
#ifdef DEMO
		if( CGRectContainsPoint([sprite boundingBox], touchPoint) && [sprite tag] == -678 && [sprite visible] ) {
            [sprite setColor:ccGREEN];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=380886785&mt=8"]];
            
            break;
        }
#endif
		if( [sprite tag] <= 0 || [sprite visible] == NO ) continue;

		if( CGRectContainsPoint([sprite boundingBox], touchPoint) ){
            [sprite setColor:ccGREEN];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
            
			[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDGameScene sceneWithMap: [sprite tag]]]];
			return;
		}
	}
	
	if( CGRectContainsPoint([_backSprite boundingBox], touchPoint) ){
        [_backSprite setColor:ccGREEN];
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
        
		[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[UDMenuScene node]]];
		return;
	}

}


@end
