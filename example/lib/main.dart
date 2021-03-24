import 'package:esptouch_smartconfig/esp_touch_result.dart';
import 'package:esptouch_smartconfig_example/connectivity_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:esptouch_smartconfig/esptouch_smartconfig.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.location.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: ConnectivityPage());
  }
}
