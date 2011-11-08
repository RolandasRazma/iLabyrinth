//
//  UDMenuScene.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "cocos2d.h"


typedef enum {
    MenuButtonPlay =1,
    MenuButtonHelp,
    MenuButtonPlayHeaven,
} MenuButton;


@interface UDMenuScene : CCScene {

}

@end


@interface UDMenuLayer : CCLayer {
    CCSpriteBatchNode	*_backgroundLayer;
}

@end
