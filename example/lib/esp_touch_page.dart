import 'dart:async';
import 'package:esptouch_smartconfig/esp_touch_result.dart';
import 'package:esptouch_smartconfig_example/task_route_page.dart';
import 'package:flutter/material.dart';

class EspTouchPage extends StatefulWidget {

  EspTouchPage(this.wifiData);
  
  final Map<String, String>? wifiData;
  @override
  _EspTouchPageState createState() => _EspTouchPageState();
}

class _EspTouchPageState extends State<EspTouchPage> {
   Stream<ESPTouchResult?>? stream;
   late StreamSubscription<ESPTouchResult> streamSubscription;
   List<ESPTouchResult> list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("SSID : ${widget.wifiData!['wifiName']}"),
            Text("BSSID : ${widget.wifiData!['bssid']}"),
            TextButton(
                onPressed: ()async{
                  await showEspTouchDialog2(context);
                },
                child: Text("Start")),
          ],
        ),
      ),
    );
  }

   Future<String?> showEspTouchDialog2(
       BuildContext context) async {
     return await showDialog<String>(
         barrierDismissible: false,
         context: context,
         builder: (context) => TaskRoute());
   }
}
