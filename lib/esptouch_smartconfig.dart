
import 'dart:async';

import 'package:flutter/services.dart';

class EsptouchSmartconfig {
  static const MethodChannel _channel =
      const MethodChannel('esptouch_smartconfig');

  static Future<Map<String,String>?>  wifiData() async {
    final Map<String,String>? wifiMap =  await _channel.invokeMapMethod('getWifiData');
    return wifiMap;
  }
}
