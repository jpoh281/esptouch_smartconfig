//
// Created by jpoh on 3/24/21.
//
/*
#include "EspTouchSmartConfig.h"
// TODO(smaho): Double check which imports are actually needed

@implementation EspTouchSmartConfig

FlutterEventSink _eventSink;

- (void)onEsptouchResultAddedWithResult:(ESPTouchResult *)result {
    NSString *bssid = result.bssid;
    NSString *ip = [ESP_NetUtil descriptionInetAddr4ByData:result.ipAddrData];
    NSDictionary *resultDictionary = @{@"bssid": bssid, @"ip": ip};
    // TODO(smaho): Verify is main queue would not be better. Or is it the main queue?
    dispatch_async(dispatch_get_main_queue(), ^{
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
        NSArray *results =  [self._esptouchTask executeForResults:self.deviceCount];
        NSLog(@"ESPViewController executeForResult() result is: %@", results);
        _eventSink(FlutterEndOfEventStream);
    });
}

- (void)cancel {
    [self._condition lock];
    if (self._esptouchTask != nil) {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}


@end
*/