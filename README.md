# esptouch_smartconfig

Espressif’s ESP-TOUCH protocol implements the Smart Config technology to help users
connect ESP8266EX- and ESP32-embedded devices (hereinafter referred to as the device)
to a Wi-Fi network through simple configuration on a smartphone flutter app. 



## Getting Started

### Android

Add Permission android/app/src/main/AndroidManifest.xml 

```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
```

### iOS

![image](https://user-images.githubusercontent.com/54665433/112471789-ab707800-8daf-11eb-9b44-c3fc00739e09.png)

Add ios/Info.plist
```
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Used to Location's Info always for Using Beacon.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Used to Location's Info always for Using Beacon.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Used to Location's Info for Using Beacon when In Use.</string>
```
## Usage
```
late Stream<ESPTouchResult>? _stream;
final Set<ESPTouchResult> _results = Set();

@override
  void initState() {
    _stream = EsptouchSmartconfig.run(widget.ssid, widget.bssid,
        widget.password, widget.deviceCount, widget.isBroadcast);
    super.initState();
  }
  
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

```


## Reference

### ESP Touch
https://github.com/smaho-engineering/esptouch_flutter </br>
https://github.com/kittenbot/flutter_smartconfig </br>
https://github.com/EspressifApp/EsptouchForIOS </br>
https://github.com/EspressifApp/EsptouchForAndroid </br>

### Wifi Info
https://github.com/flutter/plugins
