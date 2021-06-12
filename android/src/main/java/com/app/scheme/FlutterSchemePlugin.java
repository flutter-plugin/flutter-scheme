package com.app.scheme;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterSchemePlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {

  public final static String TAG = "FlutterSchemePlugin";

  private Context context;

  private static EventChannel.EventSink eventSink;

  private boolean initialIntent = true;

  private Map<String,Object> initialScheme = new HashMap<>();
  private Map<String,Object> latestScheme = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    register(flutterPluginBinding.getBinaryMessenger(), this);
  }

  private static void register(BinaryMessenger messenger, FlutterSchemePlugin plugin) {
    final MethodChannel methodChannel = new MethodChannel(messenger, "scheme/flutter.app.method");
    methodChannel.setMethodCallHandler(plugin);

    final EventChannel eventChannel = new EventChannel(messenger,"scheme/flutter.app.event");
    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        eventSink = null;
      }
    });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if("getInitScheme".equals(call.method)) {
      result.success(initialScheme);
    }else if("getLatestScheme".equals(call.method)){
      result.success(latestScheme);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    binding.addOnNewIntentListener(this);
    this.handleIntent(this.context, binding.getActivity().getIntent());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public boolean onNewIntent(Intent intent) {
    this.handleIntent(context,intent);
    return false;
  }

  private void handleIntent(Context context, Intent intent) {
    String action = intent.getAction();
    if (Intent.ACTION_VIEW.equals(action)) {
      Uri schemeUri = intent.getData();
      if(schemeUri == null){
        return;
      }
      try {
        Map<String,Object> dataMap = new HashMap<>();
        dataMap.put("scheme",schemeUri.getScheme());
        dataMap.put("host",schemeUri.getHost());
        dataMap.put("port",schemeUri.getPort());
        dataMap.put("path",schemeUri.getPath());
        dataMap.put("query",schemeUri.getQuery());
        dataMap.put("source","android");
        dataMap.put("dataString",intent.getDataString());
        if(initialIntent){
          initialScheme = dataMap;
          initialIntent = false;
        }
        latestScheme = dataMap;
        if(eventSink != null){
          eventSink.success(dataMap);
        }
      } catch (Exception e) {
        e.printStackTrace();
      }

    }
  }
}
