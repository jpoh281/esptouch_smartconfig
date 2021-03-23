package com.jpoh.esptouch_smartconfig;

import androidx.annotation.NonNull;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.location.LocationManager;

import androidx.core.content.ContextCompat;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.EventChannel;


import com.espressif.iot.esptouch.EsptouchTask;
import com.espressif.iot.esptouch.IEsptouchListener;
import com.espressif.iot.esptouch.IEsptouchResult;
import com.espressif.iot.esptouch.IEsptouchTask;
import com.espressif.iot.esptouch.task.EsptouchTaskParameter;
import com.espressif.iot.esptouch.task.__IEsptouchTask;
import com.espressif.iot.esptouch.EsptouchTask;
import com.espressif.iot.esptouch.IEsptouchResult;
import com.espressif.iot.esptouch.IEsptouchTask;
import com.espressif.iot.esptouch.util.ByteUtil;
import com.espressif.iot.esptouch.util.TouchNetUtil;

public class FlutterEventChannelHandler implements EventChannel.StreamHandler {
    private static final String TAG = "EsptouchPlugin";
    private static final String CHANNEL_NAME= "esptouch_smartconfig/result";

    private final Context context;
    final EventChannel eventChannel;

    private MainThreadEventSink eventSink;
    private EsptouchAsyncTask esptouchAsyncTask;

    FlutterEventChannelHandler(Context context, EventChannel eventChannel) {
        this.context = context;
        this.eventChannel = eventChannel;
        eventChannel.setStreamHandler(this);
    }

    @Override
    @SuppressWarnings("unchecked")
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Log.d(TAG, "Event Listener is triggered");
        Map<String, Object> map = (Map<String, Object>) o;
        String ssid = (String) map.get("ssid");
        String bssid = (String) map.get("bssid");
        String password = (String) map.get("password");
        String deviceCount = (String) map.get("deviceCount");
        Log.d(TAG, String.format("Received stream configuration arguments: SSID: %s, BBSID: %s, Password: %s", ssid, bssid, password));
        this.eventSink = new MainThreadEventSink(eventSink);
        esptouchAsyncTask = new EsptouchAsyncTask(context, this.eventSink);

        esptouchAsyncTask.execute(ssid, bssid, password, deviceCount);


//        // TODO(smaho): packet is a bool value, should pass it as such
//        String packet = (String) map.get("packet");
//        Map<String, Integer> taskParameterMap = (Map<String, Integer>) map.get("taskParameter");
//        Log.d(TAG, String.format("Received stream configuration arguments: SSID: %s, BBSID: %s, Password: %s, Packet: %s, Task parameter: %s", ssid, bssid, password, packet, taskParameterMap));
//        EsptouchTaskParameter taskParameter = buildTaskParameter(taskParameterMap);
//        Log.d(TAG, String.format("Converted taskUtil parameter from map %s to EsptouchTaskParameter %s.", taskParameterMap, taskParameter));
//        taskUtil = new EspTouchTaskUtil(context, ssid, bssid, password, packet.equals("1"), taskParameter);
//        taskUtil.listen(eventSink);
    }

    @Override
    public void onCancel(Object o) {
        Log.d(TAG, "Cancelling stream with configuration arguments" + o);
    }
}
