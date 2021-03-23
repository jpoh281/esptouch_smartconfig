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


import com.espressif.iot.esptouch.EsptouchTask;
import com.espressif.iot.esptouch.IEsptouchListener;
import com.espressif.iot.esptouch.IEsptouchResult;
import com.espressif.iot.esptouch.IEsptouchTask;
import com.espressif.iot.esptouch.task.__IEsptouchTask;
import com.espressif.iot.esptouch.EsptouchTask;
import com.espressif.iot.esptouch.IEsptouchResult;
import com.espressif.iot.esptouch.IEsptouchTask;
import com.espressif.iot.esptouch.util.ByteUtil;
import com.espressif.iot.esptouch.util.TouchNetUtil;



/** EsptouchSmartconfigPlugin */
public class EsptouchSmartconfigPlugin implements FlutterPlugin {

  private MethodChannel methodChannel;
  private static final String TAG = "esptouch_smartconfig";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      setupChannels(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      methodChannel.setMethodCallHandler(null);
      methodChannel = null;
  }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        methodChannel = new MethodChannel(messenger, TAG);

        final WifiManager wifiManager =
                (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        final WifiInfoData wifiInfoFlutter = new WifiInfoData(wifiManager, context);

        final FlutterMethodChannelHandeler methodChannelHandler =
                new FlutterMethodChannelHandeler(wifiInfoFlutter);
        methodChannel.setMethodCallHandler(methodChannelHandler);
    }
}



