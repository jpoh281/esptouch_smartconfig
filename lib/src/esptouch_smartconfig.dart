import 'dart:async';
import 'package:esptouch_smartconfig/src/esp_touch_result.dart';
import 'package:flutter/services.dart';

class EsptouchSmartconfig {
  static const MethodChannel _methodChannel =
      const MethodChannel('esptouch_smartconfig');

  static const EventChannel _eventChannel =
      const EventChannel('esptouch_smartconfig/result');

  static Future<Map<String, String>?> wifiData() async {
    final Map<String, String>? wifiMap =
        await _methodChannel.invokeMapMethod('getWifiData');
    return wifiMap;
  }

  static Stream<ESPTouchResult>? run(
      {required String ssid,
      required String bssid,
      String password = "",
      String deviceCount = "1",
      bool isBroad = true}) {
    return _eventChannel.receiveBroadcastStream({
      'ssid': ssid,
      'bssid': bssid,
      'password': password,
      "deviceCount": deviceCount,
      'isBroad': (isBroad) ? "YES" : "NO"
    }).map((event) => ESPTouchResult.fromMap(event));
  }
}
