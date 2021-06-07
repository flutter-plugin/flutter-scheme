#import "FlutterSchemePlugin.h"


static NSString *const kMessagesChannel = @"scheme/flutter.app.method";
static NSString *const kEventChannel = @"scheme/flutter.app.event";


@interface FlutterSchemePlugin () <FlutterStreamHandler>

@property(nonatomic, copy) NSDictionary *initialScheme;
@property(nonatomic, copy) NSDictionary *latestScheme;

@end


@implementation FlutterSchemePlugin{
    FlutterEventSink _eventSink;
}

static id _instance;

+ (FlutterSchemePlugin *)sharedInstance{
    if (_instance == nil) {
        _instance = [[FlutterSchemePlugin alloc] init];
    }
    return _instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterSchemePlugin *instance = [FlutterSchemePlugin sharedInstance];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:kMessagesChannel binaryMessenger:[registrar messenger]];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:kEventChannel binaryMessenger:[registrar messenger]];
    
    [eventChannel setStreamHandler:instance];
    
    ///MARK 注册应用启动回调
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"getInitScheme" isEqualToString:call.method]){
      result(_initialScheme);
  }else if([@"getLatestScheme" isEqualToString:call.method]){
      result(_latestScheme);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [self foundSchemeURL:[userActivity webpageURL]];
        return YES;
    }
    return  NO;
}

- (void)foundSchemeURL:(NSURL * _Nullable)url {
    NSString *_scheme = @"";
    NSString *_host = @"";
    int _port = -1;
    NSString *_query = @"";
    NSString *_path = @"";
    
    if([url scheme]){_scheme = [url scheme];}
    else{return;}
    if([url host]){_host = [url host];}
    if([url port]){_port = [[url port] intValue];}
    if([url query]){_query = [url query];}
    if([url path]){_path = [url path];}
    
    NSDictionary *schemeMap = @{
        @"scheme":_scheme,
        @"host":_host,
        @"port":[[NSNumber alloc] initWithInt:_port],
        @"path":_path,
        @"query":_query,
        @"source":@"ios",
        @"dataString":[url absoluteString]
    };
    if(!_initialScheme){
        _initialScheme = schemeMap;
    }
    _latestScheme = schemeMap;
    
    static NSString *key = @"latestLink";
    [self willChangeValueForKey:key];
    
    [self didChangeValueForKey:key];
    
    if (_eventSink) _eventSink(schemeMap);
}


#pragma mark - didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSURL *url = (NSURL *)launchOptions[UIApplicationLaunchOptionsURLKey];
    if(url){
        [self foundSchemeURL: url];
    }
    return YES;
}

#pragma mark - handleOpenURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [self foundSchemeURL:url];
    return YES;
}

#pragma mark - openURL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [self foundSchemeURL:url];
    return YES;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    _eventSink = events;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments{
    _eventSink = nil;
    return nil;
}


@end
