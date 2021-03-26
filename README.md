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

## Reference

### ESP Touch
https://github.com/smaho-engineering/esptouch_flutter
https://pub.dev/packages/smartconfig
https://github.com/EspressifApp/EsptouchForIOS
https://github.com/EspressifApp/EsptouchForAndroid

### Wifi Info
https://github.com/flutter/plugins
