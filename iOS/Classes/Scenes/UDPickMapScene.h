//
//  UDPickMapScene.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/22/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "cocos2d.h"


@interface UDPickMapScene : CCScene {

}

@end


@interface UDPickMapLayer : CCLayer {
	CCSpriteBatchNode	*_backgroundLayer;
	CGSize              _winSize;
	CCSprite            *_backSprite;
    
    CGPoint             _touchDownLocation;
    BOOL                _didScroll;
    float               _lowestPoint;
}

- (CCSprite *)addButtonOfMapNo:(NSUInteger)mapNo at:(CGPoint)pos;

@end
