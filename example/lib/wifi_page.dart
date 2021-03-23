import 'package:esptouch_smartconfig/esptouch_smartconfig.dart';
import 'package:esptouch_smartconfig_example/esp_touch_page.dart';
import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String>?>(
        future: EsptouchSmartconfig.wifiData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return EspTouchPage(snapshot.data);
            else return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
