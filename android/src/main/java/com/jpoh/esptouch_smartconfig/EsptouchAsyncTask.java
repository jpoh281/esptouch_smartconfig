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

public class EsptouchAsyncTask extends AsyncTask<String, IEsptouchResult, List<IEsptouchResult>> {
//    private final WeakReference<EspTouchActivity> mActivity;
private static final String TAG = "EspTouchAsyncTask";
    private final Object mLock = new Object();
    private Context context;
    private IEsptouchTask mEsptouchTask;
    MainThreadEventSink eventSink;
    EsptouchAsyncTask( Context context, MainThreadEventSink eventSink) {
//            EspTouchActivity activity
    this.context = context;
    this.eventSink = eventSink;
//        mActivity = new WeakReference<EspTouchActivity>(activity);
    }

    void cancelEsptouch() {
        cancel(true);
//        EspTouchActivity activity = mActivity.get();
//        if (activity != null) {
//            activity.showProgress(false);
//        }
        if (mEsptouchTask != null) {
            mEsptouchTask.interrupt();
        }
    }

    @Override
    protected void onPreExecute() {
//        EspTouchActivity activity = mActivity.get();
//        activity.mBinding.testResult.setText("");
//        activity.showProgress(true);
    }

    @Override
    protected void onProgressUpdate(IEsptouchResult... values) {
//        EspTouchActivity activity = mActivity.get();
//        if (activity != null) {
//            IEsptouchResult result = values[0];
//            Log.i(TAG, "EspTouchResult: " + result);
//            String text = result.getBssid() + " is connected to the wifi";
//            Toast.makeText(activity, text, Toast.LENGTH_SHORT).show();
//
//            activity.mBinding.testResult.append(String.format(
//                    Locale.ENGLISH,
//                    "%s,%s\n",
//                    result.getInetAddress().getHostAddress(),
//                    result.getBssid()
//            ));
//        }
    }

    @Override
    protected List<IEsptouchResult> doInBackground(String... params) {
//        EspTouchActivity activity = mActivity.get();
        int taskResultCount;
        synchronized (mLock) {
            String apSsid = params[0];
            String apBssid = params[1];
            String apPassword = params[2];
            String deviceCountData = params[3];
//           String broadcastData = params[4];
            taskResultCount = deviceCountData.length() == 0 ? -1 : Integer.parseInt(deviceCountData);
//            Context context = activity.getApplicationContext();
            mEsptouchTask = new EsptouchTask(apSsid, apBssid, apPassword, context);
            mEsptouchTask.setPackageBroadcast(true);
        }
            mEsptouchTask.setEsptouchListener(new IEsptouchListener() {
          @Override
          public void onEsptouchResultAdded(IEsptouchResult esptouchResult) {
            Log.d(TAG, "Received result: " + esptouchResult);
            if (!esptouchResult.isSuc()) {
              // TODO: Handle errors better. For that, I need to reproduce this error
              // and see what is sent to the Dart code first.
              final String msg = "Received unsuccessful result: " + esptouchResult;
              Log.e(TAG, msg);
              eventSink.error(msg, msg, null);
              return;
            }
            Map<String, String> result = new HashMap<>();
            result.put("bssid", esptouchResult.getBssid());
            result.put("ip", esptouchResult.getInetAddress().getHostAddress());
            eventSink.success(result);
          }
        });

        return mEsptouchTask.executeForResults(taskResultCount);
    }

    @Override
    protected void onPostExecute(List<IEsptouchResult> result) {
//        EspTouchActivity activity = mActivity.get();
//        activity.mTask = null;
//        activity.showProgress(false);
        if (result == null) {
            return;
        }

        // check whether the task is cancelled and no results received
        IEsptouchResult firstResult = result.get(0);
        if (firstResult.isCancelled()) {
            return;
        }
        // the task received some results including cancelled while
        // executing before receiving enough results

        if (!firstResult.isSuc()) {
            return;
        }

        ArrayList<CharSequence> resultMsgList = new ArrayList<>(result.size());
//        for (IEsptouchResult touchResult : result) {
//            String message = activity.getString(R.string.esptouch1_configure_result_success_item,
//                    touchResult.getBssid(), touchResult.getInetAddress().getHostAddress());
//            resultMsgList.add(message);
//        }
        CharSequence[] items = new CharSequence[resultMsgList.size()];
    }
}
