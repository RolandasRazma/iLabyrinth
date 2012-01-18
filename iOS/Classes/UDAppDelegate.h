//
//  UDAppDelegate.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"


@interface UDAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow    *_window;
    NSTimer     *_deviceOriantationTimer;
}

@property (nonatomic, retain) UIWindow *window;

@end
