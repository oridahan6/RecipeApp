//
//  Neumob.h
//  Neumob iOS Library
//
//  Copyright (c) 2015 Neumob, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NMLogLevel) {
    NMLogLevelDetail  = 0x1,
    NMLogLevelWarning = 0x3,
    NMLogLevelError   = 0x4,
    NMLogLevelNone    = 0xF
};

@interface Neumob : NSObject

// Use initialize in order to setup the Neumob library. After successful initialization,
// your network calls will automatically use Neumob's cloud and optimizations!
+ (void) initialize:(NSString*)clientKey;

// Initialize call where a completionHandler block is run after Neumob is asychronously
// initialized. The completionHandler is not be run on the main thread.
+ (void) initialize:(NSString*)clientKey completionHandler: (void (^)(void))completionHandler;

// DEPRECATED: please use `+initialize:completionHandler:` instead.
// Initialize call where a completionHandler block is run after Neumob is asychronously
// initialized. The completionHandler is not be run on the main thread.
+ (void) initialize:(NSString*)clientKey OnComplete: (void (^)(void))completionHandler DEPRECATED_MSG_ATTRIBUTE("This method has been renamed to `+initialize:completionHandler:`");

// Authenticated will return true if the client key is authenticated by the portal.
+ (BOOL) authenticated;

// Initialized returns a boolean indicating Neumob is enabled and ready to accelerate
// your network requests. Client must be authenticated before it can be initialized.
+ (BOOL) initialized;

// Accelerated will return Neumob is currently accelerating network requests. If Neumob
// is not initialized, then accelerated will return false.
+ (BOOL) accelerated;

// logLevel will return the current log level used by the Neumob library
+ (NMLogLevel)logLevel;

// Set the logLevel for the Neumob library
+ (void)setLogLevel:(NMLogLevel)logLevel;

@end
