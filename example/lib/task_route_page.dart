import 'dart:async';
import 'package:esptouch_smartconfig/esptouch_smartconfig.dart';
import 'package:flutter/material.dart';

class TaskRoute extends StatefulWidget {
  TaskRoute(
      this.ssid, this.bssid, this.password, this.deviceCount, this.isBroadcast);
  final String ssid;
  final String bssid;
  final String password;
  final String deviceCount;
  final bool isBroadcast;
  @override
  State<StatefulWidget> createState() {
    return TaskRouteState();
  }
}

class TaskRouteState extends State<TaskRoute> {
  late Stream<ESPTouchResult>? _stream;

  @override
  void initState() {
    _stream = EsptouchSmartconfig.run(
        ssid: widget.ssid,
        bssid: widget.bssid,
        password: widget.password,
        deviceCount: widget.deviceCount,
        isBroad: widget.isBroadcast);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget waitingState(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ),
          SizedBox(height: 16),
          Text(
            'Waiting for results',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget error(BuildContext context, String s) {
    return Center(
      child: Text(
        s,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget noneState(BuildContext context) {
    return Center(
        child: Text(
      'None',
      style: TextStyle(fontSize: 24),
    ));
  }

  Widget resultList(BuildContext context, ConnectionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (_, index) {
              final result = _results.toList(growable: false)[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('BSSID: '),
                        Text(result.bssid),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('IP: '),
                        Text(result.ip),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        if (state == ConnectionState.active)
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ),
      ],
    );
  }

  final Set<ESPTouchResult> _results = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_results);
            }),
        backgroundColor: Colors.red,
        title: Text(
          'Task',
        ),
      ),
      body: Container(
        child: StreamBuilder<ESPTouchResult>(
          stream: _stream,
          builder: (context, AsyncSnapshot<ESPTouchResult> snapshot) {
            if (snapshot.hasError) {
              return error(context, 'Error in StreamBuilder');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                _results.add(snapshot.data!);
                return resultList(context, ConnectionState.active);
              case ConnectionState.none:
                return noneState(context);
              case ConnectionState.done:
                if (snapshot.hasData) {
                  _results.add(snapshot.data!);
                  return resultList(context, ConnectionState.done);
                } else
                  return noneState(context);
              case ConnectionState.waiting:
                return waitingState(context);
            }
          },
        ),
      ),
    );
  }
}
