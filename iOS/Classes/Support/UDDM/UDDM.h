//
//  UDDM.h
//
//  Created by Rolandas Razma on 11/22/10.
//  Copyright 2010 UD7. All rights reserved.
//
//  Requires OSX:
//              IOKit
//

#import <Foundation/Foundation.h>


@interface UDDM : NSObject 

+ (id)sharedInstance;
+ (NSString *)UUID;

- (void)trackEvent:(NSString *)event;
- (void)trackEvent:(NSString *)event value:(NSString *)value;

@end
