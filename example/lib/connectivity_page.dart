import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:esptouch_smartconfig_example/wifi_page.dart';
import 'package:flutter/material.dart';

class ConnectivityPage extends StatefulWidget {
  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {

  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivitySubscription = _connectivityStream.listen((e){
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EspTouch"),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
        future: _connectivity.checkConnectivity(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Center(
            child: CircularProgressIndicator(),
          );
          else if(snapshot.data == ConnectivityResult.wifi)
            return WifiPage();
          else return Column(
              children: [
                Icon(Icons.wifi_off_sharp),
                Text("No Wifi")
              ],
            );
        }
      ),
    );
  }
}
