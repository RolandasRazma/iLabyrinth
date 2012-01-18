//
//  UDGameScene.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "cocos2d.h"
#import "UDGameLayer.h"


@interface UDGameScene : CCScene {
    UDGameLayer *_gameLayer;
}

+ (id)sceneWithMap:(NSUInteger)mapNo;
- (id)initWithMap:(NSUInteger)mapNo;

- (void)deviceOrientationDidChange;

@end



