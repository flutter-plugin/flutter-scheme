#import <Flutter/Flutter.h>

@protocol SchemeUriDelegate <NSObject>
- (void)foundSchemeURL:(NSURL * _Nullable)url;
@end

@interface FlutterSchemePlugin : NSObject<FlutterPlugin,SchemeUriDelegate>

+ (_Nullable instancetype)sharedInstance;

@end
