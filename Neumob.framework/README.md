# Neumob

[![CI Status](http://img.shields.io/travis/Wesley Shi/Neumob.svg?style=flat)](https://travis-ci.org/Wesley Shi/Neumob)
[![Version](https://img.shields.io/cocoapods/v/Neumob.svg?style=flat)](http://cocoapods.org/pods/Neumob)
[![License](https://img.shields.io/cocoapods/l/Neumob.svg?style=flat)](http://cocoapods.org/pods/Neumob)
[![Platform](https://img.shields.io/cocoapods/p/Neumob.svg?style=flat)](http://cocoapods.org/pods/Neumob)

## Introduction

The Neumob SDK for iOS provides a simple API to accelerate your mobile application traffic. Simply including and initializing the Neumob SDK with a single line of code will enable your application access to our cloud network and accelerate your app data traffic.
 
Before you can speed up your application, you’ll need to go through our simple sign up process for a free Neumob account where you can register your application for a client key. If this is your first time using Neumob, check out the [portal](https://portal.neumob.com/) and you can get up and running in less than 5 minutes!

To view the fully updated iOS guide please checkout our [Getting Started Guide](https://neumob.zendesk.com/hc/en-us/articles/206283315)

## Requirements

The minimum compatible iOS version is *7.0*.

## Usage

There is both a bitcode enabled and bitcode disabled version of Neumob. To distinguish whether a version of Neumob has bitcode enabled, check the last digit of the release version.

Ex.
x.x.x.1 -> Bitcode Enabled = No
x.x.x.2 -> Bitcode Enabled = Yes
 
To determine whether your application has bitcode enabled, navigate to your project in XCode and check the *Enable Bitcode* property in your *Build Settings* under *Build Options*.
 
If you use [CocoaPods](http://cocoapods.org), add one of following line to your project’s podfile and run *pod install* or *pod update*.
 
    pod 'Neumob', '3.2.0.1' // Xcode 7 - Bitcode not enabled
    pod 'Neumob', '3.2.0.2' // Xcode 7 - Bitcode enabled

Manual installation (Drag and drop)
 
1. Download and unzip the iOS SDK. You can find under a download link under your App settings on the [portal](https://portal.neumob.com/).
2. Drag *Neumob.framework* into your Xcode project.
3. Link with *SystemConfiguration.framework*, *CoreTelephony.framework*, and *libresolv.9.tbd* (Xcode 7+) or *libresolv.9.dylib* (Xcode 6 and below). We use *SystemConfiguration* and *CoreTelephony* to optimize Neumob configurations for your network and to respond to any changes that may occur. We use *resolv* for DNS related functions.

## Initializing Neumob

Initialization is the process of modifying your application in order to communicate with Neumob. To use Neumob, you’ll have to import the Neumob header into your AppDelegate’s implementation file. For Swift applications, place this import in your *bridging-header.h* file.
 
    // AppDelegate.m or bridging-header.h
    #import <Neumob/Neumob.h>
 
*Initialize* Neumob only once on the main thread at the beginning of your AppDelegate's *application:didFinishLaunchingWithOptions:* method.
 
    // Objective C 
    [Neumob initialize:@"NEUMOB_CLIENT_KEY"];
 
    // Swift
    Neumob.initialize("NEUMOB_CLIENT_KEY");
 
Your client key can be retrieved on the portal by registering an application. Neumob is now integrated with your iOS application!

## Verifying initialization

If you'd like to be notified once initialization is finished, you can add an optional *completionHandler* parameter that executes after *initialize* is completed. To check Neumob's status use the *authenticated*, *initialized*, and *accelerated* API calls.
 
*authenticated* returns a boolean indicating whether the client key used to initialize Neumob was authenticated. Neumob cannot be initialized without the client key being authenticated.
 
*initialized* returns a boolean indicating Neumob is enabled and ready to accelerate your network requests.

*accelerated* returns a boolean indicating whether Neumob is currently accelerating your requests. You may configure whether or not Neumob is accelerated by adjusting the passthrough parameter on the portal. We recommend using the *accelerated* method for A / B testing.
 
Here's an example of how you might verify Neumob initialization.
 
    // Objective C 
    [Neumob initialize:@"NEUMOB_CLIENT_KEY" completionHandler:^{
        if ([Neumob initialized]) {
            BOOL accelerated = [Neumob accelerated];
            ...
        } else if ([Neumob authenticated]) {
            ...
        }
    }];
 
    // Swift
    Neumob.initialize("NEUMOB_CLIENT_KEY", completionHandler: {
         if (Neumob.authenticated()) {
            boolean accelerated = Neumob.accelerated()
            ...
         } else if (Neumob.initialized()) {
               ...
         }
    })
 
At this time, we do not recommend executing your own initialization code inside the completion block. Also note that the block in not run on the main thread.

## Customization

If you'd like to set whether or not Neumob is accelerating your current session's network request through Neumob's custom protocol and cloud, you can use the *setAcceleration* API. This method should once be called ONCE and should take place before Neumob is initialized.

    // Objective C 
    BOOL shouldAccelerate = ... // Determine whether this session should be accelerated
    [Neumob setAcceleration:shouldAccelerate];
    // Initialize Neumob
 
    // Swift
    let shouldAccelerate = ... // Determine whether this session should be accelerated
    Neumob.setAcceleration(shouldAccelerate);
    // Initialize Neumob

## Logging

By default, Neumob logs messages that may to useful to verify Neumob initialization. To disable or tune what log messages are printed use the *setLogLevel* API. To retrieve the current log level use the *logLevel* API.

    // Objective C
    [Neumob setLogLevel:NMLogLevelNone];
    NSLog(@"Current Neumob log level is none: %@", [Neumob logLevel] == NMLogLevelNone ? @"true" : @"false");
 
    // Swift
    Neumob.setLogLevel(NMLogLevel.None);
    print("Current Neumob log level is none: \(Neumob.logLevel() == NMLogLevel.None)")

The logging levels available in order of verbosity are as follows
1. NMLogLevelDetail  - (Default) Print all messages
2. NMLogLevelWarning - Only print warning and error messages
3. NMLogLevelError   - Only print error messages
4. NMLogLevelNone    - Turn off all Neumob log messages

## Disabling Neumob

If for any reason you are looking to disable Neumob, navigate to the portal to your app settings and select the combination of application versions and/or Neumob SDK versions that should be enabled. Once disabled, Neumob will not initialize on the client device.

## Considerations

1. The Neumob iOS SDK has a native dependency which causes the Xcode debugger to stop on SIGPIPEs. These SIGPIPEs will not negatively affect your application and you can ignore them by adding a breakpoint with the debugger command "process handle SIGPIPE -n false -s false"

2. The Neumob iOS SDK uses and registers a custom NSURLProtocol and you can select which hosts you wish for Neumob to accelerate and not to accelerate by implementing a blacklist or whitelist in the portal for your SDK Version and App Version. If you use 3rd party APIs like Google Analytics, we recommend adding those hosts to the blacklist.

## Author

For any questions or concerns, contact Neumob at support@neumob.com

## License

Commercial license. Please see our [Terms and Conditions](https://s3-us-west-1.amazonaws.com/neumob-corporate/TermsofService.html).
