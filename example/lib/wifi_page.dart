import 'package:esptouch_smartconfig/esp_touch_result.dart';
import 'package:esptouch_smartconfig_example/task_route_page.dart';
import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {

  WifiPage(this.ssid, this.bssid);

  final String ssid;
  final String bssid;

  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {

  bool isBroad = true;
  TextEditingController password = TextEditingController();
  TextEditingController deviceCount = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    children: [
                      TextSpan(text: "SSID:",
                          style: TextStyle(fontSize: 14, color: Colors.pink)),
                      TextSpan(text: widget.ssid,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ]
                )),
                SizedBox(
                  height: 6,
                ),
                Text.rich(TextSpan(
                    children: [
                      TextSpan(text: "BSSID:",
                          style: TextStyle(fontSize: 14, color: Colors.pink)),
                      TextSpan(text: widget.bssid,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ]
                )),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  controller: password,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelText: "Password:",
                      suffixIcon: Icon(
                          Icons.remove_red_eye, color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black),
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: deviceCount,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelText: "DeviceCount:",
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black),
                      )
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                        groupValue: isBroad,
                        value: true,
                        activeColor: Colors.red,
                        onChanged: (bool? value) {
                          setState(() {
                            isBroad = value!;
                          });
                        }),
                    Text("BroadCast"),
                    SizedBox(width: 6),
                    Radio<bool>(
                        groupValue: isBroad,
                        value: false,
                        activeColor: Colors.red,
                        onChanged: (bool? value) {
                          setState(() {
                            isBroad = value!;
                          });
                        }),
                    Text("MultiCast"),
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      print(password.text);
                      print(deviceCount.text);
                      Set<ESPTouchResult> result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskRoute(widget.ssid, widget.bssid, password.text,deviceCount.text, isBroad)));
                      print("result : $result");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.red)
                    ),
                    child: Text("CONFIRM")),
              ],
            ),
          ),
        ));
  }
}