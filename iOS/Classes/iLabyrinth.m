//
//  iLabyrinth.m
//  iLabyrinth
//
//  Created by Rolandas Razma on 5/12/10.
//  Copyright 2010 UD7. All rights reserved.
//
//  http://www.cocos2d-iphone.org/forum/topic/1551
//

#import "iLabyrinth.h"


@implementation iLabyrinth


static iLabyrinth *_sharedInstance = nil;


#pragma mark -
#pragma mark NSObject


- (id)init {
	if( (self = [super init]) ){
		_compleatedMaps  = [[NSMutableSet alloc] initWithCapacity:50];
        _scrollOffset    = 0;
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)coder { 
	if( (self = [self init]) ){
		_sharedInstance = [self retain];
        
		[_compleatedMaps release];
		_compleatedMaps  = [[NSMutableSet alloc] initWithSet:[coder decodeObjectForKey:@"compleatedMaps"]];
        //        scrollOffset    = [coder decodeIntegerForKey:@"scrollOffset"];
	}
	
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder { 
	[coder encodeObject:_compleatedMaps forKey:@"compleatedMaps"];
    //    [coder encodeInteger:scrollOffset forKey:@"scrollOffset"];
}


- (void)dealloc {
	_sharedInstance = nil;
	[_compleatedMaps release];
	[super dealloc];
}


#pragma mark -
#pragma mark iLabyrinth


+ (iLabyrinth *)sharedInstance {
	@synchronized( [iLabyrinth class] ) {
		if ( !_sharedInstance ) _sharedInstance = [[self alloc] init];
		return _sharedInstance;
	}
	// to avoid compiler warning
	return nil;
}


+ (void)sharedInstanceRelease {
	@synchronized( [iLabyrinth class] ) {
        [_sharedInstance release];
	}
}


+ (NSString *)stateFile {
	return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"lt.ud7.iLabyrinth.state"];
}


+ (NSString *)texturePlistName {
    if( [[CCDirector sharedDirector] contentScaleFactor] > 1.0f ) {
        return @"sprites~ipad.plist";
    }
    
    return [NSString stringWithFormat:@"sprites%@.plist", (isDeviceIPad()?@"~ipad":@"")];
}


+ (NSString *)textureName {
    if( [[CCDirector sharedDirector] contentScaleFactor] > 1.0f ){
        return @"sprites~ipad.png";
    }
    
    return [NSString stringWithFormat:@"sprites%@.png", (isDeviceIPad()?@"~ipad":@"")];
}


+ (BOOL)hightRes {
    if( [[CCDirector sharedDirector] contentScaleFactor] > 1.0f ){
        return YES;
    }
    
    return isDeviceIPad();
}


#pragma mark -


- (void)setMap:(NSUInteger)map asCompleated:(BOOL)compleated {
	if( compleated ){
		[_compleatedMaps addObject:[NSNumber numberWithInt:map]];
	}else{
		[_compleatedMaps removeObject:[NSNumber numberWithInt:map]];
	}
}


- (BOOL)canPlayMap:(NSUInteger)map {
#if TARGET_IPHONE_SIMULATOR
    // If we are on simulator, enable all maps for easyer testing
    return YES;
#endif
    
	if( map == 1 || [_compleatedMaps containsObject:[NSNumber numberWithInt:map]] || [_compleatedMaps containsObject:[NSNumber numberWithInt:map-1]] ){
		return YES;
	}
	return NO;
}


@synthesize scrollOffset=_scrollOffset;
@end
