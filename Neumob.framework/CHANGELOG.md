##3.2.0

Use 3.2.0.1 for bitcode enabled = NO
Use 3.2.0.2 for bitcode enabled = YES

- User acceleration is now sticky. Please see "Verifying Integration" at http://docs.neumob.com/ios/ios.html#verifying-integration.
- Improved SSL request acceleration and SSL metrics.

##3.1.0

Use 3.1.0.1 for bitcode enabled = NO
Use 3.1.0.2 for bitcode enabled = YES

- Supports SSL session resume to reduce request initialization time.
- Fixed an issue with metrics reporting.

##3.0.1

Use 3.0.1.1 for bitcode enabled = NO
Use 3.0.1.2 for bitcode enabled = YES

- SSL acceleration

##2.4.2

Use 2.4.2.1 for bitcode enabled = NO
Use 2.4.2.2 for bitcode enabled = YES

- Improved SDK init

##2.4.1

Use 2.4.1.1 for bitcode enabled = NO
Use 2.4.1.2 for bitcode enabled = YES

- Performance improvements
- setAcceleration API update, see README

##2.4.0

Use 2.4.0.1 for bitcode enabled = NO
Use 2.4.0.2 for bitcode enabled = YES

- iOS 10 compatibile
- Added API to set Neumob logging level

##2.3.5

Use 2.3.5.1 for bitcode enabled = NO
Use 2.3.5.2 for bitcode enabled = YES

- Stability improvements

##2.3.4

Use 2.3.4.1 for bitcode enabled = NO
Use 2.3.4.2 for bitcode enabled = YES

- Fixed a caching issue
- Improved network connection errors when backgrounding/foregrounding repeatedly
- Fixed an IPv6 compatibility issue for iOS 7/8
- Improved network transition between IPv4 an IPv6

##2.3.3

Use 2.3.3.1 for bitcode enabled = NO
Use 2.3.3.2 for bitcode enabled = YES

- Stability and performance improvements

##2.3.2

Use 2.3.2.1 for bitcode enabled = NO
Use 2.3.2.2 for bitcode enabled = YES

- Support for IPv6 only networks

##2.3.1

Use 2.3.1.1 for bitcode enabled = NO
Use 2.3.1.2 for bitcode enabled = YES

- Stability and performance improvements
- Neumob header tagging for accelerated requests

##2.3.0

Use 2.3.0.1 for bitcode enabled = NO
Use 2.3.0.2 for bitcode enabled = YES

- Improved networking protocol 
- Improved SSL metrics
- Improved support for chunked downloads
- Fixed SHA1 linker collision

##2.2.1

Use 2.2.1.1 for bitcode enabled = NO
Use 2.2.1.2 for bitcode enabled = YES

- Avoid accelerating localhost and private IP addresses
- Graceful restart upon OS shutdown of ports

##2.2.0

Use 2.2.0.1 for bitcode enabled = NO
Use 2.2.0.2 for bitcode enabled = YES

- Improved SSL networking metrics

##2.1.1

Use 2.1.1.1 for bitcode enabled = NO
Use 2.1.1.2 for bitcode enabled = YES

- Improved handling of network changes

##2.1.0

Use 2.1.0.1 for bitcode enabled = NO
Use 2.1.0.2 for bitcode enabled = YES

- Improved SDK analytics for better metrics
- Improved handling of SSL traffic

##2.0.9

Use 2.0.9.1 for bitcode enabled = NO
Use 2.0.9.2 for bitcode enabled = YES

- Internal updates

##2.0.8

Use 2.0.8.1 for bitcode enabled = NO
Use 2.0.8.2 for bitcode enabled = YES

- Fixed a potential issue that could cause a memory leak
- Internal updates

##2.0.7

Use 2.0.7.1 for bitcode enabled = NO
Use 2.0.7.2 for bitcode enabled = YES

- Fixed an internal issue where non-ASCII characters were incorrectly sent for Neumob metrics
- Fixed an iOS 7 crash issue

##2.0.6

Use 2.0.6.1 for bitcode enabled = NO
Use 2.0.6.2 for bitcode enabled = YES

- Full support for custom NSURLSession based requests from custom configurations
- SDK auto-shutdown for internal errors
- Fixed a few potential error scenarios
- Improved request metrics reporting
- Updated init API per Apple conventions

##2.0.5

Use 2.0.5.1 for bitcode enabled = NO
Use 2.0.5.2 for bitcode enabled = YES

- Added support for NSURLSession based requests from custom configurations for iOS 9+
- Added setAcceleration API
- IPv6 initialization support

##2.0.4

Use 2.0.4.1 for bitcode enabled = NO
Use 2.0.4.2 for bitcode enabled = YES

- Increased number of supported servers

##2.0.3

Use 2.0.3.1 for bitcode enabled = NO
Use 2.0.3.2 for bitcode enabled = YES

- Fixed a bug in blacklist / whitelist implementation

##2.0.2

Use 2.0.2.1 for bitcode enabled = NO
Use 2.0.2.2 for bitcode enabled = YES

- Updated SDK blacklist / whitelist logic to be simpler

##2.0.1

Use 2.0.1.1 for bitcode enabled = NO
Use 2.0.1.2 for bitcode enabled = YES

- Removed the 'terminate' API call, which will not be supported in future versions
- Fixed a bug where requests might not be accelerated upon foreground

##2.0.0

Use 2.0.0.1 for bitcode enabled = NO
Use 2.0.0.2 for bitcode enabled = YES

- Neumob Protocol support
- Faster initialization process
- Internal updates for metrics and analytics
- Added passthrough mode where requests are not accelerated for internal statistics
- Blacklist / Whitelist support
