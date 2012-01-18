//
//  UDAppDelegate.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDAppDelegate.h"
#import "iLabyrinth.h"
#import "UDMenuScene.h"
#import "UDGameScene.h"
#import "SimpleAudioEngine.h"
#import "UDGameEndScene.h"
#import "CCDirectorIOS.h"


@interface UDAppDelegate (Private)

- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)updateDeviceOrientation;

@end


@implementation UDAppDelegate


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_deviceOriantationTimer invalidate];
	[_window release];
	[super dealloc];
}


#pragma mark -
#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication*)application {

	// Init the window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// cocos2d will inherit these values
	[_window setUserInteractionEnabled:YES];	
	[_window setMultipleTouchEnabled:YES];

	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
	    
    // Start listening for oriantation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // Setup Director
    if( [[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        [[CCDirector sharedDirector] setContentScaleFactor: [[UIScreen mainScreen] scale]];
    }
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
	// [[Director sharedDirector] setDisplayFPS:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

	EAGLView *glView = [EAGLView viewWithFrame: [_window bounds]
                                   pixelFormat: kEAGLColorFormatRGB565
                                   depthFormat: 0
                            preserveBackbuffer: NO
                                    sharegroup: nil
                                 multiSampling: NO
                               numberOfSamples: 0];
    [[CCDirector sharedDirector] setOpenGLView: glView];

    [_window addSubview:glView];
    
	[_window makeKeyAndVisible];
    
    // Preload sounds
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"click.caf"];
	
	// Restore GameState
	[NSKeyedUnarchiver unarchiveObjectWithFile:[iLabyrinth stateFile]];
	
    // Load sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[iLabyrinth texturePlistName]];
    
	// run scene
    [[CCDirector sharedDirector] runWithScene: [UDMenuScene node]];
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    [_deviceOriantationTimer invalidate];
    _deviceOriantationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateDeviceOrientation) userInfo:nil repeats:NO];
}


- (void)updateDeviceOrientation {
    [_deviceOriantationTimer invalidate], _deviceOriantationTimer = nil;
    
	switch( [[UIDevice currentDevice] orientation] ) {
		case UIDeviceOrientationUnknown: {
            [[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
            break;
        }
		case UIDeviceOrientationPortrait: {
            [[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
			break;
		}
		case UIDeviceOrientationPortraitUpsideDown: {
            [[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];	
			break;
		}
		case UIDeviceOrientationLandscapeLeft: {
            [[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
			break;
		}
		case UIDeviceOrientationLandscapeRight: {
            [[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
			break;
		}
		default:
			break;
	}
    
    CCScene *runningScene = [[CCDirector sharedDirector] runningScene];
    if( [runningScene respondsToSelector:@selector(deviceOrientationDidChange:)] ){
        [(UDGameScene *)runningScene deviceOrientationDidChange];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [_deviceOriantationTimer invalidate], _deviceOriantationTimer = nil;
    
	[[CCDirector sharedDirector] pause];
	[[CCDirector sharedDirector] stopAnimation];

	// Save GameState
	[NSKeyedArchiver archiveRootObject:[iLabyrinth sharedInstance] toFile:[iLabyrinth stateFile]];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_deviceOriantationTimer invalidate], _deviceOriantationTimer = nil;
    
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] pause];

	// Save GameState
	[NSKeyedArchiver archiveRootObject:[iLabyrinth sharedInstance] toFile:[iLabyrinth stateFile]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] startAnimation];
    
    [self updateDeviceOrientation];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Stop listening for oriantation updates
    [_deviceOriantationTimer invalidate], _deviceOriantationTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
	// Save GameState
	[NSKeyedArchiver archiveRootObject:[iLabyrinth sharedInstance] toFile:[iLabyrinth stateFile]];
	
	// Stop director
	[[CCDirector sharedDirector] end];
}


- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


@synthesize window=_window;
@end
