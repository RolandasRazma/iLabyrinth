//
//  UDMacros.h
//
//  Created by Rolandas Razma on 11/14/09.
//  Copyright 2009 UD7. All rights reserved.
//

static BOOL isDeviceIPad(){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return YES;
    }
#endif
    return NO;
}
