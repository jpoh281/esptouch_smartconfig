//
// Created by jpoh on 3/24/21.
//
#import "FlutterEventChannelHandler.h"

@implementation FlutterEventChannelHandler


- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    NSDictionary *args = arguments;
    NSString *bssid = args[@"bssid"];
    NSString *ssid = args[@"ssid"];
    NSString *password = args[@"password"];
    NSString *deviceCount = args[@"deviceCount"];
    NSString *broadcast = args[@"isBroad"];

    // TODO(smaho): packet is a bool value, should pass it as such
    // This requires Dart+Java+ObjC refactors as it's the plugin's interface
    //BOOL packet = [args[@"packet"] isEqual:@"1"];
    //NSDictionary *taskParameterArgs = args[@"taskParameter"];
    //ESPTaskParameter *taskParameter = [self buildTaskParameter:taskParameterArgs];
    EsptouchSmartConfig *smartConfig = [[EsptouchSmartConfig alloc]
        initWithSSID:bssid
              andBSSID:ssid
          andPassword:password
    andTaskParameters:taskParameter
        withBroadcast:packet
    ];
    [smartConfig listen:eventSink];
    self.smartConfig = smartConfig;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    if (self.smartConfig != nil) {
        [self.smartConfig cancel];
    }
    return nil;
}

@end