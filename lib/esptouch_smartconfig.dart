
import 'dart:async';

import 'package:esptouch_smartconfig/esp_touch_result.dart';
import 'package:flutter/services.dart';

class EsptouchSmartconfig {
  static const MethodChannel _methodChannel =
      const MethodChannel('esptouch_smartconfig');

  static const EventChannel _eventChannel = const EventChannel('esptouch_smartconfig/result');



  static Future<Map<String,String>?>  wifiData() async {
    final Map<String,String>? wifiMap =  await _methodChannel.invokeMapMethod('getWifiData');
    return wifiMap;
  }

  static Stream<ESPTouchResult>? run(){
    return _eventChannel.receiveBroadcastStream({  'ssid': "AHQLab_Dev",
      'bssid': "88:36:6c:31:66:58",
      'password': "ahqlab3596","deviceCount" : "2"}).map((event) => ESPTouchResult.fromMap(event));
  }

}
