package vesti.com.fluttershare;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import android.text.TextUtils;
import androidx.annotation.NonNull;

import java.net.URL;
import java.util.ArrayList;
import java.io.File;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import vesti.com.fluttershare.util.FileUtil;

public class FlutterSharePlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {

    private Activity activity;
    private MethodChannel methodChannel;
    private static final String W4B = "com.whatsapp.w4b";
    private static final String WPP = "com.whatsapp";

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        List<String> paths = call.argument("paths");
        boolean business = call.argument("business");
        String msg = call.argument("msg");
        String phone = call.argument("phone");

        switch (call.method) {
            case "whatsAppText":
                whatsAppText(msg, phone, result, business);
                break;
            case "whatsAppImageList":
                whatsAppImageList(paths, result, business);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void whatsAppImageList(List<String> paths, Result result, boolean business) {
        ArrayList<Uri> fileUris = getUrisForPaths(paths);
        try {
            Intent sendIntent = new Intent();
            sendIntent.setPackage(business ? W4B : WPP);
            sendIntent.setAction(Intent.ACTION_SEND_MULTIPLE);
            sendIntent.setType("image/*");
            sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            sendIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, fileUris);
            activity.startActivity(sendIntent);
            result.success("success");
        } catch (Exception e) {
            result.error("error", e.toString(), "");
        }
    }

    private void whatsAppText(String msg, String phone, Result result, boolean business) {
        try {
            Intent sendIntent = new Intent();
            sendIntent.setPackage(business ? W4B : WPP);
            if (!TextUtils.isEmpty(phone)) {
                sendIntent.setAction(Intent.ACTION_VIEW);
                String url = "https://wa.me/" + phone.trim() + "?text=" + msg.trim();
                sendIntent.setData(Uri.parse(url));
            } else {
                sendIntent.setType("text/plain");
                sendIntent.setAction(Intent.ACTION_SEND);
                sendIntent.putExtra(Intent.EXTRA_TEXT, msg);
            }
            sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            activity.startActivity(sendIntent);
            result.success("success");
        } catch (Exception e) {
            result.error("error", e.toString(), "");
        }
    }

    private ArrayList<Uri> getUrisForPaths(List<String> paths) {
        ArrayList<Uri> uris = new ArrayList<>(paths.size());
        for (int i = 0; i < paths.size(); i++) {
            FileUtil fileHelper = new FileUtil(activity, paths.get(i));
            uris.add(fileHelper.getPath());
        }
        return uris;
    }

    public static void registerWith(Registrar registrar) {
        final FlutterSharePlugin instance = new FlutterSharePlugin();
        instance.onAttachedToEngine(registrar.messenger());
        instance.activity = registrar.activity();
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        activity = null;
    }

    private void onAttachedToEngine(BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "flutter_vesti_share");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }
}
