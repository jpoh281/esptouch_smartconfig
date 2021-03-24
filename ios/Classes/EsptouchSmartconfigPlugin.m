#import "EsptouchSmartconfigPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import "SystemConfiguration/CaptiveNetwork.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@implementation EsptouchSmartconfigPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"esptouch_smartconfig"
            binaryMessenger:[registrar messenger]];

   //FlutterEventChannel* eventChannel = [FlutterEventChannel
   //        eventChannelWithName:@"esptouch_smartconfig/result"
   //             binaryMessenger:[registrar messenger]];

  EsptouchSmartconfigPlugin* instance = [[EsptouchSmartconfigPlugin alloc] init];

  [registrar addMethodCallDelegate:instance channel:channel];
}

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
  return info;
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

@end
