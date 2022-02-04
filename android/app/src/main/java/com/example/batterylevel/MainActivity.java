package com.example.batterylevel;
import androidx.annotation.NonNull;
import  io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.util.Log;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";
    private static final String channelCount = "getCounter";
    private static final String flutterChannel = "nativeChannel";
   
    @Override
    public  void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), flutterChannel).setMethodCallHandler((call,result)->
                {
            if(call.method.equals("passing_data")){
                Log.d("dataMap", "ini data map" + call.arguments);
                Log.d("dataMap", "ini data battery " + call.argument("batteryLevel"));
                Log.d("dataMap", "ini data counter " + call.argument("counter"));
                Log.d("dataMap", "ini data text " + call.argument("text"));
                String text = call.argument("text");
                Log.d("textMap", "ini text "+text);
//                Log.d(TAG, "configureFlutterEngine: ");

                if(text.length() >0) {
                    result.success("Passing Data Map Success");
                }else{
                    result.error("PassingError", "gagal passing data", null);
                }



            }
        }
        );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result)->
        {
            if (call.method.equals("getBatteryLevel")) {
                int batteryLevel = getBatteryLevel();

                if (batteryLevel != -1) {
                    result.success(batteryLevel);
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                }
            }else if(call.method.equals("counter")){
                 int counter = call.argument("inputBil");
                Log.d("showCounter", String.valueOf(counter));
                int resultCount = counterAdd(counter);
                result.success(resultCount);

            } else {
                result.notImplemented();
            }

        }
        );
    }


    private int counterAdd(int counter){
        
       
       return ++counter;
       
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

}
