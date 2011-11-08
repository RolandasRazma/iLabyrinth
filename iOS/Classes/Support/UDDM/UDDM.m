//
//  UDDM.m
//
//  Created by Rolandas Razma on 11/22/10.
//  Copyright 2010 UD7. All rights reserved.
//

#import "UDDM.h"


static UDDM *_sharedUDDM = nil;


#ifdef __OPTIMIZE__
__attribute__((constructor)) static void construct_uddm() {
    @autoreleasepool {
        _sharedUDDM = [NSAllocateObject([UDDM class], 0, nil) init];
    }
}

__attribute__((destructor)) static void destroy_uddm() {
    @autoreleasepool {
        NSDeallocateObject(_sharedUDDM), _sharedUDDM = nil;
    }
}
#endif


@interface UDDM (UDPrivate)

- (void)pushSessionData;
- (void)startSession;
- (NSString *)pushData:(NSDictionary *)data;
- (NSString *)model;

@end


@implementation UDDM {
    NSUInteger      _sessionID;
    NSMutableString *_data;
    NSUInteger      _dataEvents;
    NSTimeInterval  _dataLastEventTime;
}


static NSString *urlencode( NSString *string ) {
    return [((NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, CFSTR("!*’();:@&=+$,/?%#[]"), kCFStringEncodingUTF8)) autorelease];
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    if( &UIApplicationDidEnterBackgroundNotification != NULL ){
        [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                        name: UIApplicationDidEnterBackgroundNotification 
                                                      object: nil];
    }
#endif
    
    [_data release];
    [super dealloc];
}


- (id)init {
    if( (self = [super init]) ){
        _sessionID          = 0;
        _dataEvents         = 0;
        _dataLastEventTime  = 0;
        _data       = [[NSMutableString alloc] init];
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        if( &UIApplicationDidEnterBackgroundNotification != NULL ){
            [[NSNotificationCenter defaultCenter] addObserver: self 
                                                     selector: @selector(pushSessionData) 
                                                         name: UIApplicationDidEnterBackgroundNotification 
                                                       object: nil];
        }
        
        if( &UIApplicationWillEnterForegroundNotification != NULL ){
            [[NSNotificationCenter defaultCenter] addObserver: self 
                                                     selector: @selector(startSession) 
                                                         name: UIApplicationWillEnterForegroundNotification 
                                                       object: nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(pushSessionData) 
                                                     name: UIApplicationWillTerminateNotification 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(startSession) 
                                                     name: UIApplicationDidFinishLaunchingNotification 
                                                   object: nil];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(startSession) 
                                                     name: NSApplicationDidFinishLaunchingNotification 
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(pushSessionData) 
                                                     name: NSApplicationWillTerminateNotification 
                                                   object: nil];
#endif

    }
    return self;
}


#pragma mark -
#pragma mark UDDM


+ (id)sharedInstance {
    return _sharedUDDM;
}


+ (NSString *)UUID {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    if( [[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)] ){
        return [[UIDevice currentDevice] uniqueIdentifier];
    }else{
        NSLog(@"ups");
        return nil;
    }
    /*
     https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5/blob/master/Classes/UIDevice+IdentifierAddition.m
    */
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
    CFStringRef serialNumberAsCFString = NULL;
    
    if ( platformExpert ) {
        serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
        IOObjectRelease(platformExpert);
    }
    
    NSString *serialNumberAsNSString = nil;
    if (serialNumberAsCFString) {
        serialNumberAsNSString = [NSString stringWithString:(NSString *)serialNumberAsCFString];
        CFRelease(serialNumberAsCFString);
    }
    
    return serialNumberAsNSString;
#endif
}


- (NSString *)model {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    return [[UIDevice currentDevice] model];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    NSString *deviceModel = nil;
    io_struct_inband_t iokit_entry;
    uint32_t bufferSize = 4096; // this signals the longest entry we will take
    io_registry_entry_t ioRegistryRoot = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/");
    
    IORegistryEntryGetProperty(ioRegistryRoot, "model", iokit_entry, &bufferSize);
    
    deviceModel = [NSString stringWithCString: iokit_entry encoding: NSASCIIStringEncoding];
    
    IOObjectRelease((unsigned int) iokit_entry);
    IOObjectRelease(ioRegistryRoot);
    
    return deviceModel;
#endif
}


- (void)startSession {
    _dataLastEventTime = [NSDate timeIntervalSinceReferenceDate];
    [_data setString:@""];
    
    [_data appendFormat:@"s[di]=%@&",   urlencode([UDDM UUID])];
    [_data appendFormat:@"s[bi]=%@&",   urlencode([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])];
    [_data appendFormat:@"s[bv]=%@&",   urlencode([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])];
    [_data appendFormat:@"s[li]=%@&",   urlencode([[NSLocale currentLocale] localeIdentifier])];
    [_data appendFormat:@"s[dm]=%@&",   urlencode([self model])];
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [_data appendFormat:@"s[sn]=%@&",   urlencode([[UIDevice currentDevice] systemName])];
    [_data appendFormat:@"s[sv]=%@&",   urlencode([[UIDevice currentDevice] systemVersion])];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    SInt32 major, minor, bugFix;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    Gestalt(gestaltSystemVersionBugFix, &bugFix);
    
    [_data appendString:@"s[sn]=OSX&"];
    [_data appendFormat:@"s[sv]=%i.%i.%i&", major, minor, bugFix];
#endif
    
    [self pushSessionData];
}


- (void)pushSessionData {
    if( ![_data length] ) return;

    NSData *dataToPush = nil;
    @synchronized( _data ){
        [_data replaceOccurrencesOfString:@"[" withString:@"%5B" options:NSLiteralSearch range:NSMakeRange(0, [_data length])];
        [_data replaceOccurrencesOfString:@"]" withString:@"%5D" options:NSLiteralSearch range:NSMakeRange(0, [_data length])];
        [_data deleteCharactersInRange:NSMakeRange([_data length] -1, 1)];
        
        dataToPush = [_data dataUsingEncoding:NSUTF8StringEncoding];
        
        [_data setString:@""];
    }
    
    if( [dataToPush length] ){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://dm.ud7.com/mine/"]];
        [request setTimeoutInterval:60.0f];
        [request setHTTPMethod:@"POST"];	
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[UDDM UUID] forHTTPHeaderField:@"udid"];
        [request setHTTPBody:dataToPush];

        [[NSURLConnection connectionWithRequest:request delegate:self] start];
    }
}


- (void)trackEvent:(NSString *)event {
    [self trackEvent:event value:nil];
}


- (void)trackEvent:(NSString *)event value:(NSString *)value {
    @synchronized( _data ){
        NSTimeInterval eventTime = [NSDate timeIntervalSinceReferenceDate];
        
        [_data appendFormat:@"e[%u][e]=%@&", _dataEvents, urlencode(event)];
        [_data appendFormat:@"e[%u][d]=%g&", _dataEvents, round(eventTime -_dataLastEventTime)];
        if( [value length] ){
            [_data appendFormat:@"e[%u][v]=%@&", _dataEvents, urlencode(value)];
        }

        _dataEvents++;
    }
    
    if( [_data length] >= 1024 ) [self pushSessionData];
}
              

@end
