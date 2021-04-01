#import <CoreLocation/CoreLocation.h>
#import "SystemConfiguration/CaptiveNetwork.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "EsptouchSmartconfigPlugin.h"

@implementation EsptouchSmartconfigPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"esptouch_smartconfig"
            binaryMessenger:[registrar messenger]];

  FlutterEventChannel* eventChannel = [FlutterEventChannel
          eventChannelWithName:@"esptouch_smartconfig/result"
               binaryMessenger:[registrar messenger]];


  EsptouchSmartconfigPlugin* instance = [[EsptouchSmartconfigPlugin alloc] init];
    FlutterEventChannelHandler *resultsStreamHandler = [[FlutterEventChannelHandler alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [eventChannel setStreamHandler:resultsStreamHandler];
}

// <--- get wifi
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getWifiData" isEqualToString:call.method]) {
    result([self getWifiData]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString*)findNetworkInfo:(NSString*)key {
  NSString* info = nil;
  NSArray* interfaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
  for (NSString* interfaceName in interfaceNames) {
    NSDictionary* networkInfo =
        (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
    if (networkInfo[key]) {
      info = networkInfo[key];
    }
  }
  return (info == nil || [@"" isEqualToString:info]) ? @"" : info;
}

- (NSDictionary*)getWifiData {
    NSString* wifiName = [self findNetworkInfo:@"SSID"];
    NSString* bssid = [self findNetworkInfo:@"BSSID"];
    NSString* address = @"error";
      struct ifaddrs* interfaces = NULL;
      struct ifaddrs* temp_addr = NULL;
      int success = 0;
      // retrieve the current interfaces - returns 0 on success
      success = getifaddrs(&interfaces);
      if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
          if (temp_addr->ifa_addr->sa_family == AF_INET) {
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
              // Get NSString from C String
              address = [NSString
                  stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr)];
            }
          }
          temp_addr = temp_addr->ifa_next;
        }
      }
      // Free memory
      freeifaddrs(interfaces);

     NSDictionary* wifiData = @{@"wifiName":wifiName, @"bssid":bssid, @"ip":address};
  return wifiData;
}
// --->
@end

@implementation EspTouchSmartConfig

FlutterEventSink _eventSink;

- (void)onEsptouchResultAddedWithResult:(ESPTouchResult *)result {
    NSString *bssid = result.bssid;
    NSString *ip = [ESP_NetUtil descriptionInetAddr4ByData:result.ipAddrData];
    NSDictionary *resultDictionary = @{@"bssid": bssid, @"ip": ip};
    dispatch_async(dispatch_get_current_queue(), ^{
        _eventSink(resultDictionary);
    });
}

- (id)initWithSSID:(NSString *)ssid
            andBSSID:(NSString *)bssid
        andPassword:(NSString *)password
  andDeviceCount:(NSString *)deviceCount
      withBroadcast:(NSString *)isBroad {
    self = [super init];
    self.bssid = bssid;
    self.ssid = ssid;
    self.password = password;
    self.deviceCount = [deviceCount intValue];
    self.isBroad = [isBroad isEqualToString:@"YES"] ? YES : NO;
    return self;
}

- (void)listen:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
     [self._condition lock];
     self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:self.ssid andApBssid:self.bssid andApPwd:self.password];
     [self._esptouchTask setEsptouchDelegate:self];
     [self._esptouchTask setPackageBroadcast:self.isBroad];
     [self._condition unlock];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *results = [self._esptouchTask executeForResults:self.deviceCount];
        NSLog(@"executeForResult() result is: %@", results);
        if(_eventSink)
            _eventSink(FlutterEndOfEventStream);
    });
}

- (void)cancel {
    [self._condition lock];
    if (self._esptouchTask != nil) {
        [self._esptouchTask interrupt];
        _eventSink = nil;
    }
    [self._condition unlock];

}
@end


@implementation FlutterEventChannelHandler


- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    NSDictionary *args = arguments;
    NSString *bssid = args[@"bssid"];
    NSString *ssid = args[@"ssid"];
    NSString *password = args[@"password"];
    NSString *deviceCount = args[@"deviceCount"];
    NSString *broadcast = args[@"isBroad"];

    EspTouchSmartConfig *smartConfig = [[EspTouchSmartConfig alloc]
        initWithSSID:ssid
              andBSSID:bssid
          andPassword:password
    andDeviceCount:deviceCount
        withBroadcast:broadcast
    ];

    self.smartConfig = smartConfig;
    [self.smartConfig listen:eventSink];

    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    if (self.smartConfig != nil) {
        [self.smartConfig cancel];
        // need or not?
        //self.smartConfig = nil;
    }
    return nil;
}

@end
