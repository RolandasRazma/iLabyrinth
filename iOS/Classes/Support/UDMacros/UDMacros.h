//
//  UDMacros.h
//
//  Created by Rolandas Razma on 11/14/09.
//  Copyright 2009 UD7. All rights reserved.
//

#define _(format, ...) [[NSBundle mainBundle] localizedStringForKey: [NSString stringWithFormat:@"%@", [NSString stringWithFormat:format, ##__VA_ARGS__]] value:@"" table:nil]
#define MAX3(A,B,C) MAX(MAX(A, B), C)


static BOOL isDeviceIPad(){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return YES;
    }
#endif
    return NO;
}


static BOOL isOS32Up(){
    return ( &UIKeyboardFrameEndUserInfoKey != NULL );
}


static BOOL isOS40Up(){
    return ( &UIApplicationWillEnterForegroundNotification != NULL );
}


static BOOL isOS42Up(){
    return ( &UITextInputCurrentInputModeDidChangeNotification != NULL );
}


static BOOL isOS50Up() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    return ( &UIKeyboardWillChangeFrameNotification != NULL );
#endif
    return NO;
}


static NSString *imgSufix( NSString *forIpad ){
    if( isDeviceIPad() ){
        return forIpad;
    }else{
        UIScreen *mainScreen = [UIScreen mainScreen];        
        if( [mainScreen respondsToSelector:@selector(scale)] && [mainScreen scale] == 2.0f ){
            return @"@2x";
        }
    }
    return @"";
}


static BOOL isGameCenterAvailable() {
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}
