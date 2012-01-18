//
//  iLabyrinth.h
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TOTAL_MAPS 39


static float TILE_SIZE(){
    return ((isDeviceIPad())?64.0f:32.0f);
}


typedef enum {
	WalkPathWalk	= 0,
	WalkPathToTop   = 1 << 1,
	WalkPathToRight = 1 << 2,
	WalkPathToBottom= 1 << 3,
	WalkPathToLeft  = 1 << 4,
	WalkPathEntrance= 1 << 5,
	WalkPathExit	= 1 << 6,
	WalkPathNoPath	= 1 << 7,
} WalkPath;


typedef enum {
    ZeroPathToBottom= 1 << 7,
    ZeroPathToLeft  = 1 << 8,
    ZeroPathToTop   = 1 << 9,
    ZeroPathToRight = 1 << 10
} ZeroPath;


typedef enum {
	SideTop		= 0,
	SideRight	= 1,
	SideBottom	= 2,
	SideLeft	= 3,
} Side;


@interface iLabyrinth : NSObject {
	NSMutableSet	*_compleatedMaps;
    NSInteger       _scrollOffset;
}

@property(nonatomic, readwrite, assign) NSInteger scrollOffset;

+ (iLabyrinth *)sharedInstance;
+ (void)sharedInstanceRelease;

+ (NSString *)stateFile;
+ (BOOL)hightRes;

+ (NSString *)textureName;
+ (NSString *)texturePlistName;

- (void)setMap:(NSUInteger)map asCompleated:(BOOL)compleated;
- (BOOL)canPlayMap:(NSUInteger)map;

@end
